import enemigo.*
import config.*
class Entidad{
  var vida
  var danio
  var equipo
  var position
  method equipo() = equipo
  method position() = position
  method cumplirObjetivoInicial()

  //indicador de vida
  method textColor() = equipo.color()
  method text() = vida.stringValue()

  method recibirDanio(cantDanio){
    vida -= cantDanio
    if(vida <= 0){
      self.morir()
    }
  }
  method morir(){
    tablero.borrarEntidad(self)
    const sonidoMuerte = game.sound("sonido-muerte.mp3")
    sonidoMuerte.volume(0.1)
    sonidoMuerte.play()
  }
  method cambiarDeEquipo(){}
}

class Personaje inherits Entidad{
  override method cambiarDeEquipo(){
    equipo = equipo.contrario()
  }

  override method cumplirObjetivoInicial(){
    self.irATorreMasCercana()
  }

  method irATorreMasCercana(){
    game.onTick(1000, "comportamiento", {self.moveteHaciaTorreEnemigaMasCercanaSiHay()})
  }

  method irA(unaPosicion){
    game.onTick(1000, "comportamiento", {self.moveteHacia(unaPosicion)})
  }

  method moveteHaciaTorreEnemigaMasCercanaSiHay(){
    if(vida > 0){
      if(not tablero.torres(equipo.contrario()).isEmpty()){
        self.moveteHacia(tablero.posicionTorreEnemigaMasCercanaA(self))
      }
    }
  }


  // method moveteHacia(unaPosicion){
  //   const proximaPosicion =  self.proximaPosicionHacia(unaPosicion)
  //   if(position != proximaPosicion and tablero.hayAlgoEn(proximaPosicion)){
  //     const objetivo = tablero.entidadEn(proximaPosicion)
  //     if(objetivo.equipo() != equipo){
  //       self.atacar(tablero.entidadEn(proximaPosicion))
  //     }
  //   }
  //   else{
  //     position = proximaPosicion
  //   }
  //}

  method moveteHacia(unaPosicion){
    const proximaPosicion =  self.proximaPosicionHacia(unaPosicion)
    if(position != proximaPosicion and (tablero.hayAlgoAlrededor(self.position(), self) or tablero.hayAlgoEn(proximaPosicion))){
      const objetivos = tablero.enemigosAlRededor(self.position(), self)
      objetivos.forEach({
        objetivo => self.atacar(objetivo)
      })
    }
    else{
      position = proximaPosicion
    }
  }

  method proximaPosicionHacia(unaPosicion){
    if (position.y() < unaPosicion.y())
      return position.up(1)
    else if (position.y() > unaPosicion.y())
      return position.down(1)
    else if (position.x() < unaPosicion.x())
      return position.right(1)
    else if (position.x() > unaPosicion.x())
      return position.left(1)
    else
      return position
  }


  method atacar(unPersonaje){
      unPersonaje.recibirDanio(danio)
      const sonidoAtaque = game.sound("sonido-ataque")
      sonidoAtaque.play()
  }

}

class Monje inherits Personaje(vida = 50, danio = 2){
  //puede cambiar de bando a otros, sanar alrededor
  // el equipo es "Rojo" o "Azul"

  method tipo() = "Unidad"
  method image() = "monje"+ equipo.name() +".png"
  method nombre() = "monje"

  override method irATorreMasCercana(){
    game.onTick(3000, "comportamiento", {self.moveteHaciaTorreEnemigaMasCercanaSiHay()})
  }
  override method atacar(unPersonaje){
    unPersonaje.cambiarDeEquipo()
    unPersonaje.image()
    const sonidoAtaque = game.sound("wololo.mp3")
    sonidoAtaque.volume(0.3)
    sonidoAtaque.play()
  }
}

class Infanteria inherits Personaje(vida = 50, danio = 10){
  method tipo() = "Unidad"
  method image() = "infanteria"+ equipo.name() +".png"
  method nombre() = "Infantería"
}

class Arquero inherits Personaje(vida = 20, danio = 8){
  const property rango = 3 // Rango de ataque del arquero

  method tipo() = "Unidad"
  method image() = "arquero" + equipo.name() + ".png"
  method nombre() = "Arquero"

  // Método para atacar considerando el rango
  override method atacar(unPersonaje){
    if (self.estaEnRango(unPersonaje.position())) { // Verifica si está dentro del rango
      unPersonaje.recibirDanio(danio) // Inflige daño
      const sonidoAtaque = game.sound("sonido-ataque-arquero")
      sonidoAtaque.play()
    }
  }

  // Verifica si una posición está dentro del rango del arquero
  method estaEnRango(unaPosicion) =
    position.distance(unaPosicion) <= rango

  // Movimiento hacia la torre más cercana o ataques a distancia
  override method moveteHaciaTorreEnemigaMasCercanaSiHay(){
    if (vida > 0) {
      const torreEnemiga = tablero.torreMasCercanaA(position, equipo.contrario())
      if (torreEnemiga != null) {
        if (self.estaEnRango(torreEnemiga.position())) {
          self.atacar(torreEnemiga)
        } else {
          self.moveteHacia(torreEnemiga.position())
        }
      }
    }
  }
}


object equipoRojo {
  method name()= "Rojo"
  method contrario() = equipoAzul
  method color() = paleta.rojo()
}


object equipoAzul{
  method name()= "Azul"
  method contrario() = equipoRojo
  method color() = paleta.verde()
}

class Torre inherits Entidad(vida = 200, danio = 10){
  method tipo() = "Torre"
  method image() = "castillo"+equipo.name()+".png"
  override method cumplirObjetivoInicial(){
    game.onTick(1000, "comportamiento", {self.atacarAlRededor()})
  }

  method atacarAlRededor(){
    //obtiene todos los enemigos a su aldedor
    //les hace daño
    if(vida > 0)
      tablero.enemigosAlRededor(self.position(),self).forEach({e=> e.recibirDanio(danio)})
  }

  override method morir(){
    super()
    const sonidoDestruccion = game.sound("sonido-destruccion.mp3")
    sonidoDestruccion.volume(0.1)
    sonidoDestruccion.play()

    if(self.esLaUltimaTorre()){
      if(equipo == equipoRojo){
        juego.ganar()
      }
      if(equipo == equipoAzul){
        juego.perder()
      }
    }
  }
  method esLaUltimaTorre() = tablero.torres(equipo).isEmpty()

  method atacar(unPersonaje){
    unPersonaje.recibirDanio(danio)
    const sonidoAtaque = game.sound("trompeta.mp3")
    sonidoAtaque.volume(0.1)
    sonidoAtaque.play()
  }
}

object marco{
  var property position = game.at(0,0)
  var property puedeMoverse = true
  method image() = "marco.png"
  method moverA(unaPosicion){
    if(unaPosicion.x() >= 0 and unaPosicion.x() < game.width() and
       unaPosicion.y() >= 0 and unaPosicion.y() < (game.height() / 2) and puedeMoverse)
    {
      position = unaPosicion
    }
  }
}
object tablero{
  const property entidadesActivas = []

  method agregarEntidad(unaEntidad){
    game.addVisual(unaEntidad)
    entidadesActivas.add(unaEntidad)
    unaEntidad.cumplirObjetivoInicial()
  }

  method descongelarEntidades(){
    entidadesActivas.forEach({e => e.cumplirObjetivoInicial()})
  }
  method congelarEntidades(){

  }

  method borrarEntidad(unaEntidad){
    entidadesActivas.remove(unaEntidad)
    game.removeVisual(unaEntidad)
  }

  method torres(equipo) = 
    entidadesActivas.filter({entidad => entidad.tipo() == "Torre" and entidad.equipo() == equipo})

  method torreMasCercanaA(unaPosicion,equipo){
    return self.torres(equipo).min({torre => torre.position().distance(unaPosicion)})
  }

  method tropas(equipo) = entidadesActivas.filter({entidad=>entidad.tipo() == "Unidad" and entidad.equipo() == equipo})
  method cantTropas(equipo) = self.tropas(equipo).size()

  method tropaMasCercanaA(unaPosicion, equipo){
    return self.tropas(equipo).min({tropa => tropa.position().distance(unaPosicion)})
  }

  method hayAlgoEn(unaPosicion)=
    entidadesActivas.any({entidad => entidad.position() == unaPosicion})

  method hayAlgoAlrededor(unaPosicion, tropa) {
    return entidadesActivas.any({entidad => entidad.position().distance(unaPosicion) == 1 and entidad.equipo() != tropa.equipo() and entidad.tipo() != "Torre"})  
  }


  method enemigosAlRededor(unaPosicion,tropa)=
    entidadesActivas.filter({entidad => entidad.position().distance(unaPosicion) == 1 and entidad.equipo() != tropa.equipo()})

  method limpiar(){
    self.entidadesActivas().forEach({e => game.removeVisual(e)})
    self.entidadesActivas().clear()
  }

  method entidadEn(unaPosicion) =
    entidadesActivas.find({entidad => entidad.position() == unaPosicion})
  

  method posicionTorreEnemigaMasCercanaA(unaEntidad){
    return self.torreMasCercanaA(unaEntidad.position(),unaEntidad.equipo().contrario()).position()
  }

}