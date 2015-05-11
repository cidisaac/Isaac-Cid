program Edades;
uses sysutils;

function calcularEdad(Fecha : tDate): byte; //Hasta 99 años
Var ao: word;
begin
val(copy(DateToStr(Date-Fecha), 7, 4), ao);
calcularEdad := ao - 1900
end;
Var fecha : string; edad : byte;
begin
while True do
	begin
	writeln('Ingresa fecha');
	readln(fecha);
	edad := calcularEdad(StrToDate(Fecha));
	writeln(edad);
	readln
	end
end.
