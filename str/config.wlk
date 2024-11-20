import enemigo.*
import personajes.*
import game.*
import interfazJuego.*
import configInterfaz.*

object config{
    var property maximoTropas = 0
    method configurarTeclas() {
        self.controlesMarco()
        self.elegirCarta()
        self.reinicio()
        self.pausa()
	}
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
    method reinicio() {
        keyboard.r().onPressDo({juego.reiniciar()})     
    }
    method pausa() {
        var estaPausado = false
        keyboard.p().onPressDo({
            estaPausado != estaPausado
            if (!estaPausado) {
                estaPausado = true
                juego.pausar()
            } else{
                juego.desPausar()
                estaPausado = false
            }
        })
    }
    method ponerMusica() {
        const musicaAmbiente = game.sound('sonido-ambiente.mp3')
        musicaAmbiente.volume(0.5)
        musicaAmbiente.play()
    }
}

object paleta {
    const property verde = "00FF00FF"
    const property rojo = "FFC900"
    const property white = "FAFAFA"
}

object notificacionDeVictoria {
    method position() = game.center()
    method text() = "HAS GANADO!!!!  presiona R para reintentar"
    method textColor() = paleta.verde()
}

object notificacionDeDerrota {

    method position() = game.center()
    method text() = "A CASA MALO PERDISTE (exclamó el enemigo)  presiona R para reintentar"
    method textColor() = paleta.rojo()
}

object juego {
    var property estaIniciado = false
    method iniciarJuego(){
        estaIniciado = true
        tablero.agregarEntidad(new Torre(position = game.at(7,21),equipo = equipoRojo))
	    tablero.agregarEntidad(new Torre(position = game.at(3,17),equipo = equipoRojo))
        tablero.agregarEntidad(new Torre(position = game.at(11,17),equipo = equipoRojo))
        tablero.agregarEntidad(new Torre(position = game.at(7,2),equipo = equipoAzul))
        tablero.agregarEntidad(new Torre(position = game.at(3,6),equipo = equipoAzul))
        tablero.agregarEntidad(new Torre(position = game.at(11,6),equipo = equipoAzul))
    }
    method ganar(){
        const sonidoVictoria = game.sound("sonido-victoria.mp3")
        sonidoVictoria.volume(0.3)
        sonidoVictoria.play()
        self.pausar()
        game.addVisual(notificacionDeVictoria)
    }
    method reiniciar(){
        if(estaIniciado){
            game.removeVisual(notificacionDeVictoria)
            game.removeVisual(notificacionDeDerrota)
            estaIniciado = false
            self.pausar()
            tablero.limpiar()
            // // Visualizar interfaz
            interfaz.aparecerInterfaz()
            configInterfaz.reiniciar()
            configInterfaz.seleccionarDificultad()
        }
    }
    method pausar(){
        game.removeTickEvent("comportamiento")
        marco.puedeMoverse(false)
    }
    method desPausar(){
        enemigo.iniciar()
        marco.puedeMoverse(true)
        tablero.descongelarEntidades()
    }

    method perder(){
        const sonidoDerrota = game.sound("derrota.mp3")
        sonidoDerrota.volume(0.3)
        sonidoDerrota.play()
        self.pausar()
        game.addVisual(notificacionDeDerrota)
    }
}