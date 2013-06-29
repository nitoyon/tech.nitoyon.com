module.exports = function(grunt) {
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    shell: {
      jekyll: {
        command: 'jekyll build'
      }
    },
    livereloadx: {
      static: true,
      dir: '_site'
    },
    watch: {
      jekyll: {
        files: ['_posts/**/*.md', '_layouts/*.html', '_includes/*.html', '_plugins/**/*.rb', 'stylesheets/*'],
        tasks: ['shell:jekyll']
      }
    }
  });

  grunt.loadNpmTasks('grunt-shell-spawn');
  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('livereloadx');

  grunt.registerTask('default', ['livereloadx', 'watch']);
};