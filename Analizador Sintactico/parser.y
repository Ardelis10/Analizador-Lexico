%{
#include <stdio.h>
#include <stdlib.h>

void yyerror(const char *s); 
extern int yylex();          
%}

%union {
    float num;  
}

%token <num> NUMBER
%token PLUS MINUS MULT DIV LPAREN RPAREN

%type <num> exp

%left PLUS MINUS
%left MULT DIV

%% 

input:
    exp '\n'   { 
                    printf("Resultado: %f\n", $1); 
                }
    |           { 
                    printf("Entrada vacía.\n"); 
                } 
    ;

exp:
    exp PLUS exp    { 
                        $$ = $1 + $3; 
                       
                    }
    | exp MINUS exp   { 
                        $$ = $1 - $3; 
                       
                    }
    | exp MULT exp    { 
                        $$ = $1 * $3; 
                        
                    }
    | exp DIV exp     { 
                        if ($3 == 0) {
                            yyerror("Error: División por cero");
                        } else {
                            $$ = $1 / $3; 
                            
                        }
                    }
    | LPAREN exp RPAREN { 
                        $$ = $2; 
                       
                    } 
    | NUMBER            { 
                        $$ = $1; 
                        
                    }
    ;

%% 

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main() {
    printf("Ingrese una expresion matematica:\n");
    while (yyparse() == 0);  
    return 0;
}
