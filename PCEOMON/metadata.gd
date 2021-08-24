extends Node2D


#######################
##COMBAT VARIABLES#####

# ESTAS DOS VARIABLES GUARDAN EL NOMBRE DE LOS PCEOMONES EN LA PARTY
# Y LA RUTA A SU OBJETO.
var party = []
var party_paths = []
var items = ["Bocata","Ducha bluetooth","Fuente de macarras","Garrafa de paellas", "Monster","Pulsera del Murcia"]
var item_paths = ["res://GameScenes/Menues/Objects/Bocata/Bocata.tscn",
		"res://GameScenes/Menues/Objects/Ducha bluetooth/Ducha bluetooth.tscn",
		"res://GameScenes/Menues/Objects/Fuente de macarras/Fuente de macarras.tscn",
		"res://GameScenes/Menues/Objects/Garrafa de paellas/Garrafa de paellas.tscn",
		"res://GameScenes/Menues/Objects/Monster/Monster.tscn",
		"res://GameScenes/Menues/Objects/Pulsera del Murcia/Pulsera del Murcia.tscn"]
var dimensions = {} #ESTO CONTIENE LAS "DIMENSIONES" QUE HAY EN EL JUEGO,
# DE MODO QUE LOS R4 FUNCIONEN BIEN. La "llave" es el nombre del PCEOMÓN que
# tiene el mapa y los valores es un array que contiene a los pceomones que están
# dentro.

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
var first : bool = true # Esto se usa...?
