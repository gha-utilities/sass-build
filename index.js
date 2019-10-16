const fs = require('fs');
const sass = require('sass');


const source = process.env.INPUT_SOURCE;
const destination = process.env.INPUT_DESTINATION;


const result = sass.renderSync({
  file: source
});


fs.writeFile(destination, result.css, (err) => {
  if (err) {
    throw err;
  } else {
    console.log(`Wrote file -> ${destination}`);
  }
});
