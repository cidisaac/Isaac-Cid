unit Usuarios;
interface
uses
    sysutils;
const
        //Longitud de cadenas de texto
        LongNickname = 30;
        LongCiudad = 50;
        LongNombre = 30;
        LongApellido = 50;
        LongMail = 50;
        LongPass = 16;
        LongRuta = 100;
        LongFormatoFecha = 15;

        //Separadores de formatos de fecha y hora
        SeparadorFechaHora = ' ';
        SeparadorFecha = '/';
        SeparadorHora = ':';

        //Limites de cooredenadas geograficas
        MinLatitud = -90;
        MaxLatitud = 90;
        MinLongitud = -180;
        MacLongitud = 180;

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

        //Mensajes de error
        ErrTipoNum = 'El dato numerico no es valido, solo se aceptan digitos numericos. El dato debe ser mayor o igual a 0. ';
        ErrLim = 'Valor fuera de rango, debe estar entre: ';
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
        tIntereses = byte;
        tCoordenada = real;
        tUbicacion =  Record
            latitud : tCoordenada;
            longitud : tCoordenada;
            end;
        tlstIntereses = array [MinIntereses..MaxIntereses] of tIntereses;
        tUltimosPens = array [MinUltimosPens..MaxUltimosPens] of tIDpens;

        trUsuario = record
                ID : tIDusuario;
                nickname : tNickname;
                fechaNac : tfecha;
                sexo: tSexo;                             //0 = M; 1 = F; 2 = I
                ciudad : tCiudad;
                nombre : tNombre;
                apellido :tApellido ;
                mail : tMail;
                pass : tPass;
                intereses : tlstIntereses;
                ubicacion : tubicacion;
                ultimosPens : tUltimosPens
                end;

        taUsuarios = file of trUsuario;
        tRuta = string[LongRuta];

        //Indice ordenado por Mail y por Nickname mantienen la misma estructura. tMail es similar a tNickname o mas grande, entonces sirve.
        trUsuariosIdx = record
                ID : tIDusuario;
                cadena : tMail
                end;
        tUsuariosIdx = array [tIDusuario] of trUsuariosIdx;

        tFormatoFecha = string[LongFormatoFecha];
        tMensaje = string;
        tError = Byte;

procedure abrirArchivoUsuarios (var aUsuarios:taUsuarios; ruta:tRuta);

//MaxLogUsuarios es la posicion del puntero en el archivo
procedure LeerUsuario(var aUsuarios:taUsuarios; var rUsuario:trUsuario);

procedure agregarUsuarioIdx(var UsuariosIdx:tUsuariosIdx; dato:tMail; pos,ID:byte);

//Devuelve ID para usar
Function AsignarIDusuario(var aUsuarios:taUsuarios):tIDusuario;

//MaxLogUsuarios se inicializa en 0 y se devuelve con la cantidad de usuarios registrados
procedure GenerarIndices(var aUsuarios:taUsuarios; ruta:tRuta; var UsuariosIdxNickname,UsuariosIdxMail: tUsuariosIdx;var MaxIdx:tIdUsuario);

procedure validarLimites(num,min,max:word;var destino: word;var error:tError; var mensaje:tMensaje);

Procedure validarNum(num:string; min,max: word; var destino:word; var error:tError;var mensaje:tMensaje);

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

//Lee e incrementa el contador del maximo logico de usuarios
procedure LeerUsuario(var aUsuarios:taUsuarios; var rUsuario:trUsuario);

begin
        read(aUsuarios, rUsuario); //hacer lo del eof aca
end;

procedure agregarUsuarioIdx(var UsuariosIdx:tUsuariosIdx; dato:tMail; pos,ID:byte);
begin
        UsuariosIdx[pos].ID:=ID;
        UsuariosIdx[pos].cadena:=dato;
end;

//Carga el primer usuario poder comenzar a insertar
Procedure InicializarIdx(var aUsuarios:taUsuarios;var UsuariosIdxNickname,UsuariosIdxMail: tUsuariosIdx) ;
var
        rUsuario:trUsuario;
begin
        //asigno primer usuario
        LeerUsuario(aUsuarios,rUsuario);
        agregarUsuarioIdx(UsuariosIdxNickname,rUsuario.nickname,rUsuario.ID,rUsuario.ID);
        agregarUsuarioIdx(UsuariosIdxMail,rUsuario.mail,rUsuario.ID,rUsuario.ID);
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

//en MaxLogUsuarios devuelvo el maximo logico de usuarios registrados, se inicializa dentro del procedimiento
//el archivo se abre en el procedimiento
procedure GenerarIndices(var aUsuarios:taUsuarios; ruta:tRuta; var UsuariosIdxNickname,UsuariosIdxMail: tUsuariosIdx;var MaxIdx:tIdUsuario );

var
        rUsuario:trUsuario;

begin
        abrirArchivoUsuarios(aUsuarios, ruta);
        if (not EOF(aUsuarios)) then InicializarIdx(aUsuarios,UsuariosIdxNickname,UsuariosIdxMail);
        while (not EOF(aUsuarios)) do
        begin
                LeerUsuario(aUsuarios,rUsuario);
                Insertar (UsuariosIdxNickname,rUsuario.Nickname,rUsuario.ID,rUsuario.ID-1);
                Insertar (UsuariosIdxMail,rUsuario.Mail,rUsuario.ID,rUsuario.ID-1)
        end;
        maxIdx:=rUsuario.ID; //el ultimo me sirve para decir el maximo
        close (aUsuarios)
end;

Function AsignarIDusuario(var aUsuarios:taUsuarios):tIDusuario;
begin
        AsignarIDusuario:=filesize(aUsuarios)+1
end;

//Valida que sea correcto el valor y lo asigna
procedure validarLimites(num,min,max:word;var destino: word; var error:tError; var mensaje:tMensaje);
var
        minText,maxText : string[10];
begin
        if (num >= min) and (num <= max) then destino:=num
        else
        begin
                error:=1;
                str(min,minText);
                str(max,maxText);
                mensaje:=concat(concat(concat(ErrLim,minText),'-'),maxText) //Devuelve el mensaje seguido de los limites del rango
        end
end;

//Intenta obtener dato valido a partir de una cadena de texto
//Error debe venir en 0
Procedure validarNum(num:string; min,max: word; var destino:word; var error:tError;var mensaje:tMensaje);
var
        temp:word;
begin
        val(num,temp,error);
        if (error <> 0) then
                mensaje := ErrTipoNum
        else
        begin
                validarLimites(temp,min,max,destino,error,mensaje)
        end
end;

var
    formatoFechaHora,formatoFecha,formatoHora : tformatoFecha;
begin
    //Inicializa los formatos de fecha para usar en las funciones StrToDateTime, FormatDateTime
    formatoFecha :=  ShortDateFormat;
    formatoHora := ShortTimeFormat;
    formatoFechaHora :=  ShortDateFormat + SeparadorFechaHora + ShortTimeFormat;
end.


