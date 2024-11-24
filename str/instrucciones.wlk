import marco.*
import config.*

object instrucciones {
  const property position = game.at(0,0)
  const property image = "instrucciones-wollolok-2.png"
  var property estaCerrado = false
  
  method aparecerInstrucciones() {
    game.addVisual(self)
  }

  method cerrarInstrucciones() {
    if (!estaCerrado) {
      estaCerrado = true  
      game.removeVisual(self)
      juego.desPausar()
      juego.iniciarJuego()
      game.addVisual(marco)
    }
  }
}