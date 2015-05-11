program CargadorIntereses;
uses
        usuarios,crt;

var
        aIntereses: taIntereses;
        rInteres : trInteres;
        num : tIntereses;
begin
        ClrScr;

        assign (aIntereses,RutaIntereses);
        rewrite(aIntereses);

        num := 1;
        repeat
                rInteres.IDinteres := num;
                write ('Ingrese interes en min£scula: ');
                readln(rInteres.descripcion);
                write (aIntereses, rInteres);
                inc (num)
        until (num = 26);
        close (aIntereses);
        readkey
end.

