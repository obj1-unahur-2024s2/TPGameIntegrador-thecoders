import enemigo.*
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

    // method ponerMusica() {
    //     const musicaAmbiente = game.sound("sonido-ambiente.mp3")
	//     musicaAmbiente.volume(0.2)
    //     musicaAmbiente.shouldLoop(true)
	//     musicaAmbiente.play()
    // }

    method controlesMarco(){
		keyboard.left().onPressDo({marco.moverA(marco.position().left(1))})
		keyboard.right().onPressDo({marco.moverA(marco.position().right(1))})
		keyboard.up().onPressDo({marco.moverA(marco.position().up(1))})
		keyboard.down().onPressDo({marco.moverA(marco.position().down(1))})
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
        const sonidoVictoria = game.sound("sonido-victoria.mp3")
        sonidoVictoria.volume(0.5)
        sonidoVictoria.play()
        game.schedule(1000, {game.stop()})
        game.addVisual(notificacionDeVictoria)
    }

    method reinicio() {
        keyboard.r().onPressDo({game.start()})     
    }

    method pausa() {
        var estaPausado = false
        keyboard.p().onPressDo({
            estaPausado != estaPausado
            if (!estaPausado) {
                estaPausado = true
                self.pausar()
            } else{
                self.desPausar()
                estaPausado = false
            }
        })
    }
    method pausar(){
        game.removeTickEvent("comportamiento")
    }
    method desPausar(){
        enemigo.initialize()
    }

    method perder(){
        const sonidoDerrota = game.sound("derrota.mp3")
        sonidoDerrota.volume(0.3)
        sonidoDerrota.play()
        game.addVisual(notificacionDeDerrota)
    }
}

object paleta {
    const property verde = "00FF00FF"
    const property rojo = "FFC900"
    const property white = "FAFAFA"
}

object notificacionDeVictoria {

    method position() = game.center()

    method text() = "HAS GANADO!!!!"

    method textColor() = paleta.verde()
}

object notificacionDeDerrota {

    method position() = game.center()

    method text() = "A CASA MALO PERDISTE (exclamó el enemigo)"

    method textColor() = paleta.rojo()
}