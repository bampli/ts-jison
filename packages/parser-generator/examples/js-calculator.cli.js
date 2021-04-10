const Fs = require('fs');
const CalculatorParser = require('./js-calculator.js');
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
  const res = new CalculatorParser.Parser(myYy).parse(txt);
  console.log('res:', res);
};
