module.exports = function(grunt) {
    grunt.initConfig({
        sass: {
            dist: {
                options: {
                    style: 'expanded'
                },
                files: {
                    "css/main.css": "sass/main.scss"
                }
            }
        },

        watch: {
            options: {
                livereload: false,
            },
            styles: {
                files: ['sass/*.scss'], // which files to watch
                tasks: ['sass'],
                options: {
                    nospawn: true
                }
            }
        },

    });

    grunt.loadNpmTasks('grunt-contrib-sass');
    grunt.loadNpmTasks('grunt-contrib-watch');
    grunt.registerTask('default', ['phplint', 'sass', 'watch']);
};