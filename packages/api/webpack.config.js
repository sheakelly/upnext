const path = require('path');
const slsw = require('serverless-webpack');

module.exports = {
  mode: "development",
  entry: slsw.lib.entries,
  resolve: {
    extensions: [
      '.js',
      '.json',
      '.ts',
      '.tsx'
    ]
  },
  output: {
    libraryTarget: 'commonjs',
    path: path.join(__dirname, '.webpack'),
    filename: '[name].js'
  },
  target: 'node',
  module: {
    rules: [{
        test: /\.ts(x?)$/,
        use: [{
          loader: 'ts-loader'
        }],
      },
      {
        test: /\.graphql?$/,
        loader: 'webpack-graphql-loader'
      },
      {
        test: /\.mjs$/,
        include: /node_modules/,
        type: 'javascript/auto'
      }
    ]
  }
}