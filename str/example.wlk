object pepita {
  var energy = 100
  method image() = "1.png"
  method position() = game.at(0, 0)
  method energy() = energy

  method fly(minutes) {
    energy = energy - minutes * 3
  }
}
object monje2{
  var property position = game.at(10, 18) 
  var property image = "monjestandingDownBlue0.png"
}
object monje{
  var position = game.at(5, 5) 
  method position() = position
  const property animacion = ["monjestandingDownBlue0.png","monjestandingDownBlue1.png","monjestandingDownBlue2.png",
  "monjestandingDownBlue3.png","monjestandingDownBlue4.png","monjestandingDownBlue5.png"]
  var image = "monjestandingDownBlue0.png"
  method image() = image 
  method irA(x,y){
    game.onTick(1000, "movete", {self.moveteHacia(x,y)})
  }
  method moveteHacia(x,y){
    if (position.x() < x){
      position = position.right(1)
    }
    else if (position.x() > x){
      position = position.left(1)
    }
    else if (position.y() < y){
      position = position.up(1)
    }
    else if (position.y() > y){
      position = position.down(1)
    }  
  }
  var fotogramaActual = 0
  method animar(){
    image = animacion.get(fotogramaActual)
    fotogramaActual += 1
    if(fotogramaActual == animacion.size()){
      fotogramaActual = 0
    }
  }
}