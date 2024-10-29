yacc -d project3.y
lex project3.l
cc lex.yy.c y.tab.c -o project3