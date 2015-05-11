program RedSocialMensajes;

uses
crt, usuarios, sysutils;

const

    //Rutas de archivos
    rutaPens = 'pensamientos.dat';
    rutaResp = 'respuestas.dat';
    rutaUsuarios = 'usuarios.dat';

    //Rangos de longitud de mensajes
    MinLongMens = 1;
    MaxLongMens = 255;              //NO LAS USO!


    //Cantidad de opciones por pantalla
    MaxOpcionMenuPrincipal = 3;
    MaxOpcionMisPens = 2;
    MaxOpcionDetallePens = 3;
    MaxOpcionFavoritos = 2;
    MaxOpcionObtenerUserID = 1;
    MinOpcion = 0;

    //Separador para mostrar las opciones
    SeparadorOpcion = '_';

    //Codigos de cada opcion por pantalla
    OpcionVolver = 0;
    OpcionPublicarPens = 1;
    OpcionListaPens = 2;
    OpcionResponder = 1;
    OpcionVotarPos = 2;
    OpcionVotarNeg = 3;

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

	//Valores para saber a donde volver desde el módulo DetallePens
    VolverALista = 1;
    VolverABusqueda = 2;
    VolverAFavoritos = 3;

    //Mensajes por pantalla
    MsjCantCarac1 = 'Recuerde que puede escribir como m ximo 255 caracteres.';
    MsjCantCarac2 = 'Cualquier mensaje mayor ser  truncado.';
    MsjBlanco = 'Debe ingresar al menos un caracter';


type

    //tipos para el rPens y rResp
    tIDPens = integer;
    tMensaje = string;
    tVotos = byte;
    trPens = record
        IDPens : tIDPens;
        IDUsuario : tIDUsuario;
        mensaje : tMensaje;
        votosPos : tVotos;
        votosNeg : tVotos;
        fechaHora : tDateTime;
    end;
    trResp = record
        IDPens : tIDPens;
        IDUsuario : tIDUsuario;
        mensaje : tmensaje;
        tiempoDesp : tDateTime;
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

	//Indice ordenado por IDPens para cargar las respuestas de un pensamiento especifico.
	trIdxResp = record
	PosArch : tRangoResp;
	IDPens : tIDPens
	end;

tIdxResp = array [tRangoResp] of trIdxResp;


procedure MisPensamientos(var aUsuarios:taUsuarios; var aPens:taPens; var aResp:taResp; IDusuarioActual:tIDUsuario); forward;

procedure publicarPens(var aUsuarios:taUsuarios; var aPens:taPens; var aResp:taResp; IDUsuarioActual:tIDUsuario); forward;

procedure ListaPens(var aUsuarios:taUsuarios; var aPens:taPens; var aResp:taResp; IDUsuarioActual:tIDUsuario); forward;

procedure DetallePens(var aUsuarios:taUsuarios; var aPens:taPens; var aResp:taResp; IDPens:tIDPens; IDUsuarioActual:tIDUsuario; volver:tvolver); forward;

procedure Votar(var aUsuarios:taUsuarios; var aPens:taPens; var aResp:taResp; IDUsuarioActual:tIDUsuario; IDPens:tIDPens; voto:tVoto; volver:tvolver); forward;

procedure Responder(var aUsuarios:taUsuarios; var aPens:taPens; var aResp:taResp; IDPens:tIDPens; IDUsuarioActual:tIDUsuario; fechaHoraPens:tDateTime; volver:tvolver); forward;

//Autor: Gaston Snaider
//Inicializa el vector de ultimos pensamientos de un usuario con un valor predeterminado.
//Pos-Cond: Todos los campos del vector de ultimos pensamientos quedar n seteados con un ID invalido que no pertenece a pensamietos.dat
procedure InicializarVUltimosPens(var vUltimosPens:tvUltimosPens);
var
    i:integer;
begin
    for i := MinUltimosPens to MaxUltimosPens do
        vUltimosPens[i] := FinUltimosPens
end;

//Autor: Gaston Snaider
//Comprueba si un mensaje est  en blanco.
//Pos-Cond: devuelve true si el mensaje est  en blanco, y false si no.
function CheckearBlanco(var mensaje:tmensaje):boolean;
begin
    if (length(mensaje)) = 0 then
        CheckearBlanco := true
    else
        CheckearBlanco := false
end;

//Autor: Gaston Snaider
//Devuelve el nickname de un usuario.
//Pre-Cond: ID debe ser un ID v lido dentro de usuarios.dat.
//Pos-Cond: Devuelve el nickname asociado al ID.
function ObtenerNick(ID:tIDUsuario;var aUsuarios:taUsuarios):tnickname;
var
    usuario : trUsuario;
begin
    reset(aUsuarios);
    seek(aUsuarios,ID);
    read(aUsuarios,usuario);
    ObtenerNick := usuario.nickname;
    close(aUsuarios);
end;

//Autor: Gaston Snaider
//Escribe el titulo de las pantallas
//Pos-Cond: Se elimina todo texto de la pantalla. Muestra el titulo en pantalla.
procedure cabeceraPantalla(titulo:string);
begin
    clrscr;
    writeln(titulo);
    writeln;
end;

//Autor: Gaston Snaider
//Muestra la pantalla Mis Pensamientos.
//Pos-Cond: Limpia la pantalla. Muestra la pantalla Mis Pensamietos, con su t¡tulo y sus opciones.
procedure pantallaMisPens;
begin
    cabeceraPantalla('Mis pensamientos');
    publicarOpcion(OpcionVolver,'Volver');
    publicarOpcion(OpcionPublicarPens,'Publicar un pensamiento libre');
    publicarOpcion(OpcionListaPens,'Ver listado de sus ultimos pensamientos');
end;

//Autor: Gaston Snaider
//Muestra la pantalla Publicar un pensamieto libre.
//Pos-Cond: Limpia la pantalla. Muestra la pantalla Publicar un pensamieto libre, con su t¡tulo y sus opciones.
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
//Pos-Cond: Limpia la pantalla. Muestra el titulo de la pantalla Listado de £ltimos pensamientos, y la opci¢n Volver.
//          No muestra la lista de pensamientos.
procedure pantallaListaPens;
begin
    cabeceraPantalla('Listado de ultimos pensamientos');
    publicarOpcion(OpcionVolver,'Volver');
end;

//Autor: Gaston Snaider
//Muestra la pantalla del detalle de pensamiento.
//Pos-Cond: Limpia la pantalla. Muestra el titulo de la pantalla Detalle de pensamiento.
procedure pantallaDetallePens;
begin
    cabeceraPantalla('Detalle de pensamiento');
end;

//Autor: Gaston Snaider
//Muestra la Pantalla para ingresar una respuesta a un pensamiento
//Pos-Cond: Limpia la pantalla. Muestra la pantalla para responder a pensamieto libre, con su t¡tulo y sus opciones.
procedure pantallaResponder;
begin
    cabeceraPantalla('Responder');
    writeln(MsjCantCarac1);
    writeln(MsjCantCarac2);
    writeln;
    write('Ingrese respuesta: ');
end;

//Autor: Gaston Snaider
//Pantalla de confirmacion de un voto
procedure pantallaVoto;
begin
    cabeceraPantalla('Votacion');
    writeln('Su voto fue procesado.');
    writeln(MsjTeclaCualquiera);
    readkey;
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

    writeln(IntToStr(dias) + ' dias, ' + IntToStr(horas) + ' horas, ' + IntToStr(minutos) + ' minutos, ' + IntToStr(segundos) + ' segundos despues');
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
    close(aResp);
end;

//Autor: Gaston Snaider
//Procedimiento para Responder a un pensamiento.
//Pre-Cond: IDPens = ID del pensamiento al que se responde.
//          IDUsuarioActual = ID del usuario logueado.
//          fechaHoraPens = fechaHora del pensamiento al que se responde.
//Pos-Cond: Guarda la respuesta en respuestas.dat. (para mas info ver procedimiento GuardarResp)
//          Si la repsuesta est  en blanco, se muestra un mensaje de error y se recarga la pantalla.
procedure Responder(var aUsuarios:taUsuarios; var aPens:taPens; var aResp:taResp; IDPens:tIDPens; IDUsuarioActual:tIDUsuario; fechaHoraPens:tDateTime; volver:tvolver);
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
    DetallePens(aUsuarios,aPens,aResp,IDPens,IDUsuarioActual,volver);
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
//Descripci¢n: M¢dulo para votar un pensamiento
//Pre-Cond: IDUsuarioActual = ID del usuario logueado.
//          IDPens = ID del pensamiento al que se vota.
//          voto = boolean que determina el tipo de voto (true = positivo, false = negativo)
//Pos-Cond: Guarda el voto en pensamientos.dat
//          Muestra un mensaje de confirmaci¢n del voto.
//          Vuelve al m¢dulo de detalle de pensamiento
procedure Votar(var aUsuarios:taUsuarios; var aPens:taPens; var aResp:taResp; IDUsuarioActual:tIDUsuario; IDPens:tIDPens; voto:tVoto; volver:tvolver);
begin
    GuardarVoto(aPens,IDPens,voto);
    pantallaVoto;
    DetallePens(aUsuarios,aPens,aResp,IDPens,IDUsuarioActual,volver);
end;

//Autor: Gaston Snaider
//Descripci¢n: Muestra una respuesta.
//Pre-Cond: tiempoDesp = tiempoDesp de la respuesta.
//          IDUsuario = IDUsuario de la respuesta.
//          mensaje = mensaje de la respuesta.
//Pos-Cond: Muestra en pantalla el mensaje de la respuesta, indicando el "tiempo despues" en que fue publicada, y el usuario que la public¢.
procedure MostrarRespuesta(var aUsuarios:taUsuarios; tiempoDesp:tDateTime; IDUsuario:tIDUsuario; var mensaje:tmensaje);
begin
    MostrarTiempoDespResp(tiempoDesp);
    writeln('Usuario ',ObtenerNick(IDUsuario,aUsuarios),' respondio:');
    writeln(mensaje);
    writeln
end;

//Autor: Gaston Snaider
//Descripci¢n: Muestra las respuestas de un pensamiento.
//Pre-Cond: IDPens = ID del pensamiento al cual se le quieren ver las respuestas.
//Pos-Cond: Muestra en pantalla todas las respuestas del pensamiento asociado al IDPens.
procedure MostrarRespuestas(var aUsuarios:taUsuarios; var aResp:taResp; IDPens:tIDPens);
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
            MostrarRespuesta(aUsuarios, rResp.tiempoDesp, rResp.IDUsuario, rResp.mensaje)
    end;
    close(aResp)
end;

//Autor: Gaston Snaider
//Descripci¢n: Muestra el mensaje de un pensamiento.
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
//Descripci¢n: Muestra la puntuacion de un pensamiento.
//Pre-Cond: votosPos/votosNeg = cantidad de votos positivos/negativos del pensamiento.
//Pos-Cond: Muestra en pantalla la puntuacion del pensamiento.
procedure MostrarPuntuacion(votosPos,votosNeg:tVotos);
begin
    writeln('Puntuacion:');
    writeln('Positivas: ',votosPos);
    writeln('Negativas: ',votosNeg);
    writeln;
end;


//Autor: Gaston Snaider     //AGREGAR PARAMETROS DE BUSQUEDAS PARA VOLVER. DIFERENCIAR TIPOS DE BUSQUEDA/FAVORITOS?
//Descripci¢n: Muestra los detalles de un pensamiento, y las opciones correspondientes.
//Pre-Cond: IDPens = ID del pensamiento al que se le quieren ver los detalles.
//          IDUsuarioActual = ID del usuario logueado.
//          Volver = booleano que determina a que patalla volver.
//Pos-Cond: Muestra en pantalla el pensamiento, sus puntuaciones, sus respuestas, y las opciones correspondientes.
//          Si volver = 1: vuelve a la lista de pensamientos del usuario actual.
//          Si volver = 2: vuelve a la busqueda de la cual se haya llamado al m¢dulo.
//          Si volver = 3: vuelve a la pantalla de favoritos de la cual se llam¢ al m¢dulo.
procedure DetallePens(var aUsuarios:taUsuarios; var aPens:taPens; var aResp:taResp; IDPens:tIDPens; IDUsuarioActual:tIDUsuario; volver:tvolver);
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
        MostrarRespuestas(aUsuarios, aResp, IDPens);
        publicarOpcion(OpcionVolver,'Volver');
        publicarOpcion(OpcionResponder,'Responder');
        publicarOpcion(OpcionVotarPos,'Votar Positivo');
        publicarOpcion(OpcionVotarNeg,'Votar Negativo');
        IngresarOpcion(opcion, MinOpcion, MaxOpcionDetallePens, error);
    until (error = 0);

    case opcion of
        OpcionVolver:
				case volver of
                    VolverALista: ListaPens(aUsuarios,aPens,aResp,IDUsuarioActual)
				    //VolverABusqueda: Busqueda;
					//VolverAFavoritos: Favoritos;
                end;
        OpcionResponder: Responder(aUsuarios,aPens,aResp,IDPens,IDUsuarioActual,rPens.fechaHora,volver);
        OpcionVotarPos: Votar(aUsuarios,aPens,aResp,IDUsuarioActual,IDPens,VotoPos,volver);
        OpcionVotarNeg: Votar(aUsuarios,aPens,aResp,IDUsuarioActual,IDPens,VotoNeg,volver);
    end
end;

//Autor: Gaston Snaider
//Muestra el detalle del £ltimo pensamiento de un usuario
//Pre-Cond: IDUusuario = ID del usuario al cual se le quiere ver el pensamiento.
//          IDUsuarioActual = ID del usuario logueado.
//          Volver = Variable que determina a que pantalla volver.
//Pos-Cond: Redirige al m¢dulo Detalle de pensamiento, del £ltimo pensamiento del usuario asociado a IDUsuario.
procedure UltimoPens(var aUsuarios:taUsuarios; var aPens:taPens; var aResp:taResp; IDUsuario,IDUsuarioActual:tIDUsuario; volver:tvolver);
var
    rUsuario:trUsuario;
begin
    reset(aUsuarios);
    seek(aUsuarios,IDUsuario);
    read(aUsuarios,rUsuario);
    close(aUsuarios);
    DetallePens(aUsuarios,aPens,aResp,rUsuario.vUltimosPens[MinUltimosPens],IDUsuarioActual,volver)
end;

//Autor: Gaston Snaider
//Descripci¢n: Muestra la lista de ultimos pensamientos del usuario logueado.
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
        inc(i);
    end;
    cantPens := (i-1);
end;


//Autor: Gaston Snaider
//Descripci¢n: M¢dulo de la Lista de £ltimos pensamientos.
//Pre-Cond: IDUsuarioActual = ID del usuario logueado. De este usuario se van a cargar los pensamientos.
//Pos-Cond: Muestra la pantalla de toda la lista de pensamientos, con la posibilidad de elegir alguno para ver sus detalles.
procedure ListaPens(var aUsuarios:taUsuarios; var aPens:taPens; var aResp:taResp; IDUsuarioActual:tIDUsuario);
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
        OpcionVolver: MisPensamientos(aUsuarios,aPens,aResp,IDUsuarioActual);
        MinUltimosPens..MaxUltimosPens: DetallePens(aUsuarios,aPens,aResp,rUsuario.vUltimosPens[opcion],IDUsuarioActual,VolverALista)
    end
end;

//Autor: Gaston Snaider
//Descripcion: Guardar el pensamiento en pensamientos.dat
//Pre-Cond: IDUsuario = ID del usuario que public¢ el pensamiento.
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
    close(aPens);
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
        vUltimosPens[MinUltimosPens] := IDPens;
end;

//Autor: Gaston Snaider
//Descripcion: Guardar el IDPens en usuarios.dat.
//Pre-Cond: IDPens = ID del pensamiento que se guarda.
//          IDUsuario = ID del usuario que public¢ el pensamiento.
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
//Desrcipci¢n: M¢dulo para publicar un pensamiento.
//Pre-Cond: IDUsuarioActual = ID del usuario logueado.
//Pos-Cond: Permite al usuario ingresar un pensamiento.
//          Verifica que no sea blanco.
//          Guarda el pensamiento en archivos correspondientes.
//          Vuelve a la m¢dulo Mis Pensamientos.
procedure publicarPens(var aUsuarios:taUsuarios; var aPens:taPens; var aResp:taResp; IDUsuarioActual:tIDUsuario);
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
    MisPensamientos(aUsuarios,aPens,aResp,IDUsuarioActual);
end;

//Autor: Gaston Snaider
//Descripci¢n: M¢dulo Mis Pensamientos.
//Pre-Cond: IDUsuarioActual = ID del usuario logueado.
//Pos-Cond: Muestra la pantalla del menu Mis Pensamientos, y redirige al m¢dulo correspondiente a la opci¢n elegida.
procedure MisPensamientos(var aUsuarios:taUsuarios; var aPens:taPens; var aResp:taResp; IDusuarioActual:tIDUsuario);
var
    opcion:topcion;
    error:tError;
begin
    repeat
        pantallaMisPens;
        ingresarOpcion(opcion, MinOpcion, MaxOpcionMisPens, error)
    until (error = 0);

    case opcion of
        //OpcionVolver: MenuPrincipal;
        OpcionPublicarPens: PublicarPens(aUsuarios,aPens,aResp,IDUsuarioActual);
        OpcionListaPens: ListaPens(aUsuarios,aPens,aResp,IDUsuarioActual)
    end
end;

//Autor: Gaston Snaider
//Descricpi¢n: Abrir por primera vez el archivo pensamientos.dat
//Pre-Cond: ruta = ruta del archivo en el sistema.
//Pos-Cond: Intenta abrir el archivo y dejar el puntero en la primera posici¢n.
//          Si el archivo no existe, lo crea y lo deja abierto con el puntero en la primera posici¢n.
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
//Descricpi¢n: Abrir por primera vez el archivo respuestas.dat
//Pre-Cond: ruta = ruta del archivo en el sistema.
//Pos-Cond: Intenta abrir el archivo y dejar el puntero en la primera posici¢n.
//          Si el archivo no existe, lo crea y lo deja abierto con el puntero en la primera posici¢n.
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
    i:integer;
begin
    reset(aUsuarios);
    read(aUsuarios,rUsuario);
    IDUsuarioActual := rUsuario.ID;
    //InicializarVUltimosPens(rUsuario.vUltimosPens);
    close(aUsuarios)
end;


var
        aUsuarios:taUsuarios;
        aPens:taPens;
        aResp:taResp;
        IdxNIck,IdxMail:tUsuariosIdx;
        maxIdx:Byte;
        IDUsuarioActual:tIDUsuario;
begin
    abrirArchivoPens(aPens,rutaPens);
    close(aPens);
    abrirArchivoResp(aResp,rutaResp);
    close(aResp);
    abrirArchivoUsuarios(aUsuarios,rutaUsuarios);
    close(aUsuarios);
    InicializacionTesteo(aUsuarios,IDUsuarioActual);
    MisPensamientos(aUsuarios,aPens,aResp,IDUsuarioActual);
end.



















