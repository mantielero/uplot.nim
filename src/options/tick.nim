import jsffi

type
  Tick* = ref object of JsObject

proc show*(t:var Tick) =
  t["show"] = true

proc hide*(t:var Tick) =
  t["show"] = false

proc stroke*(t:var Tick, color:string) =
  t["stroke"] = color.cstring

proc width*(t:var Tick, width:uint) =
  t["width"] = width

proc size*(t:var Tick, size:uint) =
  t["size"] = size

proc dash*(t:var Tick; min,max:uint) =
  t["dash"] = ([min,max]).toJs