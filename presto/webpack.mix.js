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

mix.sass('resources/assets/sass/app.scss', 'public/css').js([
    'resources/assets/js/fontawesome-all.min.js',
    'resources/assets/js/tinymce.js',
    'resources/assets/js/mentioninstance.js',
    'resources/assets/js/app.js',
    'resources/assets/js/script.js',
    'resources/assets/js/notifications.js',
    'resources/assets/js/tagsinput.js',
    'resources/assets/js/admin.js'
], 'public/js/app.js'); 
