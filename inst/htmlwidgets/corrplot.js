HTMLWidgets.widget({
  name: 'corrplot',
  type: 'output',

  initialize: function(el, width, height) {

    console.log("init")

var corrplotArea = d3.select(el).append('div')
.attr('id', "corrplotArea")

	 var wrapDiv = corrplotArea.append("div")
		.attr("id", "content-wrapper")
		//.attr("width", "10px")//
//def buttons
	var buttonHTML = '<div id="bottonBox" class="row"> <div>' +
'<div class="svgSize"><div><p class="buttonLabel">change'+'&nbsp'+'Size:</p>'+
'<p> <span class="sizeButton">Min:'+'&nbsp'+'</span><span id="minSize"></span></p><p>Present:'+'&nbsp'+'<span id="sizeRatio"></span></p><p><span class="sizeButton">Max:'+'&nbsp'+'</span><span id="maxSize"></span></p><div><div id = "svgSizeSlider"></div> <input type="submit" id="svgSizeSub"/></div>'+
  '<p class="buttonLabel">Order:'+'&nbsp'+'</p>'+
		'<div id="hcRect"><select id="orderSelect" style="width:80px"> <option value="original">original</option> <option value="AOE">AOE</option><option value="FPC">FPC</option>			<option value="hclust">hclust</option>			<option value="name">name</option>		</select>		</div>'+
'<div><p class="buttonLabel">Significance'+'&nbsp'+'Test: </p><p class="hint">eliminate'+'&nbsp'+'the'+'&nbsp'+
'p'+'&nbsp'+'value'+'&nbsp'+'>'+'&nbsp'+'0.05</p><button id="sigshow" value="sigshow">sigshow</button></div>'+
    '<div>	<p class="buttonLabel">DiagShow:</p>		<div id="diagDiv" class="btn-group" data-toggle="buttons">			<label class="btn btn-info">				<input type="radio" name="options" id="Upper" autocomplete="off"  value="Upper" > Upper			</label>			<label class="btn btn-info">				<input type="radio" name="options" id="Lower" autocomplete="off" value="Lower">Lower</label>			<label class="btn btn-info active">				<input type="radio" name="options" id="Full" autocomplete="off" value="Full" checked> Full			</label>		</div></div>'+
		'<div>		<p class="buttonLabel">Legend:</p>			<div id="legendDiv" class="btn-group" data-toggle="buttons" style="position: relative">				<label class="btn btn-info active">					<input type="radio" name="legend" autocomplete="off" checked id="circle" value="Circle">Circle</label>				<label class="btn btn-info">					<input type="radio" name="legend" autocomplete="off" id="square"  value="Square">Square</label>				<label class="btn btn-info">					<input type="radio" name="legend" autocomplete="off" id="ellipse" value="Ellipse">Ellipse</label>			</div>	</div>'+
		'<div>		 <p class="buttonLabel">Number:'+'&nbsp'+'</p>		<button type="button" id="numShow"  value="show">Show</button>	</div></div>'

//append button in div
	var bottonDiv = corrplotArea.append("div")
		.html(buttonHTML)

  //  console.log(buttonHTML)
    return wrapDiv;
  },
/*               */
//el: the elements host the widget
//x:including data&settings

  renderValue: function(el, x, wrapDiv) {
	 wrapDiv.selectAll("div").remove();
	 wrapDiv.selectAll("svg").remove();
   seqChangeBar = wrapDiv.append("div")
   .attr("id", "seqChangeBar")
	 plotDiv = wrapDiv.append("div")
		.attr("class", "corrplot")
		.attr("id", "corrplot-1")

	var svgHTML = '	<svg xmlns="http://www.w3.org/2000/svg" version="1.1"><defs><linearGradient id="grad2" x1="0%" y1="0%" x2="0%" y2="100%"><stop offset="0%" style="stop-color:#053061;stop-opacity:1" /><stop offset="50%" style="stop-color:#FFFFFF;stop-opacity:1" /><stop offset="100%" style="stop-color:#67001F;stop-opacity:1" /></linearGradient></defs></svg>'
//append svg
	wrapDiv.append("svg")
		.html(svgHTML)


w = x['size'][0]
h = x["size"][1]

init_w = w;

maxSize = x['range'][1]
minSize = x['range'][0]
$('#minSize').text(minSize)
$('#maxSize').text(maxSize)

//console.log($("#svgSizeSlider").value)
//$("#svgSizeSlider").value

mvisCorrplotData = x['data']
rectOrderNum = x['rectOrderNum']

var  n = mvisCorrplotData["matrixLength"];



//var svgScale = d3.scale.linear().domain([]).range([]);

/**/



//console.log(x.size)
	 svg = plotDiv.append("svg")
      .attr("width", w)//这里可以修改
      .attr("height", h)//
	  .attr("id", "plotSVG");
	//console.log(svg.attr("id"))
	//console.log(el)
	//console.log(x)
    //instance.setOption(x, true);
	//instance.setTheme(eval(x.theme + "Theme"));

  /*
  outList <- list(
				matrixLength = ncol(corr),
				color = color,
				colNames = colNames,
				matrixData = corr,
				orderList = orderList
		)
    x <- list(
  data = outList,
  settings = settings
)
  */

//let 0.1 a coeff
    lineStart = 0.1*w;
		lineEnd = 0.85*w;
		cellSize = (lineEnd - lineStart)/n;//num of cell
		hLineArray = new Array(n+1);//horizontal line
		vLineArray = new Array(n+1);//vertcial line
		maxR = 0.9 * cellSize;//
		minR = 0.1 * cellSize;
		numShow = false;
		method = mvisCorrplotData["method"]
		diagShow = "diagFull";
		nofFill = 0;
		maxValue = 1;
		middleValue = 0;
		minValue = -1;
numLabelSize = 0.015*w
sigshow = false
		maxCol = mvisCorrplotData["color"][0];
    console.log(maxCol)

		middleCol = mvisCorrplotData["color"][1];
		minCol = mvisCorrplotData["color"][2];
		newSeq = mvisCorrplotData["orderList"]["original"]
    colNames = mvisCorrplotData["colNames"]
//CI   significance test
pMat = x["CI"]["p"];

SigArray = new Array();
for(var i=0;i<pMat.length;i++){
for(var j=0;j<pMat.length;j++){

if(pMat[i][j]>0.05){
  SigArray[i*n+j]=0; }else {
  SigArray[i*n+j]=1;
  };

}}


    nowSeq = new Array() ;


//iquery ui
		$( "#legendDiv" ).buttonset();
		$( "#diagDiv" ).buttonset();
		$( "#numShow" ).button();

//		$("bottonBox").css("margin-left")
// colorhex  append  string a method
		var reg = /^#([0-9a-fA-f]{3}|[0-9a-fA-f]{6})$/;//
		String.prototype.colorHex = function(){
			var that = this;
			if(/^(rgb|RGB)/.test(that)){//
				var aColor = that.replace(/(?:\(|\)|rgb|RGB)*/g,"").split(",");
				var strHex = "#";
				for(var i=0; i<aColor.length; i++){
					var hex = Number(aColor[i]).toString(16);
					if(hex === "0"){
						hex += hex;
					}
					strHex += hex;
				}
				if(strHex.length !== 7){
					strHex = that;
				}
				return strHex;
			}else if(reg.test(that)){
				var aNum = that.replace(/#/,"").split("");
				if(aNum.length === 6){
					return that;
				}else if(aNum.length === 3){
					var numHex = "#";
					for(var i=0; i<aNum.length; i+=1){
						numHex += (aNum[i]+aNum[i]);
					}
					return numHex;
				}
			}else{
				return that;
			}
		};
/*//*/
		String.prototype.colorRgb = function(){
			var sColor = this.toLowerCase();
			if(sColor && reg.test(sColor)){
				if(sColor.length === 4){
					var sColorNew = "#";
					for(var i=1; i<4; i+=1){
						sColorNew += sColor.slice(i,i+1).concat(sColor.slice(i,i+1));
					}
					sColor = sColorNew;
				}
				var sColorChange = [];
				for(var i=1; i<7; i+=2){
					sColorChange.push(parseInt("0x"+sColor.slice(i,i+2)));
				}
				return sColorChange;
			}else{
				return sColor;
			}
		};

//form th data

		var parse_mvisCorrplotData = function(a){//
			if (a.length==1){//
				outArray = new Array(1)
				percent = (a[0] - middleValue)/(maxValue - middleValue);
				r = (percent*(maxR-minR)+minR)/2;
				cx = cellSize*(0.5) + lineStart;//
				cy = cellSize*(0.5) + lineStart;//
				color = colorSelector(a[0])//
				outArray[0] = new Array(r, cx, cy, color, a[0], cellSize*0+lineStart, cellSize*0+lineStart )
				return outArray
			}else{
				outArray = new Array(n*n)
        //
				for(var i = 0; i < n; i++){
					for(var j=0; j < n; j++){
						if (a[i][j] > middleValue) percent = (a[i][j] - middleValue)/(maxValue - middleValue);
						else percent = (middleValue - a[i][j])/(middleValue - minValue);
						r = (percent*(maxR-minR)+minR)/2;
						cx = cellSize*(j+0.5) + lineStart;
						cy = cellSize*(i+0.5) + lineStart;
						color = colorSelector(a[i][j])
            //                          cell_R ，cell_postion ，color，corr，horizontal_pos，vertcial_pos
						outArray[i*n+j] = new Array(r, cx, cy, color, a[i][j], cellSize*j+lineStart, cellSize*i+lineStart,//
           [cellSize*j+lineStart+pchSider,cellSize*(j+1)+lineStart-pchSider,cellSize*i+lineStart+pchSider,cellSize*(i+1)+lineStart-pchSider],
           [cellSize*(j+1)+lineStart-pchSider,cellSize*j+lineStart+pchSider,cellSize*i+lineStart+pchSider,cellSize*(i+1)+lineStart-pchSider]
           //x1,x2,y1,y2
            //[cellSize*i+lineStart+0.05*cellSize,cellSize*(i+1)+lineStart-0.05*cellSize]//
          )//x1,x2
					}
				}
				return outArray;
			}
		}
/*           */
//\
		var colorSelector = function(v){

			var returnCol = new Array(3);
			if( (minValue <= v) && (maxValue >= v)){
				maxColRGB = maxCol.colorRgb()
				middleColRGB = middleCol.colorRgb()
				minColRGB = minCol.colorRgb()
				if (v > middleValue){
					percent = (v - middleValue)/(maxValue - middleValue)
					for (var i=0; i<3; i++){
						if (maxColRGB[i] > middleColRGB[i]) returnCol[i] = parseInt((maxColRGB[i] - middleColRGB[i]) * percent + middleColRGB[i]);
						else returnCol[i] = parseInt( middleColRGB[i] -(middleColRGB[i] - maxColRGB[i]) * percent);
					}
				}else{
					percent = (middleValue - v)/(middleValue - minValue);
					for (i=0; i<3; i++){
						if (minColRGB[i] < middleColRGB[i]) returnCol[i] = parseInt(middleColRGB[i] -(middleColRGB[i] - minColRGB[i]) * percent);
						else returnCol[i] =  parseInt((minColRGB[i] - middleColRGB[i]) * percent + middleColRGB[i]);
					}
				}
				return("RGB(" + returnCol.join(",") + ")")
			}else{
				alert( v + "unexpected false.")
			}
		}

    function colorRGB2Hex(rgb) {
        var r = parseInt(rgb[0]);
        var g = parseInt(rgb[1]);
        var b = parseInt(rgb[2]);

        var hex = "#" + ((1 << 24) + (r << 16) + (g << 8) + b).toString(16).slice(1);
        return hex;
     }
/* ################ */
//

		$( "#legend" ).buttonset();
		$( "#diag" ).buttonset();
//
function init_corrplot( method){

// recalculation for init_corrplot
lineStart = 0.1*w;
lineEnd = 0.85*w;
cellSize = (lineEnd - lineStart)/n;//cell
maxR = 0.9 * cellSize;//
minR = 0.1 * cellSize;
numLabelSize = 0.015*w
pchSider = 0.005*w
		for (i=0; i<n+1; i++){
			vLineArray[i] =  new Array(cellSize*i + lineStart, lineStart, cellSize*i + lineStart, lineEnd)
			hLineArray[i] = new Array(lineStart, cellSize*i + lineStart, lineEnd, cellSize*i + lineStart)
		}


//
var corr = mvisCorrplotData["matrixData"]
	aData = parse_mvisCorrplotData(mvisCorrplotData["matrixData"])
	//console.log(aData)

	if (method=="circle"){

//       console.log(newSeq)

		var cells = svg.selectAll(".cells").data(aData)
			.enter()
			.append("circle")
			/*changed 11-01 .attr("r", function(d){return d[0];})
			.attr("cx", function(d,i){ return d[1];})
			.attr("cy", function(d,i){ return d[2];})
			.attr("fill", function(d){return d[3];})
			.attr("class", function(d,i){ a1 = Math.floor(i/n); a2 = i%n; return("cell cell_Y_"+a1+" cell_X_"+a2);})
			.attr("class", function(d,i){ a1 = Math.floor(i/n); a2 = i%n; return("cell cell_Y_"+a1+" cell_X_"+a2);})
		*/
// outArray[i*n+j] = new Array(r, cx, cy, color, a[i][j], cellSize*j+lineStart, cellSize*i+lineStart )

			.attr("r", function(d){return d[0];})
			.attr("fill", function(d){return d[3];})
      //row，Math.floor(i/n)
			.attr("cx", function(d,i){ return (cellSize*( newSeq[Math.floor(i/n)]-0.5) + lineStart);})
      //column，i%n,取余数
      .attr("cy", function(d,i){return (cellSize*( newSeq[i%n]-0.5) + lineStart);})
			.attr("class", function(d,i){ return("cell cell_Y_"+ (newSeq[i%n] -1) ) +" cell_X_"+ (newSeq[Math.floor(i/n)] -1);})


}
else if (method=="ellipse"){//
		var cells = svg.selectAll(".cells").data(aData)
				.enter()
				.append("ellipse")
				/*changed 11-01 .append("ellipse")
				.attr("cx", function(d){return d[1];})
				.attr("cy", function(d){ return d[2];})
				.attr("fill", function(d){return d[3];})
				.attr("ry", function(d){return cellSize/2 - Math.abs(d[0]) ;})
				.attr("rx", cellSize/2)
				.attr("transform", function(d){ if (d[4]>0) {return "rotate( -45," + d[1] +","+d[2]+")"}else{ return "rotate( 45," + d[1] +","+d[2]+")"} })
				.attr("class", function(d,i){ a1 = Math.floor(i/n); a2 = i%n; return("cell cell_Y_"+a1+" cell_X_"+a2);})
		*/
				.attr("cx", function(d,i){ return (cellSize*(newSeq[Math.floor(i/n)] - 0.5)  + lineStart);})
				.attr("cy", function(d,i){ return (cellSize*( newSeq[i%n] - 0.5) + lineStart) ;})
				.attr("class", function(d,i){ return("cell cell_Y_"+ (newSeq[i%n] -1) ) +" cell_X_"+ (newSeq[Math.floor(i/n)] -1);})
				.attr("ry", function(d){return cellSize/2 - Math.abs(d[0]) ;})
				.attr("rx", cellSize/2)
				.attr("transform",function(d,i){
					if (d[4]>0) return "rotate( -45," + (cellSize*(newSeq[Math.floor(i/n)] - 0.5)  + lineStart) +","+(cellSize*( newSeq[i%n] - 0.5) + lineStart)+")";
					else return "rotate( 45," + (cellSize*(newSeq[Math.floor(i/n)] - 0.5)  + lineStart) +","+(cellSize*( newSeq[i%n] - 0.5) + lineStart)+")"})
				.attr("fill", function(d){return d[3];})

	}else if (method == "square"){
		var cells = svg.selectAll(".cells").data(aData)
				.enter()
				.append("rect")
				/*changed 11-01 .attr("x", function(d){return d[1] - d[0];})
				.attr("y", function(d){ return d[2] - d[0];})
				.attr("fill", function(d){return d[3];})
				.attr("width", function(d){return 2*d[0]})
				.attr("height", function(d){return 2*d[0]})
				.attr("class", function(d,i){ a1 = Math.floor(i/n); a2 = i%n; return("cell cell_Y_"+a1+" cell_X_"+a2);})
				*/
				.attr("fill", function(d){return d[3];})
				.attr("width", function(d){return 2*d[0]})
				.attr("height", function(d){return 2*d[0]})//
				.attr("x", function(d,i){return (cellSize*( newSeq[Math.floor(i/n)]-0.5) + lineStart) - d[0];})
				.attr("y", function(d,i){ return (cellSize*( newSeq[i%n]-0.5) + lineStart) - d[0];})
				.attr("class", function(d,i){ return("cell cell_Y_"+ (newSeq[i%n] -1) ) +" cell_X_"+ (newSeq[Math.floor(i/n)] -1);})
      }

	/*	info = "x:"+ 0+";y:"+0
	var infoLabel = svg.selectAll(".info").data([1]).enter().append("text")
			.attr("x", 20).attr("y",20)
			.text(info).attr("class","info")
	*/
//	console.log({newSeq:newSeq})
  // num on the cell

			var numLabel = svg.selectAll(".numLabelNormal").data(aData).enter().append("text")
				.attr("x", function(d,i){ return (cellSize*( newSeq[Math.floor(i/n)]-0.5) + lineStart);})
				.attr("y", function(d,i){ return (cellSize*( newSeq[i%n]-0.45) + lineStart);})//
				.attr("class", function(d,i){ return("numLabelNormal numLabel_Y_"+ (newSeq[i%n] -1) ) +" numLabel_X_"+ (newSeq[Math.floor(i/n)] -1);})
				.text(function(d){return(parseFloat(d[4]).toFixed(3));})//
				.attr("fill", function(d){ return (parseFloat(d[4])>middleValue) ? "#ffa500":"green"})
//use attr visibility to decide the display or not
        .attr("visibility", function(d, i) {
					a1 = newSeq[Math.floor(i/n)];
					a2 = newSeq[i%n];
					if (numShow){
						if (diagShow=="diagLower"){
							return  a1>a2?"hidden":"visible";
						}else if(diagShow=="diagUpper"){
							return  a1<a2?"hidden":"visible";
						}else if(diagShow=="diagFull"){
							return "visible";}
					}else{
						return "hidden";
						}
					})
				.attr("font-size",numLabelSize)
//def rect
	var rect = svg.selectAll(".rect").data(aData).enter().append("rect")
				.attr("x", function(d,i){return  d[5]})
				.attr("y", function(d,i){return  d[6]})
				.attr("class", function(d,i){ a1 = Math.floor(i/n); a2 = i%n; return("rectCellNormal rect_Y_"+a1+" rect_X_"+a2);})
				.attr("width",cellSize)
				.attr("height",cellSize)
				.attr("stroke", "grey")
				.attr("fill","grey")
				.style("opacity", 0)


	// Fixed
//Y coordinate

	var axisLabel_Y = svg.selectAll(".axis_YNormal").data(mvisCorrplotData["colNames"]).enter().append("text")
			.attr("class", function(d,i){return "axis_YNormal text_Y_" + (newSeq[i]-1)})
			.attr("x", lineStart-3)
			.attr("y", function(d,i){return (newSeq[i]-0.5)*cellSize+lineStart+5;})
			.text(function(d){return d;})
			.attr("font-size",numLabelSize*1.5)
      .attr("color","transparent")

//console.log("add axis")
	//Fixed
  //x coordinate
	var axisLabel_X = svg.selectAll(".axis_XNormal").data(mvisCorrplotData["colNames"]).enter().append("text")
		.attr("class", function(d,i){return "axis_XNormal text_X_" + (newSeq[i]-1) })
		.attr("x", lineStart+3)
		.attr("y", function(d,i){return (newSeq[i]-0.5)*cellSize+lineStart+5;})
		.attr("transform", "rotate(-90,"+lineStart+","+lineStart+")")

		.text(function(d){return d;})
    .attr("font-size",numLabelSize*1.5)
//	vLineArray[i] =
// new Array(cellSize*i + lineStart, lineStart, cellSize*i + lineStart, lineEnd)
//  hLineArray[i] =
//new Array(lineStart, cellSize*i + lineStart, lineEnd, cellSize*i + lineStart)
/*  matrix net animation */
//console.log({"vL":vLineArray});
//console.log({"vL1":vLineArray[0][0]});
	var yLines = svg.selectAll(".yLines").data(vLineArray).enter().append("line")
				.attr("x1", function(d,i){return d[0];})
				.attr("y1", function(d,i){return d[1];})
				.attr("x2", function(d,i){return d[0];})
				.attr("y2", function(d,i){return d[1];})
				.attr("stroke", "gray").attr("stroke-width",1)
				.attr("class", "yLines")

	yLines.transition().duration(800).delay(500)
				.attr("x2", function(d,i){return d[2];})
				.attr("y2", function(d,i){return d[3];})
				.attr("stroke", "gray").attr("stroke-width",1)

	var xLines = svg.selectAll(".xLines").data(hLineArray).enter().append("line")
				.attr("x1", function(d,i){return d[0];})
				.attr("y1", function(d,i){return d[1];})
				.attr("x2", function(d,i){return d[0];})
				.attr("y2", function(d,i){return d[1];})
				.attr("stroke", "gray").attr("stroke-width",1)
				.attr("class", "xLines")


	xLines.transition().duration(800).delay(1000)
				.attr("x2", function(d,i){return d[2];})
				.attr("y2", function(d,i){return d[3];})
				.attr("stroke", "gray").attr("stroke-width",1)
/* */



/*draw legend*/
	var drawLegend = function(){

console.log(d3.rgb(maxCol))

var legend = svg.selectAll(".legend")
					.data([1]).enter()
					.append("g")
var legendWidth = 0.05*w;
//linear gradient
    //
//
var defs = legend.append("defs");
var linearGradient = defs.append("linearGradient")
.attr("id","linearColor1")
.attr("x1","0%")
.attr("y1","0%")
.attr("x2","0%")
.attr("y2","100%")
var stopI1 = linearGradient.append("stop")
.attr("offset","0%")
.style("stop-color",d3.rgb(maxCol).toString())



var stopI2 = linearGradient.append("stop")
.attr("offset","100%")
.style("stop-color",d3.rgb(middleCol).toString())
//2

var linearGradient = defs.append("linearGradient")
.attr("id","linearColor2")
.attr("x1","0%")
.attr("y1","0%")
.attr("x2","0%")
.attr("y2","100%")
var stopII1 = linearGradient.append("stop")
.attr("offset","0%")
.style("stop-color",d3.rgb(middleCol).toString())

//console.log(a.toString())

var stopII2 = linearGradient.append("stop")
.attr("offset","100%")
.style("stop-color",d3.rgb(minCol).toString())
//



var  rectGradient1 = legend.append("rect")
.attr("x",w-legendWidth*2.2)
.attr("y",lineStart).attr("width",legendWidth).attr("height",1/2*n*cellSize)
.style("fill","url(#linearColor1)")

var  rectGradient2 = legend.append("rect")
.attr("x",w-legendWidth*2.2)
.attr("y",lineStart+1/2*n*cellSize).attr("width",legendWidth).attr("height",1/2*n*cellSize)
.style("fill","url(#linearColor2)")


//console.log(d3.select("#linearColor1"))

/*
			var rectGradient = legend.selectAll(".rectgradient")
					.data(nBars)
					.enter().append("rect")
					.attr("id", "rectGradient")
					.attr("x", w-legendWidth*2.2)
					.attr("y", function(d,i){
            return w/nBar*i+lineStart} )
					.attr("width", legendWidth)
					.attr("height", w/nBar)
          .style("fill",function(d,i){
            if(i<nBar/2){
              return  compute1(liner1(d));
            }else {
              return  compute2(liner2(d));
            }

          })
*/

//
			var legendLabelDefine =  function(maxValue, minValue){
				nOfLabel = 11;//show 11 nums on the legend
				heightStep = cellSize*n/(nOfLabel-1)
				numStep = (maxValue-minValue)/(nOfLabel-1)
				var returnArray = new Array()
				for (i=0; i<nOfLabel; i++){
					returnArray.push(new Array(w-legendWidth*1.2, lineStart+(i*heightStep), parseFloat(maxValue-i*numStep).toFixed(1) ))
				}

				return returnArray;
			}



			var legendData = legendLabelDefine(maxValue, minValue)
			var legendGroup = legend.selectAll(".legendGroup")
					.data(legendData)
					.enter()
					.append("g")

			var legendLine = legendGroup.selectAll(".legendLine")//scale nodes
      //
					.data(legendData)
					.enter()
					.append("line")
					.attr("x1", function(d){return d[0];})
					.attr("y1", function(d){return (d[1] + (parseFloat(d[2])>middleValue?1:-1) );})
					.attr("x2", function(d){return d[0]+5;})
					.attr("y2", function(d){return (d[1] +  (parseFloat(d[2]) > middleValue?1:-1) );})
					.attr("stroke", "gray").attr("stroke-width",1)

			var legendText = legendGroup.selectAll(".legendText")
					.data(legendData)
					.enter()
					.append("text")
					.attr("x", function(d){return d[0] +8;})
					.attr("y", function(d){return (d[1]+  (parseFloat(d[2])>middleValue?1:-1));})
					.text( function(d){return d[2];})
					//.style("text-anchor","middle")
					.style("dominant-baseline","central")
		}
	drawLegend();
/*    */

	var overCell =  function(d,i){
    //
			var y = Math.floor(i/n)//
				x = i%n//
// mouse on, cell bigger
			if (method=="circle"){
				svg.selectAll(".cell_Y_"+y).transition().duration(500).delay(200)
        //
					.attr("r", function(d){return d[0]*1.1;})

				svg.selectAll(".cell_X_"+x).transition().duration(500).delay(200)
					.attr("r", function(d){return d[0]*1.1;})
			}else if (method == "ellipse"){
				svg.selectAll(".cell_Y_"+y).transition().duration(500).delay(200)
					.attr("ry", function(d){return 1.1*(cellSize/2 - Math.abs(d[0]));})

				svg.selectAll(".cell_X_"+x).transition().duration(500).delay(200)
					.attr("ry", function(d){return 1.1*(cellSize/2 - Math.abs(d[0]));})
			}else if (method == "square"){
				svg.selectAll(".cell_Y_"+y).transition().duration(500).delay(200)
					.attr("width", function(d){return 2.2*d[0]})
					.attr("height", function(d){return 2.2*d[0]})
				svg.selectAll(".cell_X_"+x).transition().duration(500).delay(200)
					.attr("width", function(d){return 2.2*d[0]})
					.attr("height", function(d){return 2.2*d[0]})
			}
			info = "x:"+ x+";y:"+y

			//svg.selectAll(".info")
				//.transition().duration(100).delay(200)
			//.text(info)


//onsole.log({"newseq":newSeq})
			svg.selectAll(".rect_X_"+x).transition().duration(100).delay(200)
				.style("opacity", 0.2)//
			svg.selectAll(".rect_Y_"+y).transition().duration(100).delay(200)
				.style("opacity", 0.2)
				svg.selectAll(".numLabelNormal").data(aData).enter().append("text")


//
			svg.selectAll(".numLabel_Y_"+y).transition().duration(500).delay(200)
				.attr("visibility", function(d,i){//
					if (diagShow=="diagLower"){
						return  newSeq[i] > y+1 ?"hidden":"visible";
					}else if(diagShow=="diagUpper"){
						return  newSeq[i] <= y ?"hidden":"visible";
					}else if(diagShow=="diagFull"){
						return "visible";}
					})
				.attr("font-size",1.5*numLabelSize)  //visible

			svg.selectAll(".numLabel_X_"+x).transition().duration(500).delay(200)
				.attr("visibility", function(d,i){
					if (diagShow=="diagLower"){
						return  newSeq[i] < x+1 ?"hidden":"visible";
					}else if(diagShow=="diagUpper"){
						return  newSeq[i] > x+1 ?"hidden":"visible";
					}else if(diagShow=="diagFull"){
						return "visible";}
					})
				.attr("font-size",1.5*numLabelSize)


			svg.select(".text_Y_"+y).transition().duration(500).delay(200)
				.attr("font-size", 3*numLabelSize)
				.attr("font-weight","bold")
				.attr("fill","#f00")


			if (diagShow == "diagLower"){
				svg.select(".text_X_"+x).transition().duration(200).delay(200)
					.attr("x", (x+0.5)*cellSize+lineStart-5)
					.attr("y", lineStart-15+ x*cellSize)
					.attr("font-size", "23px")
					.attr("font-weight","bold")
					.attr("fill","#f00")
					.attr("transform", "")
					.attr("text-anchor", "middle")
			}else{
				svg.select(".text_X_"+x).transition().duration(200).delay(200)
				.attr("x", (x+0.5)*cellSize+lineStart-5)
				.attr("y", lineStart-15)
				.attr("font-size", 3*numLabelSize)
				.attr("font-weight","bold")
				.attr("fill","#f00")
				.attr("transform", "")
				.attr("text-anchor", "middle")

			}

	}

	var outCell = function(d,i){


		var y = Math.floor(i/n)
			x = i%n
		//alert(numShow)
			//alert("x:"+ x+"y:"+y)
			svg.selectAll(".numLabelNormal").transition().duration(500).delay(200)
			.attr("visibility", function(u,m){
				if (numShow == true){
					a1 = newSeq[Math.floor(m/n)];
					a2 = newSeq[m%n];
					if (diagShow=="diagLower"){
						return  a1>a2?"hidden":"visible";
					}else if(diagShow=="diagUpper"){
						return  a1<a2?"hidden":"visible";
					}else if(diagShow=="diagFull"){
						return "visible";}
					}else{
						return "hidden";
					}
				})
			.attr("font-size",numLabelSize)//visible


		svg.selectAll("rect.tmp_rectv").transition().duration(500).delay(200)
			.remove()
		svg.selectAll("rect.tmp_recth").transition().duration(500).delay(200)
			.remove()

		if (method=="circle"){
		svg.selectAll(".cell_Y_"+y).transition().duration(500).delay(200)
			.attr("r", function(d){return d[0];})

		svg.selectAll(".cell_X_"+x).transition().duration(500).delay(200)
			.attr("r", function(d){return d[0];})
		}else if (method == "ellipse"){
		svg.selectAll(".cell_Y_"+y).transition().duration(500).delay(200)
			.attr("ry", function(d){return (cellSize/2 - Math.abs(d[0]));})

		svg.selectAll(".cell_X_"+x).transition().duration(500).delay(200)
			.attr("ry", function(d){return (cellSize/2 - Math.abs(d[0]));})
		}else if (method == "square"){
		svg.selectAll(".cell_Y_"+y).transition().duration(500).delay(200)
			.attr("width", function(d){return 2*d[0]})
			.attr("height", function(d){return 2*d[0]})
		svg.selectAll(".cell_X_"+x).transition().duration(500).delay(200)
			.attr("width", function(d){return 2*d[0]})
			.attr("height", function(d){return 2*d[0]})
		}

		svg.selectAll(".rect_X_"+x).transition().duration(100).delay(200)
			.style("opacity", 0)
		svg.selectAll(".rect_Y_"+y).transition().duration(100).delay(200)
			.style("opacity", 0)

		svg.select(".text_Y_"+y).transition().duration(500).delay(200)
			.attr("font-size", 2*numLabelSize)
			.attr("font-weight","normal")
			.attr("fill","black")

		svg.select(".text_X_"+x).transition().duration(200).delay(200)
			.attr("x", lineStart+3 - x*cellSize)
			//.attr("x", lineStart+3)
			.attr("y", (x+0.5)*cellSize+lineStart+5)
			.attr("transform", "rotate(-90,"+lineStart+","+lineStart+")")
			.attr("font-size", 2*numLabelSize)
			.attr("font-weight","normal")
			.attr("fill","black")
			.attr("text-anchor", "left")

		if (diagShow == "diagLower"){
				svg.select(".text_X_"+x).transition().duration(200).delay(200)
					.attr("x", lineStart+3 - x*cellSize)
					//.attr("x", lineStart+3)
					.attr("y", (x+0.5)*cellSize+lineStart+5)
					.attr("transform", "rotate(-90,"+lineStart+","+lineStart+")")
					.attr("font-size", 2*numLabelSize)
					.attr("font-weight","normal")
					.attr("fill","black")
					.attr("text-anchor", "left")

			}else{
				svg.select(".text_X_"+x).transition().duration(200).delay(200)
					.attr("x", lineStart+3)
					.attr("y", (x+0.5)*cellSize+lineStart+5)
					.attr("transform", "rotate(-90,"+lineStart+","+lineStart+")")
					.attr("font-size", 2*numLabelSize)
					.attr("font-weight","normal")
					.attr("fill","black")
					.attr("text-anchor", "left")

			}


	}

	rect.on("mouseover.tooltip",overCell)

	rect.on("mouseout.tooltip",outCell)




console.log(pMat.length);



/*			.attr("x", function(d,i){return  d[5]})
      .attr("y", function(d,i){return  d[6]})
      .attr("class", function(d,i){ a1 = Math.floor(i/n); a2 = i%n; return("rectCellNormal rect_Y_"+a1+" rect_X_"+a2);})
      .attr("width",cellSize)
      .attr("height",cellSize)
      .attr("stroke", "grey")
      .attr("fill","grey")
      .style("opacity", 0)
      */

//draw pch for significance test


var sigpchx = new Array();
var sigpchy = new Array();
for(var i=0;i<n;i++){
for(var j=0;j<n;j++){
sigpchx[n*i+j] = new Array( aData[n*i+j][7][0],aData[n*i+j][7][1],aData[n*i+j][7][2],aData[n*i+j][7][3]);//y1,y2,x1,x2,
sigpchy[n*i+j] = new Array( aData[n*i+j][8][0],aData[n*i+j][8][1],aData[n*i+j][8][2],aData[n*i+j][8][3]);//y1,y2,x1,x2,
}
}
function drawPch (newSeq){
var sigArray = new Array();

for(var i=0;i<n;i++){
for(var j=0;j<n;j++){
sigArray[n*(newSeq[i]-1)+(newSeq[j]-1)] = SigArray[n*i+j];
}}
console.log(sigArray)
svg.selectAll(".sigNormalI").remove()
svg.selectAll(".sigNormalII").remove()
var sigI = svg.selectAll("#significance_I").data(sigpchx).enter().append("line")
.attr("x1",function(d){return d[0]}).attr("y1",function(d){return d[2]})
.attr("x2",function(d){return d[1]}).attr("y2",function(d){return d[3]})
.attr("stroke","black").attr("stroke-width",1)
.attr("class",function(d,i){
  var x = i/n, y = i%n;
  return 'sigNormalI sig_X_'+x+' sig_Y_'+y;
});

var sigII = svg.selectAll("#significance_II").data(sigpchy).enter().append("line")
.attr("x1",function(d){return d[0]}).attr("y1",function(d){return d[2]})
.attr("x2",function(d){return d[1]}).attr("y2",function(d){return d[3]})
.attr("stroke","black").attr("stroke-width",1)
.attr("class",function(d,i){
  var x = Math.floor(i/n), y = i%n;
  return 'sigNormalII sig_X_'+x+' sig_Y_'+y;
});

d3.selectAll('.sigNormalI').attr("visibility",function(u,m){

var a1 = Math.floor(m/n)//
var a2 = m%n//

if(sigArray[m]==1){return "hidden"}else if (diagShow=="diagLower"){
  return  a1<a2?"hidden":"visible";
}else if(diagShow=="diagUpper"){
  return  a1>a2?"hidden":"visible";
}else if(diagShow=="diagFull"){
  return "visible";}else{
return "hidden";}
})
d3.selectAll('.sigNormalII').attr("visibility",function(u,m){

  var a1 = Math.floor(m/n)//
  var a2 = m%n//

  if(sigArray[m]==1){return "hidden"}else if (diagShow=="diagLower"){
    return  a1<a2?"hidden":"visible";
  }else if(diagShow=="diagUpper"){
    return  a1>a2?"hidden":"visible";
  }else if(diagShow=="diagFull"){
    return "visible";}else{
  return "hidden";
  }

})
}

/*.attr("x1",function(d,i){
    var y = Math.floor(i/n)//
      x = i%n//

var x1 = d3.select('.rect_X_'+x+' rect_Y_'+y).attr("x")
  return x1})
.attr("y1",function(d,i){
  var y = Math.floor(i/n)//取行
    x = i%n//取列

var y1 = d3.select('.rect_X_'+x+' rect_Y_'+y).attr("y")
return y1
})
.attr("x2",function(d,i){
  var y = Math.floor(i/n)//取行
    x = i%n//取列

var x2 = d3.select('.rect_X_'+x+' rect_Y_'+y).attr("x")+cellSize
return x2
})
.attr("y2",function(d,i){
  var y = Math.floor(i/n)//取行
    x = i%n//取列

var y2 = d3.select('.rect_X_'+x+' rect_Y_'+y).attr("y")+cellSize
return y2
})
*/
//
//  var sig = d3.selectAll(".significance").append("line")
  //				.attr("x", function(d,i){ return (cellSize*( newSeq[Math.floor(i/n)]-0.5) + lineStart);})
  //				.attr("y", function(d,i){ return (cellSize*( newSeq[i%n]-0.45) + lineStart);})// 这里完全按照效果，可能需要一点靠谱的解释
  // var sig = d3.selectAll(".significance").append("line")



//sigDraw()

//console.log(aData[7])
/*
var digLineII = d3.svg.line()
.x(function(d){return 1*d[5]+0.05*cellSize;})
.y(function(d){return 1*d[5]+0.05*cellSize;})
*/

///

/*sig button*/

$("#sigshow").click(function(){
if ($(this).val()=="sigshow"){
sigshow = true;
$("#sigshow").text("sighidden")
$("#sigshow").val("sighidden")
//
drawPch(newSeq)

}else{
$("#sigshow").text("sigshow")
$("#sigshow").val("sigshow")
svg.selectAll(".sigNormalI").remove()
svg.selectAll(".sigNormalII").remove()
sigshow = false;
}


})

//


//numshowbutton

$("button[id=numShow]").click(
		function(){
			if ($(this).val()=="show"){
				numShow = true;
        //
				$("#numShow").text("Hidden")
				$("#numShow").val("hidden")
				svg.selectAll(".numLabelNormal")
				.attr("visibility", function(u,m){
						if (numShow == true){
							a1 = newSeq[Math.floor(m/n)];
							a2 = newSeq[m%n];
							if (diagShow=="diagLower"){
								return  a1>a2?"hidden":"visible";
							}else if(diagShow=="diagUpper"){
								return  a1<a2?"hidden":"visible";
							}else if(diagShow=="diagFull"){
								return "visible";}
							}else{
								return "hidden";
							}
						})
			}else{
				numShow = false;
				$("#numShow").text("Show")
				$("#numShow").val("show")

				svg.selectAll(".numLabelNormal").attr("visibility", "hidden")
			}
		}
	)
// legend


	$('#legendDiv').on('change', function() {
		//console.log( $('#diagDiv input:radio:checked').attr("id"));

		d3.selectAll(".cell").remove()//keypoint

		//method = "diag" + $('#diagDiv input:radio:checked').attr("id");
		method = $('#legendDiv input:radio:checked').attr("id");
		//console.log( $('#legendDiv input:radio:checked').attr("id"));

	if (method=="circle"){

		var cells = svg.selectAll(".cells").data(aData)
			.enter()
			.append("circle")
			/*changed 11-01 .attr("r", function(d){return d[0];})
			.attr("cx", function(d,i){ return d[1];})
			.attr("cy", function(d,i){ return d[2];})
			.attr("fill", function(d){return d[3];})
			.attr("class", function(d,i){ a1 = Math.floor(i/n); a2 = i%n; return("cell cell_Y_"+a1+" cell_X_"+a2);})
		*/
			.attr("r", function(d){return d[0];})
			.attr("fill", function(d){return d[3];})
			.attr("cx", function(d,i){ return (cellSize*( newSeq[Math.floor(i/n)]-0.5) + lineStart);})
			.attr("cy", function(d,i){return (cellSize*( newSeq[i%n]-0.5) + lineStart);})
			.attr("class", function(d,i){ return("cell cell_Y_"+ (newSeq[i%n] -1) ) +" cell_X_"+ (newSeq[Math.floor(i/n)] -1);})


	}else if (method=="ellipse"){
		var cells = svg.selectAll(".cells").data(aData)
				.enter()
				.append("ellipse")
				/*changed 11-01 .append("ellipse")
				.attr("cx", function(d){return d[1];})
				.attr("cy", function(d){ return d[2];})
				.attr("fill", function(d){return d[3];})
				.attr("ry", function(d){return cellSize/2 - Math.abs(d[0]) ;})
				.attr("rx", cellSize/2)
				.attr("transform", function(d){ if (d[4]>0) {return "rotate( -45," + d[1] +","+d[2]+")"}else{ return "rotate( 45," + d[1] +","+d[2]+")"} })
				.attr("class", function(d,i){ a1 = Math.floor(i/n); a2 = i%n; return("cell cell_Y_"+a1+" cell_X_"+a2);})
		*/
				.attr("cx", function(d,i){ return (cellSize*(newSeq[Math.floor(i/n)] - 0.5)  + lineStart);})
				.attr("cy", function(d,i){ return (cellSize*( newSeq[i%n] - 0.5) + lineStart) ;})
				.attr("class", function(d,i){ return("cell cell_Y_"+ (newSeq[i%n] -1) ) +" cell_X_"+ (newSeq[Math.floor(i/n)] -1);})
				.attr("ry", function(d){return cellSize/2 - Math.abs(d[0]) ;})
				.attr("rx", cellSize/2)
				.attr("transform",function(d,i){
					if (d[4]>0) return "rotate( -45," + (cellSize*(newSeq[Math.floor(i/n)] - 0.5)  + lineStart) +","+(cellSize*( newSeq[i%n] - 0.5) + lineStart)+")";
					else return "rotate( 45," + (cellSize*(newSeq[Math.floor(i/n)] - 0.5)  + lineStart) +","+(cellSize*( newSeq[i%n] - 0.5) + lineStart)+")"})
				.attr("fill", function(d){return d[3];})


	}else if (method == "square"){
		var cells = svg.selectAll(".cells").data(aData)
				.enter()
				.append("rect")
				/*changed 11-01 .attr("x", function(d){return d[1] - d[0];})
				.attr("y", function(d){ return d[2] - d[0];})
				.attr("fill", function(d){return d[3];})
				.attr("width", function(d){return 2*d[0]})
				.attr("height", function(d){return 2*d[0]})
				.attr("class", function(d,i){ a1 = Math.floor(i/n); a2 = i%n; return("cell cell_Y_"+a1+" cell_X_"+a2);})
				*/
				.attr("fill", function(d){return d[3];})
				.attr("width", function(d){return 2*d[0]})
				.attr("height", function(d){return 2*d[0]})
				.attr("x", function(d,i){return (cellSize*( newSeq[Math.floor(i/n)]-0.5) + lineStart) - d[0];})
				.attr("y", function(d,i){ return (cellSize*( newSeq[i%n]-0.5) + lineStart) - d[0];})
				.attr("class", function(d,i){ return("cell cell_Y_"+ (newSeq[i%n] -1) ) +" cell_X_"+ (newSeq[Math.floor(i/n)] -1);})
		}


		svg.selectAll(".numLabelNormal").remove()
		var numLabel = svg.selectAll(".numLabelNormal").data(aData).enter().append("text")
					.attr("x", function(d,i){ return (cellSize*( newSeq[Math.floor(i/n)]-0.5) + lineStart);})

					.attr("y", function(d,i){ return (cellSize*( newSeq[i%n]-0.45) + lineStart);})
					.attr("class", function(d,i){ return("numLabelNormal numLabel_Y_"+ (newSeq[i%n] -1) ) +" numLabel_X_"+ (newSeq[Math.floor(i/n)] -1);})
					.text(function(d){return(parseFloat(d[4]).toFixed(3));})
					.attr("fill", function(d){ return (parseFloat(d[4])>middleValue) ? "orange":"green"})
					//.attr("visibility", "hidden")
					.attr("font-size",numLabelSize)

		svg.selectAll(".rectCellNormal").remove()
		rect = svg.selectAll(".rectCellNormal")
					.data(aData).enter().append("rect")
					.attr("x", function(d,i){return  d[5]})
					.attr("y", function(d,i){return  d[6]})
					.attr("class", function(d,i){ a1 = Math.floor(i/n); a2 = i%n; return("rectCellNormal rect_Y_"+a1+" rect_X_"+a2);})
					.attr("width",cellSize)
					.attr("height",cellSize)
					.attr("stroke", "red")
					.attr("fill","grey")
					.style("opacity", 0)

		diagInit("diag" + $('#diagDiv input:radio:checked').attr("id"))
	rect.on("mouseover.tooltip",overCell)
	rect.on("mouseout.tooltip",outCell)



	});

	function diagInit(diagShow){
// diag show
		var t = svg.transition().duration(500);
//cell
		var cells = t.selectAll(".cell")
				cells.attr("visibility", function(d, i) {
					a1 = newSeq[Math.floor(i/n)];
					a2 = newSeq[i%n];
					if (diagShow=="diagLower"){
						return  a1>a2?"hidden":"visible";
					}else if(diagShow=="diagUpper"){
						return  a1<a2?"hidden":"visible";
					}else if(diagShow=="diagFull"){
						return "visible";}})
// rect
			var rects = t.selectAll(".rectCellNormal")
				rects.attr("visibility", function(d, i) {
					a1 = Math.floor(i/n);
					a2 = i%n;

					if (diagShow=="diagLower"){
						return  a1<a2?"hidden":"visible";
					}else if(diagShow=="diagUpper"){
						return  a1>a2?"hidden":"visible";
					}else if(diagShow=="diagFull"){
						return "visible";}})
			var numLabel = t.selectAll(".numLabelNormal")
				numLabel.attr("visibility", function(d, i) {
					a1 = newSeq[Math.floor(i/n)];
					a2 = newSeq[i%n];
					if (numShow){
						if (diagShow=="diagLower"){
							return  a1>a2?"hidden":"visible";
						}else if(diagShow=="diagUpper"){
							return  a1<a2?"hidden":"visible";
						}else if(diagShow=="diagFull"){
							return "visible";}
					}else{
						return "hidden";
						}
					})

			if (diagShow=="diagLower"){
				var axisLabel_Y = t.selectAll(".axis_YNormal")
						.attr("x", lineStart-3)
				var axisLabel_X = t.selectAll(".axis_XNormal")
						.attr("x", function(d,i){return(lineStart+3 - (newSeq[i]-1)*cellSize)})
				t.selectAll(".yLines")
					.attr("x1", function(d,i){return d[0];})
					.attr("y1", function(d,i){if (i>0)return ((i-1)*cellSize+lineStart); else return d[0];})
					.attr("x2", function(d,i){return d[2];})
					.attr("y2", function(d,i){return d[3];})
				t.selectAll(".xLines")
					.attr("x1", function(d,i){return d[0];})
					.attr("y1", function(d,i){return d[1];})
					.attr("x2", function(d,i){if (i<n)return ((i+1)*cellSize+lineStart); else return d[3];})
					.attr("y2", function(d,i){return d[3];})

			}else if (diagShow=="diagUpper"){

				var axisLabel_Y = t.selectAll(".axis_YNormal")
						.attr("x", function(d,i){return(lineStart-3 + (newSeq[i]-1)*cellSize)})
				var axisLabel_X = t.selectAll(".axis_XNormal")
						.attr("x", lineStart+3)

				t.selectAll(".yLines")
					.attr("x1", function(d,i){return d[0];})
					.attr("y1", function(d,i){return d[1];})
					.attr("x2", function(d,i){return d[2];})
					.attr("y2", function(d,i){if (i<n)return ((i+1)*cellSize+lineStart); else return d[3];})
				t.selectAll(".xLines")
					.attr("x1", function(d,i){if (i>0)return ((i-1)*cellSize+lineStart); else return d[0];})
					.attr("y1", function(d,i){return d[1];})
					.attr("x2", function(d,i){return d[2];})
					.attr("y2", function(d,i){return d[3];})

			}else{
				var axisLabel_Y = t.selectAll(".axis_YNormal")
						.attr("x", lineStart-3)
				var axisLabel_X = t.selectAll(".axis_XNormal")
						.attr("x", lineStart+3)

				t.selectAll(".yLines")
					.attr("x1", function(d,i){return d[0];})
					.attr("y1", function(d,i){return d[1];})
					.attr("x2", function(d,i){return d[2];})
					.attr("y2", function(d,i){return d[3];})
				t.selectAll(".xLines")
					.attr("x1", function(d,i){return d[0];})
					.attr("y1", function(d,i){return d[1];})
					.attr("x2", function(d,i){return d[2];})
					.attr("y2", function(d,i){return d[3];})
			}


		/*var axisLabel_Y = svg.selectAll(".axis_Y").data(mvisCorrplotData["colNames"]).enter().append("text")
			.attr("class", function(d,i){return "axis_Y text_Y_" + (newSeq[i]-1)})
			.attr("x", lineStart-3)
			.attr("y", function(d,i){return (newSeq[i]-0.5)*cellSize+lineStart+5;})
			.text(function(d){return d;})
			.attr("font-size","18px")
	var axisLabel_X = svg.selectAll(".axis_X").data(mvisCorrplotData["colNames"]).enter().append("text")
		.attr("class", function(d,i){return "axis_X text_X_" + (newSeq[i]-1) })
		.attr("x", lineStart+3)
		.attr("y", function(d,i){return (newSeq[i]-0.5)*cellSize+lineStart+5;})
		.attr("transform", "rotate(-90,"+lineStart+","+lineStart+")")
		.text(function(d){return d;})
	*/



	};


	function changeSeq(newSeq, method){


console.log({"seqInChange":newSeq})
		var t = svg.transition().duration(500);
		t.selectAll(".axis_YNormal")
			.delay(function(d, i) { return i * 40; })
			.attr("x", function(d,i){if(diagShow=="diagUpper") {return(lineStart-3 + (newSeq[i]-1)*cellSize);} else {return(lineStart-3)}})
			.attr("y", function(d,i){return (newSeq[i]-0.5)*cellSize+lineStart+5;})
			.attr("class", function(d,i){return "axis_YNormal text_Y_" + (newSeq[i]-1)})
			//.attr("transform", function(d, i) {return "translate(0," + ((newSeq[i]-i-1)*cellSize) + ")"; })
//console.log(t.selectAll(".axis_YNormal").attr("y"))

		t.selectAll(".axis_XNormal")
			.delay(function(d, i) { return i * 40; })
			.attr("x", function(d,i){ if (diagShow=="diagLower") {return(lineStart+3 - (newSeq[i]-1)*cellSize)} else {return(lineStart+3)}})
			.attr("y", function(d,i){return (newSeq[i]-0.5)*cellSize+lineStart+5;})
			.attr("class", function(d,i){return "axis_XNormal text_X_" + (newSeq[i]-1) })

	/*.attr("class", function(d,i){ a1 = Math.floor(i/n); a2 = i%n; return("cell cell_Y_"+a1+" cell_X_"+a2);})
					.attr("cx", function(d){return d[1];})
				.attr("cy", function(d){ return d[2];})
				.attr("fill", function(d){return d[3];})
				.attr("ry", function(d){return cellSize/2 - Math.abs(d[0]) ;})
				.attr("rx", cellSize/2)
				.attr("transform", function(d){ if (d[4]>0) {return "rotate( -45," + d[1] +","+d[2]+")"}else{ return "rotate( 45," + d[1] +","+d[2]+")"} })
				.attr("class", function(d,i){ a1 = Math.floor(i/n); a2 = i%n; return("cell cell_Y_"+a1+" cell_X_"+a2);})
		*/

		//cellSize*(j+0.5) + lineStart
		if(method == "ellipse"){
			t.selectAll(".cell")
				.delay(function(d, i) { return i * 4; })
				.attr("cx", function(d,i){ return (cellSize*(newSeq[Math.floor(i/n)] - 0.5)  + lineStart);})
				.attr("cy", function(d,i){ return (cellSize*( newSeq[i%n] - 0.5) + lineStart) ;})
				.attr("class", function(d,i){ return("cell cell_Y_"+ (newSeq[i%n] -1) ) +" cell_X_"+ (newSeq[Math.floor(i/n)] -1);})
				.attr("transform",function(d,i){
					if (d[4]>0) return "rotate( -45," + (cellSize*(newSeq[Math.floor(i/n)] - 0.5)  + lineStart) +","+(cellSize*( newSeq[i%n] - 0.5) + lineStart)+")";
					else return "rotate( 45," + (cellSize*(newSeq[Math.floor(i/n)] - 0.5)  + lineStart) +","+(cellSize*( newSeq[i%n] - 0.5) + lineStart)+")"})

		}else if (method == "circle"){
			t.selectAll(".cell")
				.delay(function(d, i) { return i * 4; })
				.attr("cx", function(d,i){ return (cellSize*( newSeq[Math.floor(i/n)]-0.5) + lineStart);})
				.attr("cy", function(d,i){return (cellSize*( newSeq[i%n]-0.5) + lineStart);})
				.attr("class", function(d,i){ return("cell cell_Y_"+ (newSeq[i%n] -1) ) +" cell_X_"+ (newSeq[Math.floor(i/n)] -1);})
				//.attr("transform",function(d){ if (d[4]>0) {return "rotate( -45," + (cellSize*( 1.5) + lineStart) +","+(cellSize*( 1.5) + lineStart)+")"}
				//	else{ return "rotate( 45," + (cellSize*( newSeq[Math.floor(i/n)]+0.5) + lineStart) +","+(cellSize*( newSeq[i%n]+0.5) + lineStart)+")"} })
		}else if (method == "square") {
			t.selectAll(".cell")
				.delay(function(d, i) { return i * 4; })
				.attr("x", function(d,i){return (cellSize*( newSeq[Math.floor(i/n)]-0.5) + lineStart) - d[0];})
				.attr("y", function(d,i){ return (cellSize*( newSeq[i%n]-0.5) + lineStart) - d[0];})
				.attr("class", function(d,i){ return("cell cell_Y_"+ (newSeq[i%n] -1) ) +" cell_X_"+ (newSeq[Math.floor(i/n)] -1);})
		}

		t.selectAll(".numLabelNormal")
				//.attr("visibility", "visible")
				.attr("x", function(d,i){ return (cellSize*( newSeq[Math.floor(i/n)]-0.5) + lineStart);})
				.attr("y", function(d,i){ return (cellSize*( newSeq[i%n]-0.45) + lineStart);})
				.attr("class", function(d,i){ return("numLabelNormal numLabel_Y_"+ (newSeq[i%n] -1) ) +" numLabel_X_"+ (newSeq[Math.floor(i/n)] -1);})
				//.text(function(d,i) {return(newSeq[Math.floor(i/n)] + ";" + newSeq[i%n])})
				//.attr("transform",function(d){ if (d[4]>0) {return "rotate( -45," + (cellSize*( 1.5) + lineStart) +","+(cellSize*( 1.5) + lineStart)+")"}
				//	else{ return "rotate( 45," + (cellSize*( newSeq[Math.floor(i/n)]+0.5) + lineStart) +","+(cellSize*( newSeq[i%n]+0.5) + lineStart)+")"} })



		var cells = t.selectAll(".cell")
				cells.attr("visibility", function(d, i) {
					a1 = newSeq[Math.floor(i/n)];
					a2 = newSeq[i%n];
					if (diagShow=="diagLower"){
						return  a1>a2?"hidden":"visible";
					}else if(diagShow=="diagUpper"){
						return  a1<a2?"hidden":"visible";
					}else if(diagShow=="diagFull"){
						return "visible";}})

			var rects = t.selectAll(".rectCellNormal")
				rects.attr("visibility", function(d, i) {
					a1 = Math.floor(i/n);
					a2 = i%n;

					if (diagShow=="diagLower"){
						return  a1<a2?"hidden":"visible";
					}else if(diagShow=="diagUpper"){
						return  a1>a2?"hidden":"visible";
					}else if(diagShow=="diagFull"){
						return "visible";}})

			var numLabel = t.selectAll(".numLabelNormal")
				numLabel.attr("visibility", function(d, i) {
					a1 = newSeq[Math.floor(i/n)];
					a2 = newSeq[i%n];
					if (numShow){
						if (diagShow=="diagLower"){
							return  a1>a2?"hidden":"visible";
						}else if(diagShow=="diagUpper"){
							return  a1<a2?"hidden":"visible";
						}else if(diagShow=="diagFull"){
							return "visible";}
					}else{
						return "hidden";
						}
					})


	}



/*add 2018-1-30 cell  dragabble */
//function DragExchange (d,i){
/*

//var textDrag(d,i){
 var t = d3.behavior.drag()
.origin(function(d,i){
return {x:d3.select(this).attr("x"),
y:d3.select(this).attr("y")}})
.on("drag",function(d,i){
// text_Y
d3.select(this)
.attr("x",d.x=d3.event.x)
.attr("y",d.y=d3.event.y)
//var y = Math.floor(i/n)//
//var x = i%n//
//console.log({"i":i,"y":y,"x":x})
var rect_y = d3.selectAll(".rect_Y_"+i)
  .style({"opacity":0.2})
//console.log(".rect_Y_"+i)


//console.log(rect_y.size())
var textY = d3.selectAll(".axis_YNormal")
.on("mouseover",function(d,i){
d3.select(this).style({"opacity":0.2})
})
.on("mouseout",function(d,i){
d3.select(this).style({"opacity":1})
  })
})
.on("dragend",function(d,i){
var rect_y = d3.selectAll(".rect_Y_"+i)
.style({"opacity":0,"fill":"grey"})
})

//cells


//rect_y.attr("")



// 增添坐标动画
d3.selectAll(".axis_YNormal")
.on("mouseover",function(d,i){
d3.select(this).attr("fill","steelblue").attr("opacity",0.8)
.attr("font-size",function(d){
//  console.log(d3.select(this).attr("font-size"))
return "20px"})

//var y = Math.floor(i/n)//取列
//var x = i%n//取行




})
.on("mouseout",function(d,i){
d3.select(this).transition().duration(500)
.attr("fill","black")
.attr("opacity",1)
.attr("font-size",15)
})


//
d3.selectAll(".axis_XNormal")
.on("mouseover",function(d,i){
d3.select(this).attr("fill","steelblue").attr("opacity",0.8)
.attr("font-size",function(d,i){
//  console.log(d3.select(this).attr("font-size"))
return "20px"})
//.attr("x", (newSeq[i]+0.5)*cellSize+lineStart-5)
//.attr("y", lineStart-15)
})
.on("mouseout",function(d,i){
d3.select(this).transition().duration(500)
.attr("fill","black")
.attr("opacity",1)
.attr("font-size",15)
//.attr("y", lineStart+3)
//.attr("x", function(d,i){return (newSeq[i]-0.5)*cellSize+lineStart+5;})
//.attr("transform", "rotate(-90,"+lineStart+","+lineStart+")")

//.attr("transform","rotate(-90,"+lineStart+","+lineStart+")")
})
*/


/*
function  textExchange (t){
if(t.on("mouseover").size())

}
*/

//var tem = d3.selectAll(".axis_YNormal").call(t);

//tem.on("mouseover",function(){
//  console.log({"size":d3.event.size})
//})

//};



/**/

	$("#orderSelect").on("change", function() {
		//console.log(1233332)
newSeq = mvisCorrplotData["orderList"][this.value]; changeSeq(newSeq , method=method)
console.log(d3.selectAll(".axis_YNormal"))
if(sigshow){
    drawPch(newSeq=newSeq)}
//hclust rects

/* append hclust rects  2018-2-14*/
//
var hcRectButton = '<div class=hcRectShow><button id="hcRectshow">hclustRectShow</button><select id="hcRectNum"><option value=2>2</option>'+
'<option value=3>3</option><option value=4>4</option></select></div>';
if(this.value=='hclust'){
d3.selectAll(".hcRectShow").remove();

d3.selectAll("#hcRect")
.append("div")
.attr("id","#hcRect")
.html(hcRectButton)
$('#hcRectNum').on('change',function(){
RectNum = this.value
svg.selectAll(".hcRects").remove();
if(RectNum==2){
var rectData = rectOrderNum['a']
}else if (RectNum==3){
var rectData = rectOrderNum['b']
}else if (RectNum==4){
var rectData = rectOrderNum['c']
}
//
var rectTem = new Array()
var hcRect = new Array()
console.log(rectData)

for(var i=0;i<rectData.length;i++){
if(i==0){ rectTem[i] = 0
}else{ rectTem[i] = rectData[i-1]
}
hcRect[i] = [rectTem[i],rectData[i]]
}
console.log(hcRect)

//hcRect = [[0,5],[5,7],[7,11]]

var Rect = hcRect

//
var hcRectWidth = 0.005*w
svg.selectAll('.hcRectsI').data(Rect).enter().append("line")
.attr("x1",function(d,i){
return d[0]*cellSize+lineStart})
.attr("y1",function(d,i){
return d[0]*cellSize+lineStart})
.attr("x2",function(d,i){
return d[0]*cellSize+lineStart})
.attr("y2",function(d,i){
return d[1]*cellSize+lineStart})
.attr("stroke","black")
.attr("stroke-width",hcRectWidth)
.attr('class',"hcRects")

//
svg.selectAll('.hcRectsII').data(Rect).enter().append("line")
.attr("x1",function(d,i){
return d[0]*cellSize+lineStart})
.attr("y1",function(d,i){
return d[0]*cellSize+lineStart})
.attr("x2",function(d,i){
return d[1]*cellSize+lineStart})
.attr("y2",function(d,i){
return d[0]*cellSize+lineStart})
.attr("stroke","black")
.attr("stroke-width",hcRectWidth)
.attr('class',"hcRects")
//
svg.selectAll('.hcRectsIII').data(Rect).enter().append("line")
.attr("x1",function(d,i){
return d[1]*cellSize+lineStart})
.attr("y1",function(d,i){
return d[0]*cellSize+lineStart})
.attr("x2",function(d,i){
return d[1]*cellSize+lineStart})
.attr("y2",function(d,i){
return d[1]*cellSize+lineStart})
.attr("stroke","black")
.attr("stroke-width",hcRectWidth)
.attr('class',"hcRects")
//
svg.selectAll('.hcRectsIV').data(Rect).enter().append("line")
.attr("x1",function(d,i){
return d[0]*cellSize+lineStart})
.attr("y1",function(d,i){
return d[1]*cellSize+lineStart})
.attr("x2",function(d,i){
return d[1]*cellSize+lineStart})
.attr("y2",function(d,i){
return d[1]*cellSize+lineStart})
.attr("stroke","black")
.attr("stroke-width",hcRectWidth)
.attr('class',"hcRects")

})

}else {
svg.selectAll(".hcRects").remove();
d3.selectAll("#hcRectshow").remove();
d3.selectAll("#hcRectNum").remove();
}
  });



	$('#diagDiv').on('change', function(){
			diagShow = "diag" + $('#diagDiv input:radio:checked').attr("id")

			diagInit(diagShow)
if(sigshow){
    drawPch(newSeq=newSeq)}
	});



/*
$("#barsSeq").on("click", function() {
  //console.log(1233332)

//  console.log(barSeq)
//  console.log(newSeq)
//newSeq = barSeq;

function  getSeq(){

var barSeq = new Array();
//var nowSeq = new Array();
var barText = new Array();
for(var i=0;i<colNames.length;i++){
*/
/*for(var j=0;j<colNames.length;j++){
nowSeq[j] = colNames[newSeq[j]-1]

}*/
//console.log(nowSeq)

/*
barText[i] =   $(".sortBars div:eq("+i+")").text();

}
console.log(barText)
for(var i=0;i<colNames.length;i++){

barSeq[i] = barText.indexOf(colNames[i])+1;//这里坑了很久。。。
}


//console.log(barSeq)
return barSeq;
}
newSeq = getSeq();

changeSeq( newSeq,method=method);//
if(sigshow){
    drawPch(newSeq=newSeq)}
//console.log({"newSeq":newSeq})
//console.log(d3.selectAll(".axis_YNormal"))

//


//console.log(barSeq.indexOf("mpg"))
});
*/
//



/**/

/*2018-2-6 添加聚类的rects*/
//console.log(method)



/**/

		//var rects = svg.selectAll(".rect")



	}
//end init

/**/
/*
    function addBars(){




      function nameToHtml(){

      var nameBars = new String();
      for(var i=0;i<colNames.length;i++){


        for(var j=0;j<colNames.length;j++){
        nowSeq[j] = colNames[newSeq[j]-1]

        }



      var temBar = "<div id='seqSortBars'>"+nowSeq[i]+"</div>";
      nameBars = nameBars+temBar;

      }

      return nameBars;
      }

      var nameBars = nameToHtml();
      //console.log(nameBars)


      d3.select("#seqChangeBar").append("div").attr("class","sortBars")
      .html(nameBars)
    d3.select("#sortBar").selectAll("div").style("margin-top",lineStart)
        var barsBotton = '<button type="button" id="barsSeq">change sequence by hand</button>';
      d3.select("#seqChangeBar").append("div").html(barsBotton)

      $(".sortBars").sortable();
    }
      addBars()


*/


/**/


/**/


$(function(){
$( "#svgSizeSlider" ).slider({
orientation: "horizontal",
min:minSize,max:maxSize,value:init_w,

slide: function( event, ui ) {
        $( "#sizeRatio" ).text( Math.floor(100* ui.value/init_w) +"%");
      }
});
$( "#sizeRatio" ).text( Math.floor(100*$( "#svgSizeSlider" ).slider( "value" )/init_w)+"%" );


$("#svgSizeSub").on("click",function(){
console.log(w)

d3.selectAll("#plotSVG").remove();
d3.selectAll("#seqSortBars").remove();
w = $("#svgSizeSlider").slider("value");
h = w;


svg = plotDiv.append("svg")
    .attr("width", w)//
    .attr("height", h)//
  .attr("id", "plotSVG");

//wrapDiv.selectAll("div").remove();
//wrapDiv.selectAll("svg").remove();
/*
var plotDiv = wrapDiv.append("div")
 .attr("class", "corrplot")
 .attr("id", "corrplot-1")

var svgHTML = '	<svg xmlns="http://www.w3.org/2000/svg" version="1.1"><defs><linearGradient id="grad2" x1="0%" y1="0%" x2="0%" y2="100%"><stop offset="0%" style="stop-color:#053061;stop-opacity:1" /><stop offset="50%" style="stop-color:#FFFFFF;stop-opacity:1" /><stop offset="100%" style="stop-color:#67001F;stop-opacity:1" /></linearGradient></defs></svg>'

wrapDiv.append("svg")
 .html(svgHTML)
*/
init_corrplot(method = method)

})
})

	init_corrplot(method="circle")
  },

  resize: function(el, width, height, instance) {
  }

});
