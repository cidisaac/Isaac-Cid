unit Usuarios;
interface
uses
        crt,sysutils;
const
        //Longitud de cadenas de texto
        LongNickname = 30;
        LongCiudad = 50;
        LongNombre = 30;
        LongApellido = 50;
        LongMail = 50;
        LongPass = 16;
        LongRuta = 100;
        LongPantalla = 50; //maximo permitido para los mensajes Ingrese tal opcion
        LongFechaNac = 10;
        LongFormatoFecha = 15;
        LongDescripcionInteres  = 30;

        //Separadores de formatos de fecha y hora
        SeparadorFechaHora = ' ';
        SeparadorFecha = '/';
        SeparadorHOra = ':';

        //Limites inferiores y superiores de vectores
        MinIntereses = 1;
        MaxIntereses = 5;
        MinUltimosPens = 1;
        MaxUltimosPens = 5;
        MinUsuario=1;
        MaxUsuario = 100;

        //Sexo
        M=1;
        F=2;
        I=3;

        //coordenadas
        MinLatitud = -90;
        MaxLatitud = 90;
        MinLongitud = -180;
        MaxLongitud = 180;

        //Mensajes de error
        ErrTipoNum = 'El dato debe ser numerico ';
        ErrLim = 'Valor fuera de rango, debe estar entre: ';
        ErrLetras= 'Cadena invalida.Se admiten solo letras de la A a la Z (son validos acentos y diÇresis) ';
        ErrLongCadena = 'Cadena invalida. Debe contener entre 1 y ';
        ErrIdxUnico = 'Dato ya utilizado por otro usuario, debe ser unico ';
        ErrInteresRepetido ='Un interes no se puede repetir';
        ErrFormatoFecha = 'Fecha inv†lida ';
        ErrTipoCoordenada = 'Coordenada invalida, formato no permitido';
        ErrRangoCoordenada = 'Valor de cooordenada fuera de rango (latitud entre -90 y 90, longitud entre -180 y 180';

        RutaIntereses = '\intereses.dat';
        AnoActual = 2014; //podria sacarlo del sistema
type
        //Tipos necesitados para el registro rUsuario
        tIDusuario = MinUsuario..MaxUsuario;
        tIDpens = word;
        tNickname = string[LongNickname];
        tFecha = tDate;
        tSexo = Char;
        tCiudad =  string[LongCiudad];
        tNombre = string[LongNombre];
        tApellido = string[LongApellido];
        tMail = string[LongMail];
        tPass = string[LongPass];
        tRangoIntereses = MinIntereses..MaxIntereses;
        tIntereses = byte;
        tvIntereses = array [tRangoIntereses] of tIntereses;
        tCoordenada = real;
        tUbicacion = Record
                latitud : tCoordenada;
                longitud : tCoordenada
                end;
        tRangoUltimosPens = MinUltimosPens..MaxUltimosPens;
        tvUltimosPens = array [tRangoUltimosPens] of tIDpens;

        trUsuario = record
                ID : tIDusuario;
                nickname : tNickname;
                fecha :tFecha;
                sexo: tSexo;
                ciudad : tCiudad;
                nombre : tNombre;
                apellido :tApellido ;
                mail : tMail;
                pass : tPass;
                intereses : tvIntereses;
                ubicacion: tUbicacion;
                ultimosPens : tvUltimosPens
                end;

        taUsuarios = file of trUsuario;
        tRuta = string[LongRuta];

        //Indice ordenado por Mail y por Nickname mantienen la misma estructura. tMail es similar a tNickname o m†s grande, entonces sirve.
        trUsuariosIdx = record
                ID : tIDusuario;
                cadena : tMail
                end;
        tUsuariosIdx = array [tIDusuario] of trUsuariosIdx;

        tFormatoFecha = string[LongFormatoFecha];

        tMensaje = string;
        tError = Byte;
        tPantalla=string[LongPantalla];

        tDescripcionInteres =  string [LongDescripcionInteres];
        trInteres = record
                IDinteres : byte;
                descripcion : tDescripcionInteres
                end;
        taIntereses = file of trInteres;

procedure abrirArchivoUsuarios (var aUsuarios:taUsuarios; ruta:tRuta);

//
procedure ArchivoUsuariosFinal (var aUsuarios:taUsuarios; ruta:tRuta);

//Devuelve ID para usar
Function AsignarIDusuario(maxIdx:byte):tIDusuario;

//texto que aparece de titulo
procedure cabeceraPantalla(titulo:tPantalla);

//Como el indice por Nickname y mails tienen la misma estructura funciona para ambos
//necesito inicializar por lo menos dos valores del vector
Procedure Insertar(var UsuariosIdx:tUsuariosIdx; dato:tMail; ID,max:byte);

//formato [dd/mm/aaaa]
procedure validarFecha (cadena:string; var error:tError; var mensaje:tMensaje);

//MaxLogUsuarios se inicializa en 0 y se devuelve con la cantidad de usuarios registrados
procedure GenerarIndices(var aUsuarios:taUsuarios; ruta:tRuta; var UsuariosIdxNickname,UsuariosIdxMail: tUsuariosIdx;var MaxIdx:Byte);

//muestra el mensaje de error en pantalla
procedure IngresarOpcion(var destino:byte; min,max:byte ;var error:tError);

procedure MostrarMensajeError (var mensaje:tMensaje);

//Muestra el texto de cada opcion
Procedure publicarOpcion(numOpcion:byte;texto:tPantalla);

//valida que la opcion del interes ingresada no haya sido ingresada previamente
procedure interesRepetido (var pasados:tvIntereses; opcion,maxLog: tIntereses; var error:tError; var mensaje:tMensaje);

procedure validarLimites(num,min,max:Byte;var destino: Byte;var error:tError; var mensaje:tMensaje);

procedure validarNick(cadena:string; var IdNick:tUsuariosIdx; maxIdx:byte; var error:tError; var mensaje:tMensaje);

procedure validarNombre(cadena:string; var error:tError; var mensaje:tMensaje);

procedure validarCoordenada (var destino: tCoordenada; coordenada:string; min,max:tCoordenada; var error:tError; var mensaje:tMensaje);

Procedure validarNum(num:string; min,max: Byte; var destino:Byte; var error:tError;var mensaje:tMensaje);

Procedure validarLetras(var cadena:string; var error:tError; var mensaje:tMensaje);

//Valida que la longitud este dentro del rango permitido para esa variable de texto
//Me combiene pasar una cadena con un string de [long + 1] para que el ultimo me diga si se paso o no de lo permitido.
procedure validarLongTexto(cadena:string; min,max:byte; var error:tError; var mensaje:tMensaje);

//Debe venir validado el dato, la longitud y que sean caracteres validos. Y debe venir en minusculas
procedure validarIdxUnico(dato:tMail; var usuariosIdx:tUsuariosIdx ; maxIdx:tIdUsuario; var error:tError; var mensaje:tMensaje);

implementation

//Abre archivo con cuidado de que exista, sino lo crea
procedure abrirArchivoUsuarios (var aUsuarios:taUsuarios; ruta:tRuta);
begin
        assign (aUsuarios, ruta);
        {$I-}
        reset(aUsuarios);
        {$I+}
        if (IOResult <> 0 ) then rewrite(aUsuarios)//Si no existe lo crea
end;

procedure ArchivoUsuariosFinal (var aUsuarios:taUsuarios; ruta:tRuta);
var
        rUsuario:trUsuario;
begin
        abrirArchivoUsuarios (aUsuarios,ruta);
        while not (eof(aUsuarios)) do read(aUsuarios,rUsuario)
end;

procedure agregarUsuarioIdx(var UsuariosIdx:tUsuariosIdx; dato:tMail; pos,ID:byte);
begin
        UsuariosIdx[pos].ID:=ID;
        UsuariosIdx[pos].cadena:=dato;
end;

//Carga el primer usuario poder comenzar a insertar
Procedure InicializarIdx(var aUsuarios:taUsuarios;var rUsuario:trUsuario;var UsuariosIdxNickname,UsuariosIdxMail: tUsuariosIdx) ;
begin
        //asigno primer usuario
        read(aUsuarios,rUsuario);
        agregarUsuarioIdx(UsuariosIdxNickname,rUsuario.nickname,rUsuario.ID,rUsuario.ID);
        agregarUsuarioIdx(UsuariosIdxMail,rUsuario.mail,rUsuario.ID,rUsuario.ID)
end;


//Como el indice por Nickname y mails tienen la misma estructura funciona para ambos
//necesito inicializar por lo menos dos valores del vector
Procedure Insertar(var UsuariosIdx:tUsuariosIdx; dato:tMail; ID,max:byte);
var
        enc:boolean;
        pos,i: byte;
begin
        enc:=false;
        pos:=MinUsuario;
        if (dato <= UsuariosIdx[pos].cadena) then enc := true                     //Si es el segundo max = 1, entonces si es <= al primero asigna, sino sale y guarda al final
        else inc(pos);
        while (pos <= max) and (not enc) do
                if (dato<=UsuariosIdx[pos].cadena) and (dato > UsuariosIdx[pos-1].cadena) then enc :=true
                else    inc(pos);                                                                           //Notar que si es mayor al ultimo pos = max + 1
        for i:= (max+1) downto (pos+1) do UsuariosIdx[i]:=UsuariosIdx[i-1];                 //corre a la derecha
        agregarUsuarioIdx(UsuariosIdx,dato,pos,ID);
end;

//en MaxIdx devuelvo el maximo logico de usuarios registrados, se inicializa dentro del procedimiento
//el archivo se abre en el procedimiento
procedure GenerarIndices(var aUsuarios:taUsuarios; ruta:tRuta; var UsuariosIdxNickname,UsuariosIdxMail: tUsuariosIdx;var maxIdx:Byte );

var
        rUsuario:trUsuario;
        fin:boolean;
begin
        maxIdx:=0;
        fin := false;
        abrirArchivoUsuarios(aUsuarios, ruta);
        if (not EOF(aUsuarios)) then InicializarIdx(aUsuarios,rUsuario,UsuariosIdxNickname,UsuariosIdxMail)
        else fin := true;
        while (not EOF(aUsuarios)) do
        begin
                read(aUsuarios,rUsuario);
                Insertar (UsuariosIdxNickname,rUsuario.Nickname,rUsuario.ID,rUsuario.ID-1);
                Insertar (UsuariosIdxMail,rUsuario.Mail,rUsuario.ID,rUsuario.ID-1)
        end;
        if (not fin) then maxIdx:=rUsuario.ID;//el ultimo me sirve para decir el maximo
        close (aUsuarios)
end;

Function AsignarIDusuario(maxIdx:byte):tIDusuario;
begin
        AsignarIDusuario:=maxIdx+1
end;

//Valida que sea correcto el valor y lo asigna
procedure validarLimites(num,min,max:byte;var destino: byte; var error:tError; var mensaje:tMensaje);
var
        minText,maxText : string[10]; //porque no se usarian mas de 10 digitos para numeros en todo el programa
begin
        error:=0;
        if (num >= min) and (num <= max) then destino:=num
        else
        begin
                error:=1;
                str(min,minText);
                str(max,maxText);
                mensaje:=concat(concat(concat(ErrLim,minText),'-'),maxText) //Devuelve el mensaje seguido de los limites del rango
        end
end;

//Intenta obtener dato valido a partir de una cadena de texto, dentro de los limites y que sea numerico
Procedure validarNum(num:string; min,max: byte; var destino:Byte; var error:tError;var mensaje:tMensaje);
var
        temp:byte;
begin
        error:=0;
        val(num,temp,error);
        if (error <> 0) then
        begin
                error:=2;
                mensaje := ErrTipoNum
        end
        else
        begin
                validarLimites(temp,min,max,destino,error,mensaje)
        end
end;

//Despues o antes se debe validar que la longitud sea valida
//Pasa la cadena a minusculas si es valido
//Se fija que sean todas letras de la A a la Z (se tiene en cuenta la §)
Procedure validarLetras(var cadena:string; var error:tError; var mensaje:tMensaje);
var
        letra:string[1];
        longCadena,i:byte;
begin
        error:=0;
        cadena := lowercase(cadena);
        longCadena:=length(cadena);
        for i := 1 to longCadena do
        begin
                letra:=copy(cadena,i,1);
                if ((letra < 'a') or (letra > 'z')) and (letra <> '§') and (letra <> 'Å') and ( letra<> '†' ) and ( letra<> 'Ç' ) and ( letra<> '°' ) and ( letra<> '¢' ) and ( letra<> '£' ) and ( letra <> #39) then
                begin
                        error:=3;
                        mensaje :=ErrLetras
                end
        end
end;

//Valida que la longitud este dentro del rango permitido para esa variable de texto
procedure validarLongTexto(cadena:string; min,max:byte; var error:tError; var mensaje:tMensaje);
var
        long:byte;
        longMaxText: string[3];  //maximo 255
begin
        error:=0;
        long:=length(cadena);
        if (long < min) or (long > max) then
        begin
                error:=5;
                str(max,longMaxText);
                mensaje:= concat(concat(ErrLongCadena,LongMaxText),' caracteres')
        end
end;

procedure validarIdxUnico(dato:tMail; var usuariosIdx:tUsuariosIdx ; maxIdx:tIdUsuario; var error:tError; var mensaje:tMensaje);
var
        i:tIDusuario;
begin
        error:=0;
        for i:= MinUsuario to maxIdx do
                if (dato = usuariosIdx[i].cadena) then
                begin
                        error:= 4;
                        mensaje:= ErrIdxUnico
                end
end;

procedure validarNick(cadena:string; var IdNick:tUsuariosIdx; maxIdx:byte; var error:tError; var mensaje:tMensaje);
begin
        validarLongTexto(cadena,1,LongNombre,error,mensaje);
        if (error=0) and (maxIdx > 0) then validarIdxUnico(cadena,IdNick,maxIdx,error,mensaje)
end;

procedure validarCiudad(cadena:string; var error:tError; var mensaje:tMensaje);
begin
end;

procedure validarNombre(cadena:string; var error:tError; var mensaje:tMensaje);
begin
        validarLongTexto(cadena,1,LongNombre,error,mensaje);
        if (error=0) then validarLetras(cadena,error,mensaje)
end;

procedure validarMail(cadena:string; var error:tError; var mensaje:tMensaje);
begin
end;

procedure validarPass(cadena:string; var error:tError; var mensaje:tMensaje);
begin
end;

Function EsBisiesto (ano : integer) : boolean;
begin
        EsBisiesto:=(ano mod 4=0) or ((ano mod 4=0) and (ano mod 100=0));
end;

Function DiaMesEsValido (dia, mes, ano:integer ): boolean;
var
        maxDias:byte;
begin
        case mes of
                1,3,5,7,8,10,12: maxDias:=31;
                4,6,9,11: maxDias:=30;
                2: begin
                        if (Esbisiesto(ano)) then maxDias:=29
                        else maxDias:=28
                   end
        end;
        if ((ano >= 1900) and (ano<= AnoActual )  and (dia <= maxDias )) then
        DiaMesEsValido:= true
        else DiaMesEsValido:= false
end;

//formato [dd/mm/aaaa]
procedure validarFecha (cadena:string; var error:tError; var mensaje:tMensaje);
var
        dia,mes:byte;
        ano:word;
begin
        validarLongTexto(cadena,LongFechaNac,LongFechaNac,error,mensaje);
        if (error =0) then
        begin
                validarnum(copy(cadena,1,2),1,31,dia,error,mensaje);//valida el dia que sea valido
                if (error = 0 ) then
                        if (copy(cadena,3,1) <> '/') then error := 7
                        else
                        begin
                                validarnum(copy(cadena,4,2),1,12,mes,error,mensaje);
                                if (error = 0 ) then
                                        if (copy(cadena,6,1) <> '/') then error := 7
                                        else
                                        begin
                                                val(copy(cadena,7,4),ano,error); //se valida rango en DiaMesValido
                                                if (error =0) then
                                                        if (not DiaMesEsValido(dia,mes,ano)) then error:=7
                                        end
                        end
        end;
        if (error <> 0) then
        begin
                error:= 7;
                mensaje:= ErrFormatoFecha
        end
end;

//valida y asigna si es valido
procedure validarCoordenada (var destino: tCoordenada; coordenada:string; min,max:tCoordenada; var error:tError; var mensaje:tMensaje);
var
        minText,maxText : string[4];
        temp : tCoordenada;
begin
        error:=0;
        //habria que hacerle un longtexto
        val(coordenada,temp,error);
        if (error=0) then
                if (temp < min) or (temp > max) then
                begin
                        error:=9;
                        mensaje:=ErrRangoCoordenada
                end
                else destino := temp
        else
        begin
                error:= 8;
                mensaje:= ErrTipoCoordenada
        end
end;

//muestra el mensaje de error en pantalla
procedure IngresarOpcion(var destino:byte; min,max:byte ;var error:tError);
var
        aux : string[4]; // como mucho las opciones van del 0 al 255, el 4to digito me permite saber si se paso del rango
        mensaje : tMensaje;
begin
        error:=0;
        write('Seleccione opci¢n: ');
        readln(aux);
        validarNum(aux,min,max,destino,error,mensaje);
        if (error<>0) then MostrarMensajeError(mensaje)
end;

procedure MostrarMensajeError (var mensaje:tMensaje);
begin
        writeln(mensaje);
        readkey
end;

//valida que la opcion del interes ingresada no haya sido ingresada previamente
procedure interesRepetido (var pasados:tvIntereses; opcion,maxLog: tIntereses; var error:tError; var mensaje:tMensaje);
var
        i:byte;
begin
        error := 0;
        i:=1;
        repeat
                if (opcion = pasados[i]) then
                begin
                        error:= 6;
                        mensaje := ErrInteresRepetido
                end
                else inc(i)
        until (i > maxLog) or (error <> 0)
end;

procedure cabeceraPantalla(titulo:tPantalla);
begin
        ClrScr;
        writeln(titulo);
        writeln
end;

Procedure publicarOpcion(numOpcion:byte;texto:tPantalla);
begin
        writeln(numOpcion,'_',texto)
end;

var
        formatoFechaHora,formatoFecha,formatoHora : tFormatoFecha;
        maxInteres : Byte;
begin
        //definir una variable con el filesize del archivo intereses.dat para conocer el maximo, lo valido con limites
        //inicializar ultimosPens en 0!

        //Inicializa los formatos de fecha para usar en las funciones StrToDateTime, FormatDateTim
        formatoFecha := ShortDateFormat;
        formatoHora := ShortTimeFormat;
        formatoFechaHora := ShortDateFormat + SeparadorFechaHora + ShortTimeFormat
end.


