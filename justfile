TAILWIND_CSS_VERSION := "2.1.1"

@_default:
    just --list

@lint:
	-black --check .
	-curlylint _includes/ _layouts/

@pip-compile:
    pip-compile

@serve:
    modd --file=modd.conf

@static:
	JEKYLL_ENV=production \
		npx -p tailwindcss@{{TAILWIND_CSS_VERSION}} tailwindcss build \
			./src/styles.css \
			--config ./tailwind.config.js \
			--output ./css/tailwind.css

	npx -p tailwindcss@{{TAILWIND_CSS_VERSION}} tailwindcss build \
		./src/styles.css \
		--config ./tailwind.config.js \
		--output ./css/development.css
