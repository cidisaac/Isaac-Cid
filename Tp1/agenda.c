#include "agenda.h"

int A_crear(Agenda ** a, int tamDato)
{
    (*a) = NULL;
    (*a) = malloc(sizeof(Agenda));
    if(!(*a))
    {
        return -1;
    }
    (*a)->cantContactos = 0;
    (*a)->tamContacto = 0;
    (*a)->Contactos = malloc(sizeof(V_Array));
    if(!((*a)->Contactos))
    {
        return -1;
    }
    return VA_create((*a)->Contactos, tamDato);
}

void A_destruir(Agenda** a)
{
    if(*a)
    {
        VA_destroy((*a)->Contactos);
        (*a)->cantContactos = 0;
        (*a)->tamContacto = 0;
        free(*a);
    }
}

int A_agregar_contacto(Agenda* a, void* elem)
{

     return VA_add(a->Contactos,elem);
	 
}

int A_obtener_contacto_i(Agenda * a,int pos, void * elem)
{
    VA_get_i(*(a->Contactos), pos, elem);
}

int A_cant_contactos(Agenda * a)
{
	return VA_count(*(a->Contactos));
}

int A_modificar_contacto_i(Agenda* a,int pos,void* elem)
{
	return VA_set(a->Contactos, pos, elem);
}

int a_borrar_contacto_i(Agenda* a,int pos)
{
	return VA_remove(a->Contactos, pos);
}

int A_ordenar(Agenda* a,funccmp cmp)
{
	if(a)
    {
        return VA_sort(a->Contactos,cmp);
    }
    else
    {
        fprintf(stderr,"Debe existir una agenda para poder ordenarla");
        exit(EXIT_FAILURE);
    }
}
