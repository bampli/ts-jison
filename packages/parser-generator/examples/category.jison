
/* description: Parses typescript code replacing category for cyclo. */

/* lexical grammar */
%lex
%%

\s+                         /* skip whitespace */
"category"                  return 'CATEGORYLOWER';
"Category"                  return 'CATEGORYCAMEL';
[^\S\r\n]+                  return 'SPACE'
(\r?\n)+\s*                 return 'NL'
<<EOF>>                     return 'EOF'
.                           return 'CHAR'

/lex

/* operator associations and precedence */

%start code

%% /* language grammar */

code        : lines 'EOF'                       { console.log($1); return $1; }
            ;

lines       : line                              { $$ = [$1] }
            | lines line                        { $$ = $1.concat([$2]) }
            ;

line        : text 'NL'                         { $$ = $1 + $2 }
            | 'NL'                              { $$ = $1 }
            ;

text        : [string category]                 { $$ = $1 }
            | text 'SPACE'                      { $$ = $1 + $2 }
            | text [string category]            { $$ = $1 + $2 }
            ;

category    : 'CATEGORYLOWER'                   { $$ = "cyclo" }
            | 'CATEGORYCAMEL'                   { $$ = "Cyclo" }
            ;

string      : 'CHAR'                            { $$ = $1 }            
            | string 'CHAR'                     { $$ = $1 + $2 }
            ;
