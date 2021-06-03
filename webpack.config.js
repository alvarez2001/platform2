const path = require('path');
const nodeExternals = require('webpack-node-externals');
const 	NodemonPlugin = require('nodemon-webpack-plugin');
const htmlwebpackplugin = require('html-webpack-plugin');

module.exports = {
	mode: 'development',
	target:'node',
	entry:{
		app:path.resolve(__dirname,'src','index')
	},
	output:{
		path:path.resolve(__dirname,'dist'),
		filename:'bundle.js'
	},
	externals:[
		nodeExternals()
	],
	module:{
		rules:[
			{
				test:/\.js$/,
				exclude:/node_modules/,
				loader:'babel-loader'
			}
		]
	},
	plugins:[
		new NodemonPlugin(),
		new htmlwebpackplugin({
			template:'./src/views/layouts/main.hbs'
		})
	]
}