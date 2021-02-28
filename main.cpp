#include <iostream>
#include <stdexcept>
#include "tokens.h"

extern Expr::Parser::token_type yylex(Expr::Parser::semantic_type *yylval);
extern char *yytext;

void ExeParser();
std::string TokenToString(Expr::Parser::token::yytokentype tk){
    switch(tk){
        case Expr::Parser::token::YYEOF: return "YYEOF";                   
        case Expr::Parser::token::YYerror: return "YYerror";                  
        case Expr::Parser::token::YYUNDEF: return "YYUNDEF";                  
        case Expr::Parser::token::EOL: return "EOL";                      
        case Expr::Parser::token::KwEntero: return "KwEntero";                 
        case Expr::Parser::token::KwReal: return "KwReal";                   
        case Expr::Parser::token::KwCadena: return "KwCadena";                
        case Expr::Parser::token::KwBooleano: return "KwBooleano";              
        case Expr::Parser::token::KwCaracter: return "KwCaracter";              
        case Expr::Parser::token::KwArreglo: return "KwArreglo";
        case Expr::Parser::token::KwDe: return "KwDe";
        case Expr::Parser::token::KwFuncion: return "KwFuncion";
        case Expr::Parser::token::KwProcedimiento: return "KwProcedimiento";
        case Expr::Parser::token::KwVar: return "KwVar";
        case Expr::Parser::token::KwInicio: return "KwInicio";
        case Expr::Parser::token::KwFin: return "KwFin";
        case Expr::Parser::token::KwFinal: return "KwFinal";
        case Expr::Parser::token::KwSi: return "KwSi";
        case Expr::Parser::token::KwEntonces: return "KwEntonces";
        case Expr::Parser::token::KwSino: return "KwSino";
        case Expr::Parser::token::KwPara: return "KwPara";
        case Expr::Parser::token::KwMientras: return "KwMientras";
        case Expr::Parser::token::KwHaga: return "KwHaga";
        case Expr::Parser::token::KwLlamar: return "KwLlamar";
        case Expr::Parser::token::KwRepita: return "KwRepita";
        case Expr::Parser::token::KwHasta: return "KwHasta";
        case Expr::Parser::token::KwCaso: return "KwCaso";
        case Expr::Parser::token::OpOr: return "OpOr";
        case Expr::Parser::token::OpAnd: return "OpAnd";
        case Expr::Parser::token::OpNot: return "OpNot";
        case Expr::Parser::token::OpDiv: return "OpDiv";
        case Expr::Parser::token::OpMod: return "OpMod";
        case Expr::Parser::token::KwLea: return "KwLea";
        case Expr::Parser::token::KwEscriba: return "KwEscriba";
        case Expr::Parser::token::KwRetorne: return "KwRetorne";
        case Expr::Parser::token::KwTipo: return "KwTipo";
        case Expr::Parser::token::KwEs: return "KwEs";
        case Expr::Parser::token::KwRegistro: return "KwRegistro";
        case Expr::Parser::token::KwArchivo: return "KwArchivo";
        case Expr::Parser::token::KwSecuencial: return "KwSecuencial";
        case Expr::Parser::token::KwAbrir: return "KwAbrir";
        case Expr::Parser::token::KwComo: return "KwComo";
        case Expr::Parser::token::KwLectura: return "KwLectura";
        case Expr::Parser::token::KwEscritura: return "KwEscritura";
        case Expr::Parser::token::KwCerrar: return "KwCerrar";
        case Expr::Parser::token::KwLeer: return "KwLeer";
        case Expr::Parser::token::KwEscribir: return "KwEscribir";
        case Expr::Parser::token::OpTrue: return "OpTrue";
        case Expr::Parser::token::OpFalse: return "OpFalse";
        case Expr::Parser::token::OpenBracket: return "OpenBracket";
        case Expr::Parser::token::CloseBracket: return "CloseBracket";
        case Expr::Parser::token::OpComma: return "OpComma";
        case Expr::Parser::token::OpColon: return "OpColon";
        case Expr::Parser::token::OPPAR: return "OPPAR";
        case Expr::Parser::token::CLOSEPAR: return "ClosePar";
        case Expr::Parser::token::OpAssign: return "OpAssign";
        case Expr::Parser::token::OPADD: return "OPADD";
        case Expr::Parser::token::OPSUB: return "OPSUB";
        case Expr::Parser::token::OPMUL: return "OPMUL";
        case Expr::Parser::token::OPDIV: return "OPDIV";
        case Expr::Parser::token::OpExponente: return "OpExponente";
        case Expr::Parser::token::OpLT: return "OpLT";
        case Expr::Parser::token::OpGT: return "OpGT";
        case Expr::Parser::token::OpEqual: return "OpEqual";
        case Expr::Parser::token::OpNotEqual: return "OpNotEqual";
        case Expr::Parser::token::OpLE: return "OpLE";
        case Expr::Parser::token::OpGE: return "OpGE";
        case Expr::Parser::token::stringConstant: return "stringConstant";
        case Expr::Parser::token::charConstant: return "charConstant";
        case Expr::Parser::token::ID: return "ID";
        case Expr::Parser::token::intConstant: return "intConstant";
        default: return "ERROR";   
    }
}

void ExeLexer(){
    Expr::Parser::semantic_type yylval;
    Expr::Parser::token_type tk;
    tk = yylex(&yylval);
    while(tk != Expr::Parser::token::YYEOF){
        std::cout<<"Lexema: "<<yytext<<" Token: " << TokenToString(tk) << std::endl;
        tk = yylex(&yylval);
    }
}

int main(){
    
    ExeLexer();

    return 0; 
}