import personajes.*
import config.*
object enemigo{
    const property personajes = ["infanteria","arquero","monje"]
    var property maximoTropasEnemigo = 0
    method iniciar(){
        game.onTick(3000, "comportamiento", {self.ponerEnemigoAleatorio()})
    }
    method ponerEnemigoAleatorio(){
        const personaje = personajes.anyOne()
        if(tablero.tropas(equipoRojo).size() < maximoTropasEnemigo){
            if(personaje == "Infanteria")
                tablero.agregarEntidad(new Infanteria(position = self.posicionAleatoriaEnemiga() ,equipo = equipoRojo))
            else if(personaje == "arquero")
                tablero.agregarEntidad(new Arquero(position = self.posicionAleatoriaEnemiga() ,equipo = equipoRojo))
            else if(personaje == "monje")
                tablero.agregarEntidad(new Monje(position = self.posicionAleatoriaEnemiga() ,equipo = equipoRojo))
        }   
    }
    method posicionAleatoriaEnemiga(){
        return 	game.at( 
					(0 .. game.width() - 1 ).anyOne(),
					(12..  game.height() - 1).anyOne()
		) 
    }
}