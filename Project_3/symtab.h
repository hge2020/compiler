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
				if (k < sym->num_type - 1) printf(" / ");
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
        new_symbol->num_type = 0;
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

void ConstructBodySybTab(SYMTAB* symtab, NODE* node);

int TypeDerivation(NODE* node){
	if(strcmp(node->name, "VOID: void") == 0){
		return 0;
	}
	else if(strcmp(node->name, "INT: int") == 0){
		return 1;
	}
}

char* FindName(NODE* node){
	if (strncmp(node->name, "ID: ", 4) == 0) {
        // "ID: " 이후의 문자열을 반환
        return node->name + 4;  // "ID: "의 길이인 4를 건너뛰어 반환
    }
	else{
		return FindName(node->child);
	}
}


SYMBOL* DecIDerivation(NODE* node, int kind){
	int type[8] = { -1 };
	char name[64] = "";
	while (node != NULL) {
		if(strcmp(node->name, "type") == 0){
			type[0] = TypeDerivation(node);
		}
		else if(strcmp(node->name, "variable") == 0){
			strcpy(name, FindName(node));  // FindName의 결과를 name에 복사
		}
		node = node->next;  // 다음 자식 노드로 이동
	}
	return NewSymbol(name, kind, type);
}


void DecLDerivation(SYMBOL** entry, NODE* node, int kind){
	if(strcmp(node->name, "decl_init") == 0){
		NODE* child = node->child;
		int num_entry = 0;
		while (child != NULL) {
			entry[num_entry++] = DecIDerivation(child, kind);
			child = child->next;
		}
		return;
	}
	else{
		DecLDerivation(entry, node->child, kind);
	}
}


void ForDerivation(SYMTAB* symtab, NODE* node){
	NODE* child = node->child;
	while (child != NULL) {
			if (strcmp(child->name, "init_stmt") == 0){
				child = child->child;
				if (strcmp(child->name, "decl_list") == 0){
					struct SYMBOL* entry[8];
					DecLDerivation(entry, child, 2);
					SYMTAB* child_symtab = NewSymTab();
					for(int i = 0; i<8; i++){
						AddSymbol(child_symtab, entry[i]);
					}
					AddSymTab(symtab, child_symtab);
				}
			}
			else if (strcmp(child->name, "body") == 0){
				SYMTAB* child_symtab = NewSymTab();
				AddSymTab(symtab, child_symtab);
				ConstructBodySybTab(child_symtab, child);
			}
		child = child->next;
	}
}

void IfDerivation(SYMTAB* symtab, NODE* node){
	NODE* child = node->child;
	while (child != NULL) {
			if (strcmp(child->name, "statement") == 0){
				child = child->child;
				if (strcmp(child->name, "decl_list") == 0){
					struct SYMBOL* entry[8];
					DecLDerivation(entry, child, 2);
					SYMTAB* child_symtab = NewSymTab();
					for(int i = 0; i<8; i++){
						AddSymbol(child_symtab, entry[i]);
					}
					AddSymTab(symtab, child_symtab);
				}
			}
			else if (strcmp(child->name, "body") == 0){
				SYMTAB* child_symtab = NewSymTab();
				AddSymTab(symtab, child_symtab);
				ConstructBodySybTab(child_symtab, child);
			}
		child = child->next;  // 다음 자식 노드로 이동
	}
}

void ConstructBodySybTab(SYMTAB* symtab, NODE* node){
	NODE* child = node->child;
	while (child != NULL) {
		if(strcmp(child->name, "statement") == 0){
			child = child->child;
			if (strcmp(child->name, "decl_list") == 0){
				struct SYMBOL* entry[8];
				DecLDerivation(entry, child, 2);
				SYMTAB* child_symtab = NewSymTab();
					for(int i = 0; i<8; i++){
						AddSymbol(child_symtab, entry[i]);
					}
					AddSymTab(symtab, child_symtab);
			}
		}
		else if(strcmp(child->name, "clause") == 0){
			child = child->child;
			if (strcmp(child->name, "FOR: for") == 0){
				ForDerivation(symtab, child);
			}
			else if (strcmp(child->name, "IF: if") == 0){
				IfDerivation(symtab, child);
			}
		}
		else {ConstructBodySybTab(symtab, child);}
		child = child->next;
	}
}


void ConstructFuncSymTab(SYMTAB* symtab, NODE* node){
	int type[8] = { -1 };
	char name[64] = "";
	NODE* child = node->child;
	struct SYMBOL* entry[8];
	SYMTAB* child_symtab = NewSymTab();
	SYMTAB* body_symtab = NewSymTab();
	while (child != NULL) {
		if(strcmp(child->name, "type") == 0){
			type[0] = TypeDerivation(child);
		}
		else if(strcmp(child->name, "name")==0){
			strcpy(name, FindName(node));
		}
		else if(strcmp(child->name, "func_arg_dec") == 0){
			DecLDerivation(entry, child, 1);
		}
		else if(strcmp(child->name, "body") == 0){
			ConstructBodySybTab(body_symtab, child);
		}
		child = child->next;  // 다음 자식 노드로 이동
	}
	
	for(int i = 0; i<8; i++){
		type[i+1] = entry[i]->type[0];
	}
	AddSymbol(child_symtab, NewSymbol(name, 0, type));
	for(int i = 0; i<8; i++){
		AddSymbol(child_symtab, entry[i]);
	}
	AddSymTab(symtab, child_symtab);
	AddSymTab(child_symtab, body_symtab);
}


// Construct a symbol table tree using parse tree
SYMTAB* ConstructSymTab(SYMTAB* symtab, NODE* node) {
	NODE* child = node->child;
	while (child != NULL) {
		if (strcmp(child->name, "func_def") == 0){
			ConstructFuncSymTab(symtab, child);
		}
		else{
			ConstructSymTab(symtab, child);
		}
		child = child->next;  // 다음 자식 노드로 이동
	}
}

//  PROBLEM2
// Do scope-analysis for every variables in the code
// for detecting undefined variables
void ScopeAnalysis(SYMTAB* symtab, NODE* node) {
	//node를 bfs 탐색
	//var 발견시, FindSymbol 함수 사용
	//찾지 못했다면 에러발생
}


//  PROBLEM3
// Do type-analysis for every arithmetic & logic expressions in the code
// for detecting type error
// 1. array index should be integer
// 2. float number cannot be stored in integer variable
void TypeAnalysis(SYMTAB* symtab, NODE* node) {
	//TODO
	//node를 bfs 탐색
	//var 발견시 FindSymbol 함수 사용
	//리턴된 심볼의 type이 var의 type과 일치하는지 확인
	//아니라면 에러발생
}

#endif