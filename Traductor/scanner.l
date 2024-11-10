%{
#include "parser.tab.h"
#include <stdlib.h>
#include <string.h>
%}

DIGIT       [0-9]+
ID          [a-zA-Z_][a-zA-Z0-9_]*

%%

"print"      { return PRINT; }
"if"         { return IF; }
"else"       { return ELSE; }
"for"        { return FOR; }
"in"         { return IN; }
"range"      { return RANGE; }


{DIGIT}      { yylval.num = atoi(yytext); return NUMBER; }
{ID}         { yylval.id = strdup(yytext); return ID; }

"="          { return EQUAL; }
"+"          { return PLUS; }
"-"          { return MINUS; }
"*"          { return TIMES; }
"/"          { return DIVIDE; }
"=="         { return EQ; }
">"          { return GT; }
"<"          { return LT; }
"("          { return LPAREN; }
")"          { return RPAREN; }
"{"          { return LBRACE; }
"}"          { return RBRACE; }
";"          { return SEMICOLON; }
[ \t\n]+     ; /* Ignora espacios en blanco */

%%

int yywrap() {
    return 1;
}



