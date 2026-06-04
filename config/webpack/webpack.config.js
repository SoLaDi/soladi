// See the shakacode/shakapacker README and docs directory for advice on customizing your webpackConfig.
const { generateWebpackConfig } = require('shakapacker')
const webpack = require('webpack')

const webpackConfig = generateWebpackConfig()

// Silence Sass deprecation warnings from Bootstrap
webpackConfig.module.rules.forEach(rule => {
  if (rule.use) {
    rule.use.forEach(loader => {
      if (loader.loader && loader.loader.includes('sass-loader')) {
        loader.options = loader.options || {}
        loader.options.sassOptions = loader.options.sassOptions || {}
        loader.options.sassOptions.quietDeps = true
      }
    })
  }
})

webpackConfig.plugins = webpackConfig.plugins || []
webpackConfig.plugins.push(
  new webpack.ProvidePlugin({
    $: 'jquery',
    jQuery: 'jquery',
  })
)

module.exports = webpackConfig
