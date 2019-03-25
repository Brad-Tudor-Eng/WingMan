//!
//! Copyright 2015 by Garmin Ltd. or its subsidiaries.
//! Subject to Garmin SDK License Agreement and Wearables
//! Application Developer Agreement.
//!

using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Application as App;
using Toybox.Time.Gregorian as Calendar;
using Toybox.Sensor as Snsr;
using Toybox.Position as Position;



class DZView extends Ui.View {
      
        
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
        var width = dc.getWidth();
        app = App.getApp();
        



        // Set background color
        dc.setColor( Gfx.COLOR_TRANSPARENT, Gfx.COLOR_BLACK );
        dc.clear();
        
        if( posnInfo != null ) {
        dzX = posnInfo.position.toRadians()[0];
        dzY = posnInfo.position.toRadians()[1];
        
        
        if(settings == 0){
        dzZ = posnInfo.altitude;
        }
        else{
        dzZ = posnInfo.altitude*3.2808399;
        }
            
            
            //TITLE
            dc.setColor( 0xffffff, Gfx.COLOR_TRANSPARENT );
            string = "GROUND";
            dc.drawText( ((width / 2)), ((width / 2) - 100), Gfx.FONT_LARGE, string, Gfx.TEXT_JUSTIFY_CENTER );
            string = "TARGET";
            dc.drawText( ((width / 2)), ((width / 2) - 72), Gfx.FONT_LARGE, string, Gfx.TEXT_JUSTIFY_CENTER );
    
            //SET PROPERTY
            app.setProperty("dzX_prop", dzX );
            app.setProperty("dzY_prop", dzY );
            app.setProperty("dzZ_prop", dzZ );

            
            
            //INFORMATION
            dc.setColor( Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT );
            
            string = "LAT = " + dzX.toString();
            dc.drawText( ((width / 2)), ((width / 2) - 5), Gfx.FONT_SMALL, string, Gfx.TEXT_JUSTIFY_CENTER );
            string = "LONG = " + dzY.toString();
            dc.drawText( ((width / 2)), ((width / 2)+15), Gfx.FONT_SMALL, string, Gfx.TEXT_JUSTIFY_CENTER );
            string = "ALT = " + dzZ.toString();
            dc.drawText( ((width / 2)), ((width / 2+35)), Gfx.FONT_SMALL, string, Gfx.TEXT_JUSTIFY_CENTER );
            


    //draw white box        
    dc.setColor( Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT );
    var box = [ [width/2+100,width/2-15], [width/2+100, width/2-30], [width/2-100, width/2-30],[width/2-100, width/2-15] ];
    dc.fillPolygon(box);
        //draw white box        
    dc.setColor( Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT );
    box = [ [width/2+100,width/2-17], [width/2+100, width/2-28], [width/2-100, width/2-28],[width/2-100, width/2-17] ];
    dc.fillPolygon(box);
        //draw white box        
    dc.setColor( Gfx.COLOR_BLUE, Gfx.COLOR_TRANSPARENT );
    box = [ [width/2+100,width/2-19], [width/2+100, width/2-26], [width/2-100, width/2-26],[width/2-100, width/2-19] ];
    dc.fillPolygon(box);
          
        }
        else {
            dc.setColor( 0xff0000, Gfx.COLOR_TRANSPARENT );
            dc.drawText( (width / 2), (width / 2), Gfx.FONT_SMALL, "No position info", Gfx.TEXT_JUSTIFY_CENTER );
        }
    }


    

    }


class DZViewDelegate extends Ui.BehaviorDelegate
{
    function onSelect()
    {  
    Ui.pushView(new WingManMainMenu(),new MainMenuDelegate(), Ui.SLIDE_IMMEDIATE);
    }
    
    function onBack()
    {
   Ui.pushView(new WingManMainMenu(),new MainMenuDelegate(), Ui.SLIDE_IMMEDIATE);
    }

}
