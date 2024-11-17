import personajes.*
import config.*
object enemigo{
    const property personajes = ["infanteria"]
    var property maximoTropasEnemigo = 0
    method initialize(){
        game.onTick(3000, "ponerEnemigo", {self.ponerEnemigoAleatorio()})
    }
    method ponerEnemigoAleatorio(){
        if(tablero.tropas(equipoRojo).size() < maximoTropasEnemigo)tablero.agregarEntidad(new Infanteria(position = self.posicionAleatoriaEnemiga() ,equipo = equipoRojo))
    }
    method posicionAleatoriaEnemiga(){
        return 	game.at( 
					(0 .. game.width() - 1 ).anyOne(),
					(12..  game.height() - 1).anyOne()
		) 
    }
}