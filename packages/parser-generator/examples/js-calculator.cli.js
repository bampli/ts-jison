const Fs = require('fs');
const ParserAndLexer = require('./js-calculator'); // Note, imports js-calc..., not ts-calc...

main(process.argv.slice(1));

function main (args) {
  if (!args[1]) {
    console.warn(`Usage: ${args[0]} FILE`);
    process.exit(1);
  }
  const txt = require('fs').readFileSync(require('path').normalize(args[1]), "utf8");
  const myYy = {
    // trace: function () { console.log('trace:', ...arguments); }
  };
  const res = new ParserAndLexer.JsCalcParser(myYy).parse(txt);
  console.log(txt.trim(), '=', res);
};
