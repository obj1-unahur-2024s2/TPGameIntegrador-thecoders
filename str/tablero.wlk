import personajes.*

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