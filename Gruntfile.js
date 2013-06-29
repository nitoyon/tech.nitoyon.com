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
    watch: {
      jekyll: {
        files: ['_posts/**/*.md', '_layouts/*.html', '_includes/*.html', '_plugins/**/*.rb', 'stylesheets/*'],
        tasks: ['shell:jekyll_build']
      }
    }
  });

  grunt.loadNpmTasks('grunt-shell-spawn');
  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('livereloadx');

  grunt.registerTask('default', ['livereloadx', 'watch']);
  grunt.registerTask('build', ['shell:jekyll_build']);
  grunt.registerTask('rebuild', ['shell:jekyll_rebuild']);
};