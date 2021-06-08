import jsffi

type
  Scale* = ref object of JsObject




proc unsetTimeScale*(scale:var Scale) =
  ## by default it is a time scale. This function change it to plan numbers
  scale["time"] = false


proc setMinMax(scale:var Scale; min, max:int) =
  scale["auto"] = false # Disables autorange
  scale["range"] = [min, max].toJs

proc setIndexed(scale:var Scale) =
  ## avoids empty gaps (example weekends)
  scale["distr"] = 2
