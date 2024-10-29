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
	//TODO
}

// Generate a new element for symbol table
SYMBOL* NewSymbol(char* name, int kind, int type) {
	//TODO
}

// Insert an element to symbol table entry
void AddSymbol(SYMTAB* symtab, SYMBOL* symbol) {
	//TODO
}

// Find an element with corresponding name from symbol table, considering its scope
SYMBOL* FindSymbol(SYMTAB* symtab, char* name) {
	//TODO
}

// Construct a symbol table tree using parse tree
SYMTAB* ConstructSymTab(SYMTAB* symtab, NODE* node) {
	//TODO
}


//  PROBLEM2
// Do scope-analysis for every variables in the code
// for detecting undefined variables
void ScopeAnalysis(SYMTAB* symtab, NODE* node) {
	//TODO
}


//  PROBLEM3
// Do type-analysis for every arithmetic & logic expressions in the code
// for detecting type error
// 1. array index should be integer
// 2. float number cannot be stored in integer variable
void TypeAnalysis(SYMTAB* symtab, NODE* node) {
	//TODO
}

#endif