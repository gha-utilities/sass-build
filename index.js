const fs = require('fs');
const sass = require('sass');


const get_gha_input = function(name) { return process.env[`INPUT_${name.toUpperCase()}`]; };

const source = get_gha_input('source');
const destination = get_gha_input('destination');

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


const render_options = { file: source, outputStyle: 'compressed' };


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

  if (env_value !== undefined) {
    if (env_value === 'true' || env_value === 'false') {
      render_options[name] = (env_value === 'true');
    }
  }
});


integer_gha_input_names.forEach((name) => {
  const env_value = get_gha_input(name);

  if (env_value !== undefined && env_value !== "" && Number.parseInt(env_value) != NaN) {
    render_options[name] = Number.parseInt(env_value);
  }
});


string_gha_input_names.forEach((name) => {
  let value = get_gha_input(name);
  if (value !== undefined && value !== "") {
    render_options[name] = get_gha_input(name);
  }
});


/**
 * Inputs that require a bit more care
 */
let includePaths = get_gha_input('includePaths');
if (includePaths !== undefined && includePaths != "") {
  render_options['includePaths'] = includePaths.split(':');
}

// 'sourceMap'          // May be boolean or string, see https://sass-lang.com/documentation/js-api#sourcemap
let sourceMap = get_gha_input('sourceMap');
if (sourceMap !== undefined && sourceMap != "") {
  const env_value = sourceMap;

  if (env_value === 'true' || env_value === 'false') {
    render_options['sourceMap'] = (env_value === 'true');
  } else {
    render_options['sourceMap'] = env_value;
  }
}

/**
 * Compile and write-out CSS
 */

console.log(render_options);

const result = sass.renderSync(render_options);

fs.writeFile(destination, result.css, (err) => {
  if (err) {
    throw err;
  } else {
    console.log(`Wrote file -> ${destination}`);
  }
});
