{Se ingresan dos matrices por teclado y se muestran la suma y la resta de ambas.
* Padron:96310
* Alumno: Cid Cabaleiro, Isaac}

Program SumayRestaDeMatrices;

Uses crt;

Const
	Min=1;
	Max=10;
	OperadorResta=-1;
	OperadorSuma=1;
Type
	trango=Min..Max;
	tmatriz=array[trango,trango] of longint;



{Lee los numeros que ingresa el usuario y los asigna a la posicion correspondiente de la matriz.}

Procedure LeerMatriz (Var M:tmatriz;Fila,Columna:trango);

Var i,j:integer;

begin
	for i:=Min to Fila do
		for j:=Min to Columna do
		begin
			writeln('Introduzca el numero de la matriz para la interseccion (', i, ' ; ', j, ')');
				
			readln(M[i,j])

		end
end;

{Procedimiento para operar con las matrices. Realiza la suma y la resta}

Procedure OperacionConMatrices (Var MatrizOperacion1,MatrizOperacion2,MatrizResultado:tmatriz; Fila,Columna:trango;Operador:integer);

Var	i,j:integer;

begin
	for i:=Min to Fila do
		for j:= Min to Columna do
		
			{Operador en caso de suma multiplica por 1, y en caso de resta, por -1; para realizar la suma o resta segun corresponda}
			MatrizResultado[i,j]:=MatrizOperacion1[i,j] + (Operador * MatrizOperacion2[i,j])
end;

{Procedimiento mostrar resultados de la suma y de la resta}

Procedure Mostrar (Var M:tmatriz;Fila,Columna:trango);

Var i,j:integer;

begin
	for i:=Min to Fila do
		begin
			for j:= Min to Columna do
				write((M[i,j]):15);
			writeln
		end
end;


{Aca valido los datos de filas y de columnas para que no sean mayores a 10 ni menores a 1}

Procedure ComprobarDimension (ComprobacionFila,ComprobacionColumna:integer;Var Fila,Columna:trango);

begin

	writeln('Introduzca numero de filas de las matrices');
	
	Repeat
					
		readln(ComprobacionFila);
		if ((ComprobacionFila > Max) or (ComprobacionFila < Min)) then
			writeln('Fuera de rango,ingrese nuevamente por favor :');
							
	Until ((ComprobacionFila <= Max) and (ComprobacionFila >= Min));
	
	Fila:=ComprobacionFila;
	
	writeln;
	writeln('Introduzca numero de columnas de las matrices');
        	
    Repeat
		
		readln(ComprobacionColumna);
		if ((ComprobacionColumna >Max) or (ComprobacionColumna < min)) then
			writeln('Fuera de rango.Ingrese nuevamente por favor:');

	Until ((ComprobacionColumna <= Max) and (ComprobacionColumna >= Min));
		
	Columna:=ComprobacionColumna
end;



{Programa principal}

Var ComprobacionFila,ComprobacionColumna:integer;
	MatrizA,MatrizB,MatrizResultado:tmatriz;
	Fila:trango;
	Columna:trango;
begin
	ClrScr;
	ComprobacionFila:= Min;
	ComprobacionColumna:= Min;
	Fila:=Min;
	Columna:=Min;
	
	{Llama al proceso para verificar que los datos ingresados son correctos}
	ComprobarDimension(ComprobacionFila,ComprobacionColumna,Fila,Columna);
	
	writeLn;
	writeln('Introduzca datos de la primera matriz');
	LeerMatriz(MatrizA,Fila,Columna);

    writeln;
    writeln('Introduzca datos de la segunda matriz');
	LeerMatriz(MatrizB,Fila,Columna);
	
	{Llama al procedimiento que se encarga de realizar la suma}
	OperacionConMatrices(MatrizA,MatrizB,MatrizResultado,Fila,Columna,OperadorSuma);
	
	writeln;
	writeln ('La matriz suma es ');
	Mostrar(MatrizResultado,Fila,Columna);
	
	{Llama al procedimiento que se encarga de realizar la resta}
	OperacionConMatrices(MatrizA,MatrizB,MatrizResultado,Fila,Columna,OperadorResta);
	
	writeln;
	writeln ('La matriz resta es');
	Mostrar(MatrizResultado,Fila,Columna);
	
	write('Presiona una tecla para finalizar...');
	readln;
end.
