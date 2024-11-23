import marco.*
import config.*

object instrucciones {
  const property position = game.at(0,0)
  const property image = "instrucciones-facil.png"
  
  method aparecerInstrucciones() {
    game.addVisual(self)
  }

  method cerrarInstrucciones() {
    game.removeVisual(self)
    juego.iniciarJuego()
    juego.desPausar()
    game.addVisual(marco)
  }
}