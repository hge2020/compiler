
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

int yywrap()
{
	return 1;
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
%token <string> INT VOID FLOAT
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
			// code 노드의 결과를 구문 트리의 루트로 설정
			$$ = MakeNode("c_code");
			InsertChild($$, $1);  // 첫 번째 code 노드를 c_code의 자식으로 추가
			head = $$;  // 구문 트리의 루트로 설정
		}

	| c_code code 	
		{
			$$ = MakeNode("c_code");
			InsertSibling($1, $2);  // $1은 기존의 c_code, $2는 새로 추가된 code
			InsertChild($$, $1);
			head = $$;
		}
	;

code:
	define_header
		{
			$$ = MakeNode("code");
			InsertChild($$, $1);  // $1은 define_header 노드
		};

	|func_def
		{
			$$ = MakeNode("code");
			InsertChild($$, $1);  // $1은 define_header 노드
		} 
	;

define_header:
	DEFINE ID NUM 	
		{
			// DEFINE: $1 형식으로 문자열을 생성
			char define_str[50];
			sprintf(define_str, "DEFINE: %s", $1);  // $1의 값을 문자열로 결합

			char id_str[50];
			sprintf(id_str, "ID: %s", $2);  // $2의 값을 문자열로 결합

			char num_str[50];
			sprintf(num_str, "NUM: %s", $3);  // $3의 값을 문자열로 결합

			// 생성된 문자열로 노드 생성
			NODE* define = MakeNode(define_str);
			NODE* id = MakeNode(id_str);
			NODE* num = MakeNode(num_str);

			// DEFINE, ID, NUM을 형제 노드로 연결
			InsertSibling(define, id);
			InsertSibling(id, num);

			// define_header라는 부모 노드를 만들고 자식으로 연결
			$$ = MakeNode("define_header");
			InsertChild($$, define);
		}
	;

func_def:
	type ID LPAREN func_arg_dec RPAREN LBRACE body RBRACE  	
		{
			char id_str[50];
			sprintf(id_str, "ID: %s", $2);  // $2의 값을 문자열로 결합
			NODE* id = MakeNode(id_str);
			NODE* lp_node = MakeNode("LPAREN: (");
			NODE* rp_node = MakeNode("RPAREN: )");
			NODE* lb_node = MakeNode("LBRACE: {");
			NODE* rb_node = MakeNode("RBRACE: }");

			InsertSibling($1, id);
			InsertSibling(id, lp_node);
			InsertSibling(lp_node, $4);
			InsertSibling($4, rp_node);
			InsertSibling(rp_node, lb_node);
			InsertSibling(lb_node, $7);
			InsertSibling($7, rb_node);

			$$ = MakeNode("func_def");
			InsertChild($$, $1);
		}
	;

func_arg_dec:
	decl_list 	
		{
			// decl_list 노드의 결과를 구문 트리의 루트로 설정
			$$ = MakeNode("func_arg_dec");
			InsertChild($$, $1);  // 첫 번째 func_arg_dec 노드를 decl_list의 자식으로 추가
		}
	;

body:
	clause     	
		{
			$$ = MakeNode("body");
			InsertChild($$, $1);
		}
	|statement 	
		{
			$$ = MakeNode("body");
			InsertChild($$, $1);
		}
	|body body 	
		{
			$$ = MakeNode("body");
			InsertSibling($1, $2);
			InsertChild($$, $1);
		}
	;

clause: 
    FOR LPAREN init_stmt test_expr SEMICOLON update_stmt RPAREN LBRACE body RBRACE 	
		{
			NODE* for_node = MakeNode("FOR: for");
			NODE* semicolon_node = MakeNode("SEMICOLON: ;");
			NODE* lp_node = MakeNode("LPAREN: (");
			NODE* rp_node = MakeNode("RPAREN: )");
			NODE* lb_node = MakeNode("LBRACE: {");
			NODE* rb_node = MakeNode("RBRACE: }");
		
			InsertSibling(for_node, lp_node);
			InsertSibling(lp_node, $3);
			InsertSibling($3, $4);
			InsertSibling($4, semicolon_node);
			InsertSibling(semicolon_node, $6);
			InsertSibling($6, rp_node);
			InsertSibling(rp_node, lb_node);
			InsertSibling(lb_node, $9);
			InsertSibling($9, rb_node);

			$$ = MakeNode("clause");
			InsertChild($$, for_node);
		}

    |IF LPAREN test_expr RPAREN LBRACE body RBRACE 			
		{
			NODE* if_node = MakeNode("IF: if");
			NODE* lp_node = MakeNode("LPAREN: (");
			NODE* rp_node = MakeNode("RPAREN: )");
			NODE* lb_node = MakeNode("LBRACE: {");
			NODE* rb_node = MakeNode("RBRACE: }");

			InsertSibling(if_node, lp_node);
			InsertSibling(lp_node, $3);
			InsertSibling($3, rp_node);
			InsertSibling(rp_node, lb_node);
			InsertSibling(lb_node, $6);
			InsertSibling($6, rb_node);

			$$ = MakeNode("clause");
			InsertChild($$, if_node);
		}

    |IF LPAREN test_expr RPAREN statement 			
		{
			NODE* if_node = MakeNode("if: if");
			NODE* lp_node = MakeNode("LPAREN: (");
			NODE* rp_node = MakeNode("RPAREN: )");

			InsertSibling(if_node, lp_node);
			InsertSibling(lp_node, $3);
			InsertSibling($3, rp_node);
			InsertSibling(rp_node, $5);

			$$ = MakeNode("clause");
			InsertChild($$, if_node);
		}
	;

statement:
    assign_stmt SEMICOLON  	
		{
			NODE* semicolon_node = MakeNode("SEMICOLON: ;");
			InsertSibling($1, semicolon_node);

			$$ = MakeNode("statement");
			InsertChild($$, $1);
		}

    |continue_stmt SEMICOLON 	
		{
			NODE* semicolon_node = MakeNode("SEMICOLON: ;");
			InsertSibling($1, semicolon_node);

			$$ = MakeNode("statement");
			InsertChild($$, $1);
		}

	|decl_list SEMICOLON 		
		{
			NODE* semicolon_node = MakeNode("SEMICOLON: ;");
			InsertSibling($1, semicolon_node);

			$$ = MakeNode("statement");
			InsertChild($$, $1);
		}

	|error SEMICOLON
		{
			yyerror("Syntax error encountered.");
			$$ = NULL;  // 빈 노드를 반환하여 타입 충돌 방지
		}
	;

init_stmt:
	assign_stmt SEMICOLON 
		{
			NODE* semicolon_node = MakeNode("SEMICOLON: ;");
			InsertSibling($1, semicolon_node);

			$$ = MakeNode("init_stmt");
			InsertChild($$, $1);
		}

	|decl_list SEMICOLON  
		{
			NODE* semicolon_node = MakeNode("SEMICOLON: ;");
			InsertSibling($1, semicolon_node);

			$$ = MakeNode("init_stmt");
			InsertChild($$, $1);
		}
	;

update_stmt:
	inc_expr		
		{
			$$ = MakeNode("update_stmt");
			InsertChild($$, $1);
		}
	|decl_list		
		{
			$$ = MakeNode("update_stmt");
			InsertChild($$, $1);
		}
	;

assign_stmt:
    variable OP_ASSIGN al_expr 
		{
			char assign_str[20];
			sprintf(assign_str, "OP_ASSIGN: %s", $2);
			NODE* assign_node = MakeNode(assign_str);

			InsertSibling($1, assign_node);
			InsertSibling(assign_node, $3);

			$$ = MakeNode("assign_stmt");
			InsertChild($$, $1);
		}
    ;

continue_stmt:
    CONTINUE   
		{
			NODE* continue_node = MakeNode("CONTINUE: continue");
			$$ = MakeNode("continue_stmt");
			InsertChild($$, continue_node);
		}
    ;

expr:
	rel_expr   
		{
			$$ = MakeNode("expr");
			InsertChild($$, $1);
		}

	|inc_expr  
		{
			$$ = MakeNode("expr");
			InsertChild($$, $1);
		}

    |al_expr   
		{
			$$ = MakeNode("expr");
			InsertChild($$, $1);
		}
	;

test_expr:
	rel_expr  
		{
			$$ = MakeNode("test_expr");
			InsertChild($$, $1);
		}
	;

decl_list:
	decl_init  					
		{
			$$ = MakeNode("decl_list");
			InsertChild($$, $1);
		}

	|decl_list COMMA variable  	
		{
			NODE* comma_node = MakeNode("COMMA: ,");
			InsertSibling($1, comma_node);
			InsertSibling(comma_node, $3);

			$$ = MakeNode("decl_list");
			InsertChild($$, $1);
		
		}

	|decl_list COMMA decl_init 	
		{
			NODE* comma_node = MakeNode("COMMA: ,");
			InsertSibling($1, comma_node);
			InsertSibling(comma_node, $3);

			$$ = MakeNode("decl_list");
			InsertChild($$, $1);
		}
	;

decl_init:
	type variable 
		{
			$$ = MakeNode("decl_init");
			InsertSibling($1, $2);
			InsertChild($$, $1);
		}
	;

al_expr:
	NUM 						
		{
			char num_str[50];
			sprintf(num_str, "NUM: %s", $1);  // $3의 값을 문자열로 결합
			NODE* num = MakeNode(num_str);

			$$ = MakeNode("al_expr");
			InsertChild($$, num);
		}

	| variable 					
		{
			$$ = MakeNode("al_expr");
			InsertChild($$, $1);  // $1은 define_header 노드
		} 

	| al_expr OP_ADD al_expr 	
		{
			NODE* add_node = MakeNode("OP_ADD: +");

			InsertSibling($1, add_node);
			InsertSibling(add_node, $3);

			$$ = MakeNode("al_expr");
			InsertChild($$, $1);
		}

	| al_expr OP_MUL al_expr 	
		{
			NODE* mul_node = MakeNode("OP_MUL: *");

			InsertSibling($1, mul_node);
			InsertSibling(mul_node, $3);

			$$ = MakeNode("al_expr");
			InsertChild($$, $1);
		}
	;

rel_expr:
	value 							
		{
			$$ = MakeNode("rel_expr");
			InsertChild($$, $1);
		}

	| rel_expr OP_REL rel_expr  	
		{
			char rel_str[50];
			sprintf(rel_str, "OP_REL: %s", $2);
			NODE* rel_node = MakeNode(rel_str);

			InsertSibling($1, rel_node);
			InsertSibling(rel_node, $3);

			$$ = MakeNode("rel_expr");
			InsertChild($$, $1);
		}

	| rel_expr OP_LOGIC rel_expr	
		{
			char logic_str[50];
			sprintf(logic_str, "OP_LOGIC: %s", $2);
			NODE* logic_node = MakeNode(logic_str);

			InsertSibling($1, logic_node);
			InsertSibling(logic_node, $3);

			$$ = MakeNode("rel_expr");
			InsertChild($$, $1);
		}
	;

inc_expr:
	variable OP_INC 
		{
			NODE* inc_node = MakeNode("OP_INC: ++");
			InsertSibling($1, inc_node);
		
			$$ = MakeNode("inc_expr");
			InsertChild($$, $1);
		}
	;

value:
	variable 		
		{
			$$ = MakeNode("value");
			InsertChild($$, $1);
		}

	| NUM	 		
		{
			char num_str[50];
			sprintf(num_str, "NUM: %s", $1);  // $3의 값을 문자열로 결합
			NODE* num = MakeNode(num_str);

			$$ = MakeNode("value");
			InsertChild($$, num);
		}
	;

variable:
	ID 				
		{
			char id_str[50];
			sprintf(id_str, "ID: %s", $1);  // $2의 값을 문자열로 결합
			NODE* id = MakeNode(id_str);
			$$ = MakeNode("variable");
			InsertChild($$, id);
		}

	|variable LBRACKET RBRACKET			
		{
			NODE* lbk_node = MakeNode("LBRACKET: [");
			NODE* rbk_node = MakeNode("RBRACKET: ]");

			InsertSibling($1, lbk_node);
			InsertSibling(lbk_node, rbk_node);

			$$ = MakeNode("variable");
			InsertChild($$, $1);
		}

	|variable LBRACKET NUM RBRACKET		
		{
			char num_str[50];
			sprintf(num_str, "NUM: %s", $3);  // $3의 값을 문자열로 결합
			NODE* num = MakeNode(num_str);

			NODE* lbk_node = MakeNode("LBRACKET: [");
			NODE* rbk_node = MakeNode("RBRACKET: ]");

			InsertSibling($1, lbk_node);
			InsertSibling(lbk_node, num);
			InsertSibling(num, rbk_node);

			$$ = MakeNode("variable");
			InsertChild($$, $1);
		}

	|variable LBRACKET al_expr RBRACKET	
		{
			NODE* lbk_node = MakeNode("LBRACKET: [");
			NODE* rbk_node = MakeNode("RBRACKET: ]");

			InsertSibling($1, lbk_node);
			InsertSibling(lbk_node, $3);
			InsertSibling($3, rbk_node);

			$$ = MakeNode("variable");
			InsertChild($$, $1);
		}
	;

type:
	VOID		
		{
			NODE* void_node = MakeNode("VOID: void");
			$$ = MakeNode("type");
			InsertChild($$, void_node);
		}
	| INT		
		{
			NODE* int_node = MakeNode("INT: int");
			$$ = MakeNode("type");
			InsertChild($$, int_node);
		}
	| FLOAT		
		{
			NODE* int_node = MakeNode("FLOAT: float");
			$$ = MakeNode("type");
			InsertChild($$, int_node);
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
	/* WalkTree(head); */
	SYMTAB* symtab = NewSymTab();
  	printf("yes");
	ConstructSymTab(symtab, head);
	/* PrintSymTab(symtab); */

	return 0;
}

