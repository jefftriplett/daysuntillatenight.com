TAILWIND_CSS_VERSION := 2.1.1


.PHONY: serve
serve:
	@bundle exec jekyll serve --drafts --watch --port 8000

.PHONY: static
static:
	@JEKYLL_ENV=production \
		npx -p tailwindcss@${TAILWIND_CSS_VERSION} tailwindcss build \
			./src/styles.css \
			--config ./tailwind.config.js \
			--output ./css/tailwind.css

	@npx -p tailwindcss@${TAILWIND_CSS_VERSION} tailwindcss build \
		./src/styles.css \
		--config ./tailwind.config.js \
		--output ./css/development.css
