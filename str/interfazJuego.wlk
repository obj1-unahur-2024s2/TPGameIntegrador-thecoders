import configInterfaz.*
import personajes.*

object interfaz {
  const property position = game.at(0,0)
  const property image = "papiro-interfaz.png"
  
  method aparecerInterfaz() {
    game.addVisual(self)
    game.removeVisual(marco)
  }

  method cerrarInterfaz() {
    game.removeVisual(self)
    game.addVisual(marco)
  }
}