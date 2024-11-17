import configInterfaz.*
import personajes.*

object interfaz {
  const property position = game.at(0,0)
  const property image = "popup-nuevo.png"

  method aparecerInterfaz() {
    game.addVisual(self)
  }

  method cerrarInterfaz() {
    game.removeVisual(self)
    game.addVisual(marco)
  }
}