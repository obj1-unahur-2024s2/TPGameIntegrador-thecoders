import personajes.*
object enemigo{
    const property personajes = ["infanteria"]
    // var oro = 0
    method initialize(){
        game.onTick(3000, "ganar oro", {self.ponerEnemigoAleatorio()})
    }
    method ponerEnemigoAleatorio(){
        tablero.agregarEntidad(new Infanteria(position = self.posicionAleatoriaEnemiga() ,equipo = equipoRojo))
    }
    method posicionAleatoriaEnemiga(){
        return 	game.at( 
					(0 .. game.width() - 1 ).anyOne(),
					(12..  game.height() - 1).anyOne()
		) 
    }
    // method ganarOro(cantidad){
    //     oro += cantidad
    // }
}