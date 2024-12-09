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