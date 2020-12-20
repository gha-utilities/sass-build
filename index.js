const fs = require('fs');
const sass = require('sass');
const path = require('path');

const version = require('./package.json').version;


const get_gha_input = (name) => { return process.env[`INPUT_${name.toUpperCase()}`]; };


const source = get_gha_input('source').split('\n');
const destination = get_gha_input('destination').split('\n');

if (source === undefined || destination === undefined) {
  const error_message = [
    'Required environment variable(s) are undefined!',
    `  source -> ${source}`,
    `  destination -> ${destination}`,
    'Please assign missing environment variables via',
    '  INPUT_SOURCE="path/to/main.scss"\\',
    '  INPUT_DESTINATION="assets/css/main.css"\\',
    '  node index.js'
  ];

  throw new ReferenceError(error_message.join('\n'));
}


const render_options = {
  outputStyle: 'compressed',
  indentWidth: 2  // Cannot be `NaN` https://github.com/gha-utilities/sass-build/issues/11
};


/**
 * Optional inputs with predictable types
 */


const boolean_gha_input_names = [
  'sourceComments',     // Boolean, default `false` if `true` emits comments where CSS was compiled from
  'omitSourceMapUrl',   // Boolean, when `true` compiled CSS is not linked to source map
  'sourceMapContents',  // Boolean, when `true` embeds contents of Sass files that contributed to compiled CSS
  'sourceMapEmbed',     // Boolean, when `true` embeds source map within compiled CSS
];


const integer_gha_input_names = [
  'precision',          // Integer and float precision when compiling CSS, eg. `20`
  'indentWidth',        // Integer, of tabs/spaces used to indent, eg. `1`
];


const string_gha_input_names = [
  'outputStyle',        // String, either 'expanded', 'compressed', 'nested', 'compact'
  'indentType',         // String, either 'space' or 'tab', default 'space'
  'linefeed',           // String, either 'lf', 'lfcr', 'cr', or 'crlf', default 'lf'
  'outFile',            // String, does not write but is useful in combination with 'sourceMap'
  'sourceMapRoot',      // String, prepended to all links from from source map to Sass files
];


boolean_gha_input_names.forEach((name) => {
  const env_value = get_gha_input(name);

  if (env_value === 'true' || env_value === 'false') {
    render_options[name] = (env_value === 'true');
  }
});


integer_gha_input_names.forEach((name) => {
  const env_value = get_gha_input(name);

  if (Number.parseInt(env_value) !== NaN) {
    render_options[name] = Number.parseInt(env_value);
  }
});


string_gha_input_names.forEach((name) => {
  const env_value = get_gha_input(name);

  if (env_value !== undefined && env_value !== '') {
    render_options[name] = get_gha_input(name);
  }
});


/**
 * Inputs that require a bit more care
 */


// 'includePaths'       // Array, directories to look under for imports and used modules, splits on ':'
const includePaths = get_gha_input('includePaths');
if (includePaths !== undefined && includePaths !== '') {
  render_options['includePaths'] = includePaths.split(':');
}

// 'sourceMap'          // May be boolean or string, see https://sass-lang.com/documentation/js-api#sourcemap
const sourceMap = get_gha_input('sourceMap');
if (sourceMap === 'true' || sourceMap === 'false') {
  render_options['sourceMap'] = (sourceMap === 'true');
} else if (sourceMap !== undefined && sourceMap !== '') {
  render_options['sourceMap'] = sourceMap;
}


/**
 * Compiles CSS and write it to file path
 * @param {string} source_file - Path to SCSS or SASS file to parse
 * @param {string} destination_file - Path to CSS file to write
 */
function build_CSS(source_file, destination_file) {
  render_options['file'] = source_file;
  if (get_gha_input('debug')) {
    console.log('--- render_options ---');
    console.table(render_options);
  }

  const sass_result = sass.renderSync(render_options);

  /**
   * Write CSS to file path
   */
  fs.stat(destination_file, (err, stat) => {
    if (err && err.code === 'ENOENT') {
      const warnning_message = [
        `Warning: ${err.message}`,
        `Attempting to write to file path -> ${destination_file}`,
      ];

      console.warn(warnning_message.join('\n'));
    } else if (stat.isDirectory()) {
      destination_file = `${destination_file}/${path.basename(source_file)}`;

      const warnning_message = [
        `Warning: destination path was converted to -> "${destination_file}"`,
        'To avoid this warning please assign `destination` to a file path, eg...',
        '  - name: Compile CSS from SCSS files',
        `    uses: gha-utilities/sass-build@v${version}`,
        '    with:',
        `      source: ${source_file}`,
        `      destination: ${destination_file}`,
      ];

      console.warn(warnning_message.join('\n'));
    }

    fs.writeFile(destination_file, sass_result.css, (err) => {
      if (err) {
        throw err;
      } else {
        console.log(`Wrote file -> ${destination_file}`);
      }
    });
  });
}


/**
 * @note - Last element of sources & destinations is an empty string
 */
for (i=0; i<source.length; i++) {
  if (!['', undefined].includes(source[i]) && !['', undefined].includes(destination[i])) {
    build_CSS(source[i], destination[i]);
  }
}

