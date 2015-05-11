/* Versión de comando miecho con un parámetro que indica el número
   de repeticiones
   Ej.-  c:> miecho2  /2 hola pepe
         hola hola hola pepe pepe pepe
         c:> miecho2  hola pepe
         hola pep
/* Echo version simple */
#include <stdio.h>


main(int argc, char *argv[])
{
int i,j;
int veces;
int inicio;

if ( argc < 2 )
   {
   return 0;
   }

veces  = 1;   /* Se repite una vez por omisi¢n */
inicio = 1;   /* Sacamos todos los parámetros salvo el argv[0] */

if ( argv[1][0] == '/' )  // la barra señala el parámetro veces
    {
    veces = atoi( & argv[1][1]);
    inicio = 2;
    }

for ( i= inicio; i<argc ; i++)
  {
  for ( j = 1 ; j <= veces; j++)
    {
    printf(argv[i]);
    putchar(' ');
    }
}  }
