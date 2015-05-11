#include "var_array.h"
#include "contacto.h"


typedef struct TDA_Agenda{
	int cantContactos;
	int tamContacto;
	V_Array* Contactos;
}Agenda;

//PRIMITIVAS

//PRE: -
//POST: a creado e inicializado con cantidad de contactos en "0" y tamContacto=tamDato

int A_crear(Agenda** a,int tamDato);

//PRE: a creado
//POST: devuelve la cantidad de contactos

int A_cant_contactos(Agenda * a);

//PRE: a creado
//POST: Si se pudo agregar el contacto, devuelve "0",sino,informa el codigo de error.

int A_agregar_contacto(Agenda* a,void* elem);

//PRE: a creado
//POST: Si se pudo obtener el contacto de la posicion "i", devuelve "0", sino, informa el codigo de error.

int A_obtener_contacto_i(Agenda* a,int pos,void* elem);

//PRE: a creado
//POST: Si se pudo modificar el contacto de la posicion "i", devuelve "0", sino, informa el codigo de error.

int A_modificar_contacto_i(Agenda* a,int pos,void* elem);

//PRE: a creado
//POST: Si se pudo borrar el contacto de la posicion "i", devuelve "0", sino, informa el codigo de error.

int a_borrar_contacto_i(Agenda* a,int pos);

//PRE: a creado
//POST: Si se pudo destruir la esctructura, devuelve "0", sino, informa el codigo de error.

void A_destruir(Agenda** a);

//PRE: a crado y no vacio, debe existir la funcion comparacion y compara por un campo de los campos de contacto.
//POST: Si se pudo ordenar la agenda, devuelve "0", sino, informa el codigo de error.

int A_ordenar(Agenda* a,funccmp cmp);

