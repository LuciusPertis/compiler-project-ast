%{
    #define DEF_TEST
    int countvar = 0 ;
    
%}

TAB [\t]
SPACE [ ]


%%
{TAB}           {printf("Found Tabs [%s]", countvar); countvar+=1;}
{SPACE}         {printf("Found Spaces [%s]", countvar); countvar+=1;}

.               { printf("unrecognized character"); }

%%

int yywrap() {
    return 1;
}

int main() {
    yylex();
}