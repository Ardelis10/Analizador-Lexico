%option noyywrap
%{
    #include <stdio.h>
    #include <windows.h>
    void SetColor(int ForgC);
%}


digito [0-9]
entero {digito}+
real {entero}\.{digito}*
enteroNeg \-{entero}+
realNeg \-{real}+

letra [A-Za-z]                
palabra {letra}+              
oracion ({palabra}(\s+|$))*{palabra}\. 
pregunta ({palabra}(\s+|$))*{palabra}\?   
exclamacion ({palabra}(\s+|$))*{palabra}\!

nombre [aA][rR][dD][eE][lL][iI][sS] 

%% 

[ \t] { /* Ignorar espacios en blanco */ }
{digito} { printf("\n¡Esto es un dígito!"); }
{entero} { printf("\n¡Esto es un entero!"); }
{real} { printf("\n¡Esto es un real!"); }
{enteroNeg} { printf("\n¡Esto es un entero negativo!"); }
{realNeg} { printf("\n¡Esto es un real negativo!"); }
{nombre} { SetColor(13); printf("\n¡Este es mi nombre %s!", yytext); SetColor(15); }
{exclamacion} { printf("\n¡Esto es una exclamación!"); }
{pregunta} { printf("\n¡Esto es una pregunta!"); }
{oracion} { printf("\n¡Esto es una oración!"); }
{palabra} { printf("\n¡Esto es una palabra!"); }
. { printf("\n¡Carácter no reconocido!"); }  

%% 

int main() { 
    yylex(); 
    return 0; 
}

void SetColor(int ForgC) { 
    WORD wColor; 
    HANDLE hStdOut = GetStdHandle(STD_OUTPUT_HANDLE); 
    CONSOLE_SCREEN_BUFFER_INFO csbi; 
    if (GetConsoleScreenBufferInfo(hStdOut, &csbi)) { 
        wColor = (csbi.wAttributes & 0xF0) + (ForgC & 0x0F); 
        SetConsoleTextAttribute(hStdOut, wColor); 
    } 
    return; 
}
