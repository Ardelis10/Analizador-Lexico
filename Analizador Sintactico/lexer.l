%{
#include "parser.tab.h"
#include <stdlib.h>
#include <stdio.h>
%}

%option noyywrap

digito [0-9]
numero {digito}+(\.{digito}+)?  

%% 

"+"         { return PLUS; }     
"-"         { return MINUS; }    
"*"         { return MULT; }      
"/"         { return DIV; }       
"("         { return LPAREN; }   
")"         { return RPAREN; }    
{numero}    { 
                yylval.num = atof(yytext); 
                
                return NUMBER; 
            }

[ \t]       ;  // Ignorar espacios

\n          { return '\n'; }  

.           { printf("Error: carácter inválido '%s'\n", yytext); }  

%% 
