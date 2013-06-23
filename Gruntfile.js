module.exports = function(grunt) {
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    shell: {
      jekyll: {
        command: 'jekyll build'
      }
    },
    watch: {
      jekyll: {
        files: ['_posts/**/*.md', '_layout/*.html', '_includes/*.html', '_plugins/**/*.rb'],
        tasks: ['shell:jekyll']
      }
    }
  });

  grunt.loadNpmTasks('grunt-shell-spawn');
  grunt.loadNpmTasks('grunt-contrib-watch');

  grunt.registerTask('default', ['shell:jekyll']);
};