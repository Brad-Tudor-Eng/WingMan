using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Application as App;
using Toybox.Position as Position;
using Toybox.Math as Math;
using Toybox.Time as Time;
using Toybox.Sensor as Sensor;
using Toybox.ActivityRecording as Record;



class inFlightNavView extends Ui.View {
// settings = 0 for metric and 1 for feet

    var cPosX;
	var cPosY;
	var cAlt;
	var cHeading;
	var hSpeed;
	var cTime;
	var clock;
	var offsetAlt = dzZ + targetAlt;

	var pTime;
	var pAlt;
	var vSpeed=1;
	var dtime;

	var Distance;
	var NGS;
	var CGS;
	var Bearing;
	var buffer = .2;
	
	var width;
    var height;
    
    var status = 1;
    var canopy = false;

    var accel;
    var xAccel;
    var yAccel;
    var zAccel;
    var tAccel;
    
    var session = null;

//**********************************************************************************************
    
    function initialize()
    {
     startRecording();
     canopy = false;

    }
    
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

    function CourseCorrect(startLat,endLat,startLong,endLong,h){
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

    function hDist(lat1,lat2,lon1,lon2,r){
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

    function CalcVspeed(z2,z1,ct,pt){ 
    // This function calculates the current vertical speed
    // vertical speed could be assending or decending or zero
 
	return
		ct != pt ? (abs(z2-z1)/(ct - pt)) :
		0;

    }

 //*****************************************************************************   
    function CalcNGS(ta,ca,dis){
    // this function calculates the glide slope necissary to get back to the target
    // ca = current altitude, ta = target altitude, dis = distance

	return
        dis != 0 ? Math.atan(abs(ca - ta)/dis) :
	    0;	
    }
 //********************************************************************************
    function calcCGS(vs,hs){
    // this function calculates the current glide slope

        return 
        hs != 0 ? Math.atan(abs(vs / hs)):
        0;
       
    }
 //********************************************************************************   
  function setStatus(c,n,b){
  return
       //Green - Making it back
        c <= (n - (b*n)) ?  1:
       //Yellow - May make it back
        c > (n - (b*n)) && c <= n ?  2:
       //Not Making it back
        3;
  }
 //********************************************************************************* 

        //! @param dc Device Context to Draw
    //! @param angle Angle to draw the watch hand
    //! @param length Length of the watch hand
    //! @param width Width of the watch hand
   
    function drawArrow(dc, angle, width, length){
        // Map out the coordinates of the watch hand
        var coords = [ [.06*width,-.305*length], [.1*width,-.29*length] ,[0, -.48*length], [-.1*width, -.29*length] ,[-.06*width, -.305*length],[0, -.31*length] ];
        var result = new [6];
        var centerX = dc.getWidth() / 2;
        var centerY = dc.getHeight() / 2;
        var cos = Math.cos(angle);
        var sin = Math.sin(angle);

        // Transform the coordinates
        for (var i = 0; i < 6; i += 1){
            var x = (coords[i][0] * cos) - (coords[i][1] * sin);
            var y = (coords[i][0] * sin) + (coords[i][1] * cos);
            result[i] = [ centerX+x, centerY+y];
        }

        // Draw the polygon
        dc.fillPolygon(result);
        dc.fillPolygon(result);
    }


//*****************************************************************************
//Moving average function
    function MovingAverage(oldAvg,oldCount,newValue){
        var newAverage;
        if(oldCount != 0){
            newAverage = (((oldAvg*oldCount)+newValue)/(oldCount+1));
        }
        else{ 
            newAverage = newValue;
        }
        return newAverage;
    }
//*****************************************************************************
    
   function startRecording(){
        if( Toybox has :ActivityRecording ) {
        if( ( session == null ) || ( session.isRecording() == false ) ) {
            session = Record.createSession({:name=>"Flight", :sport=>Record.SPORT_GENERIC});
            session.start();
            Ui.requestUpdate();
        }
    }
}    
//*****************************************************************************
    function stopRecording() {
        if( Toybox has :ActivityRecording ) {
            if( (session != null) && (session.isRecording() == true) ) {
                session.stop();
                session.save();
                session = null;
            }
        }
    }
   
//******************************************************************************
    //! Load your resources here
    function onLayout(dc) {
   
    }

    function onHide() {
       stopRecording();
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

        var info = Sensor.getInfo();

        if( info has :accel && info.accel != null ){
            accel = info.accel;
            xAccel = accel[0];
            yAccel = accel[1];
            zAccel = accel[2];
            
            if(xAccel == null){
                xAccel = 0;
            }
            
            if(yAccel == null){
                yAccel = 0;
            }
            
            if(zAccel == null){
                zAccel = 0;
            }
            
            if(settings == 0){
                tAccel = (Math.pow(Math.pow(xAccel,2)+Math.pow(yAccel,2)+Math.pow(zAccel,2),.5))*9.80665;
       		}
       		else{
       		    tAccel = (Math.pow(Math.pow(xAccel,2)+Math.pow(yAccel,2)+Math.pow(zAccel,2),.5))*0.0321740485564;
       		}
       		
            if(tAccel > 290.5){
                canopy = true;
            }
     
        }
       
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

        // Bearing is the angle the arrow will be displayed on the screen
        Bearing = CourseCorrect(cPosX,dzX,cPosY,dzY,cHeading);
        if(settings == 0){
            Distance = hDist(dzX,cPosX,dzY,cPosY,earthRadius)/1000;
        }
        else{
            Distance = hDist(dzX,cPosX,dzY,cPosY,earthRadius)*0.000189394;
        }


            
        if ((cTime - pTime) != 0 ){
        
            if (pAlt != null){
                vSpeed = CalcVspeed(pAlt,cAlt,cTime,pTime);
                NGS = CalcNGS(offsetAlt,cAlt,Distance);
                CGS = calcCGS(vSpeed,hSpeed);
            }

            if(NGS != null && CGS != null){
                status = setStatus(CGS,NGS,buffer);
            }
            
            pAlt = cAlt;
            pTime = cTime;
        }
            
            
        //update the damn view!
        if(status == 1 && canopy == false){
            //in flight green status
            dc.setColor(0x66ff66, 0x66ff66);
            dc.fillCircle(width/2, height/2, width/2);
            dc.drawCircle(width/2, height/2, width/2);
            dc.setColor(0x000000, 0x000000);
            dc.fillCircle(width/2, height/2, width/2-2);
            dc.drawCircle(width/2, height/2, width/2-2);    
            //draw inner circle ' main color
            dc.setColor(0x00ff00, 0x00ff00);
            dc.fillCircle(width/2, height/2, width/2-3);
            dc.drawCircle(width/2, height/2, width/2-3);
            //draw second inner circle ' border
            dc.setColor(0x000000, 0x000000);
            dc.fillCircle(width/2, height/2, width/3-7);
            dc.drawCircle(width/2, height/2, width/3-7);
            dc.setColor(0x66ff66, 0x66ff66);
            dc.fillCircle(width/2, height/2, width/3-8);
            dc.drawCircle(width/2, height/2, width/3-8);            
        }
        else if(status == 1 && canopy == true){
            // blue status for canopy flight
            //draw outer circle ' border
            dc.setColor(0x6666ff, 0x6666ff);
            dc.fillCircle(width/2, height/2, width/2);
            dc.drawCircle(width/2, height/2, width/2);
            dc.setColor(0x000000, 0x000000);
            dc.fillCircle(width/2, height/2, width/2-2);
            dc.drawCircle(width/2, height/2, width/2-2);    
            //draw inner circle ' main color
            dc.setColor(0x0000de, 0x0000ff);
            dc.fillCircle(width/2, height/2, width/2-3);
            dc.drawCircle(width/2, height/2, width/2-3);
            //draw second inner circle ' border
            dc.setColor(0x000000, 0x000000);
            dc.fillCircle(width/2, height/2, width/3-7);
            dc.drawCircle(width/2, height/2, width/3-7);
            dc.setColor(0x6666ff, 0x6666ff);
            dc.fillCircle(width/2, height/2, width/3-8);
            dc.drawCircle(width/2, height/2, width/3-8);

        }
        else if(status == 2){
            // yellow status for barely making it back
            //draw outer circle ' border
            dc.setColor(0x777777, 0x777777);
            dc.fillCircle(width/2, height/2, width/2);
            dc.drawCircle(width/2, height/2, width/2);
            dc.setColor(0x000000, 0x000000);
            dc.fillCircle(width/2, height/2, width/2-2);
            dc.drawCircle(width/2, height/2, width/2-2);    
            //draw inner circle ' main color
            dc.setColor(Gfx.COLOR_YELLOW, Gfx.COLOR_YELLOW);
            dc.fillCircle(width/2, height/2, width/2-3);
            dc.drawCircle(width/2, height/2, width/2-3);
            //draw second inner circle ' border
            dc.setColor(0x000000, 0x000000);
            dc.fillCircle(width/2, height/2, width/3-7);
            dc.drawCircle(width/2, height/2, width/3-7);
            dc.setColor(0x777777, 0x777777);
            dc.fillCircle(width/2, height/2, width/3-8);
            dc.drawCircle(width/2, height/2, width/3-8);
        }
        else if(status == 3){
            // red status not making it back
            //draw outer circle ' border
            dc.setColor(0xff6666, 0xff6666);
            dc.fillCircle(width/2, height/2, width/2);
            dc.drawCircle(width/2, height/2, width/2);
            dc.setColor(0x000000, 0x000000);
            dc.fillCircle(width/2, height/2, width/2-2);
            dc.drawCircle(width/2, height/2, width/2-2);    
            //draw inner circle ' main color
            dc.setColor(0xff0000, 0xff0000);
            dc.fillCircle(width/2, height/2, width/2-3);
            dc.drawCircle(width/2, height/2, width/2-3);
            //draw second inner circle ' border
            dc.setColor(0x000000, 0x000000);
            dc.fillCircle(width/2, height/2, width/3-7);
            dc.drawCircle(width/2, height/2, width/3-7);
            dc.setColor(0xff6666, 0xff6666);
            dc.fillCircle(width/2, height/2, width/3-8);
            dc.drawCircle(width/2, height/2, width/3-8);
        }

            // draw the mother fucking arrow
            dc.setColor(0x000000, 0x000000); 
            dc.fillCircle(width/2, height/2, width/3-10);
            dc.drawCircle(width/2, height/2, width/3-10); 
            drawArrow(dc, Bearing, dc.getWidth(), dc.getHeight());

            //dispay the altitude
            cAlt = cAlt-dzZ;
            string = cAlt.toNumber();
            string = string.toString();
            dc.setColor(Gfx.COLOR_WHITE,Gfx.COLOR_TRANSPARENT);
            dc.drawText( ((dc.getWidth() / 2)), ((dc.getHeight() / 3.5)), Gfx.FONT_NUMBER_HOT, string, Gfx.TEXT_JUSTIFY_CENTER );
            
            // update statistics

            // update statistics
            if(canopy != true){

            //vSpeedMax
            if(vSpeed > statsArray[1]){
                statsArray[1] = vSpeed;
            }
            //vSpeedAverage
            statsArray[2] = MovingAverage(statsArray[2],statsArray[0],vSpeed);

            //vSpeedMin
            if(vSpeed < statsArray[3]){
                statsArray[3] = vSpeed;
            }

            //hSpeedMax
            if(hSpeed > statsArray[4]){
                statsArray[4] = hSpeed;
            }
            //hSpeedAverage
            statsArray[5] = MovingAverage(statsArray[5],statsArray[0],hSpeed);
            //hSpeedMin
            if(hSpeed < statsArray[6]){
                statsArray[6] = hSpeed;
            }

            if(CGS != null){
                //glideSlopeMin
                if(CGS > statsArray[7]){
                    statsArray[7] = CGS;
                }

                //glideSlopeAverage
                statsArray[8] = MovingAverage(statsArray[8],statsArray[0],CGS);

                //glideSlopeMin
                if(CGS < statsArray[9]){
                    statsArray[9] = CGS;
                }
            }

            if(tAccel != null){
                //glideSlopeMin
                if(tAccel > statsArray[10]){
                    statsArray[10] = tAccel;
                }

                //glideSlopeMin
                if(tAccel < statsArray[11]){
                    statsArray[11] = tAccel;
                }
            }


            //update the counter for the averages
            statsArray[0] = statsArray[0] + 1;

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







class inFlightNavViewDelegate extends Ui.BehaviorDelegate
{

 
    function onSelect()
    {

        Ui.pushView(new reviewView(),new reviewViewDelegate(), Ui.SLIDE_IMMEDIATE); 
            
    }
    
    function onNextPage()
    {

    }

    function onPreviousPage()
    {

    }
    
    function onBack()
    {
    

    Ui.pushView(new WingManV2View(),new WatchFaceDelegate(), Ui.SLIDE_IMMEDIATE);
    
    }
    

}