yacc -d project2.y
lex project2.l
cc lex.yy.c y.tab.c -o parser
