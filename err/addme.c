/* addme.c A really silly C demo program   */
/* 990325 WCR                              */
/* Usage is <progname> <filename>          */

#include <stdlib.h>
#include <stdio.h>
#include <string.h>

int addem(a,b)
int a, b;
{
  return a+b;
}

int main(argc,argv)
int argc;
char *argv[];
{
  int i;
  char infilename[8];
  int j;
  FILE *infile;
  char number[100];
  char *infilename2=infilename;
  strcpy(infilename2,argv[1]);
  i=0; j=0;
  infile = fopen(infilename2,"r");

  if(infile==NULL)
  {
     printf("couldn't open file %s please try again\n",infilename2);
     exit(1);
  }

  i=0;
  while (fgets(number,90,infile) != '\0')
  {
     sscanf(number,"%d",&j);
     i=addem(i,j);
  }
  printf("Your total is %d\n",i);
  return 0;
}
