module.exports = {
  content: [
    './app/views/**/*.html.erb',
    './app/components/**/*',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/assets/images/**/*.svg',
    './app/javascript/**/*.js'
  ],
  theme: {
    extend: {
      screens: {
        'xs': '32rem'
      },
      boxShadow: {
        'center': '0 0 3px 0 rgb(0 0 0 / 0.1), 0 0 0 1px rgb(0 0 0 / 0.02)'
      },
    }
  }
}
