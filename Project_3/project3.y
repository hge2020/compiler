
%{
/**********PROLOGUE AREA**********/
//THIS AREA WILL BE COPIED TO y.tab.c CODE

#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>
#include "symtab.h"


//Entry point of parse tree
NODE *head;
//String buffer
char buf[100];

extern FILE *yyin;
extern char *yytext;
extern int yylineno;
char * filename;

int yylex();

void yyerror(const char *str)
{
	fprintf(stderr, "%s:%d: error: %s '%s' token \n", filename, yylineno, str, yytext);
}

%}

/**********GRAMMAR AREA**********/
%union {
	int number;
	char *string;
	NODE *node;
}

//Tokens & Nonterms
%token <string> DEFINE
%token <string> INT VOID
%token <string> IF FOR
%token <string> CONTINUE
%token <string> OP_ASSIGN OP_INC OP_ADD OP_MUL OP_LOGIC OP_REL
%token <string> ID
%token <string> NUM
%token <string> LPAREN RPAREN LBRACE RBRACE LBRACKET RBRACKET COMMA SEMICOLON


%start c_code
%type <node> c_code code define_header func_def func_arg_dec body statement assign_stmt continue_stmt expr decl_list decl_init al_expr rel_expr inc_expr variable value type clause init_stmt test_expr update_stmt

%%
//CFG

//todo: build parse tree in actions
c_code:
	code 			
					{

					}

	| c_code code 	
					{

					}
	;

code:
	define_header 	{

					}

	|func_def     	{
					
					} 
	;

define_header:
	DEFINE ID NUM 	
					{
					
					}
	;

func_def:
	type ID LPAREN func_arg_dec RPAREN LBRACE body RBRACE  	
					{
					
					}
	;

func_arg_dec:
	decl_list 	
					{
					
					}
	;

body:
	clause     	
					{
					
					}
	|statement 	
					{
					
					}
	|body body 	
					{
					
					}
	;

clause: 
    FOR LPAREN init_stmt test_expr SEMICOLON update_stmt RPAREN LBRACE body RBRACE 	
					{
					
					}

    |IF LPAREN test_expr RPAREN LBRACE body RBRACE 			
					{
					
					}

    |IF LPAREN test_expr RPAREN statement 			
					{
					
					}
	;

statement:
    assign_stmt SEMICOLON  	
					{
					
					}

    |continue_stmt SEMICOLON 	
					{
					
					}

	|decl_list SEMICOLON 		
					{
					
					}

	|error SEMICOLON
	;

init_stmt:
	assign_stmt SEMICOLON 

					{
					
					}

	|decl_list SEMICOLON  
					{
					
					}
	;

update_stmt:
	inc_expr		
					{
					
					}
	|decl_list		
					{
					
					}
	;

assign_stmt:
    variable OP_ASSIGN al_expr 
					{
					
					}
    ;

continue_stmt:
    CONTINUE   
					{
					
					}
    ;

expr:
	rel_expr   
					{
					
					}

	|inc_expr  
					{
					
					}

    |al_expr   
					{
					
					}
	;

test_expr:
	rel_expr  
					{
					
					}
	;

decl_list:
	decl_init  					
					{
					
					}

	|decl_list COMMA variable  	
					{
					
					}

	|decl_list COMMA decl_init 	
					{
					
					}
	;

decl_init:
	type variable 
					{
					
					}
	;

al_expr:
	NUM 						
					{
					
					}

	| variable 					
					{
					
					}

	| al_expr OP_ADD al_expr 	
					{
					
					}

	| al_expr OP_MUL al_expr 	
					{
					
					}
	;

rel_expr:
	value 							
					{
					
					}

	| rel_expr OP_REL rel_expr  	
					{
					
					}

	| rel_expr OP_LOGIC rel_expr	
					{
					
					}
	;

inc_expr:
	variable OP_INC 
					{
					
					}
	;

value:
	variable 		
					{
					
					}

	| NUM	 		
					{
					
					}
	;

variable:
	ID 				
					{
					
					}

	|variable LBRACKET RBRACKET			
					{
					
					}

	|variable LBRACKET NUM RBRACKET		
					{
					
					}

	|variable LBRACKET al_expr RBRACKET	
					{
					
					}
	;

type:
	VOID		
					{
					
					}
	| INT		
					{
					
					}
	;

%%

/**********EPILOGUE AREAR AREA**********/
//THIS AREA WILL BE COPIED TO y.tab.c CODE


int main(int argc, char **argv )
{
	++argv, --argc; /* skip over program name */
	if ( argc > 0 )
		yyin = fopen( argv[0], "r" );
	else
		yyin = stdin;
	filename = argv[0];

	//todo
	yyparse();
	//todo

	return 0;
}
