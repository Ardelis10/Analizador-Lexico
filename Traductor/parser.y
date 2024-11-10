%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void yyerror(const char *s);
int yylex();
%}

%union {
    int num;        // Para números enteros
    char *id;       // Para identificadores (cadenas)
}

%token <num> NUMBER
%token <id> ID
%token PRINT IF ELSE FOR IN RANGE
%token TO EQUAL PLUS MINUS TIMES DIVIDE EQ GT LT
%token LPAREN RPAREN LBRACE RBRACE SEMICOLON

%type <num> expr
%type <id> stmt

/* Declaración de la precedencia de operadores */
%left PLUS MINUS
%left TIMES DIVIDE

%%

program:
    program stmt SEMICOLON { /* Ejecuta la declaración traducida */ }
    | /* vacío */ { /* Acción vacía, no hace nada */ }
    ;

stmt:
    PRINT LPAREN expr RPAREN { printf("printf(\"%%d\\n\", %d);\n", $3); }
    | ID EQUAL expr          { printf("int %s = %d;\n", $1, $3); }
    | IF expr LBRACE program RBRACE { printf("if (%d) {\n", $2); }
    | FOR ID EQUAL expr TO expr LBRACE program RBRACE { 
        printf("for (%s = %d; %s <= %d; %s++) {\n", $2, $4, $2, $6, $2); 
    }
    ;

expr:
    NUMBER { $$ = $1; }
    | ID    { $$ = 0; /* Aquí podrías asignar un valor por defecto o buscar el valor de la variable */ }
    | expr PLUS expr { $$ = $1 + $3; }
    | expr MINUS expr { $$ = $1 - $3; }
    | expr TIMES expr { $$ = $1 * $3; }
    | expr DIVIDE expr { $$ = $1 / $3; }
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main() {
    return yyparse();
}
