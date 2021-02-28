%language "c++"

%define parse.error verbose
%define api.value.type variant
%define api.parser.class {Parser}
%define api.namespace {Expr}

%code requires{
    #include <string>
    #include <unordered_map>
}

%{
#include <stdexcept>
#include <iostream>
#include <string>
#include <unordered_map>
#include "tokens.h"

Expr::Parser::token_type yylex(Expr::Parser::semantic_type *yylval);


namespace Expr{
    void Parser::error(const std::string& msg){
            throw std::runtime_error(msg);
    }
}

%}

/* Declaracion de Tokens */
%token EOL
%token KwEntero
%token KwReal
%token KwCadena
%token KwBooleano
%token KwCaracter
%token KwArreglo
%token KwDe
%token KwFuncion
%token KwProcedimiento
%token KwVar
%token KwInicio
%token KwFin
%token KwFinal
%token KwSi
%token KwEntonces
%token KwSino
%token KwPara
%token KwMientras
%token KwHaga
%token KwLlamar
%token KwRepita
%token KwHasta
%token KwCaso
%token OpOr
%token OpAnd
%token OpNot
%token OpDiv
%token OpMod
%token KwLea
%token KwEscriba
%token KwRetorne
%token KwTipo
%token KwEs
%token KwRegistro
%token KwArchivo
%token KwSecuencial
%token KwAbrir
%token KwComo
%token KwLectura
%token KwEscritura
%token KwCerrar
%token KwLeer
%token KwEscribir
%token OpTrue
%token OpFalse
%token OpenBracket "["
%token CloseBracket "]"
%token OpComma ","
%token OpColon ":"
%token OPPAR "("
%token CLOSEPAR ")"
%token OpAssign "<-"
%token OPADD "+"
%token OPSUB "-"
%token OPMUL "*"
%token OPDIV "/"
%token OpExponente "^"
%token OpLT "<"
%token OpGT ">"
%token OpEqual "=="
%token OpNotEqual "<>"
%token OpLE "<="
%token OpGE ">="
%token<std::string> stringConstant
%token<std::string> charConstant
%token<std::string> ID "id"
%token<int> intConstant "number"
%token ERROR


%%

input: ;

%%