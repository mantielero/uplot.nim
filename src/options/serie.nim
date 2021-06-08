import jsffi, strformat

type
  Serie* = ref object of JsObject     

proc label*(serie:var Serie, label:string) =
  serie["label"] = label.cstring

proc show*(serie:var Serie) =
  serie["show"] = true

proc hide*(serie:var Serie) =
  serie["show"] = false

proc setScale*(serie:var Serie, scale:string) =
  serie["scale"] = scale.cstring

proc unsetSpanGaps*(serie:var Serie) = 
  serie["spanGaps"] = false

proc setSpanGaps*(serie:var Serie) = 
  ## connects `null` data points
  serie["spanGaps"] = true

proc stroke*(serie:var Serie, stroke:string) =
  serie["stroke"] = stroke.cstring 

proc width*(serie: var Serie, width:uint) =
  serie["width"] = width

proc fill*(serie: var Serie; r,g,b:range[0..255]; alpha:float = 1.0) =
  assert alpha >= 0.0
  assert alpha <= 1.0
  let tmp = &"rgba({r}, {g}, {b}, {alpha})"
  serie["fill"] = tmp.cstring
  #echo &"rgba({r}, {g}, {b}, {alpha})#"

proc dash*(serie: var Serie; max,min:uint) =
  serie["dash"] = [max, min]

template val*(body:untyped):untyped =
  (proc (self {.inject.}:JsObject, rawValue {.inject.}:int):cstring = 
     (body).cstring
  )

proc value*(serie: var Serie; lbd: proc (self:JsObject, rawValue:int):cstring) =
  serie["value"] = lbd