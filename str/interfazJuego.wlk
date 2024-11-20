import configInterfaz.*
import personajes.*
import marco.*

object interfaz {
  const property position = game.at(0,0)
  const property image = "instrucciones.png"
  
  method aparecerInterfaz() {
    game.addVisual(self)
    game.removeVisual(marco)
  }

  method cerrarInterfaz() {
    game.removeVisual(self)
    game.addVisual(marco)
  }
}