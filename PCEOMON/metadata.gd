extends Node2D


#######################
##COMBAT VARIABLES#####

# ESTAS DOS VARIABLES GUARDAN EL NOMBRE DE LOS PCEOMONES EN LA PARTY
# Y LA RUTA A SU OBJETO.
var party = []
var party_paths = []

# ESTA VARIABLE INDICA CUÁNTOS PCEOMONES ESTÁN ESPERANDO PARA ATACAR,
# CUANDO SU TAMAÑO SEA DISTINTO DE 0, EL TIEMPO "NO EXISTIRÁ" Y NO TRASCURRIRÁ
var time_exists = []
var freeze_time = false

func time_should_run():
	if (time_exists.size() == 0 and not freeze_time):
		return true
	return false

# ESTA VARIABLE ES UN ARRAY DOBLE QUE ALMACENA QUÉ POSICION DEBE DE 
# TENER CADA PCEOMÓN EN PANTALLA DURANTE EL COMBATE.
var combat_position = [ [10, 100], [70, 10], [150, 30], [100, 150], [180, 180] ]

# BOOLEANO PARA VER SI ESTAMOS EN FULLSCREEN O NO
var fullscreen : bool = false
var first : bool = true
