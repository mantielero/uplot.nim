import jsffi, grid

type
  Axe* = ref object of JsObject    

proc label*( axe:var Axe, label:string) =
  axe["label"] = label.cstring

proc stroke*(axe:var Axe, stroke:string) =
  axe["stroke"] = stroke.cstring

proc scale*(axe:var Axe, scale:string) =
  axe["scale"] = scale.cstring

proc top*(axe:var Axe) =
  axe["side"] = 0

proc right*(axe:var Axe) =
  axe["side"] = 1

proc bottom*(axe:var Axe) =
  axe["side"] = 2

proc left*(axe:var Axe) =
  axe["side"] = 3

proc show*(axe:var Axe) =
  axe["show"] = true

proc hide*(axe:var Axe) =
  axe["show"] = false

proc labelSize*(axe:var Axe, size:uint) =
  axe["labelSize"] = size

proc labelFont*(axe:var Axe, font:string) =
  axe["labelFont"] = font

proc font*(axe:var Axe, font:string) =
  axe["font"] = font

proc gap*(axe:var Axe, gap:uint) =
  axe["gap"] = gap

proc size*(axe:var Axe, size:uint) =
  axe["size"] = size

proc setGrid*(axe:var Axe, grid:Grid) =
  axe["grid"] = grid