#pragma once
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>
#define MAX_LENGTH 255
#define CANTIDAD_DE_CAMPOS 5

typedef enum
{
    NOMBRE,
    APELLIDO,
    TELEFONO,
    DIRECCION,
    MAIL
}Opciones;

typedef struct TDA_Contacto{

	char nombre[MAX_LENGTH];
	char apellido[MAX_LENGTH];
	char telefono[MAX_LENGTH];
	char mail[MAX_LENGTH];
	char direccion[MAX_LENGTH];
}Contacto;

//PRIMITIVAS

//PRE:--
//POST:Crea el contacto
int C_crear_vacio(Contacto** c);

//PRE:Contacto debe existir.
//POST:Destruye el contacto y libera el espacio de memoria
void C_destruir(Contacto* c);

//PRE:Contacto debe existir.
//POST:Borra el contacto
int C_borrar(Contacto* c);


//PRE: Los vectores de informacion no son nulos
//POST: Crea el contacto con datos
int C_crear_completo(Contacto** c, char nombre[], char apellido[], char telefono[], char direccion[], char mail[]);

//PRE:Contacto debe existir.
//POST:Modifica el contacto elegido


void C_modificar_nombre(Contacto * c, char nomb[]);
void C_modificar_apellido(Contacto * c, char apelli[]);
void C_modificar_telefono(Contacto * c, char telef[]);
void C_modificar_direccion(Contacto * c, char dire[]);
void C_modificar_mail(Contacto * c, char mai[]);
void C_modificar_contacto(Contacto * c, char nomb[], char apelli[], char telef[], char dire[], char mai[]);

// Mostrar
//PRE: existe el contacto y no es vacio
//POST: Escribe es el vector V_Array con los contactos


char * Mostrar_telefono(Contacto* c);
char * Mostrar_nombre(Contacto* c);
char * Mostrar_email(Contacto* c);
char * Mostrar_direccion(Contacto* c);
char * Mostrar_apellido(Contacto* c);

//PRE: Los dos contactos estan creados con datos
//POST: En el primer contacto se adjuntan los datos email, direccion y telefono que tiene el segundo contacto
void agregar(Contacto * c1, Contacto * c2);



