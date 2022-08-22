%lex

%%

"category"                  { return 'LOWER'; }
"Category"                  { return 'CAMEL'; }
[\n\r]+                     { return 'EOL'; }
<<EOF>>                     { return 'EOF'; }
.                           { return 'LINE'; }

/* ------------------
[a-zA-Z0-9]+				{ return 'WORD'; }
(.|\n)						{ return 'CHAR'; }
--------------------- */

/lex

%%

code
    : lines EOF             { console.log($1); }
    ;

lines
    : lines line            { $$ = $1 + $2; }
    | line                  { $$ = $1; }
    ;

line
    : l EOL                 { $$ = $1 + $2; }
    ;

l
    : l entity              { $$ = $1 + $2; }
    | l other            { $$ = $1 + $2; }
    | entity                { $$ = $1; }
    | other              { $$ = $1; }
    ;

other
    : LINE                  { $$ = $1; }
    ;

entity
    : 'LOWER'               { $$ = "cyclo" }
    | 'CAMEL'               { $$ = "Cyclo" }
    ;
