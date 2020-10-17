module.exports = {
  future: {
    removeDeprecatedGapUtilities: true,
    purgeLayersByDefault: true,
  },
  purge: {
    enabled: process.env.JEKYLL_ENV == "production",
    mode: 'all',
    content: [
      '**/*.html'
    ],
  },
  theme: {
    extend: {},
  },
  variants: {},
  plugins: [
    require("@tailwindcss/typography"),
    require("tailwindcss-debug-screens"),
  ],
}
