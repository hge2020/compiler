#ifndef NODE_H
#define NODE_H

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

typedef struct NODE{

    char name[64];
	struct NODE* parent;
	struct NODE* child;
	struct NODE* prev;
	struct NODE* next;

}NODE;

//MakeNode: make a new node
NODE* MakeNode(char* name){

	NODE* parsetree = (NODE*) malloc(sizeof(NODE));
	int len = (int)strlen(name);
	for (int i=0;i<len;i++){
		parsetree->name[i] = name[i];
	}
	parsetree->parent = NULL;
	parsetree->child = NULL;
	parsetree->prev = NULL;
	parsetree->next = NULL;
	return parsetree;
	
}

// Insert node (parent-child): append a child node to parent node
void InsertChild(NODE* parent_node, NODE* this_node){
	
	parent_node->child = this_node;
	this_node->parent = parent_node;
}

// Insert node (prev-next): append a next node to prev node 
void InsertSibling(NODE* prev_node, NODE* this_node){
	
	prev_node->next = this_node;
	this_node->prev = prev_node;
}

//Tree walk algorithm
void WalkTree(NODE* node){

	printf("(%s", node->name);
	if (node->child != NULL){
		printf("\n");
		WalkTree(node->child);
	}
	printf(")");
	if (node->next != NULL){
		printf("\n");
		WalkTree(node->next);
	}
}

#endif