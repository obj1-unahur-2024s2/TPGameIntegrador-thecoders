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
  method textColor() = "00FF00FF"
  method text() = vida.stringValue()

  method recibirDanio(cantDanio){
    vida -= cantDanio
    if(vida <= 0){
      self.morir()
    }
  }
  method morir(){
    tablero.borrarEntidad(self)
    const sonidoMuerte = game.sound("sonido_muerte")
    sonidoMuerte.play()
  }
  method cambiarDeEquipo(){}
}

class Personaje inherits Entidad{
  const costo //añado un costo 

  override method cambiarDeEquipo(){
    equipo = equipo.contrario()
  }

  override method cumplirObjetivoInicial(){
    self.irATorreMasCercana()
  }

  method irATorreMasCercana(){
    game.onTick(1000, "movete", {self.moveteHaciaTorreEnemigaMasCercanaSiHay()})
  }

  method irAEstructuraDeMejoraMasCercana() {
    game.onTick(1000, "movete", {self.moveteHaciaEstructuraMasCercana()})
  }
   // Verificar si hay suficiente oro para crear el personaje
  method puedeColocarse() = 
    equipo.tieneOro(costo)

  method colocarPersonaje() {
    if (self.puedeColocarse()) {
      equipo.gastarOro(costo) // Resta el costo de oro
      tablero.agregarEntidad(self) // Coloca el personaje en el tablero
    } else {
      throw("No hay suficiente oro para colocar el personaje")
    }
  }

  method irA(unaPosicion){
    game.onTick(1000, "movete", {self.moveteHacia(unaPosicion)})
  }

  method moveteHaciaTorreEnemigaMasCercanaSiHay(){
    if(vida > 0){
      if(not tablero.torres(equipo.contrario()).isEmpty()){
        self.moveteHacia(tablero.posicionTorreEnemigaMasCercanaA(self))
      }
    }
  }

  method moveteHaciaEstructuraMasCercana(){
    if(vida > 0){
      self.moveteHacia(tablero.posicionTorreEnemigaMasCercanaA(self))
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

  method mejorarPersonaje(unaEstructura) {
    if (unaEstructura == self.edificioDondeSeMejora()) {
      self.efectoMejora()
    }
  }

  method efectoMejora()
  method edificioDondeSeMejora()

  method atacar(unPersonaje){
    unPersonaje.recibirDanio(danio)
    const sonidoAtaque = game.sound("sonido_ataque")
    sonidoAtaque.play()
  }
}

class Monje inherits Personaje(vida = 50, danio = 2, costo = 3){
  //puede cambiar de bando a otros, sanar alrededor
  // el equipo es "Rojo" o "Azul"

  method tipo() = "Unidad"
  method image() = "monje"+ equipo.name() +".png"
  method nombre() = "monje"

  override method efectoMejora(){}
  override method edificioDondeSeMejora() = 'Monasterio'

  override method irATorreMasCercana(){
    game.onTick(3000, "movete", {self.moveteHaciaTorreEnemigaMasCercanaSiHay()})
  }
  override method atacar(unPersonaje){
    unPersonaje.cambiarDeEquipo()
    unPersonaje.image()
    const sonidoAtaque = game.sound("wololo.mp3")
    sonidoAtaque.play()
  }
}
class Infanteria inherits Personaje(vida = 50, danio = 10, costo = 6){
  method tipo() = "Unidad"
  method image() = "infanteria"+ equipo.name() +".png"
  method nombre() = "Infantería"
  override method edificioDondeSeMejora() = 'Cuartel'
  override method efectoMejora() {
    
    vida = 70
    danio = 20
  }

}
class Arquero inherits Personaje(vida = 20, danio = 8, costo = 4){
  var image = "arquero" + equipo.name() + ".png"
  const property rango = 3 // Rango de ataque del arquero

  method tipo() = "Unidad"
  method image() = image
  method nombre() = "Arquero"

  // Método para atacar considerando el rango
  override method atacar(unPersonaje){
    if (self.estaEnRango(unPersonaje.position())) { // Verifica si está dentro del rango
      unPersonaje.recibirDanio(danio) // Inflige daño
      const sonidoAtaque = game.sound("sonido_ataque")
      sonidoAtaque.play()
    }
  }

  // Verifica si una posición está dentro del rango del arquero
  method estaEnRango(unaPosicion) =
    position.distance(unaPosicion) <= rango

  // Movimiento hacia la torre más cercana o ataques a distancia
  override method moveteHaciaTorreEnemigaMasCercanaSiHay(){
    if (vida >= 0) {
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
  override method edificioDondeSeMejora() = 'Arqueria'
  // Mejora del arquero al convertirse en ballestero
  override method efectoMejora() {
    image = "ballestero_age.png"
    danio = 12
    vida = 30
  }
}


object equipoRojo {
  var oro = 10 // Oro inicial
  const property maxOro = 10 // Límite máximo de oro

  method name()= "Rojo"
  method contrario() = equipoAzul

  // Método para verificar si hay suficiente oro
  method tieneOro(cantidad) = oro >= cantidad

  // Método para gastar oro
  method gastarOro(cantidad) {
    if (self.tieneOro(cantidad)) {
      oro -= cantidad
    } else {
      throw("Oro insuficiente")
    }
  }

  // Método para regenerar oro (hasta el máximo)
  method regenerarOro() {
    if (oro < maxOro) {
      oro += 1
    }
  }
}


object equipoAzul{
  var oro = 10
  const property maxOro = 10
  
  method name()= "Azul"
  method contrario() = equipoRojo

    method tieneOro(cantidad) = oro >= cantidad
    method gastarOro(cantidad) {
    if (self.tieneOro(cantidad)) {
      oro -= cantidad
    } else {
      throw("Oro insuficiente")
    }
  }

  method regenerarOro() {
    if (oro < maxOro) {
      oro += 1
    }
  }
}

class Torre inherits Entidad(vida = 200, danio = 10){
  method tipo() = "Torre"
  method image() = "castillo"+equipo.name()+".png"
  override method cumplirObjetivoInicial(){
    game.onTick(1000, "atacarAlRededor", {self.atacarAlRededor()})
  }
  method atacarAlRededor(){
    //obtiene todos los enemigos a su aldedor
    //les hace daño
    if(vida > 0)
      tablero.enemigosAlRededor(self.position(),equipo.contrario()).forEach({e=> e.recibirDanio(danio)})
  }
  override method morir(){
    super()
    if(self.esLaUltimaTorre()){
      if(equipo == equipoRojo){
        config.ganar()
      }
      if(equipo == equipoAzul){
        config.perder()
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

class Arqueria inherits Estructura(vida=50, danio=0
) {
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
  
  method estructuras() = entidadesActivas.filter({entidad=>entidad.tipo() == 'Cuartel' or entidad.tipo() == "Arqueria"})
  method estructuraMasCercanaA(unaTropa){
    return self.estructuras().min({estructura => estructura.position().distance(unaTropa.position())})
  }

  method tropas(equipo) = entidadesActivas.filter({entidad=>entidad.tipo() == "Unidad" and entidad.equipo() == equipo})
  method cantTropas(equipo) = self.tropas(equipo).size()
  method tropaMasCercanaA(unaPosicion, equipo){
    return self.tropas(equipo).min({tropa => tropa.position().distance(unaPosicion)})
  }

  method infanteriaDisponible(equipo) = self.tropas(equipo).filter({tropa => tropa.nombre() == 'Infantería'})
  method arquerosDisponibles(equipo) = self.tropas(equipo).filter({tropa => tropa.nombre() == 'Arquero'})

  method hayAlgoEn(unaPosicion)=
    entidadesActivas.any({entidad => entidad.position() == unaPosicion})

  method enemigosAlRededor(unaPosicion,equipo)=
    entidadesActivas.filter({entidad => entidad.position().distance(unaPosicion) == 1 and entidad.equipo() == equipo})


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
