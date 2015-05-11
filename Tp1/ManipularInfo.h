#include <string.h>
#include "contacto.h"
#include "Agenda.h"


//POST: Devuelve la subcadena que inicia en comienzo y tiene la longitud indicada
char* subcadena(char* cadena, int comienzo, int longitud);
//POST: Reemplaza "\;" por " -"
void sacar_caracter_de_escape(char argumento[]);
//PRE: Argumento no es vacio
//POST: Crea el contacto con el argumento dado
void leer_contacto(char argumento[],Contacto** contacto);
//PRE: argv no es vacio
//POST: Se crea la agenda y se agregan los contactos almacenados en el archivo especificado en la agenda
int crear_Agenda_desde_archivo(Agenda ** a,char argv[]);
//PRE: La agenda esta creada y argv no es vacio
//POST: Se agregan los contactos almacenados en el archivo especificado en la agenda
int modificar_agenda(Agenda * a, char argv[]);
//PRE: El contacto fue creado con datos
//POST: Se deja en cadena los datos informados por contacto
int Cont_TO_Cadena(Contacto * contacto, char cadena[]);
//PRE: La agenda esta creada
//POST: Se imprime por pantalla la agenda indicada
void imprimir_agenda_por_stdoutput(Agenda * a, int i);
//PRE: La agenda esta creada, el nombre_de_archivo no esta vacio
//POST: Se crea un archivo en el directorio de ejecucion con el nombre indicado
int crear_archivo_desde_agenda(Agenda * a, char nombre_de_archivo[]);
//PRE: La agenda esta creada
//POST: La agenda queda ordenada alfabeticamente en sentido ascendente
void listar(Agenda * a);
