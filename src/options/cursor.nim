import jsffi#, uplot

type
  Sync*     = ref object of JsObject
  CursorOpts* = ref object of JsObject


# https://github.com/leeoniya/uPlot/blob/b72bd3e02810a69b10620bef512d232966d6194f/dist/uPlot.d.ts#L476-L489


# https://github.com/leeoniya/uPlot/blob/b72bd3e02810a69b10620bef512d232966d6194f/dist/uPlot.d.ts#L457
# https://github.com/leeoniya/uPlot/blob/master/dist/uPlot.d.ts#L476

proc newSyncCstring(val:cstring):Sync  {. importcpp: "uPlot.sync(@)" .}

proc newSync*(key:string):Sync =
  # let mooSync = uPlot.sync("moo");
  newSyncCstring(key.cstring)




proc setKey*(s:var Sync; k:string) =
  ## sync key must match between all charts in a synced group 
  s["key"] = k.cstring

proc setSeries*(s:var Sync; b:bool = true) =
  ## determines if series toggling and focus via cursor is synced across charts
  s["setSeries"] = b

#[
proc setScales*(s:var Sync; b:Scale) =
  ## sets the x and y scales to sync by values. null will sync
  ## by relative (%) position
  # scales?: Sync.Scales;
  s["scales"] = b  #  // [xScaleKey, null]

proc setMatch*(s:var Sync; b:Match) =
  ## fns that match x and y scale keys between publisher and subscriber 
  s["match"] = b  

proc setFilters*(s:var Sync; b:Filters) =
  ## event filters
  s["filters"] = b  

proc setValues*(s:var Sync; b:Values) =
  ## sync scales' values at the cursor position (exposed for read-back by subscribers)
  s["values"] = b  
]#

# https://github.com/leeoniya/uPlot/blob/b72bd3e02810a69b10620bef512d232966d6194f/dist/uPlot.d.ts#L403


proc newCursorOpts*():CursorOpts =
  new result

proc lock*(c:var CursorOpts) = 
  c["lock"] = true

proc proximity*(c:var CursorOpts, prox:uint) = 
  ## minimum cursor proximity to datapoint in CSS pixels for focus activation
  c["focus"] = newJsObject()
  c["focus"]["prox"] = prox

proc setSync*(c:var CursorOpts, s:Sync) = 
  c["sync"] = s
