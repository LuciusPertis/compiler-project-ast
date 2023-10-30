
%%
"+" {printf("+ symbol found");}
%%

yywrap(){
    return 0;
}

main() {
    yylex();
}
