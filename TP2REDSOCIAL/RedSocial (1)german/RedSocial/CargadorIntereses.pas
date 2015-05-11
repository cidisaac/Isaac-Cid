program CargadorIntereses;
uses
        usuarios,crt;

var
        aIntereses: taIntereses;
        rInteres : trInteres;
begin
        ClrScr;

        assign (aIntereses,RutaIntereses);
        rewrite(aIntereses);

        rInteres.IDinteres := 1;
        rInteres.descripcion := 'Fotografia';
        write(aIntereses,rInteres);
        rInteres.IDinteres := 2;
        rInteres.descripcion := 'Viajes';
        write(aIntereses,rInteres);
        rInteres.IDinteres := 3;
        rInteres.descripcion := 'Arte';
        write(aIntereses,rInteres);
        rInteres.IDinteres := 4;
        rInteres.descripcion := 'Pizza';
        write(aIntereses,rInteres);
        rInteres.IDinteres := 5;
        rInteres.descripcion := 'Asado';
        write(aIntereses,rInteres);
        rInteres.IDinteres := 6;
        rInteres.descripcion := 'M£sica';
        write(aIntereses,rInteres);
        rInteres.IDinteres := 7;
        rInteres.descripcion := 'Salud';
        write(aIntereses,rInteres);
        rInteres.IDinteres := 8;
        rInteres.descripcion := 'Bienestar';
        write(aIntereses,rInteres);
        close (aIntereses);
        readkey
end.

