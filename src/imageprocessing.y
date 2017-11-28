%{
#include <stdio.h>
#include "imageprocessing.h"
#include <FreeImage.h>
#include <pthread.h>
#include <stdlib.h>
#include <sys/types.h>
#include <unistd.h>
#include <time.h>
void yyerror(char *c);
int yylex(void);

%}
%union {
  char    strval[50];
  int     ival;
  float   fval;
}
%token <strval> STRING
%token <ival> VAR IGUAL EOL ASPA COLCHETE AST BARRA
%token <fval> FLOAT
%left SOMA

%%

PROGRAMA:
        PROGRAMA EXPRESSAO EOL
        |
        ;

EXPRESSAO:
   /* |STRING IGUAL EXPRESSAO { printf("Entrou na função");


        }*/


	 |STRING IGUAL STRING AST FLOAT  {

  int nthreads=7;
  pthread_t threads[nthreads];
  pthread_mutex_t trava1;
  int i, inicio, fim;
  clock_t t0, t1;
  struct timespec ut0, ut1;
  imagens *Im=malloc(sizeof(imagens));
  pthread_t thread[nthreads];
  imagem I = abrir_imagem($3);
	float multi = $5;
  Im->I=&I;
  Im->multiplicador=multi;
  Im->nthreads=nthreads;
  Im->trava1=&trava1;
    // printf("Multiplicador: %f, Inicio: %d, fim: %d \n",Im->multiplicador, Im->inicio, Im->fim);
  t0=clock();
  clock_gettime(CLOCK_MONOTONIC,&ut0);
  for(i=0; i<nthreads; i++){
    // Im->inicio=i*((Im->I->width)/nthreads);
    // Im->fim=Im->inicio+(Im->I->width/nthreads);
    pthread_mutex_lock(&trava1);
    Im->id=i;
    pthread_create(&(threads[i]), NULL, BRILHOMUL, (void*) (Im));
  }
  for(i=0; i<nthreads; i++){
    pthread_join(threads[i], NULL);
  }
  t1=clock();
  clock_gettime(CLOCK_MONOTONIC,&ut1);
  // rt1=gettimeofday();
  // (I->width)/2;
	// BRILHOMUL (&I, &multi);
  // pthread_join(threads[0],NULL);
  printf("User time: %f\n",(double)(t1-t0)/CLOCKS_PER_SEC);
  printf("Real time: %f\n",(double)(ut1.tv_sec-ut0.tv_sec)+(double)(ut1.tv_nsec-ut0.tv_nsec)/1000000000);
  salvar_imagem($1, &I);
	liberar_imagem(&I);
  free(Im);


    }

    |STRING IGUAL STRING BARRA FLOAT {

	imagem I = abrir_imagem($3);
	float divi = $5;
    BRILHODIV (&I, &divi);
    salvar_imagem($1, &I);
	liberar_imagem(&I);

    }
    | COLCHETE STRING COLCHETE {

	imagem I = abrir_imagem($2);
	max(&I);


    }
	| STRING IGUAL STRING {
        //printf("Copiando %s para %s\n", $3, $1);
        imagem I = abrir_imagem($3);
        //printf("Li imagem %d por %d\n", I.width, I.height);
        salvar_imagem($1, &I);
        liberar_imagem(&I);
                          }
    ;

%%

void yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
}

int main() {
  FreeImage_Initialise(0);
  yyparse();
  return 0;

}
