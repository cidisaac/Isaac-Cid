Program Favoritos;

uses usuarios,sysutils,crt;

const
	minFavoritos=0;
	maxFavoritos=99;
	rutaFavoritos='FavoritosUsuario.dat';
	//Posicion en donde se debe insertar el IDUsuario para que quede con el formato FavoritosUsuarioIDusuario.dat
	posInsercion=17;
	opcionDatosPublicos=1;
	opcionPensamientos=2;
	opcionVolver=0;
	minUsuario=0;
	maxUsuario=99;
	SeparadorOpcion='-';
type
	tFavoritos=minFavoritos..maxFavoritos;	
	taFavoritos= file of tFavoritos;
	tIDUsuario=minUsuario..maxUsuario;
	IDusuarioActual=tIDusuario;
	topcion=byte;
	
procedure opcionPantalla;
 begin
 writeln;
 write('Opcion: ');
 end;

procedure publicarOpcion(numOpcion:topcion;textoOpcion:string);
 begin
 writeln(numOpcion,SeparadorOpcion,textoOpcion);
 end;
 
 //Autor: Isaac Cid Cabaleiro
 //Abre el archivo favoritos para el usuario que se encuentra logueado.
 //Pre-Cond:IDUsuarioActual = usuario que se encuentra logueado
 //Si el archivo no existe lo crea y lo deja con el puntero en la posicion inicial
Procedure AbrirArchivoFavoritos(Var aFavoritos:taFavoritos;IDUsuarioActual:tIDusuario);
Var
	idtemp:tIDusuario;
	
	ruta:string;
	IDSTRING:string;
Begin
	ruta:=rutaFavoritos;
	idtemp:=IDUsuarioActual;
	str(idtemp,IDSTRING);
	Insert(IDSTRING,ruta,posInsercion);
	assign(aFavoritos,ruta);
	{$I-}
	reset(aFavoritos);
	{$I-}
	if (IOresult<>0) then rewrite(aFavoritos);
End;

procedure cabeceraPantalla(titulo:string);
begin
    clrscr;
    writeln(titulo);
    writeln;
end;
//Autor: Isaac Cid Cabaleiro
//Informa al usuario que no tiene ese id de usuario como favorito.
Procedure ErrorFavorito;
begin
	writeln('No posee ese usuario como favorito');
end;

Procedure ValidarFavorito(Var aFavoritos:taFavoritos;IDUsuarioActual:tIDusuario;Var IDfavoritoTemp:tIDusuario);
var
	i:tIDusuario;
	encontrado:boolean;
begin
	encontrado:=false;
	i:=minFavoritos;
	
		while not eof(aFavoritos) do
			while (encontrado=false) do
				if (i=IDfavoritoTemp) then
					encontrado:=true
				else if (i<>IDfavoritoTemp) then
					inc(i);
		ErrorFavorito;	
end;
//Autor:Isaac Cid Cabaleiro
//Muestra los favoritos del usuario logueado y pregunta al usuario sobre cual de sus favoritos desea ver mas informacion

Procedure MostrarFavoritos(Var IDUsuarioActual:tIDusuario;Var aFavoritos:taFavoritos);
Var

	i:tFavoritos;
	IDfavorito:tIDusuario;
	IDfavoritoTemp:tIDusuario;
	
Begin
	
	i:=minFavoritos;
	AbrirArchivoFavoritos(aFavoritos,IDusuarioactual);
	while not eof(aFavoritos) do
		read(aFavoritos,IDfavorito);			
		writeln(i,'.',IDfavorito);			
	writeln;
	writeln('ID del usuario que desea ver:');
	opcionPantalla;
	read(IDfavoritoTemp);
	ValidarFavorito(aFavoritos,IDUsuarioActual,IDfavoritoTemp);
	close(aFavoritos);
	
end;




//Autor:Isaac Cid Cabaleiro
//Agrega favoritos para el usuario logueado 
//Los agrega al final del archivo
Procedure AgregarFavoritos(Var IDusuarioactual:tIDUsuario;Var aFavoritos:taFavoritos);

Var
	FavoritoParaAgregar:tIDusuario;
Begin	
	writeln('Ingrese el id del usuario que desea agregar como favorito:'); 
	read(FavoritoParaAgregar);
	//VALIDAR FAVORITO PARA AGREGAR,ES DISTINTO AL PROC VALIDAR FAVORITO QUE HICE CREO.
		While not eof(aFavoritos) do			
		AbrirArchivoFavoritos(aFavoritos,IDusuarioactual);
		seek(aFavoritos,FileSize(aFavoritos));
		write(aFavoritos,FavoritoParaAgregar);
		close(aFavoritos);
end;

 procedure mostrarError;
 begin
 writeln('Dato invalido. Presione una tecla para continuar');
 readkey;
 end;


var
	aFavoritos:taFavoritos;
	IDUsuarioActual:tIDusuario;
	opcion:byte;
	
begin
	opcion:=235;// COMO OPTIMIZO ESTO...
	cabeceraPantalla('Favoritos');
	MostrarFavoritos(IDUsuarioActual,aFavoritos);
	
	writeln;
	
	publicarOpcion(opcionDatosPublicos,'Datos Publicos');
	publicarOpcion(opcionPensamientos,'Pensamientos');
	publicarOpcion(opcionVolver,'Volver');
	opcionPantalla;
	read(opcion);
	if (opcion<>opcionDatosPublicos) or (opcion<>opcionPensamientos) or(opcion<>opcionVolver) then
		mostrarError;
end.
