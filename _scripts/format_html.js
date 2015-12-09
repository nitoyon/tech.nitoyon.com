
// node _scripts\format_html.js _site\ja\blog\**\*.html

var glob = require('glob');
var fs = require('fs');
var html = require('html');

if (process.argv.length < 3) {
  console.log('node format_html.js [glob]');
  return;
}

function prettify(str) {
  str = html.prettyPrint(str, {max_char: 0})
  return str.split(/\r|\n/)
    .map(function(s) { return s.trim(); })
    .filter(function(s) { return s != ''; })
    .join("\r\n");
}

var dir = process.argv[2];
console.log('read %s', dir);
glob.sync(dir).forEach(function(fn, i) {
  console.log(fn);
  fs.writeFileSync(fn, prettify(fs.readFileSync(fn).toString()));
});
