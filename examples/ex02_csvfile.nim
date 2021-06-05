import uplot, dom, jsffi, strformat
import parsecsv, streams
include karax / prelude
import karax / kdom



proc csv*( fn:cstring;
           a: proc (a:JsObject):JsObject; 
           b: proc (a:JsObject, b:JsObject)
           ) {.importcpp: "d3.csv(@)".}  #

proc readAsText*(f: FileReader, b: dom.File, encoding = cstring"UTF-8") {.importcpp: "#.readAsText(#, #)".}

#[
proc f1(d:JsObject):JsObject =
  echo "In F1"
  return js{ name: d.Name, surname: d.Surname, age: d.Age }

proc f2(error:JsObject, rows:JsObject) =
  echo "In F2"
  echo rows[0]["name"].to(cstring)
]#

#[
d3.csv(f, function(d) {
  return {
    Name: d.Name, Surname: d.Surname, Age: d.Age,
 };
}, function(error, rows) {
	d3.select("#output")
		.text(
			rows[0].Name + " " +
			rows[0].Surname + " " +
			"is " + rows[0].Age + " years old")
});
]#
proc makeChart(data:JsObject) =
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



  let plt = newUplot( opts, data, document.getElementById("mychart") )# document.body )
 

proc createDom(): VNode =
  result = buildHtml(tdiv):
    h1(text "CSV File Example", class="title")
    #button(class="button is-primary"):
    #  text "Load file..."
    #  proc onclick(ev: Event; n: VNode) =
        #table.setDataFromLocalFile("*.json")
    #    echo "CLICK"


        #echo ev.target.InputElement
      
        #lines.add "Hello simulated universe"
    tdiv(class="file"):
      label(class="file-label"):
        input(class="file-input",`type`="file", name="resume", id="filename"):
          proc onChange(ev: Event; n: VNode) =
            echo "cambiado"
            let element = cast[InputElement](ev.target)  # https://nim-lang.org/docs/dom.html#InputElement
            let file = cast[kdom.File](element.files[0]) # https://nim-lang.org/docs/dom.html#File
            echo file.size
            echo file.`type`
            #echo file.name & "  size: " & file.size  & "   type: " & file.`type`
            echo file.name
            let reader = newFileReader()  # From dom
            reader.readAsText(file)     # "./test.csv"
            reader.onload = proc (ev:Event) =
              var strm = newStringStream( $reader.resultAsString )#result.to(cstring) #.to(cstring)# [0..100] # [0..100]
              var csv: CsvParser
              csv.open( strm, $file.name ) #, paramStr(1))

              # The data needs to go in columns
              var n = 0
              if csv.readRow():
                 n = csv.row.len
              var d = newSeq[seq[int]]()
              for item in csv.row:
                var tmp = @[item.parseInt]
                d &= tmp

              while csv.readRow():
                var tmp = newSeq[int]()
                var col = 0
                for item in csv.row.items: #csv.headers.items:
                   d[col] &= item.parseInt
                   col += 1

              makeChart(toJs(d) ) #data)
            
        span(class="file-cta"):
          span(class="file-icon"):
            italic(class="fas fa-upload")
          span(class="file-label"):
            text "Chooose the 'heart_100.csv' file..."

setRenderer createDom
