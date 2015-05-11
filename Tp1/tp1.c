#pragma once
#include <stdio.h>
#include <stdlib.h>
#include <windows.h>
#include "ManipularInfo.h"
#include "contacto.h"

typedef enum opciones_de_consola
{
    c = 99,
    a = 97,
    i = 105,
    l = 108,
    L = 76,
    o = 111,
    s = 115
}op_consola;


op_consola leer_opcion(char opcion_introducida[])
{
    return opcion_introducida[strlen(opcion_introducida)-1];
}

int FuncionComparar(Contacto* unElem, Contacto* otroElem)
{
    return strcmp(unElem->apellido, otroElem->apellido);
}

void crear_contacto_de_cadena_y_agregar(char cadena_copiada[], Agenda * a)
{
    Contacto * c=NULL;
    C_crear_vacio(&c);
    leer_contacto(cadena_copiada,&c);
    A_agregar_contacto(a,c);
	if(A_agregar_contacto(a,c)== -1){
		free(c);
		fprintf(stderr,"salir");
		//exit(0);
	}
    free(c);
}

int main(int argc, char* argv[])
{
    int contador = 1;
    int hubo_error = 0;
    Agenda * agend = NULL;
    int (*ptr_FuncionComparar)(Contacto*,Contacto*);
    ptr_FuncionComparar = FuncionComparar;
    while(contador<argc && !hubo_error)
    {
        op_consola op = leer_opcion(argv[contador]);
        switch(op)
        {
            case c:
                A_crear(&agend,sizeof(Contacto));
                break;
            case a:
                contador++;
                char cadena[sizeof(Contacto)+6];
                strcpy(cadena,argv[contador]);
                strcat(cadena,"\n");
                crear_contacto_de_cadena_y_agregar(cadena,agend);
                break;
            case i:
                contador++;
                crear_Agenda_desde_archivo(&agend,argv[contador]);
                break;
            case l:
                if(agend)
                {
                    contador++;
                    modificar_agenda(agend,argv[contador]);

                }
                break;
            case L:
                listar(agend);
                break;
            case o:
                contador++;
                crear_archivo_desde_agenda(agend,argv[contador]);
                break;
            case s:
                A_ordenar(agend,ptr_FuncionComparar);
                break;


        }
        contador++;
    }
    if(a)
    {
        A_destruir(&agend);
    }

}
