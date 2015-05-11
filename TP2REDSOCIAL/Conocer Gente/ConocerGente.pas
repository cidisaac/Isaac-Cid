program elprocedimiento;
Uses
	usuarios, math, crt, sysutils;
Const
	MinOpcion = 1;
	
	OpcionVolver = 1; OpcionMasc = 2; OpcionFem = 3;
	OpcionIndef = 4; OpcionMyF = 5; OpcionIyM = 6; OpcionIyF = 7;
	OpcionTodos = 8; maxOpcionPorInteres = 8;
	
	OpcionIntereses = 2; OpcionDistancia  = 3; maxOpcionConocerG = 3;
	
	OpcionVerPens = 2; OpcionAgregarAFav = 3; MaxOpcionPoAF = 3;
	
	MaxOpcionporDistancia = 3;
	OpcionMenorAUno = 2; OpcionEntreUnoYDiez = 3; OpcionEntreDiezYTreinta = 4;
Type
	tRangoArrayUsuarios = MinUsuario..MaxUsuario;
	tRangoSexo = M..I;
	tArraySexo = array[tRangoSexo] of tSexo;
	tArrayUsuarios = array[tRangoArrayUsuarios] of byte;
	
	
procedure conocerGente(maxIdx:byte; Var aUsuarios:taUsuarios; rUsuario:trUsuario); forward;

procedure MenuPrincipal;
begin
end; // esto no lo uso, es para que no me diga fatal error al compilar...

procedure inicializarUsuariosValidos(Var ArrayUsuarios : tArrayUsuarios);
Var cont : byte;
begin
for cont := MinUsuario to MaxUsuario do
	ArrayUsuarios[i] := 101
end;
	
function calcularEdad(Fecha : tDate): byte; //Hasta 99 años
Var edad: byte;
begin
val(copy(DateToStr(Date-Fecha), 9, 2), edad);
calcularEdad := Edad
end;
	
function Distancia(LatitudA, LongitudA, LatitudB, LongitudB: tCoordenada): integer;
	var a,c,d:real;
	begin
	LatitudA := degtorad(LatitudA);
	LatitudB := degtorad(LatitudB);
	LongitudA := degtorad(LongitudA);
	LongitudB := degtorad(LongitudB);
	a := sqr(sin(abs(latitudA-latitudB)/2))+ cos(latitudA)*cos(latitudB)*sqr(sin(abs(longitudA-longitudB)/2));
	c := 2*arctan2(sqrt(a), sqrt(1-a));
	d := c * 6371;
	Distancia := floor(d)
	end;
	
function ArraySexos(opcion:tOpcion): tArraySexo;
Var sexos:tArraySexo; cont:byte;
begin
	for cont:=M to I do
		case opcion of
			OpcionMasc : sexos[1] := 'M';
			OpcionFem : sexos[1] := 'F';
			OpcionIndef : sexos[1] := 'I';
			OpcionMyF: begin sexos[1] := 'M'; sexos[2]:= 'F' end;
			OpcionIyM : begin sexos[1] := 'I'; sexos[2] := 'M' end;
			OpcionIyF: begin sexos[1] := 'I'; sexos[2] := 'F' end;
			OpcionTodos: begin sexos[1] := 'M'; sexos[2] := 'F';  sexos[3] := 'I' end	
		end;	
	ArraySexos := sexos
end;

function chequearIntereses(Var rUsuario, usuarioActual : trUsuario) : boolean;
Var coincide : boolean; interes,j : byte; interesesA, interesesB : tvIntereses;
begin
coincide := False;
interesesA := usuarioActual.intereses;
interesesB := rUsuario.intereses;
j := minIntereses;
while (j <= maxIntereses) and not coincide do
	begin
	interes := minIntereses;
	while (interes <= maxIntereses) and not coincide do
		if interesesA[interes] = interesesB[j] then
			coincide := True
		else interes := interes+1;
	j := j+1
	end;
chequearIntereses := coincide
end;

function coincideSexo(sexos:tArraySexo; rUsuario : trUsuario) : boolean ;
Var j : byte; encontrado : boolean;
begin
	encontrado := False;
	j := M;
	while (j<= I) and (not encontrado) do
		begin
		if sexos[j] = rUsuario.Sexo then
			encontrado := True;
		j := j+1
		end;	
	coincideSexo := encontrado
end;

procedure buscarPorSexo(opcion:tOpcion; maxIdx:byte; Var aUsuarios : taUsuarios; usuarioActual : trUsuario ; Var maximo:byte ; Var usuariosValidos:tArrayUsuarios);
Var j, k:byte; sexos:tArraySexo; rUsuario : trUsuario; 
begin
reset(aUsuarios);
k := 0;
sexos := ArraySexos(opcion);
for j := 0 to maxIdx do
	begin
	read(aUsuarios, rUsuario);
	if coincideSexo(sexos, rUsuario) then
		if chequearIntereses(rUsuario, usuarioActual) then
			begin
			inc(k);
			writeln(k, '. ', rUsuario.nickname);
			writeln('Edad: ', calcularEdad(rUsuario.fecha));
			writeln('Ciudad: ', rUsuario.Ciudad);
			usuariosValidos[k] := j
			end
	end;
maximo := k
end;

procedure buscarPorDistancia(minDistancia, maxDistancia : real; ubicacion : tUbicacion; Var aUsuarios:taUsuarios; Var usuariosValidos:tArrayUsuarios; maxIdx : byte; Var maximo : byte);
Var cont, j : byte; distanciaActual : real; rUsuario : trUsuario;
begin
	reset(aUsuarios);
	j := 0;
	for cont := 0 to maxIdx do
		begin
		read(aUsuarios, rUsuario);
		distanciaActual := Distancia(ubicacion.latitud, ubicacion.longitud, rUsuario.ubicacion.latitud, rUsuario.ubicacion.longitud);
		if (distanciaActual >= minDistancia) and (distanciaActual <= maxDistancia) then
			begin
			inc(j);
			writeln(j, '. ', rUsuario.nickname);
			writeln('Edad: ', calcularEdad(rUsuario.fecha));
			writeln('Sexo: ', rUsuario.sexo);
			usuariosValidos[j] := cont
			end
		end;
	maximo := j
end;

procedure pantallaPorInteres;
	begin
	cabecerapantalla('Conocer por intereses/sexo');
	publicarOpcion(OpcionVolver, 'Volver');
	publicarOpcion(OpcionMasc, 'Solamente sexo masculino');
	publicarOpcion(OpcionFem, 'Solamente sexo femenino');
	publicarOpcion(OpcionIndef, 'Solamente sexo indefinido');
	publicarOpcion(OpcionMyF, 'Sexo masculino o femenino');
	publicarOpcion(OpcionIyM, 'Sexo masculino o indefinido');
	publicarOpcion(OpcionIyF, 'Sexo femenino o indefinido');
	publicarOpcion(OpcionTodos, 'Cualquier sexo');
	end;
	
procedure pantallaConocerGente;
	begin
	cabeceraPantalla('Conocer gente');
	publicarOpcion(OpcionVolver, 'Volver');
	publicarOpcion(OpcionIntereses, 'por intereses/sexo');
	publicarOpcion(OpcionDistancia, 'por distancia');
	end;

procedure pantallaPorDistancia;
	begin
	cabeceraPantalla('Conocer gente por distancia');
	publicarOpcion(OpcionVolver, 'Volver');
	publicarOpcion(OpcionMenorAUno, 'Menor a un km');
	publicarOpcion(OpcionEntreUnoYDiez, 'Entre uno y diez km');
	publicarOpcion(OpcionEntreDiezYTreinta, 'Entre diez y treinta km')
	end;
	
procedure pantallaVerPensOAgregarAFav;
begin
	cabeceraPantalla('¿Que desea hacer?');
	publicarOpcion(OpcionVolver, 'Volver');
	publicarOpcion(OpcionVerPens, 'Ver el ultimo pensamiento');
	publicarOpcion(OpcionAgregarAFav, 'Agregar a favoritos');
end;
	
procedure verPensOAgregarAFav; //Falta implementar VerUltimosPensamiento y Agregar a Favoritos.
Var error : tError; opcion : tOpcion;
begin
	repeat
		pantallaVerPensOAgregarAFav;
		ingresarOpcion(opcion, MinOpcion, MaxOpcionPoAF, error);
	until (error = 0);
	
	{case opcion of
		1 : conocerPorInteres;
		2 : VerUltimoPensamiento;
		3 : AgregarAFavoritos;
	end}
end;
	
procedure seleccionarUsuario(usuariosValidos:tArrayUsuarios; maximo:integer);
Var opcion:tOpcion; posX, posY : tcrtcoord; error : tError;
begin
	posX := WhereX;
	posY := WhereY;
	repeat
		ingresarOpcion(opcion, MinOpcion, maximo, error);
		GoToXY(posX, posY);
		clrEol;
	until (error = 0);
	verPensOAgregarAFav
end;
	
procedure conocerPorDistancia(maxIdx:byte; rUsuario:trUsuario; Var aUsuarios: taUsuarios);
Var opcion:tOpcion; usuariosValidos:tArrayUsuarios; error : tError; maximo : byte;
begin
	repeat
        pantallaPorDistancia;
        ingresarOpcion(opcion, MinOpcion, MaxOpcionPorDistancia, error)
    until (error = 0);
	clrscr;
	inicializarUsuariosValidos(usuariosValidos);
    case opcion of
        OpcionVolver: conocerGente(maxIdx, aUsuarios, rUsuario);
		OpcionMenorAUno : buscarPorDistancia(0, 1, rUsuario.ubicacion, aUsuarios, usuariosValidos, maxIdx, maximo);
		OpcionEntreUnoYDiez : buscarPorDistancia(1, 10, rUsuario.ubicacion, aUsuarios, usuariosValidos, maxIdx, maximo);
		OpcionEntreDiezYTreinta: buscarPorDistancia(10, 30, rUsuario.ubicacion, aUsuarios, usuariosValidos, maxIdx, maximo)
    end;	
	seleccionarUsuario(usuariosValidos, maximo);
	
 end;

procedure conocerPorInteres(maxIdx:byte; rUsuario:trUsuario; Var aUsuarios:taUsuarios);
Var opcion:topcion; error : tError; maximo : byte; usuariosValidos:tArrayUsuarios;
begin
	repeat
        pantallaPorInteres;
        ingresarOpcion(opcion, MinOpcion, MaxOpcionPorInteres, error);
    until (error = 0);
	inicializarUsuariosValidos(usuariosValidos);
    case opcion of
        OpcionVolver: conocerGente(maxIdx, aUsuarios, rUsuario);
    else 
		buscarPorSexo(opcion, maxIdx, aUsuarios, rUsuario, maximo, usuariosValidos)
    end;
    seleccionarUsuario(usuariosValidos, maximo)
 end;

procedure conocerGente(maxIdx:byte; Var aUsuarios : taUsuarios; rUsuario:trUsuario);
Var opcion:topcion; error :tError;
begin
	repeat
        pantallaConocerGente;
        ingresarOpcion(opcion, MinOpcion, MaxOpcionConocerG, error)
    until (error = 0);

    case opcion of
        OpcionVolver: MenuPrincipal;
        OpcionIntereses: conocerPorInteres(maxIdx, rUsuario, aUsuarios);
        OpcionDistancia: conocerPorDistancia(maxIdx, rUsuario, aUsuarios)
    end
 end;

Var aUsuarios : taUsuarios;
begin
end.
