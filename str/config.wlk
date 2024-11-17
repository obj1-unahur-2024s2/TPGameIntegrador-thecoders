import personajes.*
import game.*
object config{
    const alturaMax = 11
    var property maximoTropas = 0
    method configurarTeclas() {
        self.controlesMarco()
        self.elegirCarta()
        self.reinicio()
        self.pausa()
	}

    method ponerMusica() {
        const musicaAmbiente = game.sound("sonido-ambiente.mp3")
	    musicaAmbiente.volume(0.2)
        musicaAmbiente.shouldLoop(true)
	    musicaAmbiente.play()
    }

    method controlesMarco(){
		keyboard.left().onPressDo({if(marco.position().x()>0) marco.position(marco.position().left(1))})
		keyboard.right().onPressDo({if(marco.position().x()< game.width()-1) marco.position(marco.position().right(1))})
		keyboard.up().onPressDo({if(marco.position().y()< (game.height() / 2 -1)) marco.position(marco.position().up(1))})
		keyboard.down().onPressDo({if(marco.position().y()>0) marco.position(marco.position().down(1))})
    }


    method elegirCarta(){
        keyboard.num1().onPressDo({if(tablero.tropas(equipoAzul).size() < self.maximoTropas()) tablero.agregarEntidad(new Monje(position = marco.position(),equipo = equipoAzul))})
        keyboard.num2().onPressDo({if(tablero.tropas(equipoAzul).size() < self.maximoTropas()) tablero.agregarEntidad(new Arquero(position = marco.position(),equipo = equipoAzul))})
        keyboard.num3().onPressDo({if(tablero.tropas(equipoAzul).size() < self.maximoTropas())tablero.agregarEntidad(new Infanteria(position = marco.position(),equipo = equipoAzul))})
    }
    
    // method ponerMusica() {
    //     // const sonidoAmbiente = game.sound("sonido-victoria.mp3")
    //     // game.sound("sonido-victoria.mp3")
    //     // sonidoAmbiente.shouldLoop(true)
    //     // sonidoAmbiente.volume(0.2)
    //     const rain = game.sound("sonido-ambiente.mp3")
    //     rain.shouldLoop(true)
    //     game.schedule(500, { rain.play()} )
    // }
    method ganar(){
        game.sound("sonido-victoria.mp3").play()
        game.schedule(3000, {game.stop()})
        game.addVisual(notificacionDeVictoria)
        game.addVisual(notificacionDeReinicio)
    }

    method reinicio() {
        keyboard.r().onPressDo({game.start()})     
    }

    method pausa() {
        var estaPausado = false
        keyboard.p().onPressDo({
            estaPausado != estaPausado
            if (!estaPausado) {
                game.stop()
            } else{
                game.start()
            }
        })
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
    const property white = "FAFAFA"
}

object notificacionDeVictoria {

    method position() = game.center()

    method text() = "HAS GANADO!!!!"

    method textColor() = paleta.verde()
}

object notificacionDeReinicio {
    method position()=game.at(6, 14)
    method text() = "Pulsa la tecla 'R' para reiniciar"
    method textColor() = paleta.white()
}
object notificacionDeDerrota {

    method position() = game.center()

    method text() = "A CASA MALO PERDISTE (exclamó el enemigo)"

    method textColor() = paleta.rojo()
}