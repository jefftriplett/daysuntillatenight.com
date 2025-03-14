TAILWIND_CSS_VERSION := "latest"

# --------------------------------------------------------------------------------

@_default:
    just --list

@fmt:
    just --fmt --unstable

# --------------------------------------------------------------------------------

@bootstrap:
    python -m pip install --upgrade pip uv pre-commit
    python -m uv pip install --upgrade --requirement requirements.in
    # playwright install

@build:
    bundle exec jekyll build

@dump:
    python fetch-players.py dump players.db

@dump-csv:
    # -python fetch-players-to-csv.py --year=2010-11
    # -python fetch-players-to-csv.py --year=2011-12
    # -python fetch-players-to-csv.py --year=2012-13
    # -python fetch-players-to-csv.py --year=2013-14
    # -python fetch-players-to-csv.py --year=2014-15
    # -python fetch-players-to-csv.py --year=2015-16
    # -python fetch-players-to-csv.py --year=2016-17
    # -python fetch-players-to-csv.py --year=2017-18
    # -python fetch-players-to-csv.py --year=2018-19
    # -python fetch-players-to-csv.py --year=2019-20  # number issues
    # -python fetch-players-to-csv.py --year=2020-21
    # -python fetch-players-to-csv.py --year=2021-22
    # -python fetch-players-to-csv.py --year=2022-23
    # -python fetch-players-to-csv.py --year=2023-24
    -python fetch-players-to-csv.py --year=2024-25

@fetch:
    # -python fetch-players.py fetch players.db --year=2010-11
    # -python fetch-players.py fetch players.db --year=2011-12
    # -python fetch-players.py fetch players.db --year=2012-13
    # -python fetch-players.py fetch players.db --year=2013-14
    # -python fetch-players.py fetch players.db --year=2014-15
    # -python fetch-players.py fetch players.db --year=2015-16
    # -python fetch-players.py fetch players.db --year=2016-17
    # -python fetch-players.py fetch players.db --year=2017-18
    # -python fetch-players.py fetch players.db --year=2018-19
    # -python fetch-players.py fetch players.db --year=2019-20
    # -python fetch-players.py fetch players.db --year=2020-21
    # -python fetch-players.py fetch players.db --year=2021-22
    # -python fetch-players.py fetch players.db --year=2022-23
    # -python fetch-players.py fetch players.db --year=2023-24
    -python fetch-players.py fetch players.db --year=2024-25

@fill-in-player-images:
    # python fill-in-player-images.py --year=2010
    # python fill-in-player-images.py --year=2011
    # python fill-in-player-images.py --year=2012
    # python fill-in-player-images.py --year=2013
    # python fill-in-player-images.py --year=2014
    # python fill-in-player-images.py --year=2015
    # python fill-in-player-images.py --year=2016
    # python fill-in-player-images.py --year=2017
    # python fill-in-player-images.py --year=2018
    # python fill-in-player-images.py --year=2019
    # python fill-in-player-images.py --year=2020
    # python fill-in-player-images.py --year=2021
    # python fill-in-player-images.py --year=2022
    # python fill-in-player-images.py --year=2023
    python fill-in-player-images.py --year=2024

@lint:
    python -m pre_commit run --all-files

@pip-compile *ARGS:
    python -m uv pip compile {{ ARGS }}

@pre-commit *ARGS:
    pre-commit run {{ ARGS }} --all-files

@restart:
    docker compose restart

# @screenshots ARGS="--no-clobber":
#     shot-scraper multi {{ ARGS }} ./shots.yml

# starts app
@server *ARGS:
    docker compose up {{ ARGS }}

# sets up a project to be used for the first time
@setup:
    just bootstrap

@static:
    JEKYLL_ENV=production \
    npx -p tailwindcss@{{ TAILWIND_CSS_VERSION }} tailwindcss build \
        --config ./src/tailwind.config.js \
        --input ./src/styles.css \
        --output ./css/tailwind.css

    npx -p tailwindcss@{{ TAILWIND_CSS_VERSION }} tailwindcss build \
        --config ./src/tailwind.config.js \
        --input ./src/styles.css \
        --output ./css/development.css

@start +ARGS="--detach":
    just server {{ ARGS }}

@stop:
    docker compose down

@tail:
    docker compose logs --follow --tail 100

# runs tests
@test:
    echo "TODO: test"

# updates a project to run at its current version
@update:
    just bootstrap
    just pip-compile --upgrade
