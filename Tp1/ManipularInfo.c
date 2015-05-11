#include "ManipularInfo.h"


char* subcadena(char* cadena, int primer, int longitud)
{
	if (longitud == 0) longitud = strlen(cadena)-primer-1;
	char *nuevo = (char*)malloc(sizeof(char) * longitud);
	strncpy(nuevo, cadena + primer, longitud);
	return nuevo;
}


void sacar_caracter_de_escape(char arg[])
{
    int i = 0;
    char barra = '\\';
    for(i;i<strlen(arg);i++)
    {
        if(arg[i] == ';')
        {
            if(arg[i-1]==barra)
            {
                arg[i] = '-';
                arg[i-1] = ' ';
            }
        }
    }
}

void leer_contacto(char arg[],Contacto** c)
{
	sacar_caracter_de_escape(arg);
    char args[CANTIDAD_DE_CAMPOS][MAX_LENGTH];
    char * ptr = strtok(arg,";"); //Primer llamada
	
	strcpy(args[0],arg);
	int i = 1;
    while((ptr = strtok(NULL,";")) != NULL)//Posteriores llamadas
    {
			
            strcpy(args[i],ptr);
			
            char carac = args[i][strlen(args[i])];
			i++;
    }
    char * t = args[4];
    if(i==5)
    {
		
        C_modificar_contacto((*c),args[0],args[1],args[2],args[4],args[3]);
    }
    else
    {
        fprintf(stderr,"Verifique que los datos ingresados son correctos.\n");
        fprintf(stderr,"Los datos para contacto deben introducirse de la siguiente manera: NOMBRE;APELLIDO;TELEFONO;MAIL;DIRECCION. El último caracter del archivo debe ser un salto de linea.");
        exit(EXIT_FAILURE);
    }
	
}

int crear_Agenda_desde_archivo(Agenda ** a,char argv[])
{
    if(!(*a))
    {
        if(A_crear(a,sizeof(Contacto))!=0)
        {
            fprintf(stderr, "No se pudo crear la agenda");
            exit(EXIT_FAILURE);
        }
    }
    modificar_agenda(*a,argv);
}

int modificar_agenda(Agenda * a, char argv[])
{
    if(a)
    {
        FILE * f = fopen(argv,"r");
        if(!f)
        {
            fprintf(stderr,"No se encontro el archivo indicado");
            exit(EXIT_FAILURE);
        }
        else
        {
            int tamanio_de_cadenas = sizeof(Contacto)+6;
            char cadena_leida[tamanio_de_cadenas];
            int i = 0;
            for(i;i<2;i++)
            {
                fgets(cadena_leida,tamanio_de_cadenas,f);//saco el encabezado del archivo y leo primer contacto
            }
            while(!feof(f))
            {
                Contacto * c = NULL;
                C_crear_vacio(&c);
                if(!c)
                {
                    fprintf(stderr,"No se puede crear un contacto");
                    exit(EXIT_FAILURE);
                }
                leer_contacto(cadena_leida,&c);
                A_agregar_contacto(a,c);
                fgets(cadena_leida,tamanio_de_cadenas,f);
                free(c);
            }
            if(f)
            {
                close(f);
            }
        }
    }
    else
    {
        fprintf(stderr,"No ha creado una agenda, intente primero crearla vacia con el comando -c o a partir de un archivo con el comando -i");
        exit(EXIT_FAILURE);
    }

}

int Cont_TO_Cadena(Contacto * contacto, char* cadena)
{
    if(contacto)
    {
        char * n = Mostrar_nombre(contacto);//&(contacto->nombre);
        int i = 0;
        strcpy(cadena,n);
        for(i; i<(CANTIDAD_DE_CAMPOS-1);i++)
        {
            strcat(cadena,";");
            n = n + MAX_LENGTH;
            strcat(cadena,n);
        }
    }
    else
    {
        fprintf(stderr,"No se ha creado el contacto, aun asi se intenta leerlo");
        exit(EXIT_FAILURE);
    }
}

void imprimir_agenda_por_stdoutput(Agenda * a, int i)
{
    if(a)
    {
        Contacto *c =NULL;
        C_crear_vacio(&c);
        if(c)
        {
            A_obtener_contacto_i(a,i,c);
            int i = 0;
            char * n = Mostrar_nombre(c);
            char * campos[] = {"NOMBRE:", "APELLIDO:", "TELEFONO:", "EMAIL:","DIRECCION:"};
            for(i;i<CANTIDAD_DE_CAMPOS;i++)
            {
                printf("%s %s\n",campos[i],n);
                n = n + MAX_LENGTH;
            }
            free(c);
        }
        else
        {
            fprintf(stderr, "No se ha podido crear un contacto");
            exit(EXIT_FAILURE);
        }
    }
    else
    {
            fprintf(stderr, "Primero se debe crear la agenda.");
            exit(EXIT_FAILURE);
    }

}

int crear_archivo_desde_agenda(Agenda * a, char nombre_de_archivo[])
{
    if(a)
    {
        FILE * f = fopen(nombre_de_archivo,"w");
        if(f)
        {
            fprintf(f,"NOMBRE;APELLIDO;TELEFONO;EMAIL;DIRECCION\n");
            int i = 0;
            Contacto * c = NULL;
            for(i;i<A_cant_contactos(a);i++)
            {
                char contacto_en_cadena[sizeof(Contacto)+6];
                //Vacio o completo?
                C_crear_vacio/*completar*/(&c);
                A_obtener_contacto_i(a,i,c);
                Cont_TO_Cadena(c,contacto_en_cadena);
                fprintf(f,contacto_en_cadena);
                free(c);
            }

        }
        else
        {
            fprintf(stderr,"No se pudo crear el archivo.");
            exit(EXIT_FAILURE);
        }
    }
    else
    {
        fprintf(stderr,"Debe crear una agenda para poder generar el archivo.");
        exit(EXIT_FAILURE);
    }
}

void listar(Agenda * a)
{
    if(a){
        int cont = 0;
        int cant =A_cant_contactos(&a);
        printf("Los contactos son:\n\n");
        for(cont;cont<cant;cont++)
        {
            imprimir_agenda_por_stdoutput(a,cont);
        }
    }
    else
    {
        fprintf(stderr,"No hay ninguna agenda que listar, intente primero crearla vacia con el comando -c o a partir de un archivo con el comando -i");
        exit(EXIT_FAILURE);
    }
}
