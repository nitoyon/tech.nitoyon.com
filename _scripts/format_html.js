// HTML format script
// format specified directory HTML

const fs = require('fs');
const glob = require("glob");
const beautify = require('js-beautify');

// target directory
const targetDirs = process.argv.splice(2);

const beautifyOptions = {
  indent_size: 2,
  end_with_newline: true,
  preserve_newlines: false,
  max_preserve_newlines: 0,
  wrap_line_length: 0,
  wrap_attributes_indent_size: 0,
  unformatted: ['b', 'em']
};


targetDirs.forEach(targetDir => {
  console.log(`Formatting ${targetDir}...`)
  glob(targetDir, {}, (err, files) => {
    if (err) { console.log(err); return; }

    files.forEach(file => {
      console.log(`  processing ${file}`);

      fs.readFile(file, 'utf8', (err, html) => {
        if (err) { console.log(err); return; }

        const result = beautify.html(html, beautifyOptions);

        fs.writeFile(file, result, 'utf8', err => {
            if (err) { console.log(err); return; }
        });
      });
    });
  });
});