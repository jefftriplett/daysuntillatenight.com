TAILWIND_CSS_VERSION := "latest"

@_default:
    just --list

@build:
    bundle exec jekyll build

@lint:
    -black --check .

    #-curlylint _includes/ _layouts/

    -djhtml \
        --in-place \
        --tabwidth 4 \
        *.html _includes/*.html _layouts/*.html

    -rustywind \
        --write \
        .


@pip-compile:
    pip-compile

@serve:
    modd --file=modd.conf

@static:
    JEKYLL_ENV=production \
    npx -p tailwindcss@{{ TAILWIND_CSS_VERSION }} tailwindcss build \
    	--input ./src/styles.css \
    	--config ./tailwind.config.js \
    	--output ./css/tailwind.css

    npx -p tailwindcss@{{ TAILWIND_CSS_VERSION }} tailwindcss build \
    	--input ./src/styles.css \
    	--config ./tailwind.config.js \
    	--output ./css/development.css

@update +YEAR="2022":
    python main.py sync --sheet-name={{ YEAR }}

@update-all-sheets:
    python main.py sync --all-sheets

@restart:
    docker-compose restart

# starts app
@server *ARGS:
    docker-compose up {{ ARGS }}

# sets up a project to be used for the first time
@setup:
    just bootstrap

@start +ARGS="--detach":
    just server {{ ARGS }}

@stop:
    docker-compose down

@tail:
    docker-compose logs --follow --tail 100

# runs tests
@test:
    echo "TODO: test"

# updates a project to run at its current version
# @update:
#     just bootstrap

# ----

@fmt:
    just --fmt --unstable

# @screenshots ARGS="--no-clobber":
#     shot-scraper multi {{ ARGS }} ./shots.yml
