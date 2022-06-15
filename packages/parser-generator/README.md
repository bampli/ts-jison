ts-jison
=====

This is a fork of Zach Carter <zach@carter.name>'s [jison module](https://www.npmjs.com/package/jison) tweaked to use just enough templates to make typescript compilers tollerate the generated parser.

Status:
=====

This works (I'm using it in a few javascript and typescritp projects) and runs the original tests. If you want to geek about this, ping ericP on discord or ericprud on gitter.

Components:
* [@ts-jison/parser-generator](http://github.com/ericprud/ts-jison/tree/main/packages/parser-generator) - A lightly-typescriptified version of jison
* [@ts-jison/lexer-generator](http://github.com/ericprud/ts-jison/tree/main/packages/lexer-generator) - A lightly-typescriptified version of jison-lex
* [@ts-jison/parser](http://github.com/ericprud/ts-jison/tree/main/packages/parser) - runtime library for parsers
* [@ts-jison/lexer](http://github.com/ericprud/ts-jison/tree/main/packages/lexer) - runtime library for lexers
* [@ts-jison/common](http://github.com/ericprud/ts-jison/tree/main/packages/common) - functions needed by parser and lexer

## Example grammar
A .jison file (by convention only) includes:
1. a section of verbatim input in `%{...%}`,
2. lexer directives,
3. a `%%` demarcation
4. lexer patterns,
5. a `/lex` demarcation
6. parser precendents and directives
7. a `%%` demarcation
8. parser rules

``` antlr

/* description: Parses and executes mathematical expressions. */
%{      // 1
function hexlify (str:string): string { // elide TS types for js-compatibility
  return str.split('').map(ch => '0x' + ch.charCodeAt(0).toString(16)).join(', ')
}
%}

%lex    // 2
%no-break-if          (.*[^a-z] | '') 'return' ([^a-z].* | '') // elide trailing 'break;'

%%      // 3

\s+                   if (yy.trace) yy.trace(`skipping whitespace ${hexlify(yytext)}`)
[0-9]+("."[0-9]+)?\b  return 'NUMBER'
"-"                   return '-'
"+"                   return '+'
"("                   return '('
")"                   return ')'
<<EOF>>               return 'EOF'
.                     return 'INVALID'

/lex    // 5

%left '+' '-'
%left UMINUS
%start expr

%%      // 7

expr: e EOF                 { if (yy.trace)
                                yy.trace('returning', $1);
                              return $1; } ; // return e

e   : e '+' e               {$$ = $1+$3;}
    | e '-' e               {$$ = $1-$3;}
    | '-' e %prec UMINUS    {$$ = -$2;}
    | '(' e ')'             {$$ = $2;}
    | NUMBER                {$$ = Number(yytext);} ;
```



Original Jison README (modulo compilation examples):
=====
* [issues](http://github.com/zaach/jison/issues)
* [discuss](mailto:jison@librelist.com)

[![build status](https://travis-ci.org/zaach/jison.svg)](http://travis-ci.org/zaach/jison)

A lightly-typescriptified API for creating parsers in JavaScript
-----------------------------------------

Jison generates bottom-up parsers in JavaScript. Its API is similar to Bison's, hence the name. It supports many of Bison's major features, plus some of its own. If you are new to parser generators such as Bison, and Context-free Grammars in general, a [good introduction][1] is found in the Bison manual. If you already know Bison, Jison should be easy to pickup.

Briefly, Jison takes a JSON encoded grammar or Bison style grammar and outputs a JavaScript file capable of parsing the language described by that grammar. You can then use the generated script to parse inputs and accept, reject, or perform actions based on the input.

Installation
------------
Jison can be installed for [Node](http://nodejs.org) using [`npm`](http://github.com/isaacs/npm/)

Using npm:

    npm install ts-jison -g

Usage from the command line
-----------------------

Clone the github repository for examples:

    git clone git://github.com/ericprud/ts-jison.git
    cd ts-jison/examples

Now you're ready to generate some parsers:

    npx jison calculator.jison

This will generate `calculator.js` in your current working directory. This file can be used to parse an input file, like so:

    echo "2^32 / 1024" > testcalc
    node calculator.js testcalc

This will print out `4194304`.

Full cli option list:

    Usage: jison [file] [lexfile] [options]

    file        file containing a grammar
    lexfile     file containing a lexical grammar

    Options:
       -j, --json                    force jison to expect a grammar in JSON format
       -o FILE, --outfile FILE       Filename and base module name of the generated parser
       -d, --debug                   Debug mode
       -m TYPE, --module-type TYPE   The type of module to generate (commonjs, amd, js)
       -p TYPE, --parser-type TYPE   The type of algorithm to use for the parser (lr0, slr, lalr, lr)
       -t, --template                Template directory to use for code generation, defaults to javascript
       -V, --version                 print version and exit

Command line ts-node

    npx ts-node -e 'const p = require("./grammar").parser; console.log(p.parse("( ( (\n ) ) )\n"));

Usage from a CommonJS module
--------------------------

You can generate parsers programatically from JavaScript as well. Assuming Jison is in your commonjs environment's load path:

```javascript
// mygenerator.js
var Parser = require("jison").Parser;

// a grammar in JSON
var grammar = {
    "lex": {
        "rules": [
           ["\\s+", "/* skip whitespace */"],
           ["[a-f0-9]+", "return 'HEX';"]
        ]
    },

    "bnf": {
        "hex_strings" :[ "hex_strings HEX",
                         "HEX" ]
    }
};

// `grammar` can also be a string that uses jison's grammar format
var parser = new Parser(grammar);

// generate source, ready to be written to disk
var parserSource = parser.generate();

// you can also use the parser directly from memory

// returns true
parser.parse("adfe34bc e82a");

// throws lexical error
parser.parse("adfe34bc zxg");
```

More Documentation
------------------
For more information on creating grammars and using the generated parsers, read the [documentation](http://jison.org/docs).

How to contribute
-----------------

See [CONTRIBUTING.md](https://github.com/zaach/jison/blob/main/CONTRIBUTING.md) for contribution guidelines, how to run the tests, etc.

Projects using Jison
------------------

View them on the [wiki](https://github.com/zaach/jison/wiki/ProjectsUsingJison), or add your own.


Contributors
------------
[Githubbers](http://github.com/zaach/jison/contributors)

Special thanks to Jarred Ligatti, Manuel E. Bermúdez 

Please see the [license](LICENSE) in this directory.

  [1]: http://dinosaur.compilertools.net/bison/bison_4.html

