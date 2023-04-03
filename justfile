TAILWIND_CSS_VERSION := "latest"

# --------------------------------------------------------------------------------

@_default:
    just --list

@fmt:
    just --fmt --unstable

# --------------------------------------------------------------------------------

@bootstrap:
    pip install --upgrade pip pip-tools
    pip install --upgrade --requirement requirements.in

@build:
    bundle exec jekyll build

@lint:
    pre-commit run --all-files

@pip-compile *ARGS:
    pip-compile {{ ARGS }}

@pre-commit *ARGS:
    pre-commit run {{ ARGS }} --all-files

@restart:
    docker-compose restart

# @screenshots ARGS="--no-clobber":
#     shot-scraper multi {{ ARGS }} ./shots.yml

@serve:
    modd --file=modd.conf

# starts app
@server *ARGS:
    docker-compose up {{ ARGS }}

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
    docker-compose down

@tail:
    docker-compose logs --follow --tail 100

# runs tests
@test:
    echo "TODO: test"

# updates a project to run at its current version
@update:
    just bootstrap
    just pip-compile --upgrade
