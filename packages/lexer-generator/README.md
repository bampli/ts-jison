@ts-jison/lexer-generator:
====
A lightly-typescriptified API for creating parsers in JavaScript
-----------------------------------------
A lexical analyzer generator used by [@ts-jison/parser-generator](../parser-generator). It takes a lexical grammar definition (either in JSON or Bison's lexical grammar format) and outputs a JavaScript lexer.

This is a fork of Zach Carter <zach@carter.name>'s [jison module](https://www.npmjs.com/package/jison) tweaked to use just enough templates to make typescript compilers tollerate the generated parser. Additional work has gone into passing YY objects through both the parser constructor and the `parse(text, yyobject)` methods.

Installation
------------
`@ts-jison/lexer-generator` can be installed for [Node](http://nodejs.org) using [`npm`](http://github.com/isaacs/npm/)

Using npm:

    npm install @ts-jison/lexer-generator -g


Status:
=====

This works (I'm using it in a few javascript and typescritp projects) and runs the original tests. If you want to geek about this, ping ericP on discord or ericprud on gitter.

* [issues](http://github.com/ericprud/ts-jison/issues)

<!-- [![build status](https://travis-ci.org/zaach/jison.svg)](http://travis-ci.org/zaach/jison) -->

Components:
=====
* [parser-generator](../parser-generator) - A lightly-typescriptified version of jison
* [lexer-generator](../lexer-generator) - A lightly-typescriptified version of jison-lex
* [parser](../parser) - runtime library for parsers
* [lexer](../lexer) - runtime library for lexers
* [common](../common) - functions needed by parser and lexer

## usage
```
Usage: ts-lex [file] [options]

file     file containing a lexical grammar

Options:
   -o FILE, --outfile FILE       Filename and base module name of the generated parser
   -t TYPE, --module-type TYPE   The type of module to generate (commonjs, js)
   --version                     print version and exit
```

## programatic usage

```
var JisonLex = require(@ts-jison/lexer-generator');

var grammar = {
  rules: [
    ["x", "return 'X';" ],
    ["y", "return 'Y';" ],
    ["$", "return 'EOF';" ]
  ]
};

// or load from a file
// var grammar = fs.readFileSync('mylexer.l', 'utf8');

// generate source
var lexerSource = JisonLex.generate(grammar);

// or create a parser in memory
var lexer = new JisonLex(grammar);
lexer.setInput('xyxxy');
lexer.lex();
// => 'X'
lexer.lex();
// => 'Y'

## license
MIT
