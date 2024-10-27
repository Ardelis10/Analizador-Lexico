%{
#include "parser.h"
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

void yyerror(const char* s);
%}

%option noyywrap

digito      [0-9]
numero      {digito}+(\.{digito}+)?  

%%

"+"         { return PLUS; }     
"-"         { return MINUS; }    
"*"         { return MULT; }      
"/"         { return DIV; }       
"("         { return LPAREN; }   
")"         { return RPAREN; }    
{numero}    { yylval.num = atof(yytext); return NUMBER; }
[ \t]       ;  
\n          { return '\n'; }  
.           { printf("Error: caracter invalido '%s'\n", yytext); }

%%


