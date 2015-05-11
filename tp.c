#include <stddef.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#define TRUE 1
#define FALSE 0

void redireccionarchivosalida(char* rutasalida,char* mensaje){

	FILE *archivo;//se creo el puntero a archivo
	archivo=fopen(rutasalida,"w");//se abre para escritura
	fputs(mensaje,archivo);//se escribe
	fclose(archivo);//se cierra

}

void SuprimirSaltoDeLinea(char* mensaje,int posicion) {
	int i;
	for (i=posicion;i<strlen(mensaje);i ++){
		mensaje[i]=mensaje[i + 2];
	}
}

//Cuando tiene el -i
void invertirmensaje(char* mensajeainvertir){
	int largocadena=strlen(mensajeainvertir);//
	largocadena--;
	char aux;
	int i;
	for (i=0;i<=(largocadena/2);i++){
		aux=mensajeainvertir[largocadena-i];
		mensajeainvertir[largocadena-i]=mensajeainvertir[i];
		mensajeainvertir[i]=aux;
	}
}

void Posicionar(char* mensaje){
	char letra;
	int posicion,i;
	for(i=1;strlen(mensaje);i++){
		if (mensaje[i]=='\\'){
			letra=mensaje[i+1];
			posicion=i;
		}
	}
}
//Cuando se coloca el comando -e para que interprete todos los caracteres antecedidos por una contrabarra.
int IntercambioCaracter(char* mensaje,char letra,int posicion,int saltarLinea){

	if (letra=='c'){
		saltarLinea=FALSE;
		SuprimirSaltoDeLinea(mensaje,posicion) ;
	}
	if (letra=='f'){
		mensaje[posicion]='\f' ;
		mensaje[posicion+1]='\b';
	}
	if (letra=='b'){
		mensaje[posicion]='\b';
		mensaje[posicion]='\b';
	}
	if (letra=='n'){
		mensaje[posicion]='\n';
		mensaje[posicion+1]='\b';
	}
	if (letra=='r'){
		mensaje[posicion]='\r';
		mensaje[posicion+1]='\b';
	}
	if (letra=='t'){
		mensaje[posicion]='\t';
		mensaje[posicion+1]='\b';
	}
	if (letra=='a'){
		mensaje[posicion]='\a';
		mensaje[posicion+1]='\b';
	}
	if (letra=='v'){
		mensaje[posicion]='\v';
		mensaje[posicion+1]='\b';
	}
	if (letra=='\\'){
		mensaje[posicion]='\\';
		mensaje[posicion+1]='\b';
	}
	return saltarLinea;
}

//Esta función lo que hace es entender el mensaje para poder interpretar las secuencias de escape.
int DescifrarMensaje(char* mensaje,int SaltarLinea){
	int i;
	for (i=0;i<strlen(mensaje)+1;i++){
		if(mensaje[i]=='\\'){
			SaltarLinea=IntercambioCaracter(mensaje,mensaje[i+1],i,SaltarLinea);
		}
	}
	return SaltarLinea;
}

void ImpresionDeMensaje(char* mensaje,int SaltarLinea){
	if (SaltarLinea==TRUE) puts(mensaje);
	 else printf("%s", mensaje);
}

int main(int argc, char** argv){
	int INVERTIR=FALSE;
	int REDIRECCIONAR=FALSE;
	int SaltarLinea=TRUE;
	int DescifrarMensajeBool=FALSE;
	int direccionruta=0;
	int indicadordireccion=0;
	int indicadorinversion=0;
	int indicadormensaje=0;
	int indicadorsaltodelinea=0;
	int indicadordescifrarmensaje=0;
    int i;
	for (i=1;i<argc;i++){
		if((strcmp(argv[i],"-o"))==0){
			REDIRECCIONAR=TRUE;
			direccionruta=i+1;//Porque siempre despues del -o va la ruta adonde se envia el archivo
			indicadordireccion=i;//es el -o
		}
		if((strcmp(argv[i],"-i"))==0){
			indicadorinversion=i;//es el -i
			INVERTIR=TRUE;
		}
		if((strcmp(argv[i],"-n"))==0){
            SaltarLinea=TRUE;
            indicadorsaltodelinea=i;//posicion donde se encuentra el \n
            }
        if((strcmp(argv[i],"-e"))==0){
            DescifrarMensajeBool=TRUE;
            indicadordescifrarmensaje=i;
        }
	}
    int j;
	for (j=1;j<argc;j++){
		if((j!=direccionruta)&&(j!=indicadordireccion) && (j!=indicadorinversion)&&(j!=indicadorsaltodelinea)&&(j!=indicadordescifrarmensaje)){
			indicadormensaje=j;
		}

	char* ruta;
	char* mensaje=argv[indicadormensaje];
	char letra;
	int posicion,l;

	if (DescifrarMensajeBool==TRUE){
		SaltarLinea=DescifrarMensaje(mensaje,SaltarLinea) ;
	}
	if (INVERTIR==TRUE) {
        invertirmensaje(mensaje);
	}
	if  (REDIRECCIONAR==TRUE){
		redireccionarchivosalida(argv[direccionruta],mensaje);
	} else {
		ImpresionDeMensaje(mensaje,SaltarLinea);
	}
	return 0 ;
	}
}