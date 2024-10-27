%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void yyerror(const char* s);
int yylex(void); // Asegúrate de declarar esta función

%}

%union {
    float num;  // Para números de tipo flotante
}

%token <num> NUMBER
%token PLUS MINUS MULT DIV LPAREN RPAREN
%type <num> expr

%left PLUS MINUS
%left MULT DIV

%% 
program:
    program expr '\n' { 
        printf("Resultado: %f\n", $2); 
    }
    |
    ;

expr:
    expr PLUS expr   { 
        printf("Suma: %f + %f\n", $1, $3); 
        $$ = $1 + $3; 
    } 
    | expr MINUS expr { 
        printf("Resta: %f - %f\n", $1, $3); 
        $$ = $1 - $3; 
    } 
    | expr MULT expr  { 
        printf("Multiplicacion: %f * %f\n", $1, $3); 
        $$ = $1 * $3; 
    } 
    | expr DIV expr   { 
        if ($3 == 0) {
            yyerror("Error: Division por cero");
            $$ = 0; 
        } else {
            printf("Division: %f / %f\n", $1, $3); 
            $$ = $1 / $3; 
        }
    } 
    | NUMBER { 
        printf("Numero: %f\n", $1); 
        $$ = $1; 
    }
    ;

%% 

void yyerror(const char* s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main() {
    printf("Introduce expresiones matematicas:\n");
    return yyparse();
}
