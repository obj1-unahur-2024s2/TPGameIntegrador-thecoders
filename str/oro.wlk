import tablero.*
import config.*

object oro {
  var oroActual = 5
  const oroMaximo = 10
  method oroActual()= oroActual

  method regenerarOro() {
        if (oroActual < oroMaximo) {
            oroActual = oroActual + 1
        }
    }
  method gastarOro(cantidad) {
      if (oroActual >= cantidad) {
          oroActual = oroActual - cantidad
      } 
  }
  method reiniciarOro() {
    oroActual = 5
  }
  const property position = game.at(0,10)
  method text() = "Oro: " + oroActual
  method textColor() = paleta.rojo()
  method mostrarOro() {
    game.addVisual(self)
  }
  method borrarOro() {
    game.removeVisual(self)
  }
}
