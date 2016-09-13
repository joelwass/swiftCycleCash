const path = require('path');
const webpack = require('webpack');
const HtmlWebpackPlugin = require('html-webpack-plugin');
var CopyWebpackPlugin = require('copy-webpack-plugin');

module.exports = {
    devtool: '#source-map',
    entry: [
        `webpack-dev-server/client?http://localhost:8080`,
        'webpack/hot/only-dev-server',
        'react-hot-loader/patch',
        './src/index.js'
    ],
    output: {
        path: path.join(__dirname, 'dist'),
        filename: 'bundle.js'
    },

    plugins: [
        new webpack.HotModuleReplacementPlugin(),
        new webpack.NoErrorsPlugin(),
        new webpack.DefinePlugin({
            'process.env': {
                'ROOT_URL': JSON.stringify('http://localhost:3001')
            }
        }),
        new CopyWebpackPlugin([{ from: __dirname+'/assets/**/*', to: 'dist' }]) //TODO figure out why not working
    ],
    module: {
        loaders: [{
            test: /\.jsx?$/,
            loaders: ['babel?retainLines=true'],
            include: path.join(__dirname, 'src')
        }, {
            test: /\.css?$/,
            loader: 'style!css?modules&localIdentName=[name]---[local]---[hash:base64:5]'
        }]
    }
};
