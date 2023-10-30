%{
    #define DEF_TEST
    int countvar = 0 ;
    
%}

TAB [\t]
SPACE [ ]


%%
{TAB}           {printf("Found Tabs [%s]", countvar); countvar++;}
{SPACE}         {printf("Found Spaces [%s]", countvar); countvar++;}

[\t\f\v\r\n]    {printf("Found other whitespaces");}

[_a-zA-Z]*   {printf("Found alpha [%s]", countvar); countvar++;}

"!!"            {printf("Testing return [%s]", countvar); return countvar;}
.               { printf("unrecognized character"); }

%%

int yywrap() {
    return 1;
}

int main() {
    return yylex();
}