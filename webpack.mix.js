let mix = require('laravel-mix');

/*
 |--------------------------------------------------------------------------
 | Mix Asset Management
 |--------------------------------------------------------------------------
 |
 | Mix provides a clean, fluent API for defining some Webpack build steps
 | for your Laravel application. By default, we are compiling the Sass
 | file for the application as well as bundling up all the JS files.
 |
 */

mix.sass('resources/assets/sass/app.scss', 'public/css').scripts([
    'resources/assets/js/fontawesome-all.min.js',
    'resources/assets/js/summernote.js',
    'resources/assets/js/ajax.js',
    'resources/assets/js/script.js',
    'resources/assets/js/searchbar.js',
    'resources/assets/js/offcanvas.js',
    'resources/assets/js/tagsinput.js'
], 'public/js/app.js');