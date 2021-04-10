
# Javascript calculator
js-calculator-demo: js-calculator.js
	node js-calculator.cli.js calculator.input.txt

js-calculator.js: js-calculator.jison
	node ../lib/cli.js -t javascript -o js-calculator.js js-calculator.jison

# Typescript calculator
ts-calculator-demo: ts-calculator.js
	node ts-calculator.cli.js calculator.input.txt

ts-calculator.ts: ts-calculator.jison
	node ../lib/cli.js -t typescript -o ts-calculator.ts ts-calculator.jison

ts-calculator.js: ts-calculator.ts
	npx tsc ts-calculator.ts

# ts-node calculator -- run ts-calculator.ts without compiling with tsc
ts-node-calculator-demo: ts-calculator.ts
	npx ts-node ts-calculator.cli.js calculator.input.txt

