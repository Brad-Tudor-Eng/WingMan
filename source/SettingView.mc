//!
//! Copyright 2015 by Garmin Ltd. or its subsidiaries.
//! Subject to Garmin SDK License Agreement and Wearables
//! Application Developer Agreement.
//!

using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.Application as App;


class SettingView extends Ui.View{
var box;
var width; 
 
    function initialize() {

    }

    function onUpdate(dc){
        dc.setColor( Gfx.COLOR_BLACK, Gfx.COLOR_BLACK );
        dc.clear();
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        width = dc.getWidth();
        
        dzX = app.getProperty("dzX_prop");
        dzY = app.getProperty("dzY_prop");
        dzZ = app.getProperty("dzZ_prop");
        targetAlt = app.getProperty("TargetAlt_prop");
 
        if(null==dzX){
            dzX="Not set";
        }

        if(null==dzY){
            dzY="Not set";
        }

        if(null==dzZ){
            dzZ="Not set";
        }

        if(null==targetAlt){
            targetAlt="Not set";
        }
    
	    // draw the menu title
            dc.setColor( Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT );
            dc.drawText((width/2),(width/2)-100,Gfx.FONT_LARGE,"REVIEW",Gfx.TEXT_JUSTIFY_CENTER);
            dc.drawText((width/2),(width/2)-72,Gfx.FONT_LARGE,"SETTINGS",Gfx.TEXT_JUSTIFY_CENTER);
        
        //draw white box        
            dc.setColor( Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT );
            box = [ [width/2+100,width/2-15], [width/2+100, width/2-30], [width/2-100, width/2-30],[width/2-100, width/2-15] ];
            dc.fillPolygon(box);
        //draw white box        
            dc.setColor( Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT );
            box = [ [width/2+100,width/2-17], [width/2+100, width/2-28], [width/2-100, width/2-28],[width/2-100, width/2-17] ];
            dc.fillPolygon(box);
        //draw white box        
            dc.setColor( Gfx.COLOR_BLUE, Gfx.COLOR_TRANSPARENT );
            box = [ [width/2+100,width/2-19], [width/2+100, width/2-26], [width/2-100, width/2-26],[width/2-100, width/2-19] ];
            dc.fillPolygon(box);
        //DATA
            dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
            dc.drawText((dc.getWidth() / 2), ((dc.getHeight() / 2) - 5), Gfx.FONT_SMALL, "DZ LAT: " + dzX, Gfx.TEXT_JUSTIFY_CENTER);
            dc.drawText((dc.getWidth() / 2), ((dc.getHeight() / 2) +15 ), Gfx.FONT_SMALL, "DZ LON: " + dzY, Gfx.TEXT_JUSTIFY_CENTER);
            dc.drawText((dc.getWidth() / 2), ((dc.getHeight() / 2)+ 35), Gfx.FONT_SMALL, "DZ ALT: " + dzZ, Gfx.TEXT_JUSTIFY_CENTER);
            dc.drawText((dc.getWidth() / 2), ((dc.getHeight() / 2) + 55), Gfx.FONT_SMALL, "Target ALT: " + targetAlt, Gfx.TEXT_JUSTIFY_CENTER);
    }
}

class SettingViewDelegate extends Ui.BehaviorDelegate{

   function onSelect(){
        Ui.pushView(new inPlaneView(),new inPlaneViewDelegate(),Ui.SLIDE_IMMEDIATE);
   }

   function onCancel() {
        Ui.pushView(new WingManMainMenu(),new MainMenuDelegate(), Ui.SLIDE_IMMEDIATE);
    }
}