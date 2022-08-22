%lex

%%

[^\n\r]+            { return 'LINE'; }
[\n\r]+             { return 'EOL'; }
<<EOF>>             { return 'EOF'; }

/lex

%%

p
    : ll EOF        { console.log($1); }
    ;

ll
    : ll l          { $$ = $1 + $2; }
    | l             { $$ = $1; }
    ;

l
    : LINE EOL      { $$ = $1 + $2; }
    ;
