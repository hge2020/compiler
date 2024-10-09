
#include <stdio.h>
#include <string.h>
#include <stdlib.h>


typedef struct NODE {
    char* name;               // 노드의 이름
    struct NODE* parent;      // 부모 노드를 가리키는 포인터
    struct NODE* child;       // 첫 번째 자식 노드를 가리키는 포인터
    struct NODE* prev;        // 이전 형제 노드를 가리키는 포인터
    struct NODE* next;        // 다음 형제 노드를 가리키는 포인터
} NODE;




//MakeNode: make a new node
NODE* MakeNode(char* name) {
    NODE* newNode = (NODE*)malloc(sizeof(NODE));  // 메모리 할당
    newNode->name = (char*)malloc(strlen(name) + 1);  // 이름에 대한 메모리 할당
    strcpy(newNode->name, name);  // 이름 복사
    newNode->parent = NULL;
    newNode->child = NULL;
    newNode->prev = NULL;
    newNode->next = NULL;
    return newNode;
}

// Insert node (parent-child): append a child node to the parent node
void InsertChild(NODE* parent_node, NODE* this_node) {
    this_node->parent = parent_node;  // 자식 노드에 부모 설정
    if (parent_node->child == NULL) {
        parent_node->child = this_node;  // 첫 번째 자식으로 추가
    } else {
        NODE* sibling = parent_node->child;
        while (sibling->next != NULL) {
            sibling = sibling->next;  // 마지막 형제까지 이동
        }
        sibling->next = this_node;  // 형제 노드로 연결
        this_node->prev = sibling;  // 이전 형제 설정
    }
}


// Insert node (prev-next): append a next node to the prev node 
void InsertSibling(NODE* prev_node, NODE* this_node) {
    this_node->prev = prev_node;  // 이전 형제 설정
    if (prev_node->next == NULL) {
        prev_node->next = this_node;  // 형제 노드로 연결
    } else {
        NODE* next_node = prev_node->next;
        prev_node->next = this_node;
        this_node->next = next_node;
        next_node->prev = this_node;
    }
}

//Tree walk algorithm
void WalkTree(NODE* node) {
    if (node == NULL) return;

    // 여는 괄호와 노드 이름 출력 (줄 바꿈 추가)
    printf("(%s", node->name);

    // 자식 노드 순회
    if (node->child != NULL) {
        printf("\n");
        WalkTree(node->child);
        printf(")");  // 자식 노드 순회가 끝난 후 닫는 괄호
    } else {
        // 자식이 없을 경우 바로 닫는 괄호 출력
        printf(")");
    }

    // 형제 노드 순회
    if (node->next != NULL) {
        printf("\n");
        WalkTree(node->next);  // 형제 노드 순회
    }
}

int main() {
    // 그림 3과 같은 파스 트리 구성

    // 루트 노드 A 생성
    NODE* A = MakeNode("A");

    // A의 자식 B, E, I 생성 및 추가
    NODE* B = MakeNode("B");
    NODE* E = MakeNode("E");
    NODE* I = MakeNode("I");
    InsertChild(A, B);
    InsertChild(A, E);
    InsertChild(A, I);

    // B의 자식 C, D 추가
    NODE* C = MakeNode("C");
    NODE* D = MakeNode("D");
    InsertChild(B, C);
    InsertChild(B, D);

    // E의 자식 F, G, H 생성 및 추가
    NODE* F = MakeNode("F");
    NODE* G = MakeNode("G");
    NODE* H = MakeNode("H");
    InsertChild(E, F);
    InsertChild(E, G);
    InsertChild(E, H);

    WalkTree(A);

    return 0;
}