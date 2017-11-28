
#ifndef IMAGEPROCESSING_H
#define IMAGEPROCESSING_H


typedef struct {
  unsigned int width, height;
  float *r, *g, *b;
} imagem;
typedef struct imagems {
  imagem *I;
  float multiplicador;
  int nthreads;
  int id;
  void * trava1;
} imagens;

imagem abrir_imagem(char *nome_do_arquivo);
void salvar_imagem(char *nome_do_arquivo, imagem *I);
void* BRILHOMUL (imagens *Im);
void BRILHODIV (imagem *I, float *divisor);
void max (imagem *I);
void liberar_imagem(imagem *I);


#endif
