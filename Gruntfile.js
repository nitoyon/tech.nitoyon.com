module.exports = function(grunt) {
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    shell: {
      jekyll_build_ja: {
        command: 'jekyll build --future --config _config.yml,_config.ja.yml'
      },
      jekyll_build_en: {
        command: 'jekyll build --future --config _config.yml,_config.en.yml'
      },
      jekyll_rebuild_ja: {
        command: 'jekyll build --config _config.yml,_config.ja.yml'
      },
      jekyll_rebuild_en: {
        command: 'jekyll build --config _config.yml,_config.en.yml'
      }
    },
    livereloadx: {
      static: true,
      dir: '_site'
    },
    esteWatch: {
      options: {
        dirs: ['./', '_posts/*/', '_layouts', '_includes',
               'javascript/**/', 'ja/**/', 'en/**/',
               '_plugins/**/', 'stylesheets', 'javascripts'],
        livereload: {
          enabled: false
        }
      },
      '*': function(filepath) { return 'build' }
    }
  });

  grunt.loadNpmTasks('grunt-shell-spawn');
  grunt.loadNpmTasks('grunt-este-watch');
  grunt.loadNpmTasks('livereloadx');

  grunt.registerTask('watch', ['esteWatch']);
  grunt.registerTask('default', ['livereloadx', 'build', 'esteWatch']);
  grunt.registerTask('build', ['shell:jekyll_build_ja', 'shell:jekyll_build_en']);
  grunt.registerTask('rebuild', ['shell:jekyll_rebuild_ja', 'shell:jekyll_rebuild_en']);
};
