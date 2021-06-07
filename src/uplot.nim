import jsffi, dom, strformat
import options/[grid]  # [common, grid, axes, ticks, series, scale]
export grid #common, grid, axes, ticks, series, scale

when not defined(js):
  {.error: "This module only works on the JavaScript platform".}

type
  Uplot*        = ref object of JsObject
  UplotOptions* = ref object of JsObject
  Scale*        = ref object of JsObject
  Serie*        = ref object of JsObject 
  Axe*          = ref object of JsObject
  #Grid*         = ref object of JsObject
  Tick*         = ref object of JsObject


proc newUplot*(opts:UplotOptions, data:JsObject, element:Element): Uplot {. importcpp: "new uPlot(@)" .}

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

#-------------
proc addScale*(opts:var UplotOptions, name:string, scale:Scale) =
  opts["scales"][name] = scale

proc unsetTimeScale*(scale:var Scale) =
  ## by default it is a time scale. This function change it to plan numbers
  scale["time"] = false


proc setMinMax(scale:var Scale; min, max:int) =
  scale["auto"] = false # Disables autorange
  scale["range"] = [min, max].toJs

proc setIndexed(scale:var Scale) =
  ## avoids empty gaps (example weekends)
  scale["distr"] = 2

#-------------------------
proc setSeries*(opts:var UplotOptions, series: varargs[Serie]) =
  var tmp = @[Serie()]
  for i in series.items:
    tmp &= i
  opts["series"] = tmp.toJs

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


#----- Axes
proc setAxes*(opts:var UplotOptions, axes: varargs[Axe]) =
  var tmp = newSeq[Axe]() #@[Axe()]
  for i in axes.items:
    tmp &= i
  opts["axes"] = tmp.toJs

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

#--- Grid
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

#--- Ticks
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


#----- TODO: High/Low bands
# https://github.com/leeoniya/uPlot/tree/master/docs#highlow-bands



#[
Customizing the tick/grid spacing, value formatting and granularity is somewhat more involved:

let opts = {
  axes: [
    {
      space: 40,
      incrs: [
         // minute divisors (# of secs)
         1,
         5,
         10,
         15,
         30,
         // hour divisors
         60,
         60 * 5,
         60 * 10,
         60 * 15,
         60 * 30,
         // day divisors
         3600,
      // ...
      ],
      // [0]:   minimum num secs in found axis split (tick incr)
      // [1]:   default tick format
      // [2-7]: rollover tick formats
      // [8]:   mode: 0: replace [1] -> [2-7], 1: concat [1] + [2-7]
      values: [
      // tick incr          default           year                             month    day                        hour     min                sec       mode
        [3600 * 24 * 365,   "{YYYY}",         null,                            null,    null,                      null,    null,              null,        1],
        [3600 * 24 * 28,    "{MMM}",          "\n{YYYY}",                      null,    null,                      null,    null,              null,        1],
        [3600 * 24,         "{M}/{D}",        "\n{YYYY}",                      null,    null,                      null,    null,              null,        1],
        [3600,              "{h}{aa}",        "\n{M}/{D}/{YY}",                null,    "\n{M}/{D}",               null,    null,              null,        1],
        [60,                "{h}:{mm}{aa}",   "\n{M}/{D}/{YY}",                null,    "\n{M}/{D}",               null,    null,              null,        1],
        [1,                 ":{ss}",          "\n{M}/{D}/{YY} {h}:{mm}{aa}",   null,    "\n{M}/{D} {h}:{mm}{aa}",  null,    "\n{h}:{mm}{aa}",  null,        1],
        [0.001,             ":{ss}.{fff}",    "\n{M}/{D}/{YY} {h}:{mm}{aa}",   null,    "\n{M}/{D} {h}:{mm}{aa}",  null,    "\n{h}:{mm}{aa}",  null,        1],
      ],
  //  splits:
    }
  ],
}
space is the minumum space between adjacent ticks; a smaller number will result in smaller selected divisors. can also be a function of the form (self, scaleMin, scaleMax, dim) => space where dim is the dimension of the plot along the axis in CSS pixels.
incrs are divisors available for segmenting the axis to produce ticks. can also be a function of the form (self) => divisors.
values can be:
a function with the form (self, ticks, space) => values where ticks is an array of raw values along the axis' scale, space is the determined tick spacing in CSS pixels and values is an array of formated tick labels.
array of tick formatters with breakpoints.  
]#

#[
Axes for Alternate Units
Sometimes it's useful to provide an additional axis to display alternate units, e.g. °F / °C. This is done using dependent scales.

let opts = {
  series: [
    {},
    {
      label: "Temp",
      stroke: "red",
      scale: "F",
    },
  ],
  axes: [
    {},
    {
      scale: "F",
      values: (self, ticks) => ticks.map(rawValue => rawValue + "° F"),
    },
    {
      scale: "C",
      values: (self, ticks) => ticks.map(rawValue => rawValue + "° C"),
      side: 1,
      grid: {show: false},
    }
  ],
  scales: {
    "C": {
      from: "F",
      range: (self, fromMin, fromMax) => [
        (fromMin - 32) * 5/9,
        (fromMax - 32) * 5/9,
      ],
    }
  },
from specifies the scale on which this one depends.
range converts from's min/max into this one's min/max.  
]#


#[
function makeChart() {
    let opts = {
    //	cursor: {
    //		top: 100,
    //		left: 100,
    //	},
        plugins: [
            tooltipsPlugin(),
        ],

    };


}

]#

#[
function tooltipsPlugin(opts) {
    function init(u, opts, data) {
        let over = u.over;

        let ttc = u.cursortt = document.createElement("div");
        ttc.className = "tooltip";
        ttc.textContent = "(x,y)";
        ttc.style.pointerEvents = "none";
        ttc.style.position = "absolute";
        ttc.style.background = "rgba(0,0,255,0.1)";
        over.appendChild(ttc);

        u.seriestt = opts.series.map((s, i) => {
            if (i == 0) return;

            let tt = document.createElement("div");
            tt.className = "tooltip";
            tt.textContent = "Tooltip!";
            tt.style.pointerEvents = "none";
            tt.style.position = "absolute";
            tt.style.background = "rgba(0,0,0,0.1)";
            tt.style.color = s.color;
            tt.style.display = s.show ? null : "none";
            over.appendChild(tt);
            return tt;
        });

        function hideTips() {
            ttc.style.display = "none";
            u.seriestt.forEach((tt, i) => {
                if (i == 0) return;

                tt.style.display = "none";
            });
        }

        function showTips() {
            ttc.style.display = null;
            u.seriestt.forEach((tt, i) => {
                if (i == 0) return;

                let s = u.series[i];
                tt.style.display = s.show ? null : "none";
            });
        }

        over.addEventListener("mouseleave", () => {
            if (!u.cursor._lock) {
            //	u.setCursor({left: -10, top: -10});
                hideTips();
            }
        });

        over.addEventListener("mouseenter", () => {
            showTips();
        });

        hideTips();
    }

    function setCursor(u) {
        const {left, top, idx} = u.cursor;

        // this is here to handle if initial cursor position is set
        // not great (can be optimized by doing more enter/leave state transition tracking)
    //	if (left > 0)
    //		u.cursortt.style.display = null;

        u.cursortt.style.left = left + "px";
        u.cursortt.style.top = top + "px";
        u.cursortt.textContent = "(" + u.posToVal(left, "x").toFixed(2) + ", " + u.posToVal(top, "y").toFixed(2) + ")";

        // can optimize further by not applying styles if idx did not change
        u.seriestt.forEach((tt, i) => {
            if (i == 0) return;

            let s = u.series[i];

            if (s.show) {
                // this is here to handle if initial cursor position is set
                // not great (can be optimized by doing more enter/leave state transition tracking)
            //	if (left > 0)
            //		tt.style.display = null;

                let xVal = u.data[0][idx];
                let yVal = u.data[i][idx];

                tt.textContent = "(" + xVal + ", " + yVal + ")";

                tt.style.left = Math.round(u.valToPos(xVal, 'x')) + "px";
                tt.style.top = Math.round(u.valToPos(yVal, s.scale)) + "px";
            }
        });
    }

    return {
        hooks: {
            init,
            setCursor,
            setScale: [
                (u, key) => {
                    console.log('setScale', key);
                }
            ],
            setSeries: [
                (u, idx) => {
                    console.log('setSeries', idx);
                }
            ],
        },
    };
}  
]#

#[


				let mooSync = uPlot.sync("moo");

				let synced = true;
				let syncBtn = document.getElementById('sync');

				syncBtn.onclick = () => {
					synced = !synced;

					if (synced) {
						mooSync.sub(uplot1);
						mooSync.sub(uplot2);
						mooSync.sub(uplot3);
						syncBtn.textContent = 'Disable Sync';
					}
					else {
						mooSync.unsub(uplot1);
						mooSync.unsub(uplot2);
						mooSync.unsub(uplot3);
						syncBtn.textContent = 'Enable Sync';
					}
				};

				let syncedUpDown = true;
				let syncUpDownBtn = document.getElementById('sync-up-down');

				function upDownFilter(type) {
					return syncedUpDown || (type != "mouseup" && type != "mousedown");
				}

				syncUpDownBtn.onclick = () => {
					syncedUpDown = !syncedUpDown;

					if (syncedUpDown)
						syncUpDownBtn.textContent = 'Disable mouseup/down Sync';
					else
						syncUpDownBtn.textContent = 'Enable mouseup/down Sync';
				};

				const matchSyncKeys = (own, ext) => own == ext;

				const cursorOpts = {
					lock: true,
					focus: {
						prox: 16,
					},
					sync: {
						key: mooSync.key,
						setSeries: true,
						match: [matchSyncKeys, matchSyncKeys],
						filters: {
							pub: upDownFilter,
						}
					},
				};

]#