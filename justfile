TAILWIND_CSS_VERSION := "latest"

@_default:
    just --list

@fmt:
    just --fmt --unstable

# ----

@bootstrap:
    pip install --upgrade pip pip-tools
    pip install --upgrade --requirement requirements.in

@lint:
    pre-commit run --all-files

@pip-compile:
    pip-compile --upgrade

@pre-commit *ARGS:
    pre-commit run {{ ARGS }} --all-files

@serve:
    modd --file=modd.conf

@update:
    just bootstrap
    just pip-compile

# ----

@build:
    bundle exec jekyll build

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
# @screenshots ARGS="--no-clobber":
#     shot-scraper multi {{ ARGS }} ./shots.yml
