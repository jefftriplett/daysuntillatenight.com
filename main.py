import csv
import frontmatter
import typer

from pathlib import Path
from sheetfu import SpreadsheetApp, Table
from slugify import slugify


# Don't customize these
EXPECTED_ENV_VARS = [
    "GOOGLE_SHEET_APP_ID",
    "SHEETFU_CONFIG_AUTH_PROVIDER_URL",
    "SHEETFU_CONFIG_AUTH_URI",
    "SHEETFU_CONFIG_CLIENT_CERT_URL",
    "SHEETFU_CONFIG_CLIENT_EMAIL",
    "SHEETFU_CONFIG_CLIENT_ID",
    "SHEETFU_CONFIG_PRIVATE_KEY",
    "SHEETFU_CONFIG_PRIVATE_KEY_ID",
    "SHEETFU_CONFIG_PROJECT_ID",
    "SHEETFU_CONFIG_TOKEN_URI",
    "SHEETFU_CONFIG_TYPE",
]

app = typer.Typer()


def print_expected_env_variables():
    typer.echo(
        """
To use this command, you will need to setup a Google Cloud Project and have
authentication properly setup. To start, check out:

> https://github.com/socialpoint-labs/sheetfu/blob/master/documentation/authentication.rst

Once you have your your seceret JSON file, you'll want to convert the key/value
pairs in this file into ENV variables or SECRETS if you want to run this script
as a GitHub Action.

These are the values that you need to configure for the script to run:
"""
    )

    for var in EXPECTED_ENV_VARS:
        if var not in os.environ or not os.environ.get(var):
            typer.echo(f"- {var}")

    typer.echo("")


@app.command()
def main():
    filenames = Path("_players").glob("*.md")
    data = []
    for filename in filenames:
        if not str(filename.name).startswith("_"):
            # print(filename.name)
            post = frontmatter.load(filename)
            # print(post.metadata)
            years = post.metadata["years"]
            for year in years:
                data.append(
                    {
                        "year": year.get("year"),
                        "last_name": post.metadata["last_name"],
                        "first_name": post.metadata["first_name"],
                        "number": post.metadata.get("number"),
                        "image": post.metadata.get("image"),
                        "hometown": post.metadata.get("hometown"),
                        "class": year.get("class"),
                        "number": year.get("number"),
                        "position": year.get("position"),
                        "status": year.get("status"),
                        "departing_reason": year.get("departing_reason"),
                        "projected": year.get("projected"),
                    }
                )

    with open("players.csv", "w", newline="") as csv_output:
        writer = csv.DictWriter(csv_output, fieldnames=data[0].keys())
        writer.writeheader()
        writer.writerows(data)


@app.command()
def sync(
    output_folder: str = "_players",
    sheet_app_id: str = typer.Argument(envvar="GOOGLE_SHEET_APP_ID", default=""),
    sheet_name: str = typer.Argument(envvar="SHEET_NAME", default="Sheet1"),
):
    typer.secho("sync-players", fg="yellow")
    try:
        sa = SpreadsheetApp(from_env=True)
    except AttributeError:
        print_expected_env_variables()
        raise typer.Exit()

    try:
        spreadsheet = sa.open_by_id(sheet_app_id)
    except Exception:
        typer.echo(
            f"We can't find that 'sheet_app_id'.\n"
            f"Please double check that 'GOOGLE_SHEET_APP_ID' is set. (Currently set to: '{sheet_app_id}')"
        )
        raise typer.Exit()

    try:
        sheet = spreadsheet.get_sheet_by_name(sheet_name)
    except Exception:
        typer.echo(
            f"We can't find that 'sheet_name' aka the tab.\n"
            f"Please double check that 'SHEET_NAME' is set. (Currently set to: '{sheet_name}')"
        )
        raise typer.Exit()

    data_range = sheet.get_data_range()

    table = Table(data_range, backgrounds=True)

    metadata = {}
    for item in table:
        for key in item.header:
            value = item.get_field_value(key)
            metadata[key] = value

        slug = slugify(
            " ".join(
                [
                    f"{metadata['year']}",
                    "-",
                    f"{metadata['last_name']}" "-",
                    f"{metadata['first_name']}",
                ]
            )
        )

        if not Path(output_folder).exists():
            Path(output_folder).mkdir()

        player_filename = Path(output_folder, f"{slug}.md")
        if player_filename.exists():
            post = frontmatter.loads(player_filename.read_text())
        else:
            post = frontmatter.loads("")

        post.metadata.update(metadata)

        player_filename.write_text(frontmatter.dumps(post))


if __name__ == "__main__":
    app()
