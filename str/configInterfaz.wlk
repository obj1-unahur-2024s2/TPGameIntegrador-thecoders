import config.*
import interfazJuego.*
import enemigo.*
object configInterfaz {
  method seleccionarDificultad(){
      keyboard.d().onPressDo({
        config.maximoTropas(7)
        enemigo.maximoTropasEnemigo(10)
        interfaz.cerrarInterfaz()
      })
      keyboard.f().onPressDo({
        config.maximoTropas(5)
        enemigo.maximoTropasEnemigo(5)
        interfaz.cerrarInterfaz()
      })
  }
}