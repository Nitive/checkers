module.exports = {
  parser: 'sugarss',
  use: [
    'postcss-import',
    'precss',
    'postcss-define-property',
    'postcss-cssnext',
    'rucksack-css',
  ],
  input: 'src/styles/app.sss',
  output: 'static/styles.css',
}
