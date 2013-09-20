module.exports = function(grunt) {
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    shell: {
      jekyll_build: {
        command: 'jekyll build'
      },
      jekyll_rebuild: {
        command: 'jekyll build --future'
      }
    },
    livereloadx: {
      static: true,
      dir: '_site'
    },
    esteWatch: {
      options: {
        dirs: ['./', '_posts/*/', '_layouts', '_includes',
               '_plugins/**/', 'stylesheets', 'javascripts'],
        livereload: {
          enabled: false
        }
      },
      '*': function(filepath) { return 'shell:jekyll_build' }
    }
  });

  grunt.loadNpmTasks('grunt-shell-spawn');
  grunt.loadNpmTasks('grunt-este-watch');
  grunt.loadNpmTasks('livereloadx');

  grunt.registerTask('default', ['livereloadx', 'esteWatch']);
  grunt.registerTask('build', ['shell:jekyll_build']);
  grunt.registerTask('rebuild', ['shell:jekyll_rebuild']);
};