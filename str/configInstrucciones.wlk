import instrucciones.*
import config.*
import interfazJuego.*
import enemigo.*
object configInstrucciones {
  method mostrarInstrucciones(){
      keyboard.c().onPressDo({
        self.avanzarInstrucciones()
      })
  }

  method avanzarInstrucciones() {
    instrucciones.cerrarInstrucciones()
    juego.iniciarJuego()
    juego.desPausar()
  }
}