const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    '**/*.html'
  ],
  theme: {
    fontFamily: {
      'sans': ['Alegreya Sans', ...defaultTheme.fontFamily.sans],
    }
  },
  variants: {},
  plugins: [
    require("@tailwindcss/typography"),
    require("tailwindcss-debug-screens"),
  ],
}
