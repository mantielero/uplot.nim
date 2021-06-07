import jsffi, strformat
# https://github.com/leeoniya/uPlot/blob/76721bcd5f2034a5caba999be75a574420478393/dist/uPlot.d.ts#L819-L837

type
  Grid* = ref object of JsObject
    show*:bool
    #filter*: Filter
    stroke: cstring #Stroke
    width*: uint
    dash*:seq[uint]
    #cap*:Series.cap

proc rgba*(g:var Grid, red,green,blue:range[0..255],alpha:float) =
  assert alpha >= 0.0 and alpha <= 1.0, "alpha shall be between [0.0, 1.0]"
  g.stroke = cstring(&"rgba({red},{green},{blue},{alpha})")


#proc width*(g:var Grid, width:uint) =
#  g["width"] = width