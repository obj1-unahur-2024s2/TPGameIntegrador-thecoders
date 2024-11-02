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
  method textColor() = "00FF00FF"
  method text() = vida.stringValue()

  method recibirDanio(cantDanio){
    vida -= cantDanio
    if(vida<0){
      self.morir()
    }
  }
  method morir(){
    tablero.borrarEntidad(self)
    const sonidoMuerte = game.sound("sonido_muerte")
    sonidoMuerte.play()
  }
}

class Personaje inherits Entidad{
  override method cumplirObjetivoInicial(){
    self.irATorreMasCercana()
  }
  method irATorreMasCercana(){
    game.onTick(100, "movete", {self.moveteHaciaTorreEnemigaMasCercanaSiHay()})
  }
  method irA(unaPosicion){
    game.onTick(1000, "movete", {self.moveteHacia(unaPosicion)})
  }
  method moveteHaciaTorreEnemigaMasCercanaSiHay(){
    if(not tablero.torres(equipo.contrario()).isEmpty()){
      self.moveteHacia(tablero.posicionTorreEnemigaMasCercanaA(self))
    }
    else{
      game.removeTickEvent("movete")
    }
  }
  method moveteHacia(unaPosicion){
    const proximaPosicion =  self.proximaPosicionHacia(unaPosicion)
    if(position != proximaPosicion and tablero.hayAlgoEn(proximaPosicion)){
      const objetivo = tablero.entidadEn(proximaPosicion)
      if(objetivo.equipo() != equipo){
        self.atacar(tablero.entidadEn(proximaPosicion))
      }
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

  method mejorar() {
    self.efectoMejora()
  }

  method efectoMejora()

  method atacar(unPersonaje){
    unPersonaje.recibirDanio(danio)
    const sonidoAtaque = game.sound("sonido_ataque")
    sonidoAtaque.play()
  }
}

class Monje inherits Personaje(vida = 5, danio = 2){
  //puede cambiar de bando a otros, sanar alrededor
  // el equipo es "Rojo" o "Azul"

  method tipo() = "Unidad"
  method image() = "monje"+ equipo.name() +".png"
  method nombre() = "monje"

  override method efectoMejora(){}
}
class Infanteria inherits Personaje(vida = 50, danio = 10){
  var image =  "infanteria"+ equipo.name() +".png"
  method tipo() = "Unidad"
  method edificioDondeSeMejora() = "Cuartel"
  method image() = image
  method nombre() = "infanteria"

  override method efectoMejora() {
    image = "campeon_age.png"
    vida = 70
    danio = 20
  }
}
class Arquero inherits Personaje(vida = 20, danio = 8){
  var image = "arquero"+ equipo.name() +".png"
  method tipo() = "Unidad"
  method image() = image
  method nombre() = "arquero"
  method edificioDondeSeMejora() = "Arqueria"
  
  override method efectoMejora() {
    image = "ballestero_age.png"
    danio = 12
    vida = 30
  }
}
object equipoRojo{
  method name()= "Rojo"
  method contrario() = equipoAzul
}
object equipoAzul{
  method name()= "Azul"
  method contrario() = equipoRojo
}

class Torre inherits Entidad(vida = 200, danio = 10){
  method tipo() = "Torre"
  method image() = "castillo"+equipo.name()+".png"
  override method cumplirObjetivoInicial(){}

  override method morir(){
    super()
    if(self.esLaUltimaTorre()){
      if(equipo == equipoRojo){
        config.ganar()
      }
    }
  }
  method esLaUltimaTorre() = tablero.torres(equipo).isEmpty()

  method atacar(unPersonaje){
    unPersonaje.recibirDanio(danio)
    const sonidoAtaque = game.sound("sonido_ataque")
    sonidoAtaque.play()
  }
}

class Estructura inherits Entidad {
  var tropaDentro = null
  method image()
  method tipo()

  method ponerTropa(unaTropa) {
    tropaDentro = unaTropa
  }

  override method cumplirObjetivoInicial(){
    self.mejorarTropa()
  }

  method mejorarTropa(){
    if (tropaDentro != null and tropaDentro.edificioDondeSeMejora() == self.tipo()) {
      tropaDentro.mejorar()
    }
  }
}

class Cuartel inherits Estructura(vida = 100, danio = 0) {
  override method image() {
    return "cuartel_age.png"
  } 

  override method tipo() {
    return "Cuartel"
  }
}

class Arqueria inherits Estructura(vida=50, danio=0) {
  override method image() {
    return "arqueria_age.png"
  }

  override method tipo() {
    return "Arqueria"
  }
}

object marco{
  var property position = game.at(0,0)
  method image() = "marco.png"
}
object tablero{
  const property entidadesActivas = []
  method agregarEntidad(unaEntidad){
    game.addVisual(unaEntidad)
    entidadesActivas.add(unaEntidad)
    unaEntidad.cumplirObjetivoInicial()
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

  method hayAlgoEn(unaPosicion)=
    entidadesActivas.any({entidad => entidad.position() == unaPosicion})

  method entidadEn(unaPosicion) =
    entidadesActivas.find({entidad => entidad.position() == unaPosicion})

  method posicionTorreEnemigaMasCercanaA(unaEntidad){
    return self.torreMasCercanaA(unaEntidad.position(),unaEntidad.equipo().contrario()).position()
  }
}
// class PersonajeRango inherits Personaje{

// }
// class PersonajeMele inherits Personaje{

// }
// class Estructura inherits Entidad{

// }
// object monje2{
//   var property position = game.at(3, 15) 
//   var property image = "monjestandingDownBlue0.png"
// }
// object monje{
//   var equipo = equipoAzul
//   method danio() = 10
//   var position = game.at(5, 5) 
//   method position() = position
//   method fotograma(personaje,pose,direccion,color,numero){
//     return personaje+pose+direccion+color+numero+".png"
//   }
//   method image() = self.fotograma('monje','walking','Down','Red','2')
  
//   method irA(unaPosicion){
//     game.onTick(1000, "movete", {self.moveteHacia(unaPosicion)})
//   }
//   method moveteHacia(unaPosicion){
//     const proximaPosicion =  self.proximaPosicionHacia(unaPosicion)
//     if(position != proximaPosicion and tablero.hayAlgoEn(proximaPosicion)){
//       const objetivo = tablero.entidadEn(proximaPosicion)
//       if(objetivo.equipo() != equipo){
//         self.atacar(tablero.entidadEn(proximaPosicion))
//       }
//     }
//     else{
//       position = proximaPosicion
//     }
//   }
//   method proximaPosicionHacia(unaPosicion){
//     if (position.x() < unaPosicion.x()){
//       return position.right(1)
//     }
//     else if (position.x() > unaPosicion.x()){
//       return position.left(1)
//     }
//     else if (position.y() < unaPosicion.y()){
//       return position.up(1)
//     }
//     else if (position.y() > unaPosicion.y()){
//       return position.down(1)
//     }
//     else{
//       return position
//     }
//   }
//   method atacar(unPersonaje){
//     unPersonaje.recibirDanio(self.danio())
//   }
// }
