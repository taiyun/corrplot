
$(function() {

var w = 700, h = 700, n = mvisCorrplotData["matrixLength"];
	lineStart = 60;
	lineEnd = 600;
	cellSize = (lineEnd - lineStart)/n;
	hLineArray = new Array(n+1);
	vLineArray = new Array(n+1);
	maxR = 0.9 * cellSize;
	minR = 0.1 * cellSize;
	numShow = false;
	method = mvisCorrplotData["method"]
	diagShow = "diagFull";
	nofFill = 0;
	maxValue = 1;
	middleValue = 0;
	minValue = -1;
	
	maxCol = mvisCorrplotData["color"][0];
	middleCol = mvisCorrplotData["color"][1];
	minCol = mvisCorrplotData["color"][2];
	newSeq = mvisCorrplotData["orderList"]["original"]
	
  $( "#legendDiv" ).buttonset();
	$( "#diagDiv" ).buttonset();
	$( "#numShow" ).button();
	
	$("bottonBox").css("margin-left")

var reg = /^#([0-9a-fA-f]{3}|[0-9a-fA-f]{6})$/;
String.prototype.colorHex = function(){
	var that = this;
	if(/^(rgb|RGB)/.test(that)){
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

var parse_mvisCorrplotData = function(a){
	if (a.length==1){
		outArray = new Array(1)
		percent = (a[0] - middleValue)/(maxValue - middleValue);
		r = (percent*(maxR-minR)+minR)/2;
		cx = cellSize*(0.5) + lineStart;
		cy = cellSize*(0.5) + lineStart;
		color = colorSelector(a[0])
		outArray[0] = new Array(r, cx, cy, color, a[0], cellSize*0+lineStart, cellSize*0+lineStart )
		return outArray
	}else{
		outArray = new Array(n*n)
		for(var i = 0; i < n; i++){
			for(var j=0; j < n; j++){
				if (a[i][j] > middleValue) percent = (a[i][j] - middleValue)/(maxValue - middleValue);
				else percent = (middleValue - a[i][j])/(middleValue - minValue);
				r = (percent*(maxR-minR)+minR)/2;
				cx = cellSize*(j+0.5) + lineStart;
				cy = cellSize*(i+0.5) + lineStart;
				color = colorSelector(a[i][j])
				outArray[i*n+j] = new Array(r, cx, cy, color, a[i][j], cellSize*j+lineStart, cellSize*i+lineStart )
			}
		}
		return outArray;
	}
}	
	

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
				else returnCol[i] =  parseInt((minRGB[i] - middleColRGB[i]) * percent + middleColRGB[i]);
			}
		}
		return("RGB(" + returnCol.join(",") + ")")
	}else{
		alert( v + "unexpected false.")
	}
}


for (i=0; i<n+1; i++){
	vLineArray[i] =  new Array(cellSize*i + lineStart, lineStart, cellSize*i + lineStart, lineEnd)
	hLineArray[i] = new Array(lineStart, cellSize*i + lineStart, lineEnd, cellSize*i + lineStart)
}


$( "#legend" ).buttonset();
$( "#diag" ).buttonset();





//circles.on("mouseover.tooltip",overCell)

//circles.on("mouseout.tooltip",outCell)

function init_corrplot( method){

var plotDiv = d3.select("#corrplot-1")
	.attr("width", w)
    .attr("height", h);
	
var svg = plotDiv.select("svg")
      .attr("width", w)
      .attr("height", h);
	


aData = parse_mvisCorrplotData(mvisCorrplotData["matrixData"])
console.log(aData)
/*

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
	
	t.selectAll(".numLabel")
			//.attr("visibility", "visible")
			.attr("x", function(d,i){ return (cellSize*( newSeq[Math.floor(i/n)]-0.5) + lineStart);})
			.attr("y", function(d,i){ return (cellSize*( newSeq[i%n]-0.5) + lineStart-5);})
			.attr("class", function(d,i){ return("numLabel numLabel_Y_"+ (newSeq[i%n] -1) ) +" numLabel_X_"+ (newSeq[Math.floor(i/n)] -1);})
			//.attr("transform",function(d){ if (d[4]>0) {return "rotate( -45," + (cellSize*( 1.5) + lineStart) +","+(cellSize*( 1.5) + lineStart)+")"}
			//	else{ return "rotate( 45," + (cellSize*( newSeq[Math.floor(i/n)]+0.5) + lineStart) +","+(cellSize*( newSeq[i%n]+0.5) + lineStart)+")"} })

	

*/
if (method=="circle"){
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
/*	info = "x:"+ 0+";y:"+0
var infoLabel = svg.selectAll(".info").data([1]).enter().append("text")
		.attr("x", 20).attr("y",20)
		.text(info).attr("class","info")
*/
console.log(newSeq)
var numLabel = svg.selectAll(".numLabelNormal").data(aData).enter().append("text")
			.attr("x", function(d,i){ return (cellSize*( newSeq[Math.floor(i/n)]-0.5) + lineStart);})
			.attr("y", function(d,i){ return (cellSize*( newSeq[i%n]-0.5) + lineStart-5);})
			.attr("class", function(d,i){ return("numLabelNormal numLabel_Y_"+ (newSeq[i%n] -1) ) +" numLabel_X_"+ (newSeq[Math.floor(i/n)] -1);})
			.text(function(d){return(parseFloat(d[4]).toFixed(3));})
			.attr("fill", function(d){ return (parseFloat(d[4])>middleValue) ? "#ffa500":"green"})
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
			.attr("font-size","8px")
				
			
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
var axisLabel_Y = svg.selectAll(".axis_YNormal").data(mvisCorrplotData["colNames"]).enter().append("text")
		.attr("class", function(d,i){return "axis_YNormal text_Y_" + (newSeq[i]-1)})
		.attr("x", lineStart-3)
		.attr("y", function(d,i){return (newSeq[i]-0.5)*cellSize+lineStart+5;})
		.text(function(d){return d;})
		.attr("font-size","15px")

//Fixed	
var axisLabel_X = svg.selectAll(".axis_XNormal").data(mvisCorrplotData["colNames"]).enter().append("text")
	.attr("class", function(d,i){return "axis_XNormal text_X_" + (newSeq[i]-1) })
	.attr("x", lineStart+3)
	.attr("y", function(d,i){return (newSeq[i]-0.5)*cellSize+lineStart+5;})
	.attr("transform", "rotate(-90,"+lineStart+","+lineStart+")")
	.text(function(d){return d;})

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
	

gradientColor = [maxCol, middleCol, minCol]

var drawLegend = function(){
		var legend = svg.selectAll("legend")
				.data([1]).enter()
				.append("g")
		var legendWidth = 30;
		var rectGradient = legend.selectAll("rectgradient")
				.data([1])
				.enter().append("rect")
				.attr("id", "rectGradient")
				.attr("x", w-80)
				.attr("y", lineStart)
				.attr("width", legendWidth)
				.attr("height", cellSize*n)
				.attr("fill","url(#grad2)")
				
				
				
		var legendLabelDefine =  function(maxValue, minValue){
			nOfLabel = 11;
			heightStep = cellSize*n/(nOfLabel-1)
			numStep = (maxValue-minValue)/(nOfLabel-1)
			var returnArray = new Array()
			for (i=0; i<nOfLabel; i++){
				returnArray.push(new Array(w-80+legendWidth, lineStart+(i*heightStep), parseFloat(maxValue-i*numStep).toFixed(1) ))
			}
			
			return returnArray;
		}
	

		var legendData = legendLabelDefine(maxValue, minValue)
		var legendGroup = legend.selectAll(".legendGroup")
				.data(legendData)
				.enter()
				.append("g")
		
		var legendLine = legendGroup.selectAll(".legendLine")
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
drawLegend()


var overCell =  function(d,i){
		var y = Math.floor(i/n)
			x = i%n

		if (method=="circle"){
			svg.selectAll(".cell_Y_"+y).transition().duration(500).delay(200)
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
		
	

		svg.selectAll(".rect_X_"+x).transition().duration(100).delay(200)
			.style("opacity", 0.2)
		svg.selectAll(".rect_Y_"+y).transition().duration(100).delay(200)
			.style("opacity", 0.2)
			svg.selectAll(".numLabelNormal").data(aData).enter().append("text")
			

		svg.selectAll(".numLabel_Y_"+y).transition().duration(500).delay(200)
			.attr("visibility", function(d,i){
				if (diagShow=="diagLower"){
					return  newSeq[i] > y+1 ?"hidden":"visible";
				}else if(diagShow=="diagUpper"){
					return  newSeq[i] <= y ?"hidden":"visible";
				}else if(diagShow=="diagFull"){
					return "visible";}
				})
			.attr("font-size","12px")  //visible
		
		svg.selectAll(".numLabel_X_"+x).transition().duration(500).delay(200)
			.attr("visibility", function(d,i){
				if (diagShow=="diagLower"){
					return  newSeq[i] < x+1 ?"hidden":"visible";
				}else if(diagShow=="diagUpper"){
					return  newSeq[i] > x+1 ?"hidden":"visible";
				}else if(diagShow=="diagFull"){
					return "visible";}
				})
			.attr("font-size","12px")
			
			
		svg.select(".text_Y_"+y).transition().duration(500).delay(200)
			.attr("font-size", "23px")
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
			.attr("font-size", "23px")
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
		.attr("font-size","9px")//visible	
		
	
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
		.attr("font-size", "15px")
		.attr("font-weight","normal")
		.attr("fill","black")
		
	svg.select(".text_X_"+x).transition().duration(200).delay(200)
		.attr("x", lineStart+3 - x*cellSize)
		//.attr("x", lineStart+3)
		.attr("y", (x+0.5)*cellSize+lineStart+5)
		.attr("transform", "rotate(-90,"+lineStart+","+lineStart+")")
		.attr("font-size", "15px")
		.attr("font-weight","normal")
		.attr("fill","black")
		.attr("text-anchor", "left")
		
	if (diagShow == "diagLower"){
			svg.select(".text_X_"+x).transition().duration(200).delay(200)
				.attr("x", lineStart+3 - x*cellSize)
				//.attr("x", lineStart+3)
				.attr("y", (x+0.5)*cellSize+lineStart+5)
				.attr("transform", "rotate(-90,"+lineStart+","+lineStart+")")
				.attr("font-size", "15px")
				.attr("font-weight","normal")
				.attr("fill","black")
				.attr("text-anchor", "left")
		
		}else{
			svg.select(".text_X_"+x).transition().duration(200).delay(200)
				.attr("x", lineStart+3)
				.attr("y", (x+0.5)*cellSize+lineStart+5)
				.attr("transform", "rotate(-90,"+lineStart+","+lineStart+")")
				.attr("font-size", "15px")
				.attr("font-weight","normal")
				.attr("fill","black")
				.attr("text-anchor", "left")
		
		}


}

	
rect.on("mouseover.tooltip",overCell)
rect.on("mouseout.tooltip",outCell)


$('input[name=numShow]').click(
function(){
numShow = $(this).attr("checked")
if (numShow=="checked"){
	numShow = true;
	$("#numShowLabel").text("Hidden")
	d3.selectAll("#numShowLabel").style("padding",".4em 1em")
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
	$("#numShowLabel").text("Show")
	d3.selectAll("#numShowLabel").style("padding",".4em 1em")
	svg.selectAll(".numLabelNormal").attr("visibility", "hidden")
}
}
)

$('input[name=legend]').live('change', function() { 
	
	d3.selectAll(".cell").remove()
		
	method = $(this).attr("id");
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

				.attr("y", function(d,i){ return (cellSize*( newSeq[i%n]-0.5) + lineStart-5);})
				.attr("class", function(d,i){ return("numLabelNormal numLabel_Y_"+ (newSeq[i%n] -1) ) +" numLabel_X_"+ (newSeq[Math.floor(i/n)] -1);})
				.text(function(d){return(parseFloat(d[4]).toFixed(3));})
				.attr("fill", function(d){ return (parseFloat(d[4])>middleValue) ? "orange":"green"})
				//.attr("visibility", "hidden")		
				.attr("font-size","9px")			

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

	diagInit(diagShow)			
rect.on("mouseover.tooltip",overCell)
rect.on("mouseout.tooltip",outCell)

				

});

function diagInit(diagShow){

	var t = svg.transition().duration(500);

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


	
	var t = svg.transition().duration(500);
	t.selectAll(".axis_YNormal") 
        .delay(function(d, i) { return i * 40; })
		.attr("x", function(d,i){if(diagShow=="diagUpper") {return(lineStart-3 + (newSeq[i]-1)*cellSize);} else {return(lineStart-3)}})
		.attr("y", function(d,i){return (newSeq[i]-0.5)*cellSize+lineStart+5;})
		.attr("class", function(d,i){return "axis_YNormal text_Y_" + (newSeq[i]-1)})
        //.attr("transform", function(d, i) {return "translate(0," + ((newSeq[i]-i-1)*cellSize) + ")"; })
	
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
			.attr("y", function(d,i){ return (cellSize*( newSeq[i%n]-0.5) + lineStart-5);})
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


d3.select("#orderSelect").on("change", function() {newSeq = mvisCorrplotData["orderList"][this.value]; changeSeq(newSeq , method=method)

});


$('input[name=diag]').live('change', function(){
		diagShow = $(this).attr("id")
		diagInit(diagShow)			
});


	//var rects = svg.selectAll(".rect")

}
init_corrplot(method="circle")


})
