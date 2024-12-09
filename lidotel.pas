program hotel_reservations;

uses sysutils, crt;

type
    tcliente = record
        nombre: string[50];
        apellido: string[50];
        cedula: string[10];
        email: string[50];
        telefono: string[15];
        dias_estadia: integer;
        habitacion: string[20];
        costo_total: real;
    end;

    tcliente_acompanado = record
        cliente: tcliente;
        acomp_nombre: string[50];
        acomp_apellido: string[50];
    end;

    tgrupo = record
        adultos: integer;
        ninos: integer;
        nombres_ninos: array[1..20] of string[50]; // Máximo de 20 personas (adultos + niños)
        habitacion: string[20];
        costo_total: real;
    end;

    archivo_clientes = file of tcliente;
    archivo_clientes_acompanados = file of tcliente_acompanado;
    archivo_grupos = file of tgrupo;


var
    archivo_individual: archivo_clientes;
    archivo_acompanado: archivo_clientes_acompanados;
    archivo_grupo: archivo_grupos;
    cliente: tcliente;

// --- Validaciones ---
function leer_numero(mensaje: string; min, max: integer): integer;
var
    entrada: string;
    numero, codigo_error: integer; 

    begin
    repeat
        write(mensaje);
        readln(entrada);
        val(entrada, numero, codigo_error);
        if (codigo_error <> 0) or (numero < min) or (numero > max) then
            writeln('Error: ingrese un numero valido entre ', min, ' y ', max, '.');
    until (codigo_error = 0) and (numero >= min) and (numero <= max);
    leer_numero := numero;
end;

function leer_texto(mensaje: string): string;
var
    entrada: string;
    es_valido: boolean;
    i: integer;
begin
    repeat
        write(mensaje);
        readln(entrada);
        es_valido := true;

        for i := 1 to length(entrada) do
        begin
            if not (entrada[i] in ['a'..'z', 'A'..'Z', ' ']) then
            begin
                es_valido := false;
                break;
            end;
        end; 