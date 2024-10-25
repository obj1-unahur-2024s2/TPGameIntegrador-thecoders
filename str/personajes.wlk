class Entidad{
  // const vidaMax
  // var nombre
  // var danio
  var vida
  var property position
  var property image
  // method hacerDanio(unaEntidad){
  //   unaEntidad.recibirDanio(danio)
  // }
  method recibirDanio(cantDanio){
    vida -= cantDanio
    if(vida<0){
      self.morir()
    }
  }
  method morir(){
    game.removeVisual(self)
  }
}

class Personaje{
  var property equipo
  method morir(){
    game.removeVisual(self)
  }
  //ir a, golpear,
}
class PersonajeRango inherits Personaje{

}
class PersonajeMele inherits Personaje{

}
class Estructura inherits Entidad{

}
class Monje inherits Personaje{
  //puede cambiar de bando a otros, sanar alrededor
  method nombre() = "monje"
  method danio() = 0
  method vidaMax() = 30
  var vida = self.vidaMax() 
  method vida() = vida
  method recibirDanio(cantDanio){
    vida -= cantDanio
    if(vida<0){
      self.morir()
    }
  }
  method atacar(unPersonaje){
    unPersonaje.equipo(equipo)
  }
}
class Infanteria inherits Personaje{
  method nombre() = "infanteria"
  method danio() = 10
  method vidaMax() = 40
  var vida = self.vidaMax() 
  method vida() = vida
  method recibirDanio(cantDanio){
    vida -= cantDanio
    if(vida<0){
      self.morir()
    }
  }
  method atacar(unPersonaje){
    unPersonaje.recibirDanio()
  }
  method hayAlgoDelante()
  method irA(){

  }
}
object equipoRojo{

}
object equipoAzul{
  
}
object monje2{
  var property position = game.at(3, 15) 
  var property image = "monjestandingDownBlue0.png"
}
object monje{
  var equipo = equipoAzul
  method danio() = 10
  var position = game.at(5, 5) 
  method position() = position
  method fotograma(personaje,pose,direccion,color,numero){
    return personaje+pose+direccion+color+numero+".png"
  }
  method image() = self.fotograma('monje','walking','Down','Red','2')
  
  method irA(unaPosicion){
    game.onTick(1000, "movete", {self.moveteHacia(unaPosicion)})
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
    if (position.x() < unaPosicion.x()){
      return position.right(1)
    }
    else if (position.x() > unaPosicion.x()){
      return position.left(1)
    }
    else if (position.y() < unaPosicion.y()){
      return position.up(1)
    }
    else if (position.y() > unaPosicion.y()){
      return position.down(1)
    }
    else{
      return position
    }
  }
  method atacar(unPersonaje){
    unPersonaje.recibirDanio(self.danio())
  }
}
class Torre{
  method equipo() = equipoRojo
  var vida = 5
  const property position = game.at(11,17)
  method image() = "castillo.png"
    method recibirDanio(cantDanio){
    vida -= cantDanio
    if(vida<0){
      self.morir()
    }
  }
  method morir(){
    game.removeVisual(self)
    tablero.entidadesActivas().remove(self)
  }
}
object tablero{
  const property entidadesActivas = []
  const property torresRojas = []
  const property torresAzules = []
  method agregarPersonaje(unPersonaje){
    entidadesActivas.add(unPersonaje)
  }
  method agregarTorreRoja(unaTorre){
    torresRojas.add(unaTorre)
  }
  method agregarTorreAzul(unaTorre){
    torresAzules.add(unaTorre)
  }
  method hayAlgoEn(unaPosicion)=
    entidadesActivas.any({entidad => entidad.position() == unaPosicion})
  method entidadEn(unaPosicion) =
    entidadesActivas.find({entidad => entidad.position() == unaPosicion})
  method visualizar(){
    entidadesActivas.forEach({entidad => game.addVisual(entidad)})
  }
}
//   // const property animacion = ["monjestandingDownBlue0.png","monjestandingDownBlue1.png","monjestandingDownBlue2.png",
//   // "monjestandingDownBlue3.png","monjestandingDownBlue4.png","monjestandingDownBlue5.png"]
//   // var fotogramaActual = 0
//   // method animar(){
//   //   image = animacion.get(fotogramaActual)
//   //   fotogramaActual += 1
//   //   if(fotogramaActual == animacion.size()){
//   //     fotogramaActual = 0
//   //   }
//   // }
// }
// object animacion{
//   method nombre() = "caminar"
//   method fotograma(personaje,pose,direccion,color,numero){
//     return personaje+pose+direccion+color+numero+".png"
//   }
// }
