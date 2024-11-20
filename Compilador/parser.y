%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void yyerror(const char *s);
int yylex();

// Estructura para la tabla de símbolos
#define MAX_VARS 100
typedef struct {
    char *name;
    int value;
} Symbol;

Symbol symbolTable[MAX_VARS];
int symbolCount = 0;

// Archivo donde se imprimirá la tabla de símbolos
FILE *symbolFile;

// Función para buscar el valor de una variable en la tabla de símbolos
int lookup(char *name) {
    for (int i = 0; i < symbolCount; i++) {
        if (strcmp(symbolTable[i].name, name) == 0) {
            return symbolTable[i].value;
        }
    }
    return -1; // No encontrado, retornar valor de error
}

// Función para agregar o actualizar una variable en la tabla de símbolos
void addVariable(char *name, int value) {
    // Comprobar si la variable ya existe
    for (int i = 0; i < symbolCount; i++) {
        if (strcmp(symbolTable[i].name, name) == 0) {
            symbolTable[i].value = value; // Si existe, actualizamos su valor
            return;
        }
    }

    // Si no existe, agregarla a la tabla
    if (symbolCount < MAX_VARS) {
        symbolTable[symbolCount].name = strdup(name);
        symbolTable[symbolCount].value = value;
        symbolCount++;
    } else {
        printf("Error: Tabla de símbolos llena\n");
        exit(1);
    }
}

// Función para imprimir la tabla de símbolos a un archivo
void printSymbolTable() {
    if (symbolFile == NULL) {
        symbolFile = fopen("symbol_table.txt", "w"); // Abre el archivo para escribir
        if (symbolFile == NULL) {
            printf("Error al abrir el archivo de salida.\n");
            exit(1);
        }
    }

    fprintf(symbolFile, "Tabla de símbolos:\n");
    for (int i = 0; i < symbolCount; i++) {
        fprintf(symbolFile, "Variable: %s, Valor: %d\n", symbolTable[i].name, symbolTable[i].value);
    }

    fclose(symbolFile); // Cierra el archivo después de escribir
}

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
    | ID EQUAL expr { 
        printf("int %s = %d;\n", $1, $3); 
        addVariable($1, $3); 
    }
    | IF expr LBRACE program RBRACE { printf("if (%d) {\n", $2); }
    | FOR ID EQUAL expr TO expr LBRACE program RBRACE { 
        printf("for (%s = %d; %s <= %d; %s++) {\n", $2, $4, $2, $6, $2); 
    }
    ;

expr:
    NUMBER { $$ = $1; }
    | ID    { $$ = lookup($1); 
              if ($$ == -1) { 
                  printf("Error: variable '%s' no definida\n", $1); 
                  exit(1); 
              } 
            }
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
    
    
    // Llamar al analizador sintáctico
    yyparse();

    // Imprimir la tabla de símbolos después de la ejecución
    printSymbolTable();

    return 0;
}
