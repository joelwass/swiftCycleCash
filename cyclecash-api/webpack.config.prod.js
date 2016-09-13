const path = require('path');
const webpack = require('webpack');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const _ = require('lodash');

module.exports = {
    devtool: '#source-map',
    entry: {
        js: './src/index.js'
    },
    output: {
        path: path.join(__dirname, 'dist'),
        filename: 'bundle.js'
    },
    plugins: [
        new webpack.optimize.OccurenceOrderPlugin(),
        new webpack.DefinePlugin({
            'process.env': {
                'ROOT_URL': JSON.stringify('http://api.versame.com')
            }
        }),
        new webpack.optimize.UglifyJsPlugin({
            compressor: {
                warnings: false
            },
            output: {
                comments: false
            }
        }),
        new HtmlWebpackPlugin({
            template: 'index.html', // Load a custom template
            inject: 'body' // Inject all scripts into the body
        })
    ],
    module: {
        loaders: [{
            test: /\.jsx?$/,
            loaders: ['babel?retainLines=true'],
            include: path.join(__dirname, 'src')
        },{
            test: /\.css?$/,
            loader: 'style!css?modules&localIdentName=[name]---[local]---[hash:base64:5]'
        }]
    }
};
