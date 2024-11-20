object marco{
  var property position = game.at(0,0)
  var property puedeMoverse = true
  method image() = "marco.png"
  method moverA(unaPosicion){
    if(unaPosicion.x() >= 0 and unaPosicion.x() < game.width() and
      unaPosicion.y() < game.height() and
      unaPosicion.y() >= 0 and unaPosicion.x() < (game.width() / 2) and puedeMoverse)
    {
      position = unaPosicion
    }
  }
}
