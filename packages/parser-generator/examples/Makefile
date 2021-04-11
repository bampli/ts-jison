
# Javascript calculator
js-calculator-demo: js-calculator.js
	node js-calculator.cli.js calculator.input.txt

js-calculator.js: js-calculator.jison ../templates/javascript/parser ../../lexer-generator/templates/javascript/lexer
	node ../lib/cli.js -t javascript -n JsCalc -o js-calculator.js js-calculator.jison

# Typescript calculator
ts-calculator-demo: ts-calculator.js
	node ts-calculator.cli.js calculator.input.txt

ts-calculator.ts: ts-calculator.jison ../templates/typescript/parser ../../lexer-generator/templates/typescript/lexer
	node ../lib/cli.js -t typescript -n TsCalc -o ts-calculator.ts ts-calculator.jison

ts-calculator.js: ts-calculator.ts
	npx tsc ts-calculator.ts

# ts-node calculator -- run ts-calculator.ts without compiling with tsc
ts-node-calculator-demo: ts-calculator.ts
	npx ts-node ts-calculator.cli.js calculator.input.txt

