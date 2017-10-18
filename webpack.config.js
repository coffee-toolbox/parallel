var path = require('path');

module.exports = {
    entry: {
        'main': path.resolve('Parallel.coffee')
    },
    output: {
        'path': path.resolve(__dirname, 'dist'),
        filename: '[name].js'
    },
    module: {
        rules: [
            {
                test: /\.coffee$/,
                use: {
                    loader: 'coffee-loader',
                    options: {
                        sourceMap: true,
                        transpile: {
                            presets: ['env']
                        }
                    }
                }
            }
        ]
    }
}
