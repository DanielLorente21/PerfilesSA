function calcularAnios(fechaTexto) {
    if (!fechaTexto) {
        return null;
    }

    var fecha = new Date(fechaTexto);
    var hoy = new Date();

    var anios = hoy.getFullYear() - fecha.getFullYear();
    var mesActual = hoy.getMonth();
    var diaActual = hoy.getDate();
    var mesFecha = fecha.getMonth();
    var diaFecha = fecha.getDate();

    if (mesActual < mesFecha || (mesActual === mesFecha && diaActual < diaFecha)) {
        anios--;
    }

    return anios < 0 ? 0 : anios;
}

function calcularEdadEnPantalla(fechaNacimiento) {
    var anios = calcularAnios(fechaNacimiento);
    var spanEdad = document.getElementById('spanEdadCalculada');

    if (spanEdad) {
        spanEdad.textContent = (anios === null) ? '--' : anios;
    }
}

function calcularAntiguedadEnPantalla(fechaIngreso) {
    var anios = calcularAnios(fechaIngreso);
    var spanAntiguedad = document.getElementById('spanAntiguedadCalculada');

    if (spanAntiguedad) {
        spanAntiguedad.textContent = (anios === null) ? '--' : anios;
    }
}