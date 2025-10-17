module liga_deportiva::liga_deportiva {
    use std::string::String;
    use sui::vec_map::{VecMap, Self};

    public struct Liga has key {
        id: UID,
        nombre: String,
        equipos: VecMap<IDEquipo, Equipo>,
    }

    public struct Equipo has store, drop, copy {
        nombre: String,
        ciudad: String,
        jugadores: VecMap<IDJugador, Jugador>,
    }

    public struct Jugador has store, drop, copy {
        nombre: String,
        edad: u8,
        posicion: String,
        activo: bool,
    }

    public struct IDEquipo has store, drop, copy {
        value: u16
    }

    public struct IDJugador has store, drop, copy {
        value: u16
    }

    public fun crear_liga(nombre: String, ctx: &mut TxContext) {
        let liga = Liga {
            id: object::new(ctx),
            nombre,
            equipos: vec_map::empty(),
        };

        transfer::transfer(liga, tx_context::sender(ctx));
    }

    public fun agregar_equipo(nombre: String, ciudad: String, id_equipo: u16, liga: &mut Liga){
        let equipo = Equipo {
            nombre,
            ciudad,
            jugadores: vec_map::empty(),
        };

        let ide = IDEquipo { value: id_equipo };

        liga.equipos.insert(ide, equipo);
    }

    public fun eliminar_equipo(id_equipo: u16, liga: &mut Liga){
        let ide = IDEquipo { value: id_equipo };
        liga.equipos.remove(&ide);
    }

    public fun agregar_jugador(nombre: String, edad: u8, posicion: String, id_jugador: u16, id_equipo: u16, liga: &mut Liga){
        let ide = IDEquipo { value: id_equipo };
        let equipo = liga.equipos.get_mut(&ide);

        let jugador = Jugador {
            nombre,
            edad,
            posicion,
            activo: true,
        };

        let idj = IDJugador { value: id_jugador };
        equipo.jugadores.insert(idj, jugador);
    }

    public fun eliminar_jugador(id_jugador: u16, id_equipo: u16, liga: &mut Liga){
        let ide = IDEquipo { value: id_equipo };
        let equipo = liga.equipos.get_mut(&ide);

        let idj = IDJugador { value: id_jugador };
        equipo.jugadores.remove(&idj);
    }

    public fun actualizar_estado_jugador(id_jugador: u16, id_equipo: u16, liga: &mut Liga){
        let ide = IDEquipo { value: id_equipo };
        let equipo = liga.equipos.get_mut(&ide);

        let idj = IDJugador { value: id_jugador };
        let jugador = equipo.jugadores.get_mut(&idj);
        jugador.activo = !jugador.activo;
    }

    public fun editar_nombre_equipo(id_equipo: u16, nombre: String, liga: &mut Liga){
        let ide = IDEquipo { value: id_equipo };
        let equipo = liga.equipos.get_mut(&ide);
        equipo.nombre = nombre;
    }

    public fun eliminar_liga(liga: Liga) {
        let Liga { id, equipos: _, nombre: _ } = liga;
        id.delete();
    }

}
