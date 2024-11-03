#ifndef SYMTAB_H
#define SYMTAB_H

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "node.h"

//  PROBLEM1
// Structure for a symbol table
typedef struct SYMTAB {
	struct SYMTAB* parent;
	struct SYMTAB* child[16];	// maximum child num = 16
	int num_child;				// real child num
    struct SYMBOL* entry[64];	// maximum number of symbol table entries = 64
	int num_entry;				// real entry num
} SYMTAB;

// Structure for a symbol table entry
typedef struct SYMBOL {
    char name[64];
	int kind;		// 0: func, 1: param, 2: var
    int type[8];	// 0: void, 1: int,   2: float
	int num_type;	// if symbol is param or var, num_type = 1.
					// else if symbol is func, num_type can be larger than 1. (return type + args type)
} SYMBOL;

// Generate a symbol table
// Example
SYMTAB* NewSymTab() {
	SYMTAB* new_symtab = (SYMTAB*) malloc(sizeof(SYMTAB));
	new_symtab->num_child = 0;
	new_symtab->num_entry = 0;
	for (int i=0; i<16; i++)
		new_symtab->child[i] = (SYMTAB*) malloc(sizeof(SYMTAB));
	for (int i=0; i<64; i++)
		new_symtab->entry[i] = (SYMBOL*) malloc(sizeof(SYMBOL));
	return new_symtab;
}

// Add a symbol table to another symbol table as a child
// Example
void AddSymTab(SYMTAB* parent_symtab, SYMTAB* child_symtab) {
	parent_symtab->child[parent_symtab->num_child] = child_symtab;
	child_symtab->parent = parent_symtab;
	parent_symtab->num_child += 1;
	return;
}

// Print a symbol table tree
void PrintSymTab(SYMTAB* symtab) {
    if (symtab == NULL) return;

    printf("name       | kind       | type\n");
    printf("-----------------------------------\n");

    // 현재 심볼 테이블의 모든 엔트리를 출력
    for (int i = 0; i < symtab->num_entry; i++) {
        SYMBOL* sym = symtab->entry[i];
        printf("%-10s |", sym->name);
		if (sym->kind == 0) {
			printf(" %-10s | ", "func");
			// 함수인 경우 여러 타입이 있을 수 있으므로 타입을 순서대로 출력
			for (int k = 0; k < sym->num_type; k++) {
                printf("%s", sym->type[k] == 0 ? "void" : (sym->type[k] == 1 ? "int" : "float"));
                if (k == 0 && sym->num_type > 1) {
                    printf(" / ");  // 첫 번째 타입 뒤에만 슬래시 추가
                } else if (k < sym->num_type - 1) {
                    printf(" ");  // 나머지 타입들은 공백으로 구분
                }
            }
		} else {
			printf(" %-10s | ", sym->kind == 1 ? "param" : "var");
			// 함수가 아닌 경우 타입이 하나만 존재
			printf("%s", sym->type[0] == 0 ? "void" : (sym->type[0] == 1 ? "int" : "float"));
		}
		printf("\n");
    }

    printf("\n");

    // 모든 자식 심볼 테이블에 대해 재귀적으로 호출
    for (int i = 0; i < symtab->num_child; i++) {
        PrintSymTab(symtab->child[i]);
    }
}



// Generate a new element for symbol table
SYMBOL* NewSymbol(char* name, int kind, int* type) {
	SYMBOL* new_symbol = (SYMBOL*) malloc(sizeof(SYMBOL));
	strncpy(new_symbol->name, name, sizeof(new_symbol->name) - 1);
    new_symbol->name[sizeof(new_symbol->name) - 1] = '\0'; // 널 종료 문자 추가
	new_symbol->kind = kind;
	if (kind == 1||kind == 2){
		new_symbol->num_type = 1;
		new_symbol->type[0] = type[0];
	}
	else if (kind == 0) {
        // 함수인 경우, 배열의 끝을 -1로 표시한다고 가정
        new_symbol->num_type = 1;
        for (int i = 0; i < 8; i++) {
            if (type[i] == -1) {
                break; // 배열의 끝을 찾았으므로 반복 종료
            }
            new_symbol->type[i] = type[i];
            new_symbol->num_type++;
        }
    }
	return new_symbol;
}

// Insert an element to symbol table entry
void AddSymbol(SYMTAB* symtab, SYMBOL* symbol) {
	symtab->entry[symtab->num_entry++] = symbol;
}

void DeleteLastChildSymTab(SYMTAB* symtab) {
    if (symtab == NULL || symtab->num_child == 0) return;

    // 마지막 자식 테이블의 참조 제거
    symtab->child[symtab->num_child - 1] = NULL;
    symtab->num_child--;
}

// Find an element with corresponding name from symbol table, considering its scope
SYMBOL* FindSymbol(SYMTAB* symtab, char* name) {
	SYMTAB* current = symtab;
    while (current != NULL) {
        // Search in the current symbol table
        for (int i = 0; i < current->num_entry; i++) {
            if (strcmp(current->entry[i]->name, name) == 0) {
                return current->entry[i]; // Symbol found
            }
        }
        // Move to the parent symbol table
        current = current->parent;
    }
    return NULL; // Symbol not found in any scope
}

char* FindName(NODE* node){
	if (strncmp(node->name, "ID: ", 4) == 0) {
        // "ID: " 이후의 문자열을 반환
        return node->name + 4;  // "ID: "의 길이인 4를 건너뛰어 반환
    }
	else{
		FindName(node->child);
	}
}


void DecIDerivation(NODE* node, SYMBOL* sym){
	if (node == NULL) return;
	if (strcmp(node->name, "type") == 0) {
		// printf("type:%s\n", node->child->name);
		if(strcmp(node->child->name, "VOID: void") == 0){
			sym->type[0] = 0;		}
		else if(strcmp(node->child->name, "INT: int") == 0){
			sym->type[0] = 1;}
		else if(strcmp(node->child->name, "FLOAT: float") == 0){
			sym->type[0] = 2;}	
    }
	if (strcmp(node->name, "al_expr") == 0){
		return;
	}
	else if(strcmp(node->name, "variable") == 0 && (strncmp(node->child->name, "ID: ", 4) == 0)){
		char* varName = FindName(node->child);
		// printf("name:%s\n", FindName(node->child));
        if (varName != NULL) {
            strncpy(sym->name, varName, sizeof(sym->name) - 1);  // name 배열에 varName 복사
        	sym->name[sizeof(sym->name) - 1] = '\0';  // 널 종결자를 추가하여 안전하게 만듦
        }
	}
	if (node->child != NULL) {
        DecIDerivation(node->child, sym);
    }
    // 형제 노드 탐색
    if (node->next != NULL) {
        DecIDerivation(node->next, sym);
    }
}

void DecLDerivation(SYMTAB* symtab, NODE* node, int kind){
	if (node == NULL) return;
	if(strcmp(node->name, "decl_init") == 0) {
		int type_array[8];
        memset(type_array, -1, sizeof(type_array));  // 모든 요소를 -1로 설정
		SYMBOL* newsym = NewSymbol("", kind, type_array);
		DecIDerivation(node, newsym);
		AddSymbol(symtab, newsym);
	}
	// 현재 노드의 자식 노드 탐색
    if (node->child != NULL) {
        DecLDerivation(symtab, node->child, kind);
    }

    // 형제 노드 탐색
    if (node->next != NULL) {
        DecLDerivation(symtab, node->next, kind);
    }
}

void ArgDerivation(SYMTAB* symtab, NODE* node){
	DecLDerivation(symtab, node->child, 1);
}

void BodyDerivation(SYMTAB* symtab, NODE* node);

void ForDerivation(SYMTAB* symtab, NODE* node){
	SYMTAB* fortab = NewSymTab();
	while (node != NULL) {
		if(strcmp(node->name, "body")==0){
			BodyDerivation(fortab, node);
		}
		node = node->next;  // 다음 형제 노드로 이동
	}
	if (fortab->num_entry > 0 || fortab->num_child > 0) {
        AddSymTab(symtab, fortab);
	}
	return;
}

void BodyDerivation(SYMTAB* symtab, NODE* node) {
    if (node == NULL) return;

    if (strcmp(node->name, "clause") == 0 && node->child != NULL && strcmp(node->child->name, "FOR: for") == 0) {
		ForDerivation(symtab, node->child);
        return;
    }
	else if(strcmp(node->name, "statement") == 0){
		DecLDerivation(symtab, node->child, 2);
	}
    // 자식 노드를 DFS 방식으로 재귀 호출
    if (node->child != NULL) {
        BodyDerivation(symtab, node->child);
    }

    // 형제 노드를 DFS 방식으로 재귀 호출
    if (node->next != NULL) {
        BodyDerivation(symtab, node->next);
    }
}

void TreeRetrieve(SYMTAB* symtab, NODE* node) {
    if (node == NULL) return;
	if (strcmp(node->name, "define_header") == 0){
		if(strncmp(node->child->next->name, "ID: ", 4) == 0){
			int type_array[8];
			memset(type_array, -1, sizeof(type_array));  // 모든 요소를 -1로 설정
			type_array[0] = 1;
			SYMBOL* newsym = NewSymbol(node->child->next->name+4, 2, type_array);
			AddSymbol(symtab, newsym);
		}
	}
    // 현재 노드가 "func_def"인지 확인
    if (strcmp(node->name, "func_def") == 0) {
        SYMTAB* functab = NewSymTab();
		int type_array[8];
		memset(type_array, -1, sizeof(type_array));  // 모든 요소를 -1로 설정
		SYMBOL* funcsym = NewSymbol("", 0, type_array);

        NODE* child_node = node->child;  // 자식 노드를 위한 포인터

        // 자식 노드들 순회
        while (child_node != NULL) {
            if (child_node->name != NULL && strcmp(child_node->name, "type") == 0) {
                if (child_node->child != NULL && strcmp(child_node->child->name, "VOID: void") == 0) {
					funcsym->type[0] = 0;		
                } else if (child_node->child != NULL && strcmp(child_node->child->name, "INT: int") == 0) {
					funcsym->type[0] = 1;		
                } else if (child_node->child != NULL && strcmp(child_node->child->name, "FLOAT: float") == 0) {
					funcsym->type[0] = 2;	
                }
            }
			else if (child_node->name != NULL && strncmp(child_node->name, "ID: ", 4) == 0) {
                char* varName = child_node->name + 4;
				strncpy(funcsym->name, varName, sizeof(funcsym->name) - 1);  // name 배열에 varName 복사
				funcsym->name[sizeof(funcsym->name) - 1] = '\0';
            }
			else if (child_node->name != NULL && strcmp(child_node->name, "func_arg_dec") == 0) {
                ArgDerivation(functab, child_node->child);
					for (int i = 0; i < functab->num_entry; i++){
					SYMBOL* sym = functab->entry[i];
					funcsym->type[i+1] = sym->type[0];
					funcsym->num_type++;
				}
				AddSymbol(symtab, funcsym);
            }
			else if(child_node->name != NULL && strcmp(child_node->name, "body") == 0){
				BodyDerivation(functab, node->child);
			}
            child_node = child_node->next;  // 다음 형제 노드로 이동
        }

		AddSymTab(symtab, functab);
    }

    // 자식 노드로 재귀 호출
    if (node->child != NULL) {
        TreeRetrieve(symtab, node->child);
    }

    // 형제 노드로 재귀 호출
    if (node->next != NULL) {
        TreeRetrieve(symtab, node->next);
    }
}
//  PROBLEM2
// Do scope-analysis for every variables in the code
// for detecting undefined variables

void ScopeAnalysis(SYMTAB* symtab, NODE* node);

void ScopeIn(SYMTAB* scopetab, NODE* node) {
    if (scopetab->num_child > 0) {
        SYMTAB* childtab = scopetab->child[0];  // 하위 스코프로 이동
        // printf("Entering new scope, first symbol: %s\n", childtab->num_entry > 0 ? childtab->entry[0]->name : "No symbols");
        
        // 하위 스코프에서만 탐색 수행
        ScopeAnalysis(childtab, node);
    }
}

void ScopeAnalysis(SYMTAB* scopetab, NODE* node) {
    if (node == NULL) return;

    // 변수 노드인 경우 현재 스코프에서 심볼 탐색
    if (strcmp(node->name, "variable") == 0 && strncmp(node->child->name, "ID: ", 4) == 0) {
        if (FindSymbol(scopetab, node->child->name + 4) == NULL) {
            printf("Undefined Error (%s)\n", node->child->name + 4);
            exit(1);  // 프로그램 종료
        }
    }

    // 스코프 진입 조건 확인 후 ScopeIn 실행
    if ((strcmp(node->name, "func_arg_dec") == 0 || strcmp(node->name, "FOR: for") == 0) && scopetab->num_child > 0) {
        ScopeIn(scopetab, node);  // 하위 스코프 진입
        return;  // 상위 스코프 탐색 종료
    }

    // 현재 스코프에서 자식 노드 DFS 탐색
    if (node->child != NULL) {
        ScopeAnalysis(scopetab, node->child);  // 현재 scopetab을 유지하며 자식 탐색
    }

    // 현재 스코프에서 형제 노드 DFS 탐색
    if (node->next != NULL) {
        ScopeAnalysis(scopetab, node->next);  // 현재 scopetab을 유지하며 형제 탐색
    }
}

int AL_exprTypeDerivation(SYMTAB* symtab, NODE* node){
    if (strncmp(node->name, "NUM: ", 5) == 0){
        return 1;
    }
    if(strcmp(node->name, "LBRACKET: [")){
        //variable찾기
        //variable이라면 심볼테이블에서 찾아서 타입리턴
        char* varName = FindName(node->prev);
        SYMBOL* varsym = FindSymbol(symtab, varName);
        printf("variable name: %s, variable type: %d\n", varsym->name, varsym->type[0]);
        return varsym->type[0];
    }
    if(strcmp(node->next->name, "OP_MUL: *") ==0 ||strcmp(node->next->name, "OP_ADD: +") ==0){
        //근데이제 덧셈곱셈있다면
        // 타입연산해야함...
        int left = AL_exprTypeDerivation(symtab, node);
        int right = AL_exprTypeDerivation(symtab, node->next->next);
        printf("left type: %d, right type: %d\n", left, right);
        return (left > right) ? left : right;
    }
        // 자식 노드로 재귀 호출
    if (node->child != NULL) {
        AL_exprTypeDerivation(symtab, node->child);
    }

    // 형제 노드로 재귀 호출
    if (node->next != NULL) {
        AL_exprTypeDerivation(symtab, node->next);
    }
}

int VariableType(SYMTAB* symtab, NODE* node){
	char* varName = FindName(node);
    SYMBOL* varsym = FindSymbol(symtab, varName);
    return varsym->type[0];
}
//  PROBLEM3
// Do type-analysis for every arithmetic & logic expressions in the code
// for detecting type error
// 1. array index should be integer
// 2. float number cannot be stored in integer variable


SYMTAB* SymtabInitialize(SYMTAB* symtab) {
    // 현재 symtab의 child가 없는 경우
    if (symtab->num_child == 0) {
        return symtab;  // child가 없으므로 리턴
    }
    if (symtab->child[0] != NULL) {
        SymtabInitialize(symtab->child[0]);  // 재귀 호출
    }
}

void TypeAnalysis(SYMTAB* symtab, NODE* node) {
	//TODO
	
	if(strcmp(node->name, "assign_stmt")==0 && strcmp(node->child->next->name, "OP_ASSIGN")==0) {
		NODE* left = node->child;
		NODE* right = node->child->next->next;
		int left_type = VariableType(symtab, left);
		int right_type = AL_exprTypeDerivation(symtab, right);
		//할당 연산자 확인해서 symboltable을 기반, left,right 타입 일치여부 확인
		//op assign이 있다면, 왼쪽 symbol의 type, 오른쪽 symbol의 type을 확인한다.
		if (right_type > left_type) {  // float을 int에 저장하려는 경우
            printf("float cannot be stored in int variable\n");
            exit(1);  // 프로그램 종료
        }
	}

	if (strcmp(node->name, "al_expr")==0 && strcmp(node->child->name, "variable")==0){
        char* varName = FindName(node->child);
        SYMBOL* varsym = FindSymbol(symtab, varName);
        if (varsym->type[0] != 1){
            printf("float number cannot be stored in integer variable!\n");
            exit(1);  // 프로그램 종료
        }
		//findnode-type
		//if not int -> 에러출력
	}
	//al_expr->variable이 int인지 symboltable에서 확인.
    // 자식 노드로 재귀 호출
    if (node->child != NULL) {
        TypeAnalysis(symtab, node->child);
    }

    // 형제 노드로 재귀 호출
    if (node->next != NULL) {
        TypeAnalysis(symtab, node->next);
    }
}

void TypeAnalysisStart(SYMTAB* symtab, NODE* node){
    SYMTAB* childtab = SymtabInitialize(symtab);
    TypeAnalysis(childtab, node);
}


#endif