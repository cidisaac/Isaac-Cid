program RedSocial;
uses
        usuarios,crt,sysutils;
const
        RutaUsuarios= '\usuarios.dat';
        TituloRegistroPublico = 'Registro de nuevo usuario: "Datos P�blicos"';
        TituloRegistroPrivado = 'Registro de nuevo usuario: "Datos Privados"';

type
        tListaIntereses = array [1..255] of tDescripcionInteres;

Procedure obtenerNickValido(var destino:tNombre; var IdxNick:tUsuariosIdx; maxIdx:byte);
var
        error:tError;
        mensaje:tMensaje;
        aux:string[LongNickname + 1]; //el caracter de mas permite saber si se paso o no del rango
begin
        repeat
                cabeceraPantalla(TituloRegistroPublico);
                write('Ingrese su nombre de usuario o nickname: ');
                readln(aux);
                validarNick(aux,IdxNick,maxIdx,error,mensaje);
                if (error = 0) then destino:=aux
                else MostrarMensajeError(mensaje)
        until (error = 0)
end;

procedure obtenerSexoValido(var destino:tSexo);
var
        error:tError;
        mensaje:tMensaje;
        opcion:byte;
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
                //validarCiudad();
                error := 0;
                if (error = 0) then destino:=aux
                else MostrarMensajeError(mensaje)
        until (error=0)
end;

//Sirve para nombre y apellido el mismo procedimiento porque tienen misma longitud de string
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
        until (error = 0);
end;

procedure obtenerMailValido (var destino:tMail);
var
        aux : string[LongMail + 1];
        error:tError;
        mensaje:tMensaje;
begin
        repeat
                cabeceraPantalla(TituloRegistroPrivado);
                write('Ingrese su correo de e-mail: ');
                readln(aux);
                error := 0;
                //validarMail(aux,error,mensaje);
                if (error = 0) then destino:=aux
                else MostrarMensajeError(mensaje)
        until (error = 0);
end;

procedure obtenerPassValida (var destino:tPass);
var
        aux : string[LongPass + 1];
        error:tError;
        mensaje:tMensaje;
begin
        repeat
                cabeceraPantalla(TituloRegistroPrivado);
                write('Ingrese su contrase�a: ');
                readln(aux);
                error := 0;
                //validarPass(aux,error,mensaje);
                if (error = 0) then destino:=aux
                else MostrarMensajeError(mensaje)
        until (error = 0);
end;

procedure IngresarCoordenada(var pantalla:tPantalla; var aux:string);
begin
        cabeceraPantalla(TituloRegistroPrivado);
        write(pantalla);
        readln(aux)
end;

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

procedure obtenerInteresValido(var destino:tvIntereses; var listaIntereses : tListaIntereses;maxInteres:Byte );
var
        opcion,num,i : byte;
        error:tError;
        mensaje:tMensaje;
begin
        num:=1;
        repeat
                repeat
                        cabeceraPantalla(TituloRegistroPrivado);
                        writeln('Ingrese ',num ,'� interes: ');
                        writeln('');
                        for i:= 1 to maxInteres do publicarOpcion(i,listaIntereses[i]);
                        writeln('');
                        ingresarOpcion(opcion,1,maxInteres,error);
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
        until (error = 0);
end;

//Si maxInteres vuelve en 0 entonces o no existe el archivo o esta vacio
procedure AbrirArchivoIntereses(var aIntereses:taIntereses;var maxInteres:byte);
begin
        maxInteres:=0;
        assign (aIntereses,RutaIntereses);
        {$I-}
        reset(aIntereses);
        {$I+}
        if (IOResult = 0) then maxInteres:= filesize(aIntereses)    //me sirve luego si el archivo no es valido
end;

//viene reseteado
procedure cargarListaIntereses (var listaIntereses : tListaIntereses; var aIntereses:taIntereses; maxInteres:Byte);
var
        rInteres: trInteres;
        i:byte;
begin
         for i := 1 to maxInteres do
         begin
                read(aIntereses,rInteres);
                listaIntereses[i] := rInteres.descripcion
         end
end;

procedure inicializarUltimosPens (var destino:tvUltimosPens) ;
var
        i: tRangoUltimosPens;
begin
        for i := MinUltimosPens to MaxUltimosPens do
                destino[i] := 0
end;

procedure Registro(var IdxNIck,IdxMail:tUsuariosIdx; maxIdx:byte; var aUsuarios: taUsuarios);
var
        rUsuario:trUsuario;
        pantalla:tPantalla;
        listaIntereses : tListaIntereses;
        aIntereses:taIntereses;
        maxInteres,i:Byte;
begin
        AbrirArchivoIntereses(aIntereses,maxInteres);
        cargarListaIntereses(listaIntereses, aIntereses,maxInteres);
        close (aIntereses);

        obtenerNickValido(rUsuario.nickname,IdxNIck,maxIdx);

        obtenerFechaValida(rUsuario.Fecha);

        obtenerSexoValido(rUsuario.sexo);

        obtenerCiudadValida(rUsuario.ciudad);//  falta validar

        pantalla:= 'Ingrese su nombre: ';
        obtenerNombreValido(rUsuario.nombre,pantalla);

        pantalla:= 'Ingrese su apellido: ';
        obtenerNombreValido(rUsuario.apellido,pantalla);

        obtenerMailValido (rUsuario.mail);    // falta validar que no repita

        obtenerPassValida(rUsuario.pass);      // falta validar y asteriscos

        obtenerInteresValido(rUsuario.intereses, listaIntereses, maxInteres);

        obtenerUbicacionValida (rUsuario.ubicacion);

        inicializarUltimosPens(rUsuario.UltimosPens);

        rUsuario.ID := asignarIDusuario(maxIdx);

        ArchivoUsuariosFinal(aUsuarios,RutaUsuarios);
        write(aUsuarios,rUsuario);
        close (aUsuarios);

        //una vez que lo guarda sin problemas

        insertar(IdxNick,rUsuario.nickname,rUsuario.ID,maxIdx);
        insertar(IdxMail,rUsuario.mail,rUsuario.ID,maxIdx)
        //tengo todos los datos para guardar
end;

var
        aUsuarios:taUsuarios;
        rUsuario:trUsuario;
        IdxNIck,IdxMail:tUsuariosIdx;
        maxIdx,i:Byte;
begin
        ClrScr;
        generarIndices(aUsuarios,RutaUsuarios,IdxNIck,IdxMail,maxIdx);   //el maximo logico se asigna dentro
        if (maxIdx>0 ) then
                for i:= MinUsuario to maxIdx do
                        writeln(IdxNIck[i].ID,' ',IdxNIck[i].cadena);  //Prueba de indices
        readkey;
        Registro(IdxNick,IdxMail,maxIdx,aUsuarios);
        readkey
end.
