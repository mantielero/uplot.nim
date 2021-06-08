import jsffi

type
  Grid* = ref object of JsObject


proc show*(g:var Grid) =
  g["show"] = true

proc hide*(g:var Grid) =
  g["show"] = false

proc stroke*(g:var Grid, color:string) =
  g["stroke"] = color.cstring


proc width*(g:var Grid, width:uint) =
  g["width"] = width

proc dash*(g:var Grid, min,max:uint) =
  g["dash"] = ([min,max]).toJs
