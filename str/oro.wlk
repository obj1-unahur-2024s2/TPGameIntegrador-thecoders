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
  method oroSuficiente(unaEntidad) {
    var suficiente = false
    if (oroActual >= unaEntidad.costo()) {
      suficiente = true
    }
    return suficiente
  }
  const property position = game.at(0,10)
  method image() =""+oroActual+"-oro.png"
  method mostrarOro() {
    game.addVisual(self)
  }
  method borrarOro() {
    game.removeVisual(self)
  }
}
