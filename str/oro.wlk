import tablero.*
import config.*

object oro {
  const property position = game.at(0,10)
  method text() = "Oro: " + tablero.oroActual()
  method mostrarOro() {
    game.addVisual(self)
  }
  method borrarOro() {
    game.removeVisual(self)
  }
}
