import personajes.*
import game.*
object config{
    const alturaMax = 11
    method configurarTeclas() {
        self.controlesMarco()
        self.elegirCarta()
	}
    method controlesMarco(){
		keyboard.left().onPressDo({if(marco.position().x()>0) marco.position(marco.position().left(1))})
		keyboard.right().onPressDo({if(marco.position().x()< game.width()-1) marco.position(marco.position().right(1))})
		keyboard.up().onPressDo({if(marco.position().y()< (game.height() / 2 -1)) marco.position(marco.position().up(1))})
		keyboard.down().onPressDo({if(marco.position().y()>0) marco.position(marco.position().down(1))})
    }

    // Tenemos que hacer la lógica para poder mejorar la tropa, pero para eso debemos identificar cual es la tropa
    // más cercana al marco en el que estamos posicionado (y que haya alguna de esas tropas)
    // method mejorarTropa(unaTropa){
    //     keyboard.num4().onPressDo({if(tablero.hayAlgunArquero()) tablero.tropaMasCercanaA().mejorarTropa()})
    // }

    method elegirCarta(){
        keyboard.num1().onPressDo({if(tablero.tropas(equipoAzul).size() < 5) tablero.agregarEntidad(new Monje(position = marco.position(),equipo = equipoAzul))})
        keyboard.num2().onPressDo({if(tablero.tropas(equipoAzul).size() < 5) tablero.agregarEntidad(new Arquero(position = marco.position(),equipo = equipoAzul))})
        keyboard.num3().onPressDo({if(tablero.tropas(equipoAzul).size() < 5)tablero.agregarEntidad(new Infanteria(position = marco.position(),equipo = equipoAzul))})
    }
        
    method ponerMusica() {
        // const sonidoAmbiente = game.sound("sonido-victoria.mp3")
        // game.sound("sonido-victoria.mp3")
        // sonidoAmbiente.shouldLoop(true)
        // sonidoAmbiente.volume(0.2)
        const rain = game.sound("sonido-ambiente.mp3")
        rain.shouldLoop(true)
        game.schedule(500, { rain.play()} )
    }
    method ganar(){
        game.sound("sonido-victoria.mp3").play()
        game.schedule(3000, {game.stop()})
        game.addVisual(notificacionDeVictoria)
    }
    method perder(){
        game.sound("sonido-muerte.mp3").play()
        game.schedule(3000, {game.stop()})
        game.addVisual(notificacionDeDerrota)
    }
  //Regeneracion automatica del oro
    method iniciarRegeneracionOro() {
    game.onTick(1000, "regenerarOroEquipos", { 
        equipoRojo.regenerarOro()
        equipoAzul.regenerarOro()
    })
}
    // Método para mostrar oro en pantalla (No se como se hace todavia xd)
  //method mostrarOro() {
  //  game.displayText("Oro Rojo: " + equipoRojo.oro + " | Oro Azul: " + equipoAzul.oro, game.at(0, 0))
 // }
}

object paleta {
    const property verde = "00FF00FF"
    const property rojo = "FF0000FF"
}

object notificacionDeVictoria {

    method position() = game.center()

    method text() = "HAS GANADO!!!!"

    method textColor() = paleta.verde()
}
object notificacionDeDerrota {

    method position() = game.center()

    method text() = "A CASA MALO PERDISTE (exclamo el enemigo)"

    method textColor() = paleta.rojo()
}