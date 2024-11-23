import instrucciones.*
import enemigo.*
import personajes.*
import game.*
import interfazJuego.*
import configInterfaz.*
import tablero.*
import marco.*

object config{
    var property maximoTropas = 0
    method configurarTeclas() {
        self.controlesMarco()
        self.elegirCarta()
        self.reinicio()
        self.pausa()
	}
    method controlesMarco(){
		keyboard.left().onPressDo({marco.intentarMoverA(marco.position().left(1))})
		keyboard.right().onPressDo({marco.intentarMoverA(marco.position().right(1))})
		keyboard.up().onPressDo({marco.intentarMoverA(marco.position().up(1))})
		keyboard.down().onPressDo({marco.intentarMoverA(marco.position().down(1))})
    }
    method elegirCarta(){
        keyboard.num1().onPressDo({if(tablero.tropas(equipoAzul).size() < self.maximoTropas()) tablero.agregarEntidad(new Monje(position = marco.position(),equipo = equipoAzul))})
        keyboard.num2().onPressDo({if(tablero.tropas(equipoAzul).size() < self.maximoTropas()) tablero.agregarEntidad(new Arquero(position = marco.position(),equipo = equipoAzul))})
        keyboard.num3().onPressDo({if(tablero.tropas(equipoAzul).size() < self.maximoTropas())tablero.agregarEntidad(new Infanteria(position = marco.position(),equipo = equipoAzul))})
    }

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
    const musicaAmbiente = game.sound('musica-ambiente.mp3')
    const sonidoDerrota = game.sound("derrota.mp3")
    const sonidoVictoria = game.sound("sonido-victoria.mp3")
    
    method iniciarJuego(){
        if (!estaIniciado){
            estaIniciado = true
            tablero.agregarEntidad(new Torre(position = game.at(17, 11),equipo = equipoRojo))
            tablero.agregarEntidad(new Torre(position = game.at(21,7),equipo = equipoRojo))
            tablero.agregarEntidad(new Torre(position = game.at(17,3),equipo = equipoRojo))
            tablero.agregarEntidad(new Torre(position = game.at(6,11),equipo = equipoAzul))
            tablero.agregarEntidad(new Torre(position = game.at(2,7),equipo = equipoAzul))
            tablero.agregarEntidad(new Torre(position = game.at(6,3),equipo = equipoAzul))
            musicaAmbiente.volume(0.3)
            musicaAmbiente.shouldLoop(true)
            musicaAmbiente.play()
        }
    }
    method ganar(){
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
            musicaAmbiente.stop()
            self.pausar()
            tablero.limpiar()
            instrucciones.estaCerrado(false)
            // // Visualizar interfaz otra vez
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
        sonidoDerrota.volume(0.3)
        sonidoDerrota.play()
        self.pausar()
        game.addVisual(notificacionDeDerrota)
    }
}