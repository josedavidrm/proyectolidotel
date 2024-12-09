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

         if (entrada = '') or (not es_valido) then
        begin
            writeln('Error: ingrese solo letras y no deje el campo vacio.');
            es_valido := false;
        end;
    until es_valido;

    leer_texto := entrada;
end;

function leer_email(mensaje: string): string;
var
    entrada: string;
begin
    write(mensaje);
    readln(entrada);
    leer_email := entrada; 
end;

function leer_telefono(mensaje: string): string;
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
            if not (entrada[i] in ['0'..'9']) then
            begin
                es_valido := false;
                break;
            end;
        end;

        if (entrada = '') or (not es_valido) then
        begin
            writeln('Error: ingrese solo numeros y no deje el campo vacio.');
            es_valido := false;
        end;
    until es_valido;

    leer_telefono := entrada;
end;

// --- Crear Archivos ---
procedure crear_archivos;
begin
    assign(archivo_individual, 'clientes_individual.dat');
    if not fileexists('clientes_individual.dat') then
        rewrite(archivo_individual)
    else
        reset(archivo_individual);
    close(archivo_individual);

    assign(archivo_acompanado, 'clientes_acompanados.dat');
    if not fileexists('clientes_acompanados.dat') then
        rewrite(archivo_acompanado)
    else
        reset(archivo_acompanado);
    close(archivo_acompanado);

    assign(archivo_grupo, 'clientes_grupos.dat');
    if not fileexists('clientes_grupos.dat') then
        rewrite(archivo_grupo)
    else
        reset(archivo_grupo);
    close(archivo_grupo);
end;
 
 
// --- Cliente ya registrado ---
function cliente_ya_registrado(cedula: string; var archivo: archivo_clientes): boolean;
var
    cliente: tcliente;
begin
    reset(archivo); // Asegurarse de abrir correctamente el archivo
    cliente_ya_registrado := false;

    while not eof(archivo) do
    begin
        read(archivo, cliente);
        if cliente.cedula = cedula then
        begin
            cliente_ya_registrado := true;
            break;
        end;
    end;

    close(archivo); // Cerrar después de finalizar
end;


// --- Registrar Cliente Individual ---
procedure registrar_cliente_individual;
var
    precio_por_noche: real;
    tipo_habitacion: integer;
begin
 
 assign(archivo_individual, 'clientes_individual.dat');
    if not fileexists('clientes_individual.dat') then
        rewrite(archivo_individual)
    else
        reset(archivo_individual);
        
    writeln('Ingrese los datos del cliente individual:');
    cliente.nombre := leer_texto('Nombre: ');
    cliente.apellido := leer_texto('Apellido: ');
    cliente.cedula := leer_telefono('Cedula: ');
    cliente.email := leer_email('Email: ');
    cliente.telefono := leer_telefono('Telefono: ');
    cliente.dias_estadia := leer_numero('Dias de estadia: ', 1, 365);

    writeln('Seleccione el tipo de habitacion:');
    writeln('1. FAMILY ROOM - $200 por noche');
    writeln('2. SENCILLA - $60 por noche');
    writeln('3. DOBLE - $120 por noche');
    writeln('4. SUITE - $300 por noche');
    tipo_habitacion := leer_numero('Opcion: ', 1, 4); 