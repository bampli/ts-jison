/**
 * Gist from https://gist.github.com/matthewkastor/6547389
 * The jison grammar file describes a parser that recognizes HTML style comments.
 * It should be simple to change the grammar to recognize any other markup for
 * multiline comments. I've put a lot of notes in the grammar file about it's
 * structure and links to where I found the information. To generate the comment
 * parser you'll need jison installed. Then run commentsParserGenerator.js through
 * Node, it will read comments.jison and generate the parser as comments.js.
 * It will then run comments.js over comments.txt and display the results.
 *
 * npx jison comments.jison
 * 
*/

/**
 * # Lexer
 * 
 * Section begins with %lex and ends with /lex it is divided up by %%
 *  signs. Explained in http://dinosaur.compilertools.net/flex/flex_6.html#SEC6
 */
%lex

/**
 * ## Lexer: Definitions
 */

%{
    /**
     * ### Miscellaneous Code
     * 
     * Any code in crazybraces anywhere in the lex section is copied into
     *  the lexer.
     */
%}

/**
 * ### Name Definitions
 *  Basically its "name" space "regular expression". Then you can refer to the
 *  regex in your lexer rules by wrapping the name in curly braces {name}
 */
ANY (.|\s)

/**
 * ### Start conditions
 *  (%s, %x) explained at
 *  http://dinosaur.compilertools.net/flex/flex_11.html
 *  %s is shared %x is exclusive
 *  %s contexts use their own rules and rules without contexts.
 *  %x contexts use only the set of rules for their specific context.
 *  Add rules to a context by preceeding them with the context name in angle
 *  brackets. <myContext>
 */
%s Comments

%%

/**
 * ## Lexer: Rules
 */

// left arrow in the "INITIAL" (default, 0) context switches to "Comments"
// context.
<INITIAL>"<--"              {
                                //console.log("comment : " + showInvisibles(yytext));
                                lexer.begin('Comments');
                                return 'COMMENT';
                            }
// when in "Comments" context the first right arrow will switch back to
// "INITIAL" context.
<Comments>"-->"             {
                                //console.log("comment : " + showInvisibles(yytext));
                                lexer.begin('INITIAL');
                                return 'COMMENT';
                            }
// when in "Comments" context every character is a comment and passes through to
// the parser.
<Comments>{ANY}             {
                                //console.log("comment : " + showInvisibles(yytext));
                                return 'COMMENT';
                            }
// end of "Comments" context conditions.

// in the "INITIAL" context, by default every character is text and  and passes
// through to the parser. Since the start conditions are specified with %s this
// rule has effect in all contexts. Override it to treat characters as something
// other than  "TEXT", or switch the start conditions to %x
{ANY}                       {
                                //console.log("text : " + showInvisibles(yytext));
                                return 'TEXT';
                            }
// same "global" effect as noted above. Allows you to catch the end of the file
// in parser rules.
<<EOF>>                     {
                                //console.log("EOF");
                                return 'EOF';
                            }
%%
/**
 * ## Lexer: User Code
 */

function showInvisibles (text) {
    var replacers = ["\\r", "\\n", "\\t", "\\v", "\\f", "\\0"];
    replacers.forEach(function (replacement) {
        var replacer = new RegExp(replacement, "g");
        text = text.replace(replacer, replacement);
    });
    text = text.replace(/ /g, "•")
    return text;
}

/lex

/**
 * # Parser
 * 
 * Section begins here and goes to end of file it is divided up by %% signs
 *  explained in http://www.gnu.org/software/bison/manual/html_node/Grammar-Layout.html#Grammar-Layout
 */

%{
    /**
     * ## Parser: Prologue
     * 
     * These crazybraces . . .
     * 
     * The prologue is copied into the parser. Put code in here to use in
     *  actions in the grammar rules. You may declare a lexical analyzer `lexer`
     *  and the error printer yyerror here. To `require` code, you will need to
     *  keep in mind that parser is going to be in a different scope from your
     *  module, so either pass it as an argument to simple functions or give the
     *  parser to some initialization code in your module that will keep a
     *  reference to it.
     */
%}

/**
 * ## Parser Declarations
 * 
 * The Bison declarations declare the names of the terminal and nonterminal
 *  symbols, and may also describe operator precedence and the data types of
 *  semantic values of various symbols. Explained in
 *  http://www.gnu.org/software/bison/manual/html_node/Declarations.html#Declarations
 */
%token TEXT COMMENT
%token EOF
%start corruption

%%

/**
 * ## Parser Grammar
 * 
 * The grammar rules define how to construct each nonterminal symbol from its
 *  parts. Explained in 
 *  http://www.gnu.org/software/bison/manual/html_node/Grammar-File.html#Grammar-File
 */

// corruption comes from studying dark arts.
corruption
    : dark_arts EOF {return $dark_arts;}
    ;

// dark arts may be a single occurrence of pyrotechnics or repeated occurrences.
dark_arts
    : pyrotechnics {$$ = $pyrotechnics;}
    | dark_arts pyrotechnics {$$ = $dark_arts + $pyrotechnics;}
    ;

// flame warriors from every corner of the internet know that the best way to
// start a tire fire is with misspelled text or smarmy comments.
pyrotechnics
    : TEXT {$$ = yytext;}
    | COMMENT {$$ = '';}
    ;

%%

/**
 * ## Parser Epilogue
 * 
 * The epilogue can contain any code you want to use. Often the definitions of
 *  functions declared in the prologue go here. In a simple program, all the
 *  rest of the program can go here.
 */