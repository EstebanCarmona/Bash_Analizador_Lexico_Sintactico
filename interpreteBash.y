/*
  JEYC
  JTSD
*/
%{
/*  #define YYPARSE_PARAM scanner
  #define YYLEX_PARAM   scanner*/
  #include <stdio.h>
  #include <math.h>
  #include <ctype.h>
  #include <string.h>
  int yylex (void);
  void yyerror (char const *);

  typedef struct {
    char*   varNombre;
    float   varValor;
    int     varTipo;
    char*   varStr;
  } ArregloVariables;

  //Se crea el vector para guardar las variables
  ArregloVariables vectorDatos [10];

  void IngresarDatos (char* nomVar, float num, char* str){ 
   //printf("%s\n","Ingresar" );
  int i = 0;

    while(vectorDatos[i].varNombre != NULL && i < 10){
      i += 1;
    }
    if(str == NULL){
      vectorDatos[i].varTipo = 0;
    }else{
      vectorDatos[i].varTipo = 1;
    }
    vectorDatos[i].varNombre = nomVar;
    vectorDatos[i].varValor  = num;
    vectorDatos[i].varStr    = str; 
  }

  ArregloVariables BuscarDato(char * nomVar){
    int i;
    for(i = 0; i < 10; i++){
        if(strcmp(vectorDatos[i].varNombre,nomVar) == 0){
          return vectorDatos[i];
        }
    }
  }

  void Actualizar(char* nomVar, float numero, char* string){
    int i;
    for(i = 0; i < 10; i++){
      if(vectorDatos[i].varNombre != NULL){
        if(strcmp(vectorDatos[i].varNombre,nomVar) == 0){
          if(string == NULL){
            vectorDatos[i].varTipo = 0;
          }else{
            vectorDatos[i].varTipo = 1;
          }
          vectorDatos[i].varValor = numero;
          vectorDatos[i].varStr = string;
          return;
        }
      }
    }
    //if(i != 4242){
      IngresarDatos(nomVar,numero,string);
    //}
  }

  float buscarValorFloat(char* nomVar){
    int i = 0;
    while(vectorDatos[i].varNombre != NULL && i < 10){
      if(strcmp(vectorDatos[i].varNombre,nomVar) == 0){
        return vectorDatos[i].varValor;
      }
      i += 1;
    }
    return -1;
  } 

  char* buscarValorString(char* nomVar){
    int i = 0;
    while(vectorDatos[i].varNombre != NULL && i < 10){
      if(strcmp(vectorDatos[i].varNombre,nomVar) == 0){
        return vectorDatos[i].varStr;
      }
      i += 1;
    }
    return "noEncontrado";
  }

  void IniciarMatriz(){
    int i;
    for(i = 0; i < 10; i++){
      vectorDatos[i].varNombre = NULL;
      vectorDatos[i].varValor  = 1.18e-38;
      vectorDatos[i].varTipo   = -1;
      vectorDatos[i].varStr    = NULL;
    }
  }

  //Retorna 0 para numerico, 1 para string y -1 para no existente.
  int tipoDato(char* nombre){
    int i = 0;
      while(vectorDatos[i].varNombre != NULL && i < 10){
        if(strcmp(vectorDatos[i].varNombre,nombre) == 0){
          return vectorDatos[i].varTipo;
        }
        i += 1;
      }
    return -1;
  }

%}

 //%define api.value.type{double}
%union
{
  double  floatval;
  int     intval;
  char*   strval;
}

//Terminales  
%token <strval>   CADENASTRING
%token <strval>   IDVAR
%token <strval>   IDVARSTRING
%token <strval>   IDVARFLOAT 
%token <strval>   MOSTRARVAR //ECHO
%token <floatval> NUM 
%token <floatval> SEN   
%token <floatval> COS   
%token <floatval> TAN   
%token <floatval> ASIN  
%token <floatval> ACOS  
%token <floatval> ATAN  
%token <floatval> LOG   
%token <floatval> E   
%token <floatval> PI
%token <floatval> POW 
%token <floatval> NOTACION
 

//No terminales
%type  <floatval> exp  
%type  <strval>   expStr
%type  <floatval> term  
%type  <floatval> valor 
%type  <strval>   asignacion
%type  <strval>   mostrarStr
%type  <floatval> mostrarFloat
%type  <strval>   valStr
%type  <strval>   mostrar


%% 

/* Grammar rules and actions follow. */
 
input:
| input line
;

line:
  '\n'  { printf ("> "); }
| asignacion {}
| mostrarStr   { printf("%s\n",$1); }
| mostrarFloat { printf("%.10g\n",$1); }
| mostrar      {}
| exp          { printf("Bash: comando no esncontrado\n");}
| expStr '\n'  { printf("%s\n",$1); }
;

expStr:
valStr              { $$ = $1; }
| valStr '+' valStr { char* str = malloc(150);
          *str = 0;
          strcat(str,$1);
          $$ = strcat(str, $3); }
| '$' IDVAR         { $$ = ""; }          
;

valStr:
CADENASTRING { $$ = $1; }
|'$' IDVARSTRING { char* val = buscarValorString($2);
                    if(strcmp(val,"noEncontrado") != 0){
                      $$ = val;
                    }else{
                      printf("%s\n", "La variable no existe" );
                    }

                  }
;

exp:
 term           { $$ = $1; }
| exp '+' term  { $$ = $1 + $3; }
| exp '-' term  { $$ = $1 - $3; }
;

term:
  valor               { $$ = $1; }
| term '*' term       { $$ = $1 * $3; }
| term '/' term       { $$ = $1 / $3; }
| term '^' term       { $$ = pow($1,$3); }
| LOG term            { $$ = log($2); }     
| E term              { $$ = exp($2); }
| term NOTACION term  { $$ = $1*pow(10,$3); }
;

valor:
 '$'IDVARFLOAT    { float val = buscarValorFloat($2);
                    if(val != -1){
                      $$ = val;
                    }else{
                      printf("%s\n", "La variable no existe" );
                    }
                  }
| NUM             { $$ = $1; }
| PI              { $$ = 3.14159265359; }  
| '(' exp ')'     { $$ = $2; }
| SEN  valor      { $$ = sin($2); }
| COS  valor      { $$ = cos($2); }
| TAN  valor      { $$ = tan($2); }
| ASIN valor      { $$ = asin($2); }
| ACOS valor      { $$ = acos($2); }
| ATAN valor      { $$ = atan($2); }
;

asignacion:
 IDVAR '=' exp  { 
                  Actualizar($1,$3,NULL); 
                 }
| IDVAR '='  expStr  {
                  Actualizar($1,1.18e-38,$3); 
                  }
| IDVARFLOAT '=' exp {
                  Actualizar($1,$3,NULL); 
                }
| IDVARFLOAT '=' expStr {
                  Actualizar($1,1.18e-38,$3); 
                }
| IDVARSTRING '=' exp {
                Actualizar($1,$3,NULL); 
                }
| IDVARSTRING '=' expStr {
                Actualizar($1,1.18e-38,$3); 
                }

;

mostrarFloat:
 MOSTRARVAR exp { $$ = $2; }
;

mostrarStr:
  MOSTRARVAR expStr { $$ = $2; }
;

mostrar:
  MOSTRARVAR { $$ = $1; }
%%
int main (void)
{
  IniciarMatriz();

  printf ("\n\n> ");
    return yyparse ();
}

/* Called by yyparse on error. */
void yyerror (char const *s)
{
  fprintf (stderr, "%s\n", s);
}
