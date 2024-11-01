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
		keyboard.up().onPressDo({if(marco.position().y()< alturaMax) marco.position(marco.position().up(1))})
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
}