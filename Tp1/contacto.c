#include "contacto.h"
#include <stdio.h>
#include <string.h>
#include <math.h>
#include <stdlib.h>

//int funccmp(char apellidoA[] ,char apellidoB[])
//{
	//return strcmp(apellidoA,apellidoB);
//}

int C_crear_vacio(Contacto** c)
{
	*c = NULL;
    *c = malloc(sizeof(Contacto));
    if(!(*c))
    {
        return 0;
    }
    else
    {
        return 1;
    }
}

int C_crear_completo(Contacto** c, char nombre[], char apellido[], char telefono[], char direccion[], char mail[])
{
    if(C_crear_vacio(c))
    {
        C_modificar_contacto(*c,nombre,apellido,telefono,direccion,mail);
        return 0;
    }
    else
    {
        return -1;
    }
}

void C_destruir(Contacto* c)
{
    if(c)
    {
        free(c);
    }
}


void C_modificar_nombre(Contacto* c,char nomb[])
{
	if (c)
	{
		strcpy(c->nombre,nomb);
	}

}

void C_modificar_apellido(Contacto* c,char apelli[])
{
	if (c)
	{
		strcpy(c->apellido,apelli);
	}
}

void C_modificar_telefono(Contacto * c, char telef[])
{
    if(c)
    {
        strcpy(c->telefono, telef);
    }
}

void C_modificar_direccion(Contacto* c,char dire[])
{
    if(c)
    {
        strcpy(c->direccion, dire);
    }
}

void C_modificar_mail(Contacto* c,char mai[])
{
    if(c)
    {
        strcpy(c->mail, mai);}
}

void C_modificar_contacto(Contacto* c,char nomb[],char*apelli,char telef[],char dire[],char mai[])
{
	if(c)
	{
	C_modificar_nombre(c,nomb);
	C_modificar_apellido(c,apelli);
	C_modificar_telefono(c,telef);
	C_modificar_direccion(c,dire);
	C_modificar_mail(c,mai);
	}
}

void agregar(Contacto * c1, Contacto * c2)
{
    if(c1 && c2)
    {
        if (c1->nombre == c2->nombre && c1->apellido == c2->apellido)
        {
            strcat(c1->mail, c2->mail);
            strcat(c1->telefono, c2->telefono);
            strcat(c1->direccion, c2->direccion);
        }
    }
    else
    {
        fprintf(stderr, "No se pudo copiar el contacto");
    }
}

char * Mostrar_telefono(Contacto * c)
{
    if(c)
    {
        return c->telefono;
    }
}

char * Mostrar_nombre(Contacto * c)
{
    if(c)
    {
        return c->nombre;
    }
}

char * Mostrar_email(Contacto * c)
{
    if(c)
    {
        return c->mail;
    }
}
char * Mostrar_direccion(Contacto * c)
{
    if(c)
    {
        return c->direccion;
    }

}
char * Mostrar_apellido(Contacto * c)
{
    if(c)
    {
        return c->apellido;
    }
}
char ** Mostrar_datos(Contacto * c)
{
    if(c)
    {
        char * datos[CANTIDAD_DE_CAMPOS];
        char * dir_dato = &c->nombre;
		
        int i = 0;
        for(i;i<CANTIDAD_DE_CAMPOS-1;i++)
        {
            datos[i] = dir_dato;
            dir_dato = dir_dato + MAX_LENGTH;
        }
        return datos;
    }
    else
    {
    	return NULL;
    }
}
