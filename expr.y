%language "c++"

%define parse.error verbose
%define api.value.type variant
%define api.parser.class {Parser}
%define api.namespace {Expr}

%parse-param{list &expr_list}

%code requires{
    #include <string>
    #include <unordered_map>
    #include <vector>
    #include "ast.h"
}

%{
#include <stdexcept>
#include <iostream>
#include <string>
#include <unordered_map>
#include <vector>
#include "tokens.h"
#include "ast.h"


Expr::Parser::token_type yylex(Expr::Parser::semantic_type *yylval);

extern int yylineno;

namespace Expr{
    void Parser::error(const std::string& msg){
            std::cout << "Error en linea: " << yylineno << std::endl;
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
%token KwFuncion "funcion"
%token KwProcedimiento
%token KwVar
%token KwInicio "inicio"
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
%token OpExponente "^"
%token OpLT "<"
%token OpGT ">"
%token OpEqual "=="
%token OpNotEqual "<>"
%token OpLE "<="
%token OpGE ">="
%token stringConstant
%token charConstant
%token <std::string> ID "id"
%token <int>intConstant "number"
%token ERROR

%left OpEqual OpNotEqual OpLT OpGT OpLE OpGE
%left OPADD OpOr
%left OPMUL OpDiv OpMod OpAnd 
%left OpNot OPSUB 
%right OpExponente

%type <Ast::Expr*> program expr term factor rvalue variable_decl exponent variable_section assign
%type <Ast::Expr*> statement statement_list argument_list lvalue constants
%type <Ast::SubType*> type
%type <IdList*> id_list
%%

input: program ;

program: opt_subtype_definition_section
         opt_variable_section
         opt_subprogram_decl
         "inicio" 
         opt_eols
         statement_list 
         eols
         KwFin
         opt_eols
         
        ;

opt_subtype_definition_section: subtype_definition_section eols
                            |   %empty;

subtype_definition_section: subtype_definition_section eols KwTipo ID KwEs type
                        |   KwTipo ID KwEs type;

type:   KwEntero { $$ = new Ast::Int_Type();}
    |   KwBooleano { $$ = new Ast::Char_Type();}
    |   KwCaracter { $$ = new Ast::Bool_Type();}
    |   array_type;

array_type: KwArreglo OpenBracket intConstant CloseBracket KwDe type;

opt_variable_section: variable_section eols 
                    | %empty;

variable_section: variable_section eols variable_decl 
                {
                   $$ = $1;
                   reinterpret_cast<Ast::VarSection*>($$)->varDecls.push_back($3);
                   expr_list.push_back($3);
                }
                | variable_decl
                {
                    list temp;
                    temp.push_back($1);
                    $$ = new Ast::VarSection(temp);
                    expr_list.push_back($1);
                };

variable_decl: type id_list { $$ = new Ast::VarDecl($1,$2);};

id_list: id_list OpComma ID 
        {
            $$ = $1; 
            reinterpret_cast<std::vector<std::string>*>($$)->push_back($3);
        }
       | ID 
       {
           IdList *tempList = new std::vector<std::string>();
           tempList->push_back($1);
           $$ = tempList;
       };

opt_subprogram_decl: subprogram_decl_list eols
                   | %empty;

subprogram_decl_list: subprogram_decl_list eols subprogram_decl
                    | subprogram_decl;
                
subprogram_decl: "funcion" ID opt_arguments OpColon type eols
                 opt_variable_section
                 KwInicio opt_eols
                 statement_list eols
                 KwFin
               | KwProcedimiento ID opt_arguments eols
                 opt_variable_section
                 KwInicio opt_eols
                 statement_list eols
                 KwFin;

opt_arguments: OPPAR argument_decl_list CLOSEPAR
            |  %empty;

argument_decl_list: argument_decl_list OpComma type ID
                |   argument_decl_list OpComma KwVar type ID
                |   type ID
                |   KwVar type ID;

statement_list: statement_list eols statement 
            {
                $$ = $1;
                expr_list.push_back($3);
            }
            |   statement 
            {
                $$ = $1; 
                expr_list.push_back($1);
            };

statement: assign { $$ = $1; }
        |  KwLlamar ID
        | KwLlamar subprogram_call
        | KwEscriba argument_list {$$ = new Ast::PrintExpr($2);}
        | KwLea lvalue_list
        | if_statement
        | KwMientras expr opt_eols
        KwHaga eols
        statement_list eols
        KwFin KwMientras
        
        | KwRepita eols
        statement_list eols
        KwHasta expr 
       
        | KwPara assign KwHasta expr KwHaga eols
        statement_list eols
        KwFin KwPara
        | KwRetorne expr ;

assign: ID OpAssign expr {$$ = new Ast::AssignExpr($1,$3);};

lvalue_list: lvalue_list OpComma lvalue 
        |   lvalue ;

lvalue: ID {$$ = new Ast::IdExpr($1);}
    |   ID OpenBracket expr CloseBracket;

opt_expr_list: expr_list 
            |  %empty;

expr_list: expr_list OpComma expr 
        |  expr;

expr: expr OpEqual term {$$ = new Ast::EqExpr($1,$3);}
    | expr OpNotEqual term {$$ = new Ast::NeqExpr($1,$3);}
    | expr OpLT term {$$ = new Ast::LtExpr($1,$3);}
    | expr OpGT term {$$ = new Ast::GtExpr($1,$3);}
    | expr OpLE term {$$ = new Ast::LetExpr($1,$3);}
    | expr OpGE term {$$ = new Ast::GetExpr($1,$3);}
    | term {$$ = $1;};

term: term OPADD factor {$$ = new Ast::AddExpr($1,$3);}
    | term OPSUB factor {$$ = new Ast::SubExpr($1,$3);}
    | term OpOr factor {$$ = new Ast::OrExpr($1,$3);}
    | factor {$$ = $1;};

factor: factor OPMUL exponent {$$ = new Ast::MulExpr($1,$3);}
    |   factor OpDiv exponent {$$ = new Ast::DivExpr($1,$3);}
    |   factor OpMod exponent {$$ = new Ast::ModExpr($1,$3);}
    |   factor OpAnd exponent {$$ = new Ast::AndExpr($1,$3);}
    |   exponent {$$ = $1;};

exponent: exponent OpExponente rvalue
        | rvalue {$$ = $1;};

rvalue: OPPAR expr CLOSEPAR {$$ = $2;}
    |   constants {$$ = $1;}
    |   lvalue {$$ = $1;}
    |   subprogram_call 
    |   OPSUB expr {$$ = new Ast::UnaryExpr($2);}
    |   OpNot expr {$$ = new Ast::NotExpr($2);};

constants: intConstant {$$ = new Ast::NumExpr($1);}
        |  charConstant
        |  OpTrue
        |  OpFalse;

subprogram_call: ID OPPAR opt_expr_list CLOSEPAR;

argument_list: argument_list OpComma expr
            |  argument_list OpComma stringConstant
            |  expr {$$ = $1;}
            |  stringConstant;

if_statement: KwSi expr opt_eols
              KwEntonces opt_eols
              statement_list eols
              else_if_list
              else_statement
              KwFin KwSi;

else_if_list: else_if_list else_if_statement
            | else_if_statement
            | %empty;

else_if_statement: KwSino KwSi expr opt_eols KwEntonces opt_eols statement_list eols;

else_statement: KwSino eols statement_list eols
            |   %empty;

opt_eols: eols
        | %empty;

eols: eols EOL
    | EOL;

%%