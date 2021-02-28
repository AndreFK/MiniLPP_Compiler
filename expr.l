%option noyywrap   
%option nodefault
%option caseless

%{
#include <iostream>
#include <cstdio>
#include <cstring>
#include "tokens.h"
#define YY_DECL Expr::Parser::token_type yylex(Expr::Parser::semantic_type *yylval)
#define yyterminate() return Expr::Parser::token::YYEOF
%} 

%x bcomments

%%
[ \t]
[\n] return Expr::Parser::token::EOL;
"//"[^\n]*
"/*" {BEGIN(bcomments);}

"entero" return Expr::Parser::token::KwEntero;
"real" return Expr::Parser::token::KwReal;
"cadena" return Expr::Parser::token::KwCadena;
"booleano" return Expr::Parser::token::KwBooleano;
"caracter" return Expr::Parser::token::KwCaracter;
"arreglo" return Expr::Parser::token::KwArreglo;
"de" return Expr::Parser::token::KwDe;
"funcion" return Expr::Parser::token::KwFuncion;
"procedimiento" return Expr::Parser::token::KwProcedimiento;
"var" return Expr::Parser::token::KwVar;
"inicio" return Expr::Parser::token::KwInicio;
"fin" return Expr::Parser::token::KwFin;
"final" return Expr::Parser::token::KwFinal;
"si" return Expr::Parser::token::KwSi;
"entonces" return Expr::Parser::token::KwEntonces;
"sino" return Expr::Parser::token::KwSino;
"para" return Expr::Parser::token::KwPara;
"mientras" return Expr::Parser::token::KwMientras;
"haga" return Expr::Parser::token::KwHaga;
"llamar" return Expr::Parser::token::KwLlamar;
"repita" return Expr::Parser::token::KwRepita;
"hasta" return Expr::Parser::token::KwHasta;
"Caso" return Expr::Parser::token::KwCaso;
"o" return Expr::Parser::token::OpOr;
"y" return Expr::Parser::token::OpAnd;
"no" return Expr::Parser::token::OpNot;
"div" return Expr::Parser::token::OpDiv;
"mod" return Expr::Parser::token::OpMod;
"lea" return Expr::Parser::token::KwLea;
"escriba" return Expr::Parser::token::KwEscriba;
"retorne" return Expr::Parser::token::KwRetorne;
"tipo" return Expr::Parser::token::KwTipo;
"es" return Expr::Parser::token::KwEs;
"registro" return Expr::Parser::token::KwRegistro;
"archivo" return Expr::Parser::token::KwArchivo;
"secuencial" return Expr::Parser::token::KwSecuencial;
"abrir" return Expr::Parser::token::KwAbrir;
"como" return Expr::Parser::token::KwComo;
"lectura" return Expr::Parser::token::KwLectura;
"escritura" return Expr::Parser::token::KwEscritura;
"cerrar" return Expr::Parser::token::KwCerrar;
"leer" return Expr::Parser::token::KwLeer;
"escribir" return Expr::Parser::token::KwEscribir;
"verdadero" return Expr::Parser::token::OpTrue;
"falso" return Expr::Parser::token::OpFalse;

"[" return Expr::Parser::token::OpenBracket;
"]" return Expr::Parser::token::CloseBracket;
"," return Expr::Parser::token::OpComma;
":" return Expr::Parser::token::OpColon;
"(" return Expr::Parser::token::OPPAR;
")" return Expr::Parser::token::CLOSEPAR;
"<-" return Expr::Parser::token::OpAssign;
"+" return Expr::Parser::token::OPADD;
"-" return Expr::Parser::token::OPSUB;
"*" return Expr::Parser::token::OPMUL;
"/" return Expr::Parser::token::OPDIV;
"^" return Expr::Parser::token::OpExponente;
"<" return Expr::Parser::token::OpLT;
">" return Expr::Parser::token::OpGT;
"=" return Expr::Parser::token::OpEqual;
"<>" return Expr::Parser::token::OpNotEqual;
"<=" return Expr::Parser::token::OpLE;
">=" return Expr::Parser::token::OpGE;

"\""[^\n]+"\"" {return Expr::Parser::token::stringConstant;}
"\'"[^\n']"\'" {return Expr::Parser::token::charConstant;}
[0-9]+ {yylval->emplace<double>(std::stod(yytext)); return Expr::Parser::token::intConstant;}
"0x"[A-F0-9]+ {yylval->emplace<double>(std::stod(yytext)); return Expr::Parser::token::intConstant;}
"0b"[0-1]+ {yylval->emplace<double>(std::stod(yytext)); return Expr::Parser::token::intConstant;}
[a-zA-Z_]?[_a-zA-Z0-9]+ {yylval->emplace<std::string>(yytext,yyleng); return Expr::Parser::token::ID;}
. return Expr::Parser::token::ERROR; 

<bcomments>"*/" { BEGIN(INITIAL);}
<bcomments>.|\n
<bcomments><<EOF>> { std::cout<<"ERROR"<<'\n'; } 
%%
