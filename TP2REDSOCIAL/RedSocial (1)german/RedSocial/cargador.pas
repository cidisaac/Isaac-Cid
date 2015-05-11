Program cargador;
uses
        crt,usuarios,,sysutils;
const
        SEP = ';';
type
        taCsv = TEXT;

procedure abrirCsv (var aCsv:taCsv; ruta:tRuta; var error:tError);
begin
        assign(aCsv,ruta);
        {$I-}
        reset(aCsv);
        {$I-}
        if (IOResult <> 0) then
        begin
                writeln('El archivo CSV es invalido o no existe. ');
                error:=20
        end
end;

Procedure saltoLinea(var aCsv:taCsv;var linea:string;var posi:word);
begin
        readln(aCsv,linea);
        posi:=pos(SEP,linea)
end;

procedure CargarDato(var aCsv:taCsv;var aUsuarios:taUsuarios;var IdxNIck,IdxMail:tUsuariosIdx; maxIdx:byte;var listaIntereses : tListaIntereses);
var
        posi:word;
        linea:string;
        rUsuario:trUsuario;
begin                     //falta asignar a una cadena y validar antes de asignar al usuario
        rUsuario.Nickname := copy(linea,1,posi-1);
        delete(linea,1,posi);
        rUsuario.Sexo := copy(linea,1,posi-1);
        delete(linea,1,posi);


        rUsuario.Ciudad := copy(linea,1,posi-1);
        delete(linea,1,posi);


        rUsuario.Nombre := copy(linea,1,posi-1);
        delete(linea,1,posi);


        rUsuario.Apellido := copy(linea,1,posi-1);
        delete(linea,1,posi);


        rUsuario.Mail := copy(linea,1,posi-1);
        delete(linea,1,posi);


        rUsuario.Pass := copy(linea,1,posi-1);
        delete(linea,1,posi);


        rUsuario.Intereses := copy(linea,1,posi-1);     //alguna funcion que me devuelva un array, igual que para ultimos pens
        delete(linea,1,posi);


        rUsuario.ultimosPens := copy(linea,1,posi-1);
        delete(linea,1,posi) ;
        rUsuario.ID:= asignarIDusuario(aUsuarios);
end;

//Formato CSV
// Nick String[30] - Sexo (1-3) - Ciudad - Nombre - apellido - mail - pass - intereses (5 digitos seguidos) - ultimos (5 dig)
procedure CargarCsv(var aCsv:taCsv;var aUsuarios:taUsuarios;var IdxNIck,IdxMail:tUsuariosIdx; maxIdx:byte);
var
        rUsuario:trUsuario;
        listaIntereses : tListaIntereses;
        aIntereses:taIntereses;
        maxInteres,i:Byte;
begin

        AbrirArchivoIntereses(aIntereses,maxInteres,RutaIntereses);
        cargarListaIntereses(listaIntereses, aIntereses,maxInteres);
        close (aIntereses);

        saltoLinea(aCsv,linea,posi);      //Falta validaciones

end;

var
        aUsuarios:taUsuarios;
        rUsuario:trUsuario;
        IdxNIck,IdxMail:tUsuariosIdx;
        maxIdx,i:Byte;
begin
        ClrScr;
        abrirCsv (aCsv, rutaEntrada);
        abrirArchivoUsuarios (aUsuarios,rutaSalida);    //Abre y resetea al principio
        generarIndices(aUsuarios,RutaUsuarios,IdxNIck,IdxMail,maxIdx);   //el maximo logico se asigna dentro
        if (maxIdx>0 ) then
                for i:= MinUsuario to maxIdx do
                        writeln(IdxNIck[i].ID,' ',IdxMail[i].cadena);//Prueba de indices
        readkey;

end.
