import jsffi, axes, serie, scale

type
  UplotOptions* = ref object of JsObject

proc newUplotOptions*():UplotOptions =
  result = UplotOptions()
  result["scales"] = newJsObject()

proc title*(opts:var UplotOptions, title:string) =
  opts["title"] = title.cstring

proc width*(opts:var UplotOptions, width:uint) =
  opts["width"] = width

proc height*(opts:var UplotOptions, height:uint) =
  opts["height"] = height

proc setId*(opts:var UplotOptions, id:string) =
  opts["id"] = id.cstring

proc setClass*(opts:var UplotOptions, cls:string) =
  opts["class"] = cls.cstring

proc setAxes*(opts:var UplotOptions, axes: varargs[Axe]) =
  var tmp = newSeq[Axe]() #@[Axe()]
  for i in axes.items:
    tmp &= i
  opts["axes"] = tmp.toJs

proc setSeries*(opts:var UplotOptions, series: varargs[Serie]) =
  var tmp = @[Serie()]
  for i in series.items:
    tmp &= i
  opts["series"] = tmp.toJs

proc addScale*(opts:var UplotOptions, name:string, scale:Scale) =
  opts["scales"][name] = scale