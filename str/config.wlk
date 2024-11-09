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
		keyboard.up().onPressDo({if(marco.position().y()< game.height()-1) marco.position(marco.position().up(1))})
		keyboard.down().onPressDo({if(marco.position().y()>0) marco.position(marco.position().down(1))})
    }
    method elegirCarta(){
        keyboard.num1().onPressDo({tablero.agregarEntidad(new Monje(position = marco.position(),equipo = equipoAzul))})
        keyboard.num2().onPressDo({tablero.agregarEntidad(new Arquero(position = marco.position(),equipo = equipoAzul))})
        keyboard.num3().onPressDo({tablero.agregarEntidad(new Infanteria(position = marco.position(),equipo = equipoAzul))})
    }
    method ponerMusica() {
        const sonidoAmbiente = game.sound("sonido_ambiente.mp3")
        sonidoAmbiente.shouldLoop(true)
        sonidoAmbiente.volume(0.2)
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