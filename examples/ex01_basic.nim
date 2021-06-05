import uplot, dom, jsffi, strformat

proc makeChart() =
  var opts = newUplotOptions()
  opts.title("Tooltips")
  opts.width(600)
  opts.height(400)  

  #opts["scales"] =  newJsObject()
  var scale  = Scale()
  scale.unsetTimeScale
  opts.addScale( "x", scale )

  var serie1 = Serie()
  serie1.label("One")
  serie1.stroke("red")
  serie1.width(3)  

  var serie2 = Serie()
  serie2.label("Two")
  serie2.stroke("blue")
  serie2.fill(0,255,0,0.3)
  serie2.hide
  serie2.dash(10,5)
  # TODO:
  serie2.value( val( &"{rawValue:04}days" )  )  
  #serie2.value( (self:JsObject, rawValue:int) => (&"{rawValue:04}days").cstring )
  #serie2.value( (self:JsObject, rawValue:int) => (&"{rawValue:>9.1f}hours").cstring )

  opts.setSeries(serie1, serie2)

  # Axes
  var axe1 = Axe()
  axe1.label("Day")
  axe1.top
  axe1.stroke("red")
  opts.setAxes( axe1 )


  #opts["series"] = series.toJs

  let data = toJs( [
        [ 1, 2, 3, 4, 5, 6, 7],  # x-values (timestamps)
        [40,43,60,65,71,73,80],  # y-values (series 1)
        [18,24,37,55,55,60,63]   # y-values (series 2)
    ] )

  let plt = newUplot( opts, data, document.body )

makeChart()
