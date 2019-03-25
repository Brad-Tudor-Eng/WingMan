using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Application as App;
using Toybox.Time.Gregorian as Calendar;
using Toybox.Sensor as Snsr;
using Toybox.Position as Position;
using Toybox.Math as Math;
using Toybox.Time as Time;
using Toybox.ActivityRecording as Record;


class inPlaneView extends Ui.View {
// settings = 0 for metric and 1 for feet

    var cPosX;
	var cPosY;
	var cAlt;
	var cHeading;
	var hSpeed;
	var cTime;
	var clock;
	var hour;
	var minute;

	var pTime;
	var pAlt;
	var vSpeed;

	var Distance;
	var Bearing;
	
	var width;
    var height;


//**********************************************************************************************
    
    function initialize()
    {


    }
//**************************************************************************************

    
    
//*************************************************************************    
function atan2(y, x) {
// quadrant specific tangent function 
        return
            x > 0 ? Math.atan(y / x) :
            x < 0 && y >= 0 ? Math.atan(y / x) + Math.PI :
            x < 0 && y < 0 ? Math.atan(y / x) - Math.PI :
            x == 0 && y > 0 ? Math.PI / 2 :
            x == 0 && y < 0 ? -1 * Math.PI / 2 :
            0;
    }
//*************************************************************************

//****************************************************************************
function mod(num,div) {
// mod function: Thank you Olga
//var Mreturn = num - Math.floor(num/div)* div;
var Mreturn = num - ((num/div).toNumber()* div);

return Mreturn;
}
//******************************************************************************

function abs(x){
x = Math.sqrt(Math.pow(x,2));
return x; 
}
//*****************************************************************************

function CourseCorrect(startLat,endLat,startLong,endLong,h)
{
// This function calculates the bearing from your current position to the target
// the current heading is taken into consideration and angle is adjusted 
// current heading is 12:00 position on watch face
// current pos is 2 = a; destination is 1 = b
var dLong = endLong - startLong;
var dPhi = Math.log(Math.tan(endLat/2+Math.PI/4)/Math.tan(startLat/2+Math.PI/4));

if (abs(dLong) > Math.PI){
	if (dLong > 0){
	  dLong = -(2*Math.PI - dLong);
	}
	else{
	dLong = (2*Math.PI + dLong);
	}
} 

var cc = mod((atan2(dLong,dPhi)*(180/Math.PI)+360),360);

h = h*(180/Math.PI);


	return
        cc < h ? (360 + cc - h)*(Math.PI/180) :
	    cc > h ? (cc - h)*(Math.PI/180) :
	    0;
}
//*****************************************************************************

    function hDist(lat1,lat2,lon1,lon2,r)
    {
    // calculates the distance between you and the target
    var a;
    var c;
    var d;

    
    a = Math.pow(Math.sin(((lat2 - lat1) / 2)),2) + Math.cos(lat1) * Math.cos(lat2) * Math.pow(Math.sin(((lon2 - lon1) / 2)),2);
        
    c = 2 * atan2(Math.sqrt(a),Math.sqrt(1-a));
    
    d = r.toFloat() * c;
    
    return d; 
    }

//**********************************************************    

    function CalcVspeed(z2,z1,ct,pt)
    { 
    // This function calculates the current vertical speed
    // vertical speed could be assending or decending or zero
 
	return
		ct != pt ? (abs(z2-z1)/(ct - pt)) :
		0;

    }

 //*****************************************************************************   
    function CalcNGS(ta,ca,dis)
    {
    // this function calculates the glide slope necissary to get back to the target
    // ca = current altitude, ta = target altitude, dis = distance

	return
        dis != 0 ? Math.atan(abs(ca - ta)/dis) :
	    0;	
    }
 //********************************************************************************
    function calcCGS(z2,z1,ct,pt,hs)
    {
    // this function calculates the current glide slope
        var VertSpeed = CalcVspeed(z2,z1,ct,pt);
        var HorzSpeed = hs;
        var CGS = Math.atan(VertSpeed / HorzSpeed);
       return CGS;
    }
 //********************************************************************************   

 //********************************************************************************* 
        //! @param dc Device Context to Draw
    //! @param angle Angle to draw the watch hand
    //! @param length Length of the watch hand
    //! @param width Width of the watch hand
   
    function drawArrow(dc, angle, width, length)
    {
        // Map out the coordinates of the watch hand
        var coords = [ [.03*width,-.44*length], [0, -.5*length],[-.03*width, -.44*length] ];
        var result = new [3];
        var centerX = dc.getWidth() / 2;
        var centerY = dc.getHeight() / 2;
        var cos = Math.cos(angle);
        var sin = Math.sin(angle);

        // Transform the coordinates
        for (var i = 0; i < 3; i += 1)
        {
            var x = (coords[i][0] * cos) - (coords[i][1] * sin);
            var y = (coords[i][0] * sin) + (coords[i][1] * cos);
            result[i] = [ centerX+x, centerY+y];
        }

        // Draw the polygon
        dc.fillPolygon(result);
        dc.fillPolygon(result);
    }
    
    //*****************************************************************************************************

    //! Load your resources here
    function onLayout(dc) {
   
    }

    function onHide() {
   
    }

    //! Restore the state of the app and prepare the view to be shown
    function onShow() {

    }

    //! Update the view
    function onUpdate(dc) {
        var string;
        
    app = App.getApp();
    dzX = app.getProperty("dzX_prop");
    dzY = app.getProperty("dzY_prop");
    dzZ = app.getProperty("dzZ_prop");
    targetAlt = app.getProperty("TargetAlt_prop");
       
   		width = dc.getWidth();
        height = dc.getHeight();
         
        // Set background color
        dc.setColor( Gfx.COLOR_TRANSPARENT, Gfx.COLOR_BLACK );
        dc.clear();
        dc.setColor( Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT );
        if( posnInfo != null ) {
        
        clock = Sys.getClockTime();
        
  
        if(cAlt == null){
          pTime = ((clock.hour % 12) * 3600) + (clock.min * 60) + clock.sec;
          pTime = pTime.toFloat();
        
        if(settings == 0){
          pAlt = posnInfo.altitude;
	    }
	    else{
	      pAlt = posnInfo.altitude*3.2808399;
	    }
	    }
	          
        cPosX = posnInfo.position.toRadians()[0];
        cPosY = posnInfo.position.toRadians()[1];
        
        if(settings == 0){
        cAlt = posnInfo.altitude;
        cHeading = posnInfo.heading;
	    hSpeed = posnInfo.speed.toFloat();
		}
		else{
		cAlt = posnInfo.altitude*3.2808399;
        cHeading = posnInfo.heading;
	    hSpeed = posnInfo.speed.toFloat()*3.2808399;
		}
		
	    
	    cTime = ((clock.hour % 12) * 3600) + (clock.min * 60) + clock.sec;
        cTime = cTime.toFloat();
        hour = (clock.hour % 12).toString();
        if (hour == "0" || hour == 0){
        hour = "12";
        }
        
        minute = clock.min;
        if(minute < 10){
        minute = "0" + clock.min.toString();
        }

        // Bearing is the angle the arrow will be displayed on the screen
          Bearing = CourseCorrect(cPosX,dzX,cPosY,dzY,cHeading);
          if(settings == 0){
          Distance = hDist(dzX,cPosX,dzY,cPosY,earthRadius)/1000;
          }
          else{
          Distance = hDist(dzX,cPosX,dzY,cPosY,earthRadius)*0.000189394;
          }
        
        
        
        if (pAlt != null && cTime != pTime){
        vSpeed = CalcVspeed(pAlt,cAlt,cTime,pTime);
        pTime = cTime;
        pAlt = cAlt;
        }	    
        
        if (vSpeed == null)
        {
        vSpeed = 0;
        }
            
            
            

//draw layout

// draw  circle
    dc.setColor(0xffff,0xffff);
    dc.fillCircle(width/2,height/2, width/2);
    dc.drawCircle(width/2,height/2, width/2);
    dc.setColor(0x000000,0x000000);
    dc.fillCircle(width/2,height/2, width/2-15);
    dc.drawCircle(width/2,height/2, width/2-15);




dc.setColor(0xffffff, 0xffffff);   
drawArrow(dc, Bearing, dc.getWidth(), dc.getHeight());


//DISPLAY INFORMATION

dc.setColor(Gfx.COLOR_WHITE,Gfx.COLOR_TRANSPARENT);


dc.drawText( dc.getWidth() / 2 - 57, ((dc.getHeight() / 2-80)), Gfx.FONT_TINY, "Altitude" , Gfx.TEXT_JUSTIFY_LEFT );
dc.drawText( ((dc.getWidth() / 2)+40), ((dc.getHeight() / 2-45)), Gfx.FONT_NUMBER_HOT , hour + ":" + minute, Gfx.TEXT_JUSTIFY_CENTER );
dc.drawText( ( dc.getWidth() / 2 - 70), (dc.getHeight() / 2 + 42 ), Gfx.FONT_TINY, "V Speed" , Gfx.TEXT_JUSTIFY_LEFT );
dc.drawText( dc.getWidth() / 2 - 90, (dc.getHeight() / 2+2 ), Gfx.FONT_TINY, "G Speed" , Gfx.TEXT_JUSTIFY_LEFT );
dc.drawText( dc.getWidth() / 2 - 85, (dc.getHeight() / 2 - 40 ), Gfx.FONT_TINY, "Distance" , Gfx.TEXT_JUSTIFY_LEFT );


if(settings == 0){
string = (cAlt - dzZ).format( "%.02f" );
dc.drawText( dc.getWidth() / 2 - 70, ((dc.getHeight() / 2-64)), Gfx.FONT_TINY, string + " m" , Gfx.TEXT_JUSTIFY_LEFT );
string = Distance.format( "%.02f" );
dc.drawText( dc.getWidth() / 2 - 88, (dc.getHeight() / 2-24 ), Gfx.FONT_TINY, string +" km" , Gfx.TEXT_JUSTIFY_LEFT );
string = (hSpeed*3.6).format( "%.02f" );
dc.drawText(dc.getWidth() / 2 - 85, (dc.getHeight() / 2 + 18 ), Gfx.FONT_TINY, string + " km/h" , Gfx.TEXT_JUSTIFY_LEFT );
string = vSpeed.format( "%.02f" );
dc.drawText(   dc.getWidth() / 2 - 55, (dc.getHeight() / 2 + 58 ), Gfx.FONT_TINY, string + " m/s" , Gfx.TEXT_JUSTIFY_LEFT );
}
else{
string = (cAlt - dzZ).format( "%.02f" );
dc.drawText( dc.getWidth() / 2 - 70, ((dc.getHeight() / 2-64)), Gfx.FONT_TINY, string + " ft", Gfx.TEXT_JUSTIFY_LEFT );
string = Distance.format( "%.02f" );
dc.drawText(  dc.getWidth() / 2 - 88, (dc.getHeight() / 2-24 ), Gfx.FONT_TINY,string +" mi" , Gfx.TEXT_JUSTIFY_LEFT );
string = (hSpeed*0.681818).format( "%.02f" );
dc.drawText( dc.getWidth() / 2 - 85, (dc.getHeight() / 2 + 18 ), Gfx.FONT_TINY, string + " mph" , Gfx.TEXT_JUSTIFY_LEFT );
string = vSpeed.format( "%.02f" );
dc.drawText(  dc.getWidth() / 2 - 55, (dc.getHeight() / 2 + 58 ), Gfx.FONT_TINY, string + " fps" , Gfx.TEXT_JUSTIFY_LEFT );
}	
        }
        else {
            dc.setColor( Gfx.COLOR_TRANSPARENT, Gfx.COLOR_BLACK );
            dc.clear();
            dc.setColor( Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT );
            dc.drawText( (dc.getWidth() / 2), (dc.getHeight() / 2), Gfx.FONT_SMALL, "No position info", Gfx.TEXT_JUSTIFY_CENTER );
              }
    }     
}







class inPlaneViewDelegate extends Ui.BehaviorDelegate
{
    function onSelect()
    {
    
    Ui.pushView(new inFlightNavView(),new inFlightNavViewDelegate(), Ui.SLIDE_IMMEDIATE);
    }
    
    function onNextPage()
    {

    }

    function onPreviousPage()
    {

    }
    
    function onBack()
    {

    Ui.pushView(new WingManMainMenu(),new MainMenuDelegate(), Ui.SLIDE_IMMEDIATE);
    
    }
    

}