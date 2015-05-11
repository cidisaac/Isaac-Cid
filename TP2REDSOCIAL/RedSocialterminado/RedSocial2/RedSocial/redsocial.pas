program RedSocial;
uses
        usuarios,crt,sysutils,math;
const
        TituloRegistroPublico = 'Registro de nuevo usuario: "Datos P�blicos"';
        TituloRegistroPrivado = 'Registro de nuevo usuario: "Datos Privados"';
        TituloLogin = 'Login';
		
	//Cantidad de opciones por pantalla
	MaxOpcionPpal = 2;
    MaxOpcionMenuPpal = 3;
    MaxOpcionMisPens = 2;
    MaxOpcionDetallePens = 3;
    MaxOpcionFavoritos = 2;
    MaxOpcionObtenerUserID = 1;
    MinOpcion = 0;
	
	//Codigos de cada opcion por pantalla
    OpcionVolver = 0;
	OpcionMisPens = 1;
	OpcionBuscador = 2;
	OpcionFavoritos = 3;
    OpcionPublicarPens = 1;
    OpcionListaPens = 2;
    OpcionResponder = 1;
    OpcionVotarPos = 2;
    OpcionVotarNeg = 3;
    OpcionRegistro = 1;
    OpcionLogin = 2;

    //Formatos de Fechas y Horas
    FormatoFechaHora = 'dd/mm/yyyy hh:nn:ss';   //Formato para mostrar la fecha y hora de un pensamiento
    FormatoHora = 'hh:nn:ss';                   //Formato auxiliar para pasar mostrar el "tiempo despues"
    SeparadorHora = ':';
    MaxLongFechaHora = 20;                      //Asumiendo que dias es un byte
    MaxLongHora = 8;


    //Valores de inicializacion (puntuacion, vUltimosPens)
    DefaultVotosPos = 0;
    DefaultVotosNeg = 0;
    FinUltimosPens = -1;

	//Valores para comprobar si es voto positivo o negativo
    VotoPos = true;
    VotoNeg = false;

	//Valores para saber a donde volver desde el m�dulo DetallePens
    VolverALista = 1;
    VolverABusqueda = 2;
    VolverAFavoritos = 3;

    //Mensajes por pantalla
    MsjCantCarac1 = 'Recuerde que puede escribir como m�ximo 255 caracteres.';
    MsjCantCarac2 = 'Cualquier mensaje mayor ser� truncado.';
    MsjBlanco = 'Debe ingresar al menos un caracter';
	
	MinResp = 0;
	MaxResp = 500; //Limite para usar en el indice.

	{CONSTANTES DE ISAAC}
	minFavoritos=0;
	maxFavoritos=99;
	rutaFavoritos='FavoritosUsuario.dat';
	//Posicion en donde se debe insertar el IDUsuario para que quede con el formato FavoritosUsuarioIDusuario.dat
	posInsercion=17;
	opcionDatosPublicos=1;
	opcionAgregarFavoritosxID=1;
	opcionPensamientos=2;
	minUsuario=0;
	maxUsuario=99;
	SeparadorOpcion='-';
	opcionVerDatosPublicos = 2;
	MaxOpcionDPoUP = 2;
	
	 {FIN CONSTANTES DE ISAAC}
	 {CONSTANTES DE NICOLAS}
	
	OpcionMasc = 1; OpcionFem = 2;
	OpcionIndef = 3; OpcionMyF = 4; OpcionIyM = 5; OpcionIyF = 6;
	OpcionTodos = 7; maxOpcionPorInteres = 7;
	
	OpcionIntereses = 1; OpcionDistancia  = 2; maxOpcionConocerG = 2;
	
	OpcionVerPens = 1; OpcionAgregarAFav = 2; MaxOpcionPoAF = 2;
	
	MaxOpcionporDistancia = 3;
	OpcionMenorAUno = 1; OpcionEntreUnoYDiez = 2; OpcionEntreDiezYTreinta = 3;
	
	ErrNoHayUsuarios = 'No se encontraron usuarios';
	 {FIN CONSTANTES DE NICOLAS}
	{CONSTANTES DE GASTON}
	rutaPens = 'pensamientos.dat';
    rutaResp = 'respuestas.dat';
	{FIN CONSTANTES DE GASTON}


Type
	{TYPES DE GASTON}
	//tipos para el rPens y rResp
    //tIDPens = integer; se necesit� declarar en la unit
    tMensaje = string;
    tVotos = byte;
    trPens = record
        IDPens : tIDPens;
        IDUsuario : tIDUsuario;
        mensaje : tMensaje;
        votosPos : tVotos;
        votosNeg : tVotos;
        fechaHora : tDateTime
    end;
    trResp = record
        IDPens : tIDPens;
        IDUsuario : tIDUsuario;
        mensaje : tmensaje;
        tiempoDesp : tDateTime
    end;


    //Tipos de archivos
    taPens = file of trPens;
    taResp = file of trResp;

    //Tipos de strings para trabajar con fechas
    tStrFechaHora = string[MaxLongFechaHora];
    tStrHora = string[MaxLongHora];

    //Tipo para procesar votaciones
    tVoto = boolean;

	//Tipo para controlar la salida del modulo DetallePens
	tvolver = byte;	

	tRangoResp = MinResp..MaxResp;
		
	tFavoritos=minFavoritos..maxFavoritos;	
	taFavoritos= file of tFavoritos;
	tIDusuarioActual=tIDusuario;
	
	 {FIN TYPES DE GASTON}
	 {TYPES DE NICOLAS}
	tRangoArrayUsuarios = MinUsuario..MaxUsuario;
	tRangoSexo = M..I;
	tArraySexo = array[tRangoSexo] of tSexo;
	tArrayUsuarios = array[tRangoArrayUsuarios] of tIDUsuario;
	 {FIN TYPES DE NICOLAS}
		
procedure MisPensamientos(var aUsuarios:taUsuarios; var aPens:taPens; var aResp:taResp; IDusuarioActual:tIDUsuario; maxIDxUsuarios: tIDUsuario; var aFavoritos:taFavoritos; var IDxNick,IDxMail:tUsuariosIdx); forward;

procedure publicarPens(var aUsuarios:taUsuarios; var aPens:taPens; var aResp:taResp; IDUsuarioActual:tIDUsuario; maxIDxUsuarios: tIDUsuario; var aFavoritos:taFavoritos; var IDxNick,IDxMail:tUsuariosIdx); forward;

procedure ListaPens(var aUsuarios:taUsuarios; var aPens:taPens; var aResp:taResp; IDUsuarioActual:tIDUsuario;  maxIDxUsuarios: tIDUsuario; var aFavoritos:taFavoritos; var IDxNick,IDxMail:tUsuariosIdx); forward;

procedure DetallePens(var aUsuarios:taUsuarios; var aPens:taPens; var aResp:taResp; IDPens:tIDPens; IDUsuarioActual:tIDUsuario; volver:tvolver; maxIdxUsuarios:tIDUsuario; var aFavoritos:taFavoritos; var IdxNick,IdxMail:tUsuariosIdx); forward;

procedure Votar(var aUsuarios:taUsuarios; var aPens:taPens; var aResp:taResp; IDUsuarioActual:tIDUsuario; IDPens:tIDPens; voto:tVoto; volver:tvolver; maxIDxUsuarios: tIDUsuario; var aFavoritos:taFavoritos; var IDxNick,IDxMail:tUsuariosIdx); forward;

procedure Responder(var aUsuarios:taUsuarios; var aPens:taPens; var aResp:taResp; IDPens:tIDPens; IDUsuarioActual:tIDUsuario; fechaHoraPens:tDateTime; volver:tvolver; maxIDxUsuarios: tIDUsuario; var aFavoritos:taFavoritos; var IDxNick,IDxMail:tUsuariosIdx
); forward;

procedure Inicio(var aUsuarios:taUsuarios; var aPens:taPens; var aResp:taResp; var aFavoritos:taFavoritos; var IdxNick,IdxMail:tUsuariosIdx;  var maxIdxUsuarios:tIDUsuario); forward;

procedure MenuPrincipal(var aUsuarios:taUsuarios; var aPens:taPens; var aResp:taResp; var aFavoritos:taFavoritos; var IdxNick,IdxMail:tUsuariosIdx; var maxIdxUsuarios:tIDUsuario;IDUsuarioActual:tIDUsuario); forward;
	
procedure UltimoPens(var aUsuarios:taUsuarios; var aPens:taPens; var aResp:taResp; IDUsuario,IDUsuarioActual:tIDUsuario; volver:tvolver;  maxIDxUsuarios: tIDUsuario; var aFavoritos:taFavoritos; var IDxNick,IDxMail:tUsuariosIdx); forward;
		
//Autor: Germ�n Concilio
//Descripci�n: Obtiene el nick validado
//Pre-Cond: Que exista el �ndice de usuarios ordenados por nickname y su m�ximo l�gico
Procedure obtenerNickValido(var destino:tNombre; var IdxNick:tUsuariosIdx; maxIdxUsuarios:tIdUsuario);

var
        error:tError;
        mensaje:tMensaje;
        aux:string[LongNickname + 1]; //el caracter de mas permite saber si se paso o no del rango
begin
        repeat
                cabeceraPantalla(TituloRegistroPublico);
                write('Ingrese su nombre de usuario o nickname: ');
                readln(aux);
                validarNick(aux,IdxNick,maxIdxUsuarios,error,mensaje);
                if (error = 0) then destino:=aux
                else MostrarMensajeError(mensaje)
        until (error = 0)
end;
//Autor: Germ�n Concilio
//Descripci�n: Obtiene el sexo validado
procedure obtenerSexoValido(var destino:tSexo);
var
        error:tError;
        opcion:tOpcion;
begin
        repeat
                cabeceraPantalla(TituloRegistroPublico);
                writeln('Ingrese su sexo: ');
                writeln('');
                publicarOpcion(1,'Masculino');
                publicarOpcion(2,'Femenino');
                publicarOpcion(3,'Indefinido');
                writeln('');
                ingresarOpcion(opcion,1,3,error)    //donde guarda,min,max,error
        until (error = 0);
        case opcion of
                M:destino:='m';//masculino
                F:destino:='f';//femenino
                I:destino:='i' //indefinido
        end
end;
//Autor: Germ�n Concilio
//Descripci�n: Obtiene la ciudad validada
procedure obtenerCiudadValida(var destino :tCiudad);
var
        error:tError;
        mensaje:tMensaje;
        aux:string[LongCiudad + 1];
begin
        repeat
                cabeceraPantalla(TituloRegistroPublico);
                write('Ingrese su ciudad: ');
                readln(aux);
                validarCiudad(aux,error,mensaje);
                if (error = 0) then destino:=aux
                else MostrarMensajeError(mensaje)
        until (error=0)
end;
//Autor: Germ�n Concilio
//Descripci�n: Obtiene el nombre o apellido del usuario a registrar validado
//Observaci�n: Sirve para nombre y apellido el mismo procedimiento porque tienen misma longitud de string
procedure obtenerNombreValido (var destino:tNombre;var pantalla:tPantalla);
var
        aux : string[LongNombre + 1];
        error:tError;
        mensaje:tMensaje;
begin
        repeat
                cabeceraPantalla(TituloRegistroPrivado);
                write(pantalla);
                readln(aux);
                validarNombre(aux,error,mensaje);
                if (error = 0) then destino:=aux
                else MostrarMensajeError(mensaje)
        until (error = 0)
end;
//Autor: Germ�n Concilio
//Descripci�n: Obtiene el mail validado
//Pre-Cond: Que exista el �ndice de usuarios ordenados por mail y su m�ximo l�gico
procedure obtenerMailValido (var destino:tMail; var IdxMail:tUsuariosIdx; maxIdxUsuarios:byte);
var
        aux : string[LongMail + 1];
        error:tError;
        mensaje:tMensaje;
begin
        repeat
                cabeceraPantalla(TituloRegistroPrivado);
                write('Ingrese su correo de e-mail: ');
                readln(aux);
                validarMail(aux,IdxMail,maxIdxUsuarios,error,mensaje);
                if (error = 0) then destino:=aux
                else MostrarMensajeError(mensaje)
        until (error = 0)
end;
//Autor: Germ�n Concilio
//Descripci�n: Muestra "*" al ingresar una contrase�a y devuelve la cadena ingresada por el usuario
procedure ingresarPass(var destino:string);
var
        ch:char;
        i:byte;
        pass : string;
begin
        i:=0;
        pass:='';
        repeat
                        ch:=readkey;
                        if (ch = #8) and (i > 0) then  //backspace
                        begin
                                 pass := Copy(pass,1,i - 1); //borra el ultimo
                                 GotoXY(WhereX-1,WhereY);
                                 ClrEol;
                                 dec(i)
                        end
                        else if (Ch in [#32..#126]) then
                        begin
                                write('*');
                                if (i < LongPassMax + 1) then pass := pass + ch;
                                inc(i)
                        end
        until (ch= #13); //enter
        destino:= pass
end;
//Autor: Germ�n Concilio
//Descripci�n: Obtiene la contrase�a validada
procedure obtenerPassValida (var destino:tPass);
var
        aux : string[LongPassMax + 1];
        error:tError;
        mensaje:tMensaje;
begin
        repeat
                cabeceraPantalla(TituloRegistroPrivado);
                write('Ingrese su contrase�a: ');
                IngresarPass(aux);
                validarPass(aux,error,mensaje);
                if (error = 0) then destino:=aux
                else MostrarMensajeError(mensaje)
        until (error = 0)
end;
//Autor: Germ�n Concilio
//Descripci�n: Pantalla para ingresar latitud o longitud
//Observaci�n: se us� para no hacer redundancia de c�digo
procedure IngresarCoordenada(var pantalla:tPantalla; var aux:string);
begin
        cabeceraPantalla(TituloRegistroPrivado);
        write(pantalla);
        readln(aux)
end;
//Autor: Germ�n Concilio
//Descripci�n: Obtiene una ubicaci�n (latitud - longitud) validada
procedure obtenerUbicacionValida (var destino:tUbicacion);
var
        auxLatitud,auxLongitud : string;
        error:tError;
        mensaje:tMensaje;
        pantalla:tPantalla;
begin
        repeat
                pantalla:= 'Ingrese la latitud de su ubicaci�n: ';
                ingresarCoordenada( pantalla, auxLatitud);
                validarCoordenada(destino.latitud , auxLatitud,MinLatitud,MaxLatitud,error,mensaje);
                if (error <> 0) then MostrarMensajeError(mensaje)
        until (error = 0);
        repeat
                pantalla:= 'Ingrese la longitud de su ubicaci�n: ';
                ingresarCoordenada( pantalla, auxLongitud);
                validarCoordenada(destino.longitud , auxLongitud,MinLongitud,MaxLongitud,error,mensaje);
                if (error <> 0) then MostrarMensajeError(mensaje)
        until (error = 0)
end;
//Autor: Germ�n Concilio
//Descripci�n: Obtiene 5 intereses validos
//Pre-Cond: Que exista el archivo intereses.dat con un m�nimo de 5 intereses cargados
procedure obtenerInteresValido(var destino:tvIntereses; var listaIntereses : tListaIntereses;maxInteres:tIntereses );
var
        opcion:tOpcion;
        num,i : byte;
        error:tError;
        mensaje:tMensaje;
begin
        num:=minIntereses;
        repeat
                repeat
                        cabeceraPantalla(TituloRegistroPrivado);
                        writeln('Ingrese ',num ,'� interes: ');
                        writeln('');
                        for i:= minIntereses to maxInteres do publicarOpcion(i,listaIntereses[i]);
                        writeln('');
                        ingresarOpcion(opcion,minIntereses,maxInteres,error);
                        if (error = 0) then
                        begin
                                interesRepetido(destino,opcion,num,error,mensaje);
                                if (error <> 0) then MostrarMensajeError(mensaje)
                        end
                until (error=0);
                destino[num] := opcion;              //guarda el numero de interes en los datos del usuario
                inc(num)
        until (num > maxIntereses)
end;
//Autor: Germ�n Concilio
//Descripci�n: Obtiene una fecha validada
//Observaci�n: El formtato debe ser [dd/mm/aaaa], si el mes es enero se debe poner 01 por ejemplo
procedure obtenerFechaValida (var destino: tFecha);
VAR
        error:tError;
        mensaje:tMensaje;
        aux : string[LongFechaNac + 1];
begin
         repeat
                cabeceraPantalla(TituloRegistroPublico);
                write('Ingrese su fecha de nacimiento [dd/mm/aaaa]: ');
                readln(aux);
                validarFecha(aux,error,mensaje);
                if (error = 0) then destino:= strToDate(aux)
                else MostrarMensajeError(mensaje)
        until (error = 0)
end;
//Autor: Germ�n Concilio
//Descripci�n: Controla todo el proceso de registro de un usuario
//Pre-Cond: Que exista el �ndice de usuarios ordenados por nickname y mail,  y su m�ximo l�gico
procedure Registro(var IdxNIck,IdxMail:tUsuariosIdx; var maxIdxUsuarios:tIDusuario; var aUsuarios: taUsuarios; var IDUsuarioActual : tIDUsuario);
var
        rUsuario:trUsuario;
        pantalla:tPantalla;
        listaIntereses : tListaIntereses;
        aIntereses:taIntereses;
        maxInteres:Byte;
        MaxIDUsuario : tIDUsuario;
begin
		MaxIDUsuario := maxIdxUsuarios;
        AbrirArchivoIntereses(aIntereses,maxInteres,RutaIntereses);
        cargarListaIntereses(listaIntereses, aIntereses,maxInteres);
        close (aIntereses);
        if (maxInteres < MaxIntereses) then writeln(ErrArchivoIntereses); //debe salir

        obtenerNickValido(rUsuario.nickname,IdxNIck,maxIdxUsuarios);

        obtenerFechaValida(rUsuario.Fecha);

        obtenerSexoValido(rUsuario.sexo);

        obtenerCiudadValida(rUsuario.ciudad);

        pantalla:= 'Ingrese su nombre: ';
        obtenerNombreValido(rUsuario.nombre,pantalla);

        pantalla:= 'Ingrese su apellido: ';
        obtenerNombreValido(rUsuario.apellido,pantalla);

        obtenerMailValido (rUsuario.mail,IdxMail,maxIdxUsuarios);

        obtenerPassValida(rUsuario.pass);      // falta validar y asteriscos

        obtenerInteresValido(rUsuario.intereses, listaIntereses, maxInteres);

        obtenerUbicacionValida (rUsuario.ubicacion);

        inicializarUltimosPens(rUsuario.vUltimosPens);

        rUsuario.ID := asignarIDusuario(maxIdxUsuarios);

        ArchivoUsuariosFinal(aUsuarios,RutaUsuarios);
        write(aUsuarios,rUsuario);
        close (aUsuarios);

        //Inserta en lso indices por Nick y por Mail
       if (maxIdxUsuarios = MaxIDUsuario + 1) then
       begin
                agregarUsuarioIdx(IdxNick,rUsuario.nickname,rUsuario.ID,rUsuario.ID); //si no hay ningun usuario cargado debe inicilizarlo con el primer valor
                agregarUsuarioIdx(IdxMail,rUsuario.mail,rUsuario.ID,rUsuario.ID)
       end
       else
       begin
                InsertarUsuarioIdx(IdxNick,rUsuario.nickname,rUsuario.ID,maxIdxUsuarios);
                InsertarUsuarioIdx(IdxMail,rUsuario.mail,rUsuario.ID,maxIdxUsuarios)
       end;
       maxIdxUsuarios:=rUsuario.ID;
       IDUsuarioActual := rUsuario.ID
end;
//Autor: Germ�n Concilio
//Descripci�n: Obtiene el ID del usuario a partir del nickname utilizando b�squeda binaria
//Pre-Cond: Que exista el �ndice de usuarios ordenados por nickname y su m�ximo l�gico
procedure buscarNick (var aux:string; var ID:tIDusuario; var IdxNick:tUsuariosIdx ; maxIdxUsuarios:tIdUsuario; var error:tError; var mensaje:tMensaje );
var
        max,min,medio:tIDusuario;
begin
        validarLongTexto(aux,1,LongNombre,error,mensaje);
        if(error= 0) then
        begin
                error:=21;
                aux := lowercase(aux);
                min:= MinUsuario;
                max:= maxIdxUsuarios;
                while (error <> 0) and (min <= max ) do               //busco si esta en el indice
                begin
                        medio := (min + max) div 2;
                        if (aux = lowercase(idxNick[medio].cadena)) then
                        begin
                                ID:=idxNick[medio].Id;//devuelvo el ID real en el archivo
                                error :=0
                        end
                        else
                                if (aux < lowercase(idxNick[medio].cadena)) then max := medio - 1
                                else min := medio +1
                end;
                if (error = 21) then mensaje := ErrNoExisteUsuario
        end
end;
//Autor: Germ�n Concilio
//Descripci�n: Verifica la coincidencia de la contrase�a ingresada con la que corresponde
procedure buscarPass (aux:string; ID:tIDusuario; var aUsuarios:taUsuarios; var error:tError; var mensaje:tMensaje);
var
        rUsuario:trUsuario;
begin
        validarPass(aux,error,mensaje); //valida que la longitud sea la correcta
        if (error=0) then
        begin
                abrirArchivoUsuarios(aUsuarios,rutaUsuarios);
                seek(aUsuarios,ID);
                read(aUsuarios,rUsuario);
                if (aux <> rUsuario.pass) then
                begin
                        error:= 22;
                        mensaje := ErrNoCoincidePass
                end;
                close(aUsuarios)
        end

end;
//Autor: Germ�n Concilio
//Descripci�n: Controla el proceso de Logueo de un usuario
//Pre-Cond: Que exista el �ndice de usuarios ordenados por nickname y su m�ximo l�gico
procedure Login(var IdxNick:tUsuariosIdx; var maxIdxUsuarios:tIdUsuario;var aUsuarios:taUsuarios; var error:tError; var IDUsuarioActual:tIDUsuario);
Var
        mensaje:tMensaje;
        aux:string; //el caracter de mas permite saber si se paso o no del rango
        var ID : tIDusuario;
begin
        repeat
                cabeceraPantalla(TituloLogin);
                write('Ingrese su nombre de usuario o nickname (Presione "0" para cancelar): ');
                readln(aux);
                //me fijo si esta en el indice
                if (aux<> '0') then
                begin
                        buscarNick(aux,ID,IdxNick,maxIdxUsuarios,error,mensaje);
                        if (error = 0) then
                        begin
                                cabeceraPantalla(TituloLogin);
                                write('Ingrese su contrase�a: ');
                                ingresarPass(aux);
                                buscarPass(aux,ID,aUsuarios,error,mensaje)
                        end;
                        if (error <> 0) then MostrarMensajeError(mensaje)
                        else IDUsuarioActual := ID
                end
                else error:=23
        until (error = 0) or (error = 23)
end;

procedure pantallaPrincipal;
begin
	cabeceraPantalla('Ingreso al sistema');
	publicarOpcion(OpcionVolver, 'Salir');
	publicarOpcion(OpcionRegistro, 'Registrarse');
	publicarOpcion(OpcionLogin, 'Ingresar')
end;

//Autor: Gaston Snaider
//Muestra la pantalla Menu Principal.
//Pos-Cond: Limpia la pantalla. Muestra la pantalla Menu Principal, con su t�tulo y sus opciones.
procedure pantallaMenuPpal;
begin
    cabeceraPantalla('Menu Principal');
    publicarOpcion(OpcionVolver,'Volver');
    publicarOpcion(OpcionMisPens,'Mis Pensamientos');
    publicarOpcion(OpcionBuscador,'Buscador');
    publicarOpcion(OpcionFavoritos,'Favoritos')
end;

procedure conocerPorInteres(var maxIdxUsuarios:tIDUsuario; rUsuario:trUsuario; Var aUsuarios:taUsuarios; var aPens:taPens; var aResp:taResp; var aFavoritos:taFavoritos; var IdxNick,IdxMail:tUsuariosIdx); forward;

procedure conocerGente(var maxIdxUsuarios:tIDUsuario; Var aUsuarios : taUsuarios; IDUsuario:tIDUsuario; var aPens:taPens; var aResp:taResp; var aFavoritos:taFavoritos; var IdxNick,IdxMail:tUsuariosIdx); forward;

{PROCEDIMIENTOS DE ISAAC}

function calcularEdad(Fecha : tDate) : byte; forward;

Procedure MostrarFavoritos(Var IDUsuarioActual:tIDusuario;Var aFavoritos:taFavoritos;Var aUsuarios : taUsuarios; Var aPens:taPens; Var aResp:taResp; var IdxNick, IdxMail : tUsuariosIdx; maxIdxUsuarios : tIDUsuario); forward;

 //Autor: Isaac Cid Cabaleiro
 //Abre el archivo favoritos para el usuario que se encuentra logueado.
 //Pre-Cond:IDUsuarioActual = usuario que se encuentra logueado
 //Si el archivo no existe lo crea y lo deja con el puntero en la posicion inicial
procedure AbrirArchivoFavoritos(Var aFavoritos:taFavoritos;IDUsuarioActual:tIDusuario);
Var
	idtemp:tIDusuario;
	ruta:string;
	IDSTRING:string;
begin
	ruta:=rutaFavoritos;
	idtemp:=IDUsuarioActual;
	str(idtemp,IDSTRING);
	Insert(IDSTRING,ruta,posInsercion);
	assign(aFavoritos,ruta);
	{$I-}
	reset(aFavoritos);
	{$I-}
	if (IOresult<>0) then rewrite(aFavoritos)
end;

//Autor:Isaac Cid Cabaleiro
//Valida que no agregue como favorito a alguien que ya tiene agregado.
Function FavoritoYaAgregado(Var aFavoritos:taFavoritos;IDUsuarioActual:tIDUsuario;IDFavoritoTemp:tIDUsuario):boolean;
var
	TEMPORALFAVORITO:tIDUsuario;
	Error : boolean;
begin
	AbrirArchivoFavoritos(aFavoritos, IDUsuarioActual);
	Error:=false;
	while (not Error) and not eof(aFavoritos) do
		begin
		read(aFavoritos,TEMPORALFAVORITO);
		if (TEMPORALFAVORITO=IDFavoritoTemp) then
			Error:=true
		end;	
	close(aFavoritos);
	FavoritoYaAgregado := Error
end;

procedure MostrarDatosPublicos(Var IDUsuarioActual:tIDUsuario; var aFavoritos:taFavoritos; IDUsuario:tIDUsuario; var aUsuarios:taUsuarios; maxIdxUsuarios:tIDUsuario; var aPens : taPens; var aResp:taResp; Var IdxNick, IdxMail: tUsuariosIdx);
Var rUsuario : trUsuario;
begin
	AbrirArchivoUsuarios(aUsuarios, rutaUsuarios);
	seek(aUsuarios, IDUsuario);
	read(aUsuarios, rUsuario);
	close(aUsuarios);
	writeln('Nickname: ', rUsuario.nickname);
	writeln('Edad: ', calcularEdad(rUsuario.fecha));
	writeln('Sexo: ', rUsuario.Sexo);
	writeln('Ciudad: ', rUsuario.Ciudad);
	readln;
	MostrarFavoritos(IDUsuarioActual, aFavoritos, aUsuarios, aPens, aResp, IdxNick, IdxMail, maxIdxUsuarios)
end;

procedure pantallaDatosPublicosOUltimoPens;
begin
	cabeceraPantalla('Ver datos publicos o ultimo pensamiento');
    publicarOpcion(OpcionVolver,'Volver');
	publicarOpcion(OpcionVerPens, 'Ver ultimo pensamiento');
	publicarOpcion(OpcionVerDatosPublicos, 'Ver datos publicos')
end;

procedure datosPublicosOUltimoPens(var aUsuarios:taUsuarios; var aPens:taPens; var aResp:taResp; IDUsuario,IDUsuarioActual:tIDUsuario; maxIdxUsuarios:tIDUsuario; var aFavoritos:taFavoritos; var IdxNick,IdxMail:tUsuariosIdx);
Var error : tError; opcion : tOpcion;
begin
	repeat
		pantallaDatosPublicosOUltimoPens;
		ingresarOpcion(opcion, MinOpcion, MaxOpcionDPoUP, error);
	until (error = 0);
	case opcion of
		OpcionVolver : conocerGente(maxIdxUsuarios, aUsuarios, IDUsuarioActual, aPens, aResp, aFavoritos, IdxNick, IdxMail);
		OpcionVerPens : UltimoPens(aUsuarios, aPens, aResp, IDUsuario, IDUsuarioActual, VolverAFavoritos, maxIDxUsuarios, aFavoritos, IDxNick,IDxMail);
		OpcionVerDatosPublicos : MostrarDatosPublicos(IDUsuarioActual, aFavoritos, IDUsuario, aUsuarios, maxIdxUsuarios, aPens, aResp, IdxNick, IdxMail)
	end
end;


//Autor:Isaac Cid Cabaleiro
//Muestra los favoritos del usuario logueado y pregunta al usuario sobre cual de sus favoritos desea ver mas informacion

Procedure MostrarFavoritos(Var IDUsuarioActual:tIDusuario;Var aFavoritos:taFavoritos;Var aUsuarios : taUsuarios; Var aPens:taPens; Var aResp:taResp; var IdxNick, IdxMail : tUsuariosIdx; maxIdxUsuarios : tIDUsuario);
Var
	IDfavorito, i:tIDusuario;
	opcion : tOpcion;
	error : tError;
	rUsuario : trUsuario;
	usuariosValidos : tArrayUsuarios;
Begin
	clrscr;
	i := 0;
	AbrirArchivoFavoritos(aFavoritos,IDusuarioactual);
	AbrirArchivoUsuarios(aUsuarios, rutaUsuarios);
	publicarOpcion(opcionVolver, 'Volver');
	writeln;
	while not eof(aFavoritos) do
		begin
		inc(i);
		read(aFavoritos,IDfavorito);
		seek(aUsuarios, IDfavorito);
		read(aUsuarios, rUsuario);
		writeln(i,'. ', rUsuario.nickname);
		usuariosValidos[i] := IDfavorito
		end;
	close(aFavoritos);
	close(aUsuarios);
	writeln;
	writeln('Ingrese el usuario que desea ver');
	repeat
		ingresarOpcion(opcion, minOpcion, i, error);
	until (error = 0);
	IDfavorito := usuariosValidos[opcion];
	if opcion <> opcionVolver then 
		datosPublicosOUltimoPens(aUsuarios, aPens, aResp, IDfavorito,IDUsuarioActual, maxIdxUsuarios, aFavoritos, IdxNick, IdxMail)
	else
		MenuPrincipal(aUsuarios, aPens, aResp, aFavoritos, IdxNick, IdxMail, maxIdxUsuarios, IDUsuarioActual)
end;

//Autor:Isaac Cid Cabaleiro
//Agrega favoritos para el usuario logueado 
//Los agrega al final del archivo
procedure AgregarFavoritosxID(Var IDUsuarioActual:tIDUsuario;Var aFavoritos:taFavoritos;Var FavoritoParaAgregar:tIDUsuario; var aUsuarios:taUsuarios;var maxIdxUsuarios:tIDUsuario; var aPens:taPens; var aResp:taResp; var IdxNick,IdxMail : tUsuariosIdx);	
begin	
	
	if (not FavoritoYaAgregado(aFavoritos,IDUsuarioActual,FavoritoParaAgregar)) and (FavoritoParaAgregar <> IDUsuarioActual) then
		begin
		AbrirArchivoFavoritos(aFavoritos,IDUsuarioActual);
		seek(aFavoritos,FileSize(aFavoritos));
		write(aFavoritos,FavoritoParaAgregar);
		close(aFavoritos);
		writeln('El usuario fue agregado a favoritos')
		end
	else
		if FavoritoParaAgregar <> IDUsuarioActual then
			writeln('Ya posee como favorito a ese usuario.')
		else
			writeln('No se puede agregar a si mismo como favorito');
	readln;
	conocerGente(maxIdxUsuarios, aUsuarios, IDUsuarioActual, aPens, aResp, aFavoritos, IdxNick, IdxMail)
end;

{FIN PROCEDIMIENTOS DE ISAAC}


{PROCEDIMIENTOS DE NICOLAS}
	
//Autor: Nicolas Keklikian
//Calcula la edad a base de la fecha de nacimiento. Maximo, 255.	
function calcularEdad(Fecha : tDate): byte;
Var resultado: word;
begin
val(copy(DateToStr(Date-Fecha), 7, 4), resultado);
calcularEdad := resultado-1900
end;

//Autor: Nicolas Keklikian
//Calcula la distancia entre dos puntos de la Tierra.	
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
	
//Autor: Nicolas Keklikian
//Devuelve un vector que contiene los sexos que el usuario desea encontrar.
function ArraySexos(opcion:tOpcion): tArraySexo;
Var sexos:tArraySexo; cont:byte;
begin
	for cont:=M to I do
		case opcion of
			OpcionMasc : sexos[1] := 'm';
			OpcionFem : sexos[1] := 'f';
			OpcionIndef : sexos[1] := 'i';
			OpcionMyF: begin sexos[1] := 'm'; sexos[2]:= 'f' end;
			OpcionIyM : begin sexos[1] := 'i'; sexos[2] := 'm' end;
			OpcionIyF: begin sexos[1] := 'i'; sexos[2] := 'f' end;
			OpcionTodos: begin sexos[1] := 'm'; sexos[2] := 'f';  sexos[3] := 'i' end	
		end;	
	ArraySexos := sexos
end;

//Autor: Nicolas Keklikian
//Verdadero si hay al menos un interes en comun, falso de otro modo.
function chequearIntereses(Var interesesA, interesesB : tvIntereses) : boolean;
Var coincide : boolean; interes,j : byte;
begin
coincide := False;
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

//Autor: Nicolas Keklikian
//Verdadero si el sexo buscado se encuentra en el vector. Falso de otro modo.
function coincideSexo(var sexos:tArraySexo; sexoBuscado : tSexo) : boolean ;
Var j : byte; encontrado : boolean;
begin
	encontrado := False;
	j := M;
	while (j<= I) and (not encontrado) do
		begin
		if sexos[j] = sexoBuscado then
			encontrado := True;
		j := j+1
		end;	
	coincideSexo := encontrado
end;

//Autor: Nicolas Keklikian
procedure verLosSiguientesCinco();
begin
	writeln('Enter para ver los siguientes 5');
	readln;
	clrscr
end;

//Autor: Nicolas Keklikian
//Imprime los usuarios que tienen el sexo deseado y al menos un interes
//en comun con el usuario actual. Los guarda en UsuariosValidos.
//maximo es la posicion en el vector del ultimo usuario guardado.
procedure buscarPorSexo(opcion:tOpcion; maxIdxUsuarios:byte; Var aUsuarios : taUsuarios; usuarioActual : trUsuario ; Var maximo:byte ; Var usuariosValidos:tArrayUsuarios);
Var j, k:byte; sexos:tArraySexo; rUsuario : trUsuario;
begin
AbrirArchivoUsuarios(aUsuarios, RutaUsuarios);
clrscr;
k := 0;
sexos := ArraySexos(opcion);
publicarOpcion(OpcionVolver, 'Volver');
writeln;
for j := 0 to maxIdxUsuarios do
	begin
	read(aUsuarios, rUsuario);
	if coincideSexo(sexos, rUsuario.Sexo) then
		begin
		if chequearIntereses(rUsuario.intereses, usuarioActual.intereses) then
			begin
			inc(k);
			publicarOpcion(k,rUsuario.nickname);
			writeln('Edad: ', calcularEdad(rUsuario.fecha));
			writeln('Ciudad: ', rUsuario.Ciudad);
			writeln;
			usuariosValidos[k] := j;
			if k mod 5 = 0 then
				verLosSiguientesCinco
			end
		end
	end;
maximo := k;
close(aUsuarios)
end;

//Autor: Nicolas Keklikian
//Imprime los usuarios que estan a la distancia deseada del usuario actual.
//Los guarda en UsuariosValidos.
//maximo es la posicion en el vector del ultimo usuario guardado.
procedure buscarPorDistancia(minDistancia, maxDistancia : real; ubicacion : tUbicacion; Var aUsuarios:taUsuarios; Var usuariosValidos:tArrayUsuarios; maxIdxUsuarios : byte; Var maximo : byte);
Var cont, j : byte; distanciaActual : real; rUsuario : trUsuario;
begin
	publicarOpcion(OpcionVolver, 'Volver');
	writeln;
	AbrirArchivoUsuarios(aUsuarios, RutaUsuarios);
	j := 0;
	for cont := 0 to maxIdxUsuarios do
		begin
		read(aUsuarios, rUsuario);
		distanciaActual := Distancia(ubicacion.latitud, ubicacion.longitud, rUsuario.ubicacion.latitud, rUsuario.ubicacion.longitud);
		if (distanciaActual >= minDistancia) and (distanciaActual <= maxDistancia) then
			begin
			inc(j);
			writeln(j, '. ', rUsuario.nickname);
			writeln('Edad: ', calcularEdad(rUsuario.fecha));
			writeln('Sexo: ', rUsuario.sexo);
			writeln;
			usuariosValidos[j] := cont;
			if (j mod 5 = 0) then
				verLosSiguientesCinco
			end
		end;
	maximo := j;
	close(aUsuarios)
end;

//Autor: Nicolas Keklikian
procedure pantallaPorInteres;
	begin
	cabecerapantalla('Conocer por intereses/sexo');
	publicarOpcion(OpcionVolver, 'Volver');
	writeln();
	publicarOpcion(OpcionMasc, 'Solamente sexo masculino');
	publicarOpcion(OpcionFem, 'Solamente sexo femenino');
	publicarOpcion(OpcionIndef, 'Solamente sexo indefinido');
	publicarOpcion(OpcionMyF, 'Sexo masculino o femenino');
	publicarOpcion(OpcionIyM, 'Sexo masculino o indefinido');
	publicarOpcion(OpcionIyF, 'Sexo femenino o indefinido');
	publicarOpcion(OpcionTodos, 'Cualquier sexo')
	end;
	
//Autor: Nicolas Keklikian	
procedure pantallaConocerGente;
	begin
	cabeceraPantalla('Conocer gente');
	publicarOpcion(OpcionVolver, 'Volver');
	writeln();
	publicarOpcion(OpcionIntereses, 'Por intereses/sexo');
	publicarOpcion(OpcionDistancia, 'Por distancia')
	end;

//Autor: Nicolas Keklikian
procedure pantallaPorDistancia;
	begin
	cabeceraPantalla('Conocer gente por distancia');
	publicarOpcion(OpcionVolver, 'Volver');
	writeln();
	publicarOpcion(OpcionMenorAUno, 'Menor a un km');
	publicarOpcion(OpcionEntreUnoYDiez, 'Entre uno y diez km');
	publicarOpcion(OpcionEntreDiezYTreinta, 'Entre diez y treinta km')
	end;

//Autor: Nicolas Keklikian	
procedure pantallaVerPensOAgregarAFav;
begin
	cabeceraPantalla('�Que desea hacer?');
	publicarOpcion(OpcionVolver, 'Volver');
	writeln();
	publicarOpcion(OpcionVerPens, 'Ver el ultimo pensamiento');
	publicarOpcion(OpcionAgregarAFav, 'Agregar a favoritos')
end;
	
//Autor: Nicolas Keklikian
//Pregunta si desea ver el ultimo pensamiento del usuario o
//agregarlo a favoritos.
procedure verPensOAgregarAFav(var aUsuarios:taUsuarios; var aPens:taPens; var aResp:taResp; IDUsuario,IDUsuarioActual:tIDUsuario; maxIdxUsuarios:tIDUsuario; var aFavoritos:taFavoritos; var IdxNick,IdxMail:tUsuariosIdx);
Var error : tError; opcion : tOpcion;
begin
	repeat
		pantallaVerPensOAgregarAFav;
		ingresarOpcion(opcion, MinOpcion, MaxOpcionPoAF, error);
	until (error = 0);
	case opcion of
		OpcionVolver : conocerGente(maxIdxUsuarios, aUsuarios, IDUsuarioActual, aPens, aResp, aFavoritos, IdxNick, IdxMail);
		OpcionVerPens : UltimoPens(aUsuarios, aPens, aResp, IDUsuario, IDUsuarioActual, VolverABusqueda, maxIDxUsuarios, aFavoritos, IDxNick,IDxMail);
		OpcionAgregarAFav : AgregarFavoritosxID(IDUsuarioActual, aFavoritos, IDUsuario, aUsuarios, maxIdxUsuarios, aPens, aResp, IdxNick, IdxMail)
	end
end;
	
//Autor: Nicolas Keklikian
//Pregunta que usuario desea ver.
//Valida que la opcion elegida sea valida.
procedure seleccionarUsuario(var usuariosValidos:tArrayUsuarios; maximo:integer; var aUsuarios:taUsuarios; var aPens:taPens; var aResp:taResp; IDUsuarioActual:tIDUsuario; var maxIdxUsuarios:tIDUsuario; var aFavoritos:taFavoritos; var IdxNick,IdxMail:tUsuariosIdx);
Var opcion:tOpcion; posX, posY : tcrtcoord; error : tError; IDUsuario : tIDUsuario;
begin
	posX := WhereX;
	posY := WhereY;
	repeat
		ingresarOpcion(opcion, MinOpcion, maximo, error);
		GoToXY(posX, posY);
		clrEol;
	until (error = 0);
	IDUsuario := usuariosValidos[opcion];
	if opcion <> 0 then
		verPensOAgregarAFav(aUsuarios, aPens, aResp, IDUsuario, IDUsuarioActual, maxIdxUsuarios, aFavoritos, IdxNick, IdxMail)
	else
		conocerGente(maxIdxUsuarios, aUsuarios, IDUsuarioActual, aPens, aResp, aFavoritos, IdxNick, IdxMail)
end;
	
//Autor: Nicolas Keklikian
//Pregunta a que distancia quiere encontrar usuarios.
procedure conocerPorDistancia(var maxIdxUsuarios:tIDUsuario; rUsuario:trUsuario; Var aUsuarios: taUsuarios; var aPens:taPens; var aResp:taResp; var aFavoritos:taFavoritos; var IdxNick,IdxMail:tUsuariosIdx);
Var opcion:tOpcion; usuariosValidos:tArrayUsuarios; error : tError; maximo : byte;
begin
	repeat
        pantallaPorDistancia;
        ingresarOpcion(opcion, MinOpcion, MaxOpcionPorDistancia, error)
    until (error = 0);
	clrscr;
    case opcion of
        OpcionVolver: conocerGente(maxIdxUsuarios, aUsuarios, rUsuario.ID, aPens, aResp, aFavoritos, IdxNick, IdxMail);
		OpcionMenorAUno : buscarPorDistancia(0, 1, rUsuario.ubicacion, aUsuarios, usuariosValidos, maxIdxUsuarios, maximo);
		OpcionEntreUnoYDiez : buscarPorDistancia(1, 10, rUsuario.ubicacion, aUsuarios, usuariosValidos, maxIdxUsuarios, maximo);
		OpcionEntreDiezYTreinta: buscarPorDistancia(10, 30, rUsuario.ubicacion, aUsuarios, usuariosValidos, maxIdxUsuarios, maximo)
    end;	
    if maximo > 0 then
		seleccionarUsuario(usuariosValidos, maximo, aUsuarios, aPens, aResp, rUsuario.ID, maxIdxUsuarios, aFavoritos, IdxNick, IdxMail)
	else
		begin
		clrscr ;
		writeln(ErrNoHayUsuarios);
		readln;
		conocerGente(maxIdxUsuarios, aUsuarios, rUsuario.ID, aPens, aResp, aFavoritos, IdxNick, IdxMail)
		end
 end;

//Autor: Nicolas Keklikian
//Pregunta de que sexos quiere encontrar usuarios.
procedure conocerPorInteres(var maxIdxUsuarios:tIDUsuario; rUsuario:trUsuario; Var aUsuarios:taUsuarios; var aPens:taPens; var aResp:taResp; var aFavoritos:taFavoritos; var IdxNick,IdxMail:tUsuariosIdx);
Var opcion:topcion; error : tError; maximo : byte; usuariosValidos:tArrayUsuarios;
begin
	repeat
        pantallaPorInteres;
        ingresarOpcion(opcion, MinOpcion, MaxOpcionPorInteres, error);
    until (error = 0);
    case opcion of
        OpcionVolver: conocerGente(maxIdxUsuarios, aUsuarios, rUsuario.ID, aPens, aResp, aFavoritos, IdxNick, IdxMail);
    else
		buscarPorSexo(opcion, maxIdxUsuarios, aUsuarios, rUsuario, maximo, usuariosValidos)
    end;
    seleccionarUsuario(usuariosValidos, maximo, aUsuarios, aPens, aResp, rUsuario.ID, maxIdxUsuarios, aFavoritos, IdxNick, IdxMail)
 end;

//Autor: Nicolas Keklikian
//Pregunta si desea conocer gente por intereses o por distancia.
procedure conocerGente(var maxIdxUsuarios:tIDUsuario; Var aUsuarios : taUsuarios; IDUsuario:tIDUsuario; var aPens:taPens; var aResp:taResp; var aFavoritos:taFavoritos; var IdxNick,IdxMail:tUsuariosIdx);
Var opcion:topcion; error :tError; rUsuario : trUsuario;
begin
	abrirArchivoUsuarios(aUsuarios, RutaUsuarios);
	seek(aUsuarios, IDUsuario);
	read(aUsuarios, rUsuario);
	close(aUsuarios);
	repeat
        pantallaConocerGente;
        ingresarOpcion(opcion, MinOpcion, MaxOpcionConocerG, error)
    until (error = 0);

    case opcion of
        OpcionVolver: MenuPrincipal(aUsuarios, aPens, aResp, aFavoritos, IdxNick, IdxMail, maxIdxUsuarios, IDUsuario);
        OpcionIntereses: conocerPorInteres(maxIdxUsuarios, rUsuario, aUsuarios, aPens, aResp, aFavoritos, IdxNick, IdxMail);
        OpcionDistancia: conocerPorDistancia(maxIdxUsuarios, rUsuario, aUsuarios, aPens, aResp, aFavoritos, IdxNick, IdxMail)
    end
 end;

{FIN PROCEDIMIENTOS DE NICOLAS}


{PROCEDIMIENTOS DE GASTON}

//Autor: Gaston Snaider
//Inicializa el vector de ultimos pensamientos de un usuario con un valor predeterminado.
//Pos-Cond: Todos los campos del vector de ultimos pensamientos quedar�n seteados con un ID invalido que no pertenece a pensamietos.dat
procedure InicializarVUltimosPens(var vUltimosPens:tvUltimosPens);
var
    i:integer;
begin
    for i := MinUltimosPens to MaxUltimosPens do
        vUltimosPens[i] := FinUltimosPens
end;

//Autor: Gaston Snaider
//Comprueba si un mensaje est� en blanco.
//Pos-Cond: devuelve true si el mensaje est� en blanco, y false si no.
function CheckearBlanco(var mensaje:tmensaje):boolean;
begin
    if (length(mensaje)) = 0 then
        CheckearBlanco := true
    else
        CheckearBlanco := false
end;

//Autor: Gaston Snaider
//Devuelve el nickname de un usuario.
//Pre-Cond: ID debe ser un ID v�lido dentro de usuarios.dat.
//Pos-Cond: Devuelve el nickname asociado al ID.
function ObtenerNick(ID:tIDUsuario; var IdxNick:tUsuariosIdx; var maxIdxUsuarios:tIDusuario):tnickname;
var
    enc:boolean;
    i: tIDusuario;
begin
	i:=MinUsuario;
	enc:=false;
    while (i>=MinUsuario) and (i<=maxIdxUsuarios) and not enc do
		if (ID = IdxNick[i].ID) then
		begin
			obtenerNick:= IdxNIck[i].cadena;
			enc:= true
		end
		else
			inc(i)
end;

//Autor: Gaston Snaider
//Muestra la pantalla Mis Pensamientos.
//Pos-Cond: Limpia la pantalla. Muestra la pantalla Mis Pensamietos, con su t�tulo y sus opciones.
procedure pantallaMisPens;
begin
    cabeceraPantalla('Mis pensamientos');
    publicarOpcion(OpcionVolver,'Volver');
    writeln();
    publicarOpcion(OpcionPublicarPens,'Publicar un pensamiento libre');
    publicarOpcion(OpcionListaPens,'Ver listado de sus ultimos pensamientos')
end;

//Autor: Gaston Snaider
//Muestra la pantalla Publicar un pensamieto libre.
//Pos-Cond: Limpia la pantalla. Muestra la pantalla Publicar un pensamieto libre, con su t�tulo y sus opciones.
procedure pantallaPublicarPens;
begin
    cabeceraPantalla('Publicar un pensamiento libre');
    writeln(MsjCantCarac1);
    writeln(MsjCantCarac2);
    writeln;
    write('Ingrese pensamiento: ')
end;

//Autor: Gaston Snaider
//Muestra la pantalla de ultimos Pensamientos.
//Pos-Cond: Limpia la pantalla. Muestra el titulo de la pantalla Listado de �ltimos pensamientos, y la opci�n Volver.
//          No muestra la lista de pensamientos.
procedure pantallaListaPens;
begin
    cabeceraPantalla('Listado de ultimos pensamientos');
    publicarOpcion(OpcionVolver,'Volver')
end;

//Autor: Gaston Snaider
//Muestra la pantalla del detalle de pensamiento.
//Pos-Cond: Limpia la pantalla. Muestra el titulo de la pantalla Detalle de pensamiento.
procedure pantallaDetallePens;
begin
    cabeceraPantalla('Detalle de pensamiento')
end;

//Autor: Gaston Snaider
//Muestra la Pantalla para ingresar una respuesta a un pensamiento
//Pos-Cond: Limpia la pantalla. Muestra la pantalla para responder a pensamieto libre, con su t�tulo y sus opciones.
procedure pantallaResponder;
begin
    cabeceraPantalla('Responder');
    writeln(MsjCantCarac1);
    writeln(MsjCantCarac2);
    writeln;
    write('Ingrese respuesta: ')
end;

//Autor: Gaston Snaider
//Pantalla de confirmacion de un voto
procedure pantallaVoto;
begin
    cabeceraPantalla('Votacion');
    writeln('Su voto fue procesado.');
    writeln(MsjTeclaCualquiera);
    readkey
end;



//Autor: Gaston Snaider
//Escribe en pantalla la fechaHora en el formato "tiempo despues"
//Pos-Cond: Escribe un texto en pantalla mostrando la fechaHora en formato "tiempo despues"
procedure MostrarTiempoDespResp(fechaHora:tDateTime);
var
    strHora:tStrHora;
    posicion:integer;
    dias,horas,minutos,segundos,error : byte;
begin

    dias := trunc(fechaHora);

    strHora := formatDateTime(formatoHora,fechaHora);

    posicion := pos(SeparadorHora,strHora);
    val(copy(strHora,1,posicion - 1),horas,error);
    delete(strHora,1,posicion);

    posicion := pos(SeparadorHora,strHora);
    val(copy(strHora,1,posicion - 1),minutos,error);
    delete(strHora,1,posicion);

    val(strHora,segundos,error);

    writeln(IntToStr(dias) + ' dias, ' + IntToStr(horas) + ' horas, ' + IntToStr(minutos) + ' minutos, ' + IntToStr(segundos) + ' segundos despues')
end;

//Autor: Gaston Snaider
//Guarda la respuesta en respuestas.dat
//Pre-Cond: IDPens = ID del pensamiento al que responde.
//          IDUsuario = ID del usuario que responde.
//          fechaHoraPens = fechaHora del pensamiento al que responde.
//Pos-Cond: Escribe un nuevo registro en respuestas.dat, con todos los datos ingresados.
//          El tiempoDesp de la respuesta se guarda como "Fecha actual - fechaHoraPens".
procedure GuardarResp(var aResp:taResp; IDPens:tIDPens; IDUsuario:tIDUsuario; var respuesta:tmensaje; fechaHoraPens:tDateTime);
var
    rResp:trResp;
begin
    rResp.IDPens := IDPens;
    rResp.IDUsuario := IDUsuario;
    rResp.mensaje := respuesta;
    rResp.tiempoDesp := (Now - fechaHoraPens);

    reset(aResp);
    seek(aResp,filesize(aResp));
    write(aResp,rResp);
    close(aResp)
end;

//Autor: Gaston Snaider
//Procedimiento para Responder a un pensamiento.
//Pre-Cond: IDPens = ID del pensamiento al que se responde.
//          IDUsuarioActual = ID del usuario logueado.
//          fechaHoraPens = fechaHora del pensamiento al que se responde.
//Pos-Cond: Guarda la respuesta en respuestas.dat. (para mas info ver procedimiento GuardarResp)
//          Si la repsuesta est� en blanco, se muestra un mensaje de error y se recarga la pantalla.
procedure Responder(var aUsuarios:taUsuarios; var aPens:taPens; var aResp:taResp; IDPens:tIDPens; IDUsuarioActual:tIDUsuario; fechaHoraPens:tDateTime; volver:tvolver; maxIDxUsuarios: tIDUsuario; var aFavoritos:taFavoritos; var IDxNick,IDxMail:tUsuariosIdx
);
var
    respuesta:tmensaje;
    blanco:boolean;
begin
    repeat
    pantallaResponder;
    readln(respuesta);
    blanco := CheckearBlanco(respuesta);
    if blanco then
        MostrarMensajeError(MsjBlanco);
    until not blanco;
    GuardarResp(aResp,IDPens,IDUsuarioActual,respuesta,fechaHoraPens);
    DetallePens(aUsuarios,aPens,aResp,IDPens,IDUsuarioActual,volver, maxIdxUsuarios,aFavoritos, IdxNick, IdxMail)
end;


//Autor: Gaston Snaider
//Guarda el voto a un pensamiento en pensamientos.dat
//Pre-Cond: IDPens = ID del pensamiento al que se vota. Debe existir en pensamientos.dat
//          Voto = boolean que determina el tipo de voto (positivo o negativo)
//Pos-Cond: Modifica el contador de votos del pensamiento en pensamientos.dat.
procedure GuardarVoto(var aPens:taPens; IDPens:tIDPens; Voto:tVoto);
var
    rPens:trPens;
begin
    reset(aPens);
    seek(aPens,IDPens);
    read(aPens,rPens);
    if (voto = VotoPos) then
        inc(rPens.votosPos)
    else
        inc(rPens.votosNeg);
    seek(aPens,IDPens);
    write(aPens,rPens);
    close(aPens)
end;

//Autor: Gaston Snaider
//Descripci�n: M�dulo para votar un pensamiento
//Pre-Cond: IDUsuarioActual = ID del usuario logueado.
//          IDPens = ID del pensamiento al que se vota.
//          voto = boolean que determina el tipo de voto (true = positivo, false = negativo)
//Pos-Cond: Guarda el voto en pensamientos.dat
//          Muestra un mensaje de confirmaci�n del voto.
//          Vuelve al m�dulo de detalle de pensamiento
procedure Votar(var aUsuarios:taUsuarios; var aPens:taPens; var aResp:taResp; IDUsuarioActual:tIDUsuario; IDPens:tIDPens; voto:tVoto; volver:tvolver; maxIDxUsuarios: tIDUsuario; var aFavoritos:taFavoritos; var IDxNick,IDxMail:tUsuariosIdx);
begin
    GuardarVoto(aPens,IDPens,voto);
    pantallaVoto;
    DetallePens(aUsuarios,aPens,aResp,IDPens,IDUsuarioActual,volver, maxIdxUsuarios,aFavoritos, IdxNick, IdxMail)
end;

//Autor: Gaston Snaider
//Descripci�n: Muestra una respuesta.
//Pre-Cond: tiempoDesp = tiempoDesp de la respuesta.
//          IDUsuario = IDUsuario de la respuesta.
//          mensaje = mensaje de la respuesta.
//Pos-Cond: Muestra en pantalla el mensaje de la respuesta, indicando el "tiempo despues" en que fue publicada, y el usuario que la public�.
procedure MostrarRespuesta(var IdxNIck:tUsuariosIdx; maxIdxUsuarios:tIDusuario; tiempoDesp:tDateTime; IDUsuario:tIDUsuario; var mensaje:tmensaje);
begin
    MostrarTiempoDespResp(tiempoDesp);
    writeln('Usuario ',ObtenerNick(IDUsuario,IdxNIck,maxIdxUsuarios),' respondio:');
    writeln(mensaje);
    writeln
end;

//Autor: Gaston Snaider
//Descripci�n: Muestra las respuestas de un pensamiento.
//Pre-Cond: IDPens = ID del pensamiento al cual se le quieren ver las respuestas.
//Pos-Cond: Muestra en pantalla todas las respuestas del pensamiento asociado al IDPens.
procedure MostrarRespuestas(var IdxNIck:tUsuariosIdx; maxIdxUsuarios:tIDusuario;  var aResp:taResp; IDPens:tIDPens);
var
    rResp:trResp;
begin
    writeln('Respuestas: ');
    writeln;
    reset(aResp);
    while (not eof(aResp)) do
    begin
        read(aResp,rResp);
        if (rResp.IDPens = IDPens) then
            MostrarRespuesta(IdxNIck,maxIdxUsuarios, rResp.tiempoDesp, rResp.IDUsuario, rResp.mensaje)
    end;
    close(aResp)
end;

//Autor: Gaston Snaider
//Descripci�n: Muestra el mensaje de un pensamiento.
//Pre-Cond: fechaHora = fechaHora del pensamiento.
//          mensaje = mensaje del pensamiento.
//Pos-Cond: Muestra en pantalla el mensaje del pensamiento y su fecha/hora de publicacion.
procedure MostrarPensamiento(fechaHora:tDateTime; var mensaje:tmensaje);
begin
    writeln('Fecha y Hora: ',formatDateTime(formatoFechaHora,fechaHora));
    writeln('Pensamiento: ',mensaje);
    writeln
end;

//Autor: Gaston Snaider
//Descripci�n: Muestra la puntuacion de un pensamiento.
//Pre-Cond: votosPos/votosNeg = cantidad de votos positivos/negativos del pensamiento.
//Pos-Cond: Muestra en pantalla la puntuacion del pensamiento.
procedure MostrarPuntuacion(votosPos,votosNeg:tVotos);
begin
    writeln('Puntuacion:');
    writeln('Positivas: ',votosPos);
    writeln('Negativas: ',votosNeg);
    writeln
end;


//Autor: Gaston Snaider     //AGREGAR PARAMETROS DE BUSQUEDAS PARA VOLVER. DIFERENCIAR TIPOS DE BUSQUEDA/FAVORITOS?
//Descripci�n: Muestra los detalles de un pensamiento, y las opciones correspondientes.
//Pre-Cond: IDPens = ID del pensamiento al que se le quieren ver los detalles.
//          IDUsuarioActual = ID del usuario logueado.
//          Volver = booleano que determina a que patalla volver.
//Pos-Cond: Muestra en pantalla el pensamiento, sus puntuaciones, sus respuestas, y las opciones correspondientes.
//          Si volver = 1: vuelve a la lista de pensamientos del usuario actual.
//          Si volver = 2: vuelve a la busqueda de la cual se haya llamado al m�dulo.
//          Si volver = 3: vuelve a la pantalla de favoritos de la cual se llam� al m�dulo.
procedure DetallePens(var aUsuarios:taUsuarios; var aPens:taPens; var aResp:taResp; IDPens:tIDPens; IDUsuarioActual:tIDUsuario; volver:tvolver; maxIdxUsuarios:tIDUsuario; var aFavoritos:taFavoritos; var IdxNick,IdxMail:tUsuariosIdx);
var
    rPens:trPens;
    opcion:topcion;
    error:terror;

begin
    reset(aPens);
    seek(aPens,IDPens);
    read(aPens,rPens);
    close(aPens);

    repeat
        pantallaDetallePens;
        MostrarPensamiento(rPens.fechaHora,rPens.mensaje);
        MostrarPuntuacion(rPens.votosPos,rPens.votosNeg);
        MostrarRespuestas(IdxNIck,maxIdxUsuarios, aResp, IDPens);
        publicarOpcion(OpcionVolver,'Volver');
        publicarOpcion(OpcionResponder,'Responder');
        publicarOpcion(OpcionVotarPos,'Votar Positivo');
        publicarOpcion(OpcionVotarNeg,'Votar Negativo');
        IngresarOpcion(opcion, MinOpcion, MaxOpcionDetallePens, error);
    until (error = 0);

    case opcion of
        OpcionVolver:
				case volver of
                    VolverALista: ListaPens(aUsuarios,aPens,aResp,IDUsuarioActual, maxIDxUsuarios, aFavoritos, IDxNick, IDxMail);
				    VolverABusqueda: conocerGente(maxIdxUsuarios, aUsuarios, IDUsuarioActual, aPens, aResp, aFavoritos, IdxNick, IdxMail);
					VolverAFavoritos: MostrarFavoritos(IDUsuarioActual, aFavoritos, aUsuarios, aPens, aResp, IdxNick, IdxMail, maxIdxUsuarios)
                end;
        OpcionResponder: Responder(aUsuarios,aPens,aResp,IDPens,IDUsuarioActual,rPens.fechaHora,volver, maxIDxUsuarios, aFavoritos, IDxNick, IDxMail);
        OpcionVotarPos: Votar(aUsuarios,aPens,aResp,IDUsuarioActual,IDPens,VotoPos,volver, maxIDxUsuarios, aFavoritos, IDxNick, IDxMail);
        OpcionVotarNeg: Votar(aUsuarios,aPens,aResp,IDUsuarioActual,IDPens,VotoNeg,volver, maxIDxUsuarios, aFavoritos, IDxNick, IDxMail)
    end
end;

//Autor: Gaston Snaider
//Muestra el detalle del �ltimo pensamiento de un usuario
//Pre-Cond: IDUusuario = ID del usuario al cual se le quiere ver el pensamiento.
//          IDUsuarioActual = ID del usuario logueado.
//          Volver = Variable que determina a que pantalla volver.
//Pos-Cond: Redirige al m�dulo Detalle de pensamiento, del �ltimo pensamiento del usuario asociado a IDUsuario.
procedure UltimoPens(var aUsuarios:taUsuarios; var aPens:taPens; var aResp:taResp; IDUsuario,IDUsuarioActual:tIDUsuario; volver:tvolver;  maxIDxUsuarios: tIDUsuario; var aFavoritos:taFavoritos; var IDxNick,IDxMail:tUsuariosIdx);
var
    rUsuario:trUsuario;
begin
    reset(aUsuarios);
    seek(aUsuarios,IDUsuario);
    read(aUsuarios,rUsuario);
    close(aUsuarios);
    if rUsuario.vUltimosPens[MinUltimosPens] <> -1 then
		DetallePens(aUsuarios,aPens,aResp,rUsuario.vUltimosPens[MinUltimosPens],IDUsuarioActual,volver, maxIdxUsuarios,aFavoritos, IdxNick, IdxMail)
	else
		begin
		    MostrarMensajeError(ErrNoPens);
            case volver of
		        VolverABusqueda: conocerGente(maxIdxUsuarios, aUsuarios, IDUsuarioActual, aPens, aResp, aFavoritos, IdxNick, IdxMail);
                VolverAFavoritos: MostrarFavoritos(IDUsuarioActual, aFavoritos, aUsuarios, aPens, aResp, IdxNick, IdxMail, maxIdxUsuarios)
            end
        end
end;

//Autor: Gaston Snaider
//Descripci�n: Muestra la lista de ultimos pensamientos del usuario logueado.
//Pos-Cond: Muestra la lista de ultimos pensamientos, y devuelve la cantidad de pensamientos mostrados en cantPens.
procedure MostrarListaPens(var aPens:taPens; var vUltimosPens:tvUltimosPens; var cantPens:topcion);
var
    i:integer;
    rPens:trPens;
begin
    i := MinUltimosPens;
    while (i <= MaxUltimosPens) and (vUltimosPens[i] <> FinUltimosPens) do
    begin
        reset(aPens);
        seek(aPens,vUltimosPens[i]);
        read(aPens,rPens);
        publicarOpcion(i,rPens.mensaje);
        close(aPens);
        inc(i)
    end;
    cantPens := (i-1)
end;


//Autor: Gaston Snaider
//Descripci�n: M�dulo de la Lista de �ltimos pensamientos.
//Pre-Cond: IDUsuarioActual = ID del usuario logueado. De este usuario se van a cargar los pensamientos.
//Pos-Cond: Muestra la pantalla de toda la lista de pensamientos, con la posibilidad de elegir alguno para ver sus detalles.
procedure ListaPens(var aUsuarios:taUsuarios; var aPens:taPens; var aResp:taResp; IDUsuarioActual:tIDUsuario;  maxIDxUsuarios: tIDUsuario; var aFavoritos:taFavoritos; var IDxNick,IDxMail:tUsuariosIdx);
var
    rUsuario : trUsuario;
    opcion,cantPens:topcion;
    error:terror;
begin
    reset(aUsuarios);
    seek(aUsuarios,IDUsuarioActual);
    read(aUsuarios,rUsuario);
    close(aUsuarios);

    repeat
        pantallaListaPens;
        MostrarListaPens(aPens,rUsuario.vUltimosPens,cantPens);
        IngresarOpcion(opcion, MinOpcion, cantPens, error);
    until (error = 0);

    case opcion of
        OpcionVolver: MisPensamientos(aUsuarios,aPens,aResp,IDUsuarioActual, maxIDxUsuarios, aFavoritos, IDxNick, IDxMail);
        MinUltimosPens..MaxUltimosPens: DetallePens(aUsuarios,aPens,aResp,rUsuario.vUltimosPens[opcion],IDUsuarioActual,VolverALista, maxIdxUsuarios,aFavoritos, IdxNick, IdxMail)
    end
end;

//Autor: Gaston Snaider
//Descripcion: Guardar el pensamiento en pensamientos.dat
//Pre-Cond: IDUsuario = ID del usuario que public� el pensamiento.
//          mensaje = mensaje del pensamiento que se guarda.
//Pos-Cond: Guarda el pensamiento en pensamientos.dat, con la fecha actual.
//          Devuelve el IDPens.
procedure guardarPensArchPens(var aPens:taPens; IDUsuario:tIDUsuario; var mensaje:tmensaje; var IDPens:tIDPens);
var
    rPens : trPens;
begin
    reset(aPens);
    rPens.IDPens := fileSize(aPens);
    IDPens := rPens.IDPens;
    rPens.IDUsuario := IDusuario;
    rPens.mensaje := mensaje;
    rPens.votosPos := DefaultVotosPos;
    rPens.votosNeg := DefaultVotosNeg;
    rPens.fechaHora := Now;
    seek(aPens,fileSize(aPens));
    write(aPens,rPens);
    close(aPens)
end;

//Autor: Gaston Snaider
//Descripcion: Guardar el IDPens en el vector de ultimos pensamientos.
//Pre-Cond: IDPens = ID del pensamiento que se guarda.
//Pos-Cond: Guarda el IDPens en la primer posicion del vUltimosPens.
//          Corre un lugar los demas pensamientos del vector.
procedure InsertarPensVUltPens(var vUltimosPens:tvUltimosPens; IDPens:tIDPens);
var
    i : integer;
begin

        for i := MaxUltimosPens  downto MinUltimosPens + 1 do
            vUltimosPens[i] := vUltimosPens[i - 1];
        vUltimosPens[MinUltimosPens] := IDPens
end;

//Autor: Gaston Snaider
//Descripcion: Guardar el IDPens en usuarios.dat.
//Pre-Cond: IDPens = ID del pensamiento que se guarda.
//          IDUsuario = ID del usuario que public� el pensamiento.
//Pos-Cond: Guarda el IDPens en el vector de ultimos pensamientos del usuario, dentro de usuarios.dat.
procedure guardarPensArchUsuarios(var aUsuarios:taUsuarios; IDusuario:tIDUsuario; IDPens:tIDPens);
var
    rUsuario:trUsuario;
begin
    reset(aUsuarios);
    seek(aUsuarios,IDusuario);
    read(aUsuarios,rUsuario);
    InsertarPensVUltPens(rUsuario.vUltimosPens,IDPens);
    seek(aUsuarios,IDUsuario);
    write(aUsuarios,rUsuario);
    close(aUsuarios)
end;

//Autor: Gaston Snaider
//Desrcipci�n: M�dulo para publicar un pensamiento.
//Pre-Cond: IDUsuarioActual = ID del usuario logueado.
//Pos-Cond: Permite al usuario ingresar un pensamiento.
//          Verifica que no sea blanco.
//          Guarda el pensamiento en archivos correspondientes.
//          Vuelve a la m�dulo Mis Pensamientos.
procedure publicarPens(var aUsuarios:taUsuarios; var aPens:taPens; var aResp:taResp; IDUsuarioActual:tIDUsuario; maxIDxUsuarios: tIDUsuario; var aFavoritos:taFavoritos; var IDxNick,IDxMail:tUsuariosIdx);
var
    mensaje:tmensaje;
    IDPens:tIDPens;
    blanco:boolean;
begin
    repeat
        pantallaPublicarPens;
        readln(mensaje);
        blanco := CheckearBlanco(mensaje);
        if blanco then
            MostrarMensajeError(MsjBlanco);
    until not blanco;

    guardarPensArchPens(aPens,IDUsuarioActual,mensaje,IDPens);
    guardarPensArchUsuarios(aUsuarios,IDUsuarioActual,IDPens);
    MisPensamientos(aUsuarios,aPens,aResp,IDUsuarioActual, maxIDxUsuarios, aFavoritos, IDxNick, IDxMail)
end;

//Autor: Gaston Snaider
//Descripci�n: M�dulo Mis Pensamientos.
//Pre-Cond: IDUsuarioActual = ID del usuario logueado.
//Pos-Cond: Muestra la pantalla del menu Mis Pensamientos, y redirige al m�dulo correspondiente a la opci�n elegida.
procedure MisPensamientos(var aUsuarios:taUsuarios; var aPens:taPens; var aResp:taResp; IDusuarioActual:tIDUsuario; maxIDxUsuarios: tIDUsuario; var aFavoritos:taFavoritos; var IDxNick,IDxMail:tUsuariosIdx);
var
    opcion:topcion;
    error:tError;
begin
    repeat
        pantallaMisPens;
        ingresarOpcion(opcion, MinOpcion, MaxOpcionMisPens, error)
    until (error = 0);

    case opcion of
        OpcionVolver: MenuPrincipal(aUsuarios, aPens, aResp, aFavoritos, IdxNick, IdxMail,  maxIdxUsuarios, IDUsuarioActual);
        OpcionPublicarPens: PublicarPens(aUsuarios,aPens,aResp,IDUsuarioActual, maxIDxUsuarios, aFavoritos, IDxNick, IDxMail);
        OpcionListaPens: ListaPens(aUsuarios,aPens,aResp,IDUsuarioActual, maxIDxUsuarios, aFavoritos, IDxNick, IDxMail)
    end
end;

//Autor: Gaston Snaider
//Descricpi�n: Abrir por primera vez el archivo pensamientos.dat
//Pre-Cond: ruta = ruta del archivo en el sistema.
//Pos-Cond: Intenta abrir el archivo y dejar el puntero en la primera posici�n.
//          Si el archivo no existe, lo crea y lo deja abierto con el puntero en la primera posici�n.
procedure abrirArchivoPens(var aPens:taPens;ruta:tRuta);
begin
        assign (aPens, ruta);
        {$I-}
        reset(aPens);
        {$I+}
        if (IOResult <> 0 ) then
            rewrite(aPens)//Si no existe lo crea
end;


//Autor: Gaston Snaider
//Descricpi�n: Abrir por primera vez el archivo respuestas.dat
//Pre-Cond: ruta = ruta del archivo en el sistema.
//Pos-Cond: Intenta abrir el archivo y dejar el puntero en la primera posici�n.
//          Si el archivo no existe, lo crea y lo deja abierto con el puntero en la primera posici�n.
procedure abrirArchivoResp(var aResp:taResp;ruta:tRuta);
begin
        assign (aResp, ruta);
        {$I-}
        reset(aResp);
        {$I+}
        if (IOResult <> 0 ) then
            rewrite(aResp)//Si no existe lo crea
end;

//Autor: Gaston Snaider
procedure InicializacionTesteo (var aUsuarios:taUsuarios; var IDUsuarioActual:tIDUsuario);
var
    rUsuario:trUsuario;
begin
    reset(aUsuarios);
    read(aUsuarios,rUsuario);
    IDUsuarioActual := rUsuario.ID;
    //InicializarVUltimosPens(rUsuario.vUltimosPens);
    close(aUsuarios)
end;

{FIN PROCEDIMIENTOS DE GASTON}

//Autor: Gaston Snaider
//Descripci�n: Modulo "Menu Principal".
//Pre-Cond: IDUsuarioActual = ID del usuario logueado.
//Pos-Cond: Muestra la pantalla del Menu Principal, y redirige al modulo correspondiente a la opcion elegida.
procedure MenuPrincipal(var aUsuarios:taUsuarios; var aPens:taPens; var aResp:taResp; var aFavoritos:taFavoritos; var IdxNick,IdxMail:tUsuariosIdx;var maxIdxUsuarios:tIDUsuario; IDUsuarioActual:tIDUsuario);
var
    opcion:topcion;
    error:tError;
begin
    repeat
        pantallaMenuPpal;
        ingresarOpcion(opcion, MinOpcion, MaxOpcionMenuPpal, error)
    until (error = 0);

    case opcion of
        OpcionVolver: Inicio(aUsuarios, aPens, aResp, aFavoritos, IdxNick, IdxMail, maxIdxUsuarios);
        OpcionMisPens: MisPensamientos(aUsuarios, aPens, aResp, IDUsuarioActual, maxIDxUsuarios, aFavoritos, IDxNick, IDxMail);
        OpcionBuscador: conocerGente(maxIdxUsuarios, aUsuarios, IDUsuarioActual, aPens, aResp, aFavoritos, IdxNick, IdxMail);
		OpcionFavoritos: MostrarFavoritos(IDUsuarioActual, aFavoritos, aUsuarios, aPens, aResp, IdxNick, IdxMail, maxIdxUsuarios)
    end
end;

procedure Inicio(var aUsuarios:taUsuarios; var aPens:taPens; var aResp:taResp; var aFavoritos:taFavoritos; var IdxNick,IdxMail:tUsuariosIdx; var maxIdxUsuarios:tIDUsuario);
Var opcion:tOpcion; error :tError; IDUsuarioActual:tIDUsuario;
begin
    repeat
        pantallaPrincipal;
        ingresarOpcion(opcion, MinOpcion, MaxOpcionPpal, error)
    until (error = 0);

    case opcion of
        OpcionRegistro: Registro(IdxNIck, IdxMail, maxIdxUsuarios, aUsuarios, IDUsuarioActual);
        OpcionLogin: Login(IdxNick, maxIdxUsuarios, aUsuarios, error, IDUsuarioActual)		
    end;
	
	if error = 23 then //cancela login
		Inicio(aUsuarios, aPens, aResp, aFavoritos, IdxNick, IdxMail, maxIdxUsuarios)
	else
		if opcion <> OpcionVolver then MenuPrincipal(aUsuarios, aPens, aResp, aFavoritos, IdxNick, IdxMail, maxIdxUsuarios, IDUsuarioActual)
end;

var
        aUsuarios:taUsuarios;
        IdxNick,IdxMail:tUsuariosIdx;
        maxIdxUsuarios:tIDusuario;
        aPens:taPens;
        aResp:taResp;
        aFavoritos : taFavoritos;
begin
        ClrScr;
        GenerarIndicesUsuarios(aUsuarios,RutaUsuarios,IdxNick,IdxMail,maxIdxUsuarios);   //el maximo logico se asigna dentro
        abrirArchivoPens(aPens,rutaPens);
		close(aPens);
		abrirArchivoResp(aResp,rutaResp);//Me aseguro de que exista el archivo cuando se abre el programa
		close(aResp);
		abrirArchivoPens(aPens,rutaPens); //Me aseguro de que exista el archivo cuando se abre el programa
		close(aPens);
        Inicio(aUsuarios, aPens, aResp, aFavoritos, IDxNick, IdxMail, maxIdxUsuarios)
end.
