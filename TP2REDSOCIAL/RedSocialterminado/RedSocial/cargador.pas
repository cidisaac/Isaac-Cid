Program cargador;
uses
        crt,usuarios,sysutils;
const
        SEP = ',';
        RutaErrores = 'errores.log';
        RutaEntradaDefault= 'DatosPrueba.csv';
        RutaSalidaDefault = 'usuarios.dat';
        cabecera ='Cargador de usuarios <Presione "0" para salir>';
        TituloEntrada = 'Ruta de entrada del csv ( "1"= ruta por defecto): ';
        TituloSalida = 'Ruta de salida del csv ( "1"= valor por defecto): ';
        TItuloErrores = 'Errores al crear el archivo: ';
        TituloUsuarios = 'Los usuarios cargados fueron: ';
        ErrCsvNoValido = 'El archivo CSV es inv lido o no existe ' ;
        LongMinRuta = 4;
        LongMaxRuta = 255;
type
        taCsv = TEXT;
        tLinea = string;
        tPosicion = word; //posicion en el archivo
        tAcumulador = byte;

procedure abrirCsv (var aCsv:taCsv; ruta:tRuta; var error:tError);
begin
        error:=0;
        assign(aCsv,ruta);
        {$I-}
        reset(aCsv);
        {$I-}
        if (IOResult <> 0) then
        begin
                writeln(ErrCsvNoValido);
                error:=20;
                readkey
        end
end;

procedure cambioVariable(var aux,linea: tLinea; var posi:tPosicion;var variableErr:tAcumulador );
begin
        inc(variableErr);
        posi:=pos(SEP,linea);  //la posicion del separador en lo que me queda de la linea del csv
        if (posi<>0) then aux := copy(linea,1,posi-1)  //corta desde el principio hasta el separador sin incluirlo
        else aux:=''
end;

procedure cortarCoordenada(var aux,linea: tLinea; var posi:tPosicion;var variableErr:tAcumulador) ;
var
        posiComa:tPosicion;
begin
        inc(variableErr);
        posi:=pos('"',linea);
        delete(linea,1,posi);            //borro hasta la apertura de la comilla inclusive
        posi :=pos('"',linea);
        aux := copy(linea,1,posi-1); //tengo lo que hay adentro de las comillas
        posiComa := pos(',',aux);
        if (posi <> 0) then aux :=concat(concat(copy(aux,1,posiComa - 1),'.'),copy(aux,posiComa + 1,length(aux)-posiComa)) //le pongo un punto si hay coma
end;

procedure CargarDato(var aCsv:taCsv;var aUsuarios:taUsuarios;var IdxNIck,IdxMail:tUsuariosIdx;var maxIdx:tIDusuario;var listaIntereses : tListaIntereses;maxInteres:tIntereses;numDato:word);
var
        posi:tPosicion;
        linea,aux:tLinea;
        rUsuario:trUsuario;
        variableErr : tAcumulador;
        error:tError;
        mensaje:tMensaje;
        i, IDinteres:tIntereses;
begin
        readln(aCsv,linea);
        variableErr := 0;  //me permite saber en que variable me da error.
         //Nickname code = 1
        cambioVariable (aux,linea,posi,variableErr);
        validarNick(aux,IdxNick,maxIdx,error,mensaje);  //ojo hay que insertar
        if (error = 0) then
        begin
                rUsuario.Nickname := lowercase(aux);
                delete(linea,1,posi);
                //Fecha code = 2
                cambioVariable (aux,linea,posi,variableErr);
                if (length(aux) = 8) then aux:= concat(concat(copy(aux,1,6),'19'),copy(aux,7,2));  //agrego el 19
                validarFecha (aux,error,mensaje);
                if (error = 0) then
                begin
                        rUsuario.Fecha:= strToDate(aux);
                        delete(linea,1,posi);
                        //Sexo code = 3
                        cambioVariable (aux,linea,posi,variableErr);
                        validarSexoCaracter(aux,error,mensaje);
                        if (error = 0) then
                        begin
                                rUsuario.Sexo := aux[1];
                                delete(linea,1,posi);
                                //Ciudad code = 4
                                cambioVariable (aux,linea,posi,variableErr);
                                validarCiudad(aux,error,mensaje);
                                if (error = 0) then
                                begin
                                        rUsuario.Ciudad := aux;
                                        delete(linea,1,posi);
                                        //Nombre code = 5
                                        cambioVariable (aux,linea,posi,variableErr);
                                        validarNombre(aux,error,mensaje);
                                        if (error = 0) then
                                        begin
                                                rUsuario.Nombre := aux;
                                                delete(linea,1,posi);
                                                //Apellido code = 6
                                                cambioVariable (aux,linea,posi,variableErr);
                                                validarNombre(aux,error,mensaje);
                                                if (error = 0) then
                                                begin
                                                        rUsuario.Apellido := aux;
                                                        delete(linea,1,posi);
                                                        //Mail code = 7
                                                        cambioVariable (aux,linea,posi,variableErr);
                                                        validarMail(aux,IdxMail,maxIdx,error,mensaje);
                                                        if (error = 0) then
                                                        begin
                                                                rUsuario.Mail := aux;
                                                                delete(linea,1,posi);
                                                                //Password code = 8
                                                                cambioVariable (aux,linea,posi,variableErr);
                                                                validarPass(aux,error,mensaje);
                                                                if (error = 0) then
                                                                begin
                                                                        rUsuario.Pass := aux;
                                                                        delete(linea,1,posi);
                                                                        //Interes code = 9 al 13
                                                                        cambioVariable (aux,linea,posi,variableErr);
                                                                        i:= MinIntereses;
                                                                        while (i<= MaxIntereses) and (error=0) do
                                                                        begin
                                                                                validarInteres(rUsuario.intereses,i,IDinteres,aux,listaIntereses,maxInteres,error, mensaje);
                                                                                IF (error=0) then
                                                                                begin
                                                                                        rUsuario.intereses[i]:=IDinteres;
                                                                                        delete(linea,1,posi);
                                                                                        if (i < MaxIntereses) then cambioVariable (aux,linea,posi,variableErr);
                                                                                        inc(i)
                                                                                end
                                                                        end;
                                                                        //Ubicacion code = 14-15

                                                                        cortarCoordenada(aux,linea,posi,variableErr);
                                                                        validarCoordenada(rUsuario.ubicacion.latitud, aux ,MinLatitud, MaxLatitud,error,mensaje); //asigna si es correcto
                                                                        if (error = 0) then
                                                                        begin
                                                                                delete(linea,1,posi+1);//borra hasta la ultima comilla y la coma
                                                                                cortarCoordenada(aux,linea,posi,variableErr);
                                                                                validarCoordenada(rUsuario.ubicacion.longitud,aux,MinLongitud, MaxLongitud,error,mensaje);//asigna si es correcto
                                                                                if (error = 0) then
                                                                                begin
                                                                                        inicializarUltimosPens(rUsuario.vUltimosPens);
                                                                                        rUsuario.ID:= asignarIDusuario(maxIdx);
                                                                                        write (aUsuarios,rUsuario);
                                                                                        //guardar en archivo
                                                                                        if (maxIdx = MaxUsuario + 1) then
                                                                                        begin
                                                                                                agregarUsuarioIdx(IdxNick,rUsuario.nickname,rUsuario.ID,rUsuario.ID);
                                                                                                agregarUsuarioIdx(IdxMail,rUsuario.mail,rUsuario.ID,rUsuario.ID)
                                                                                        end
                                                                                        else
                                                                                        begin
                                                                                                insertar(IdxNick,rUsuario.nickname,rUsuario.ID,maxIdx);
                                                                                                insertar(IdxMail,rUsuario.mail,rUsuario.ID,maxIdx)
                                                                                        end;
                                                                                        maxIdx:=rUsuario.ID
                                                                                        //si llega cargo con exito, si corto en cualquier lugar va al .log
                                                                                end
                                                                        end
                                                                end
                                                        end
                                                end
                                        end
                                end
                        end
                end
        end;
        if(error <> 0) then writeln('fallo el dato:',numDato,' la variable: ',variableErr,' Error numero: ',error,' ',mensaje)
end;

procedure CargarCsv(var aCsv:taCsv;var aUsuarios:taUsuarios;var IdxNIck,IdxMail:tUsuariosIdx;var maxIdx:tIDusuario);
var
        listaIntereses : tListaIntereses;
        aIntereses:taIntereses;
        maxInteres,i:tIntereses;
        numDato:word;
        linea:tLinea;
begin
        cabeceraPantalla(TituloErrores);
        AbrirArchivoIntereses(aIntereses,maxInteres,RutaIntereses);
        cargarListaIntereses(listaIntereses, aIntereses,maxInteres);
        close (aIntereses);
        readln(aCsv,linea);//en DatosPrueba.csv la primera linea no es dato
        numDato := 2;
        while (not eof(aCsv)) do
        begin
                CargarDato(aCsv,aUsuarios,IdxNIck,IdxMail,maxIdx,listaIntereses,maxInteres,numDato);
                inc(numDato)
        end;
        writeln();
        writeln('se cargaron ',maxIdx + 1,' usuarios con ‚xito. <Presione un tecla para continuar>');
        readkey
end;
procedure mostrarUsuarios(maxIdx:tIdUsuario;var IdxNIck:tUsuariosIdx);
var
        i:tIDusuario;
begin
        cabeceraPantalla(TituloUsuarios);
        if (maxIdx <> MaxUsuario+1 ) then
                for i:= MinUsuario to maxIdx do
                        writeln(IdxNick[i].cadena);
        readkey
end;

procedure IngresarRuta(var destino:tRuta;rutaDefecto:tRuta; titulo:tPantalla; var error : tError; entrada: boolean; var aCsv:taCsv);
var
        mensaje:tMensaje;
begin
        repeat
                cabeceraPantalla(cabecera);
                write (titulo);
                readln(destino);
                validarLongTexto(destino,LongMinRuta,LongMaxRuta,error,mensaje);
                if (error <> 0) then
                        if (destino = '1') then
                        begin
                                error:=0;
                                destino := RutaDefecto
                        end
                        else if (destino ='0') then error:=24   //cancelaRegistro
                        else
                        begin
                                writeln(mensaje);
                                readkey
                        end;
                if (error = 0) and (entrada) then AbrirCsv(aCsv, destino, error);
        until (error = 0) or (error = 24);
end;

var
        aUsuarios:taUsuarios;
        rUsuario:trUsuario;
        aCsv:taCsv;
        IdxNIck,IdxMail:tUsuariosIdx;
        maxIdx,i:tIDusuario;
        rutaEntrada,rutaSalida:tRuta;
        error: tError;
        mensaje:tMensaje;
begin
        //Ruta Entrada
        IngresarRuta(rutaEntrada,RutaEntradaDefault,TituloEntrada,error,true,aCsv);
        if (error = 0) then
        begin
                //Ruta salida
                IngresarRuta(rutaSalida,RutaSalidaDefault,TituloSalida,error,false,aCsv);
                if (error= 0) then
                begin
                        abrirArchivoUsuarios (aUsuarios,rutaSalida);//Abre y resetea al principio
                        rewrite(aUsuarios); //lo va a pisar
                        maxIdx :=MaxUsuario + 1;  //le asigno algo invalido para que el primer ID sea 0
                        CargarCsv(aCsv,aUsuarios,IdxNIck,IdxMail,maxIdx);
                        close (aCsv);
                        close (aUsuarios);
                        mostrarUsuarios(maxIdx,IdxNIck);
                end
        end
end.
