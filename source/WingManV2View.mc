using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Math as Math;
using Toybox.Time as Time;
using Toybox.Time.Gregorian as Calendar;
using Toybox.WatchUi as Ui;
using Toybox.Application as App;




class WingManV2View extends Ui.WatchFace {
//******************************************************************
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


//*******************************************************************
    //! Draw the watch hand
    //! @param dc Device Context to Draw
    //! @param angle Angle to draw the watch hand
    //! @param length Length of the watch hand
    //! @param width Width of the watch hand
    
    function drawHand(dc, angle, length, width,hand){
        var thickness;
        if(hand == 1){
            thickness = 5;
        }
        else{
            thickness = 4;
        }
        // Map out the coordinates of the watch hand
        var coords = [ [(-(width/2)-1)-1,0], [(-(width/2)-thickness-1), (-length*.75)], [width/2, -length-1] ,[(width/2+thickness)+1, (-length*.75)], [(width/2+1)+1, 0] ];
        var result = new [5];
        var result2 = new [4];
        var result3 = new [4];
        var result4 = new [4];
        var result5 = new [5];
        var centerX = dc.getWidth() / 2;
        var centerY = dc.getHeight() / 2;
        var cos = Math.cos(angle);
        var sin = Math.sin(angle);

		dc.setColor(Gfx.COLOR_DK_GRAY, Gfx.COLOR_WHITE);
        // Transform the coordinates
        for (var i = 0; i < 5; i += 1)
        {
            var x = (coords[i][0] * cos) - (coords[i][1] * sin);
            var y = (coords[i][0] * sin) + (coords[i][1] * cos);
            result5[i] = [ centerX+x, centerY+y];
        }

        // Draw the polygon
        dc.fillPolygon(result5);
        dc.fillPolygon(result5);

        coords = [ [(-(width/2)-1),0], [(-(width/2)-thickness), (-length*.75)], [width/2, -length] ,[(width/2+thickness), (-length*.75)], [(width/2+1), 0] ];
		dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_WHITE);
        // Transform the coordinates
        for (var i = 0; i < 5; i += 1)
        {
            var x = (coords[i][0] * cos) - (coords[i][1] * sin);
            var y = (coords[i][0] * sin) + (coords[i][1] * cos);
            result[i] = [ centerX+x, centerY+y];
        }

        // Draw the polygon
        dc.fillPolygon(result);
        dc.fillPolygon(result);
        
        
        
        var x1 = (-(width/2)-1);
        var x2 = (-(width/2)-thickness);
        var y1 = 0;
        var y2 = (-length*.75);
        var a = 1;
        var b = 1.5;
        var rlocx =(x1 + b*(x2 - x1)/(a + b));
        var rlocy =(y1 + b*(y2 - y1)/(a + b));
                
        //draw the gray section on the hands
        dc.setColor(Gfx.COLOR_LT_GRAY,Gfx.COLOR_TRANSPARENT);
        coords = [ [(-(width/2)-1),0], [rlocx, rlocy],[(width/2), rlocy], [(width/2), 0] ];
        for (var i = 0; i < 4; i += 1)
        {
            var x = (coords[i][0] * cos) - (coords[i][1] * sin);
            var y = (coords[i][0] * sin) + (coords[i][1] * cos);
            result2[i] = [ centerX+x, centerY+y];
        }

        // Draw the polygon
        dc.fillPolygon(result2);
        dc.fillPolygon(result2);
        
                dc.setColor(Gfx.COLOR_DK_GRAY,Gfx.COLOR_TRANSPARENT);
        coords = [ [((width/2+1)),0], [-rlocx, rlocy],[(width/2), rlocy], [(width/2), 0] ];
        for (var i = 0; i < 4; i += 1)
        {
            var x = (coords[i][0] * cos) - (coords[i][1] * sin);
            var y = (coords[i][0] * sin) + (coords[i][1] * cos);
            result3[i] = [ centerX+x, centerY+y];
        }

        // Draw the polygon
        dc.fillPolygon(result3);
        dc.fillPolygon(result3);
 
        dc.setColor(Gfx.COLOR_LT_GRAY,Gfx.COLOR_TRANSPARENT);
        coords = [ [(width/2), rlocy],[width/2, -length],[(width/2+thickness), (-length*.75)],[-rlocx, rlocy]];
        for (var i = 0; i < 4; i += 1)
        {
            var x = (coords[i][0] * cos) - (coords[i][1] * sin);
            var y = (coords[i][0] * sin) + (coords[i][1] * cos);
            result4[i] = [ centerX+x, centerY+y];
        }

        // Draw the polygon
        dc.fillPolygon(result4);
        dc.fillPolygon(result4);       
    }

   //****************************************************************

    //! Draw the hash mark symbols on the watch
    //! @param dc Device context
    function drawHashMarks(dc)
    {
    	var width = dc.getWidth();
        var angle = 0;
        var coords = [ [-1,-110], [-1, -95], [0, -95], [0, -110] ];
        var result = new [4];
        var result2 = new [4];
        var centerX = dc.getWidth() / 2;
        var centerY = dc.getHeight() / 2;
        var cos;
        var sin;
        
        //draw the big dashes
        // Transform the coordinates
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        for (angle = 0; angle < (360/(2*Math.PI)); angle += (30*Math.PI/180)){
        for (var i = 0; i < 4; i += 1)
        {
        	cos = Math.cos(angle);
            sin = Math.sin(angle);
            var x = (coords[i][0] * cos) - (coords[i][1] * sin);
            var y = (coords[i][0] * sin) + (coords[i][1] * cos);
            result[i] = [ centerX+x, centerY+y];
        }
        
        // Draw the polygon
        dc.fillPolygon(result);
        //dc.fillPolygon(result);
     }
     
       dc.setColor(Gfx.COLOR_LT_GRAY, Gfx.COLOR_TRANSPARENT);
       coords = [ [0,-110], [0, -95], [1, -95], [1, -110] ];
        for (angle = 0; angle < (360/(2*Math.PI)); angle += (30*Math.PI/180)){
        for (var i = 0; i < 4; i += 1)
        {
        	cos = Math.cos(angle);
            sin = Math.sin(angle);
            var x = (coords[i][0] * cos) - (coords[i][1] * sin);
            var y = (coords[i][0] * sin) + (coords[i][1] * cos);
            result[i] = [ centerX+x, centerY+y];
        }
        
        // Draw the polygon
        dc.fillPolygon(result);
        //dc.fillPolygon(result);
     }
     
     
     
    }

   //****************************************************************

//********************************************************************
// Built in functions below
//********************************************************************

    function initialize() {
    
        if(settings.distanceUnits == 1){
        //1 = inches
    //You can use 3,959 for miles, 6,371 for kilometers or 20,903,520 to get the result in feet
         earthRadius = 20903520;
        
 
        }
        else {
        // 2 = metric settings meters
        earthRadius = 6371000;    
        }
        
    }

    //! Load your resources here
    function onLayout(dc) {
        
    }

    //! Called when this View is brought to the foreground. Restore
    //! the state of this View and prepare it to be shown. This includes
    //! loading resources into memory.
    function onShow() {
    
    }

    //! Update the view
    function onUpdate(dc) {


        var width, height;
        var clockTime = Sys.getClockTime();
        var hour;
        var min;
        var font = Gfx.FONT_NUMBER_MEDIUM;
        var hand = 1;
        var cDZ;
        
        app = App.getApp();
        dzX = app.getProperty("dzX_prop");
        dzY = app.getProperty("dzY_prop");
        dzZ = app.getProperty("dzZ_prop");
        targetAlt = app.getProperty("TargetAlt_prop");
        


        width = dc.getWidth();
        height = dc.getHeight();
           


        var now = Time.now();
        var info = Calendar.info(now, Time.FORMAT_LONG);
        
        // Clear the screen
        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_WHITE);
        dc.fillRectangle(0,0,dc.getWidth(), dc.getHeight());
              
      
        // Draw the 12
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        dc.drawText((width/2),10,font,"12",Gfx.TEXT_JUSTIFY_CENTER);


        drawHashMarks(dc);
        // Draw the hour. Convert it to minutes and
        // compute the angle.
        hour = ( ( ( clockTime.hour % 12 ) * 60 ) + clockTime.min );
        hour = hour / (12 * 60.0);
        hour = hour * Math.PI * 2;
        // hand = 1 for hour and 2 for minute
        drawHand(dc, hour, (width/2-10)*.7 , 3,1);
        // Draw the minute
        min = ( clockTime.min / 60.0) * Math.PI * 2;
        drawHand(dc, min, (width/2-10), 2,2);
        // Draw the inner circle
        dc.setColor(Gfx.COLOR_DK_GRAY, Gfx.COLOR_DK_GRAY);
        dc.fillCircle(width/2, height/2, 7);
        dc.setColor(Gfx.COLOR_DK_GRAY,Gfx.COLOR_DK_GRAY);
        dc.drawCircle(width/2, height/2, 7);
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_WHITE);
        dc.fillCircle(width/2, height/2, 6);
        dc.setColor(Gfx.COLOR_DK_GRAY,Gfx.COLOR_DK_GRAY);
        dc.drawCircle(width/2, height/2, 6);
        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
        dc.fillCircle(width/2, height/2, 1);
        dc.setColor(Gfx.COLOR_BLACK,Gfx.COLOR_BLACK);
        dc.drawCircle(width/2, height/2, 1);
        
        //If the user is aproximately 500 feet above the Dz then push the in airplane view.
        if(dzX != null){
            if(settings == 0 && posnInfo.altitude > (dzZ+200)){
                Ui.pushView(new inPlaneView(),new inPlaneViewDelegate(),Ui.SLIDE_IMMEDIATE);
            }
            else if(settings == 1 && (posnInfo.altitude*3.2808399) > (dzZ+500)){ 
                Ui.pushView(new inPlaneView(),new inPlaneViewDelegate(),Ui.SLIDE_IMMEDIATE);
            }
        }
    }
}

    //! Called when this View is removed from the screen. Save the
    //! state of this View here. This includes freeing resources from
    //! memory.
    function onHide() {
    }

class WatchFaceDelegate extends Ui.BehaviorDelegate{
    function onSelect(){
        
        Ui.pushView(new WingManMainMenu(),new MainMenuDelegate(), Ui.SLIDE_IMMEDIATE);
    }
    
    function onNextPage(){
        return false;
    }

    function onPreviousPage(){
        return false;
    }
    
    function onBack(){
        Sys.exit();
    }

}