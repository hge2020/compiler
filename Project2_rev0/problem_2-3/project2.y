
%{
/**********PROLOGUE AREA**********/
//THIS AREA WILL BE COPIED TO y.tab.c CODE

#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>
#include "node.c"


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
							// "c_code"라는 이름의 노드를 만들고, code 노드를 자식으로 추가
							$$ = MakeNode("c_code");
							InsertChild($$, $1);  // code 노드를 자식으로 추가
					}

	| c_code code 	
					{
							// 기존 c_code 노드에 새로운 code 노드를 추가
							InsertChild($1, $2);
							$$ = $1;
					}
	;

code:
	define_header
					{
							$$ = $1;  // define_header 노드를 그대로 반환
					}

	|func_def     	{
							$$ = $1;  // func_def 노드를 그대로 반환
					} 
	;

define_header:
	DEFINE ID NUM 	
					{
					// "define_header"라는 이름의 노드를 만들고, ID와 NUM을 자식으로 추가
							$$ = MakeNode("define_header");
							InsertChild($$, MakeNode($2));  // ID 노드
							InsertChild($$, MakeNode($3));  // NUM 노드
					}
	;

func_def:
	type ID LPAREN func_arg_dec RPAREN LBRACE body RBRACE  	
					{
							$$ = MakeNode("func_def");
							InsertChild($$, $1);  // type 노드
							InsertChild($$, MakeNode($2));  // ID 노드
							InsertChild($$, $4);  // func_arg_dec 노드
							InsertChild($$, $6);  // body 노드
					}
	;

func_arg_dec:
	decl_list 	
					{
							$$ = $1;  // decl_list 노드를 그대로 반환
					}
	;

body:
	clause     	
					{
							$$ = $1;
					}
	|statement 	
					{
							$$ = $1;
					}
	|body body 	
					{
							$$ = $1;
					}
	;

clause: 
    FOR LPAREN init_stmt test_expr SEMICOLON update_stmt RPAREN LBRACE body RBRACE 	
					{
							// "FOR" 노드를 루트로 생성
							$$ = MakeNode("FOR");
							
							// 각 자식 노드를 트리에 추가
							InsertChild($$, MakeNode("LPAREN"));  // "(" 노드
							InsertChild($$, $3);  // init_stmt 노드
							InsertChild($$, $4);  // test_expr 노드
							InsertChild($$, MakeNode("SEMICOLON"));  // ";" 노드
							InsertChild($$, $6);  // update_stmt 노드
							InsertChild($$, MakeNode("RPAREN"));  // ")" 노드
							InsertChild($$, MakeNode("LBRACE"));  // "{" 노드
							InsertChild($$, $9);  // body 노드
							InsertChild($$, MakeNode("RBRACE"));  // "}" 노드
					}

    |IF LPAREN test_expr RPAREN LBRACE body RBRACE 			
					{
							// "IF" 노드를 루트로 생성
							$$ = MakeNode("IF");
							
							// 각 자식 노드를 트리에 추가
							InsertChild($$, MakeNode("LPAREN"));  // "(" 노드
							InsertChild($$, $3);  // test_expr 노드
							InsertChild($$, MakeNode("RPAREN"));  // ")" 노드
							InsertChild($$, MakeNode("LBRACE"));  // "{" 노드
							InsertChild($$, $6);  // body 노드
							InsertChild($$, MakeNode("RBRACE"));  // "{" 노드
					}

    |IF LPAREN test_expr RPAREN statement 			
					{
														// "IF" 노드를 루트로 생성
							$$ = MakeNode("IF");
							
							// 각 자식 노드를 트리에 추가
							InsertChild($$, MakeNode("LPAREN"));  // "(" 노드
							InsertChild($$, $3);  // test_expr 노드
							InsertChild($$, MakeNode("RPAREN"));  // ")" 노드
							InsertChild($$, $5);  // statement 노드
					}
	;

statement:
    assign_stmt SEMICOLON  	
					{
							// "assign_stmt" 노드를 생성하고, 그 자식으로 assign_stmt와 SEMICOLON을 추가
							$$ = MakeNode("assign_stmt");
							InsertChild($$, $1);  // assign_stmt 노드 추가
							InsertChild($$, MakeNode("SEMICOLON"));  // ";" 노드 추가
					}

    | continue_stmt SEMICOLON 	
					{
							// "continue_stmt" 노드를 생성하고, 그 자식으로 continue_stmt와 SEMICOLON을 추가
							$$ = MakeNode("continue_stmt");
							InsertChild($$, $1);  // continue_stmt 노드 추가
							InsertChild($$, MakeNode("SEMICOLON"));  // ";" 노드 추가
					}

    | decl_list SEMICOLON 		
					{
							// "decl_list" 노드를 생성하고, 그 자식으로 decl_list와 SEMICOLON을 추가
							$$ = MakeNode("decl_list");
							InsertChild($$, $1);  // decl_list 노드 추가
							InsertChild($$, MakeNode("SEMICOLON"));  // ";" 노드 추가
					}

    | error SEMICOLON
					{
							// 에러가 발생한 경우 "error" 노드를 생성
							$$ = MakeNode("error");
							InsertChild($$, MakeNode("SEMICOLON"));  // ";" 노드 추가
					}
    ;

init_stmt:
    assign_stmt SEMICOLON 
    {
        // "init_stmt"라는 노드를 생성합니다.
        $$ = MakeNode("init_stmt");
        InsertChild($$, $1);  // assign_stmt 노드 추가
        InsertChild($$, MakeNode("SEMICOLON"));  // 세미콜론 노드 추가
    }

    | decl_list SEMICOLON  
    {
        $$ = MakeNode("init_stmt");
        InsertChild($$, $1);  // 선언 목록 노드 추가
        InsertChild($$, MakeNode("SEMICOLON"));  // 세미콜론 노드 추가
    }
;

	update_stmt:
		inc_expr		
						{
								$$ = MakeNode("update_stmt");
								InsertChild($$, $1);  // 증가 표현식 노드 추가
						}
		|decl_list		
						{
								$$ = MakeNode("update_stmt");
								InsertChild($$, $1);  // 선언 목록 노드 추가
						}
		;

assign_stmt:
    variable OP_ASSIGN al_expr 
					{
							$$ = MakeNode("assign_stmt");
							InsertChild($$, $1); 
							InsertChild($$, MakeNode("OP_ASSIGN")); 
							InsertChild($$, $3); 
					}
    ;

continue_stmt:
    CONTINUE   
					{
							$$ = MakeNode("continue_stmt");
							InsertChild($$, MakeNode("CONTINUE"));
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

	yyparse();

	//todo: print tree


	return 0;
}
