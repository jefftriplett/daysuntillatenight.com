module.exports = function(grunt) {
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    clean: ["build"],
    uglify: {
      dev: {
        files: {
          'build/latenight.min.js': [
            'js/main.js'
          ]
        }
      },
      prod: {
        files: {
          'build/latenight.min.js': [
            'js/main.js',
            'js/ga.js'
          ]
        }
      }
    },
    cssmin: {
      dist: {
        files: {
          'build/latenight.min.css': [
            'css/normalize.css',
            'css/main.css',
            'css/latenight.css'
          ]
        }
      }
    },
    htmlmin: {
      dist: {
        options: {
          removeComments: true,
          collapseWhitespace: true
        },
        files: {
          'build/index.html': 'index.html'
        }
      }
    },
    copy: {
      dist: {
        files: [
          {
            expand: true,
            src: [
              'images/**',
              'favicon.ico',
              'humans.txt',
              'robots.txt'
            ],
            dest: 'build/'
          }
        ]
      }
    },
    replace: {
      dist: {
        options: {
          patterns: [
            {
              match: 'timestamp',
              replacement: '<%= new Date().getTime() %>'
            }
          ]
        },
        files: [
          { src: ['build/index.html'], dest: 'build/index.html' }
        ]
      }
    },
    connect: {
      server: {
        options: {
          port: 9001,
          base: 'build',
          keepalive: true,
          open: true
        }
      }
    }
  });

  grunt.loadNpmTasks('grunt-contrib-clean');
  grunt.loadNpmTasks('grunt-contrib-uglify');
  grunt.loadNpmTasks('grunt-contrib-cssmin');
  grunt.loadNpmTasks('grunt-contrib-htmlmin');
  grunt.loadNpmTasks('grunt-contrib-copy');
  grunt.loadNpmTasks('grunt-replace');
  grunt.loadNpmTasks('grunt-contrib-connect');

  grunt.registerTask('default', ['dev']);
  grunt.registerTask('dev', [
    'clean',
    'uglify:dev',
    'cssmin',
    'htmlmin',
    'copy',
    'replace',
    'connect'
  ]);
  grunt.registerTask('deploy', [
    'clean',
    'uglify:prod',
    'cssmin',
    'htmlmin',
    'copy',
    'replace'
  ]);
};
