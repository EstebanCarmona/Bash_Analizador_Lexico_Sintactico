/*
  JEYC
  JTSD
*/
%{
#include <ctype.h>
#include "interpreteBash.tab.h"
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
int tipoDato(char* nombre);
// extern YYSTYPE yylval;
%}

%option noyywrap
/* %option bison-bridge */

digit 	[0-9]
space	[ \t]
SumaResta 	[+|-]
MultiDivi	[*|/]
cos		("COS"|"cos")
sen 	("SEN"|"sen")
tan 	("TAN"|"tan")
asin 	("ASEN"|"asen")	
acos 	("ACOS"|"acos")
atan 	("ATAN"|"atan")
log 	("LOG"|"log")
e 		("E"|"e")
pow 	"^"
pi      "pi"
Notacion "x10"
spaces	{space}+ 
ID 	        [a-zA-Z][a-zA-Z0-9]*			
Echo		("ECHO"|"echo")
cadenaString ["].*["]
num 	{digit}+("."{digit}+)?	
%%

{num}	{
	  yylval.floatval = atof(yytext);
	  return NUM;
	}

{Echo} {
	yylval.strval = (char*)malloc(150); 
	strcpy(yylval.strval,yytext);
	return MOSTRARVAR;
}	

{cadenaString} {
	yylval.strval = (char*)malloc(150);
	strcpy(yylval.strval,yytext+1);
	*(yylval.strval+yyleng-2)=0;
	return CADENASTRING;
}

{cos} {
	  yylval.intval = 0;
	  return COS;
	}

{sen} {
		yylval.floatval = atof(yytext);
		return SEN;
	}

{tan} {
		yylval.floatval = atof(yytext);
		return TAN;
	}	

{asin} {
		yylval.floatval = atof(yytext);
		return ASIN;
	}

{acos} {
		yylval.floatval = atof(yytext);
		return ACOS;
	}

{atan} { 
		yylval.floatval = atof(yytext);
		return ATAN;
	}

{log} {
		yylval.floatval = atof(yytext);
		return LOG;
	}

{e} 	{
		yylval.floatval = atof(yytext);
		return E;
	}

{pi}	{
		yylval.floatval = atof(yytext);
		return PI;
	}

{Notacion} {
		yylval.floatval = atof(yytext);
		return NOTACION;
	}

{ID} {
	yylval.strval = (char*)malloc(150); 
	strcpy(yylval.strval,yytext);
	int tipo = tipoDato(yytext);
	if(tipo == 0){
		return IDVARFLOAT;
	}else if(tipo == 1){
		return IDVARSTRING;
	}else{
		return IDVAR;
	}
}

{spaces} {}

\n	{ return '\n'; }

.	{ return *yytext;}


