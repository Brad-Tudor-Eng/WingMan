using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Math as Math;
using Toybox.Time as Time;
using Toybox.Time.Gregorian as Calendar;
using Toybox.WatchUi as Ui;
using Toybox.Application as App;

var Menuindex = 1;
var lastIndex = 5;

var menuItem;
var Arrow;
var scale;
var centerX;
var centerY;




class WingManMainMenu extends Ui.View {

var width;




//********************************************************************
// Built in functions below
//********************************************************************
function setMenuItem(i){

return
       i == 1 ? "DZ POSITION":
       i == 2 ? "TARGET ALTITUDE":
       i == 3 ? "REVIEW SETTINGS":
       i == 4 ? "FLY":
       i == 5 ? "REVIEW LAST FLIGHT":
       "bull shit";

}


//*********************************************************************
//variables
//*********************************************************************

    function initialize() {
        
    }

    //! Load your resources here
    function onLayout(dc) {
        
    }

    //! Called when this View is brought to the foreground. Restore
    //! the state of this View and prepare it to be shown. This includes
    //! loading resources into memory.
    function onShow() {
 
    }

    function onHide() {
    }
    
    //! Update the view
    function onUpdate(dc) {
    width = dc.getWidth();
    
    //draw the index item
    menuItem = setMenuItem(Menuindex);
    dc.setColor( Gfx.COLOR_BLACK, Gfx.COLOR_BLACK );
    dc.clear();
    dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
    dc.drawText((width/2),(width/2)+15,Gfx.FONT_SMALL,menuItem,Gfx.TEXT_JUSTIFY_CENTER);
	// draw the menu title
     dc.setColor( Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT );
     dc.drawText((width/2),(width/2)-100,Gfx.FONT_LARGE,"OPTIONS",Gfx.TEXT_JUSTIFY_CENTER);
     dc.drawText((width/2),(width/2)-72,Gfx.FONT_LARGE,"MENU",Gfx.TEXT_JUSTIFY_CENTER);
	
	// draw the up arrow
	
    dc.setColor( Gfx.COLOR_DK_GRAY, Gfx.COLOR_TRANSPARENT );
    Arrow = [ [((width/2 + width/4)),((width/2))], [(width/2), ((width/2-width/8))], [((width/2-width/4)), ((width/2))] ];
    dc.fillPolygon(Arrow);

	scale = 1;
    dc.setColor( Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT );
    Arrow =  [ [((width/2 + width/4)-7*scale),((width/2)-1.25*scale)], [(width/2), ((width/2-width/8)+2*scale)], [((width/2-width/4)+7*scale), ((width/2)-1.25*scale)] ];
    dc.fillPolygon(Arrow);
    
    scale = 2;
    dc.setColor( Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT );
    Arrow =  [ [((width/2 + width/4)-7*scale),((width/2)-1.25*(scale+1))], [(width/2), ((width/2-width/8)+2*scale)], [((width/2-width/4)+7*scale), ((width/2)-1.25*(scale+1))] ];
    dc.fillPolygon(Arrow);

    scale = 3;
    dc.setColor( Gfx.COLOR_BLUE, Gfx.COLOR_TRANSPARENT );
    Arrow =  [ [((width/2 + width/4)-7*scale),((width/2)-1.25*(scale+1.25))], [(width/2), ((width/2-width/8)+2*scale)], [((width/2-width/4)+7*scale), ((width/2)-1.25*(scale+1.25))] ];
    dc.fillPolygon(Arrow);

	// draw the down arrow
   
    dc.setColor( Gfx.COLOR_DK_GRAY, Gfx.COLOR_TRANSPARENT );
    Arrow = [ [((width/2+width/4)),((width/2)+60)], [((width/2)), ((width/2+width/8+60))], [((width/2-width/4)), ((width/2)+60)] ];
    dc.fillPolygon(Arrow);
    
    scale = 1;
    dc.setColor( Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT );
    Arrow =  [ [((width/2 + width/4)-7*scale),((width/2+60)+1.25*scale)], [(width/2), ((width/2+width/8+60)-2*scale)], [((width/2-width/4)+7*scale), ((width/2+60)+1.25*scale)] ];
    dc.fillPolygon(Arrow);
    
    scale = 2;
    dc.setColor( Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT );
    Arrow =  [ [((width/2 + width/4)-7*scale),((width/2+60)+1.25*(scale+1))], [(width/2), ((width/2+width/8+60)-2*scale)], [((width/2-width/4)+7*scale), ((width/2+60)+1.25*(scale+1))] ];
    dc.fillPolygon(Arrow);

    scale = 3;
    dc.setColor( Gfx.COLOR_BLUE, Gfx.COLOR_TRANSPARENT );
    Arrow =  [ [((width/2 + width/4)-7*scale),((width/2+60)+1.25*(scale+1.25))], [(width/2), ((width/2+width/8+60)-2*scale)], [((width/2-width/4)+7*scale), ((width/2+60)+1.25*(scale+1.25))] ];
    dc.fillPolygon(Arrow);
	
    }

    //! Called when this View is removed from the screen. Save the
    //! state of this View here. This includes freeing resources from
    //! memory.



}
class MainMenuDelegate extends Ui.BehaviorDelegate
{
    function onSelect()
    {
    
  	// push view based on index item
	return
		Menuindex == 1 ? Ui.pushView(new DZView(),new DZViewDelegate(), Ui.SLIDE_IMMEDIATE):
		Menuindex == 2 ? Ui.pushView(new TargetAltitudeView(),new TargetAltitudeViewDelegate(), Ui.SLIDE_IMMEDIATE):
        Menuindex == 3 ? Ui.pushView(new SettingView(),new SettingViewDelegate(), Ui.SLIDE_IMMEDIATE):  
        Menuindex == 4 ? Ui.pushView(new inFlightNavView(),new inFlightNavViewDelegate(), Ui.SLIDE_IMMEDIATE):
        Menuindex == 5 ? Ui.pushView(new reviewView(),new reviewViewDelegate(), Ui.SLIDE_IMMEDIATE):
        Ui.pushView(new DZView(),new DZViewDelegate(), Ui.SLIDE_IMMEDIATE);    
    }
    
    function onNextPage()
    {
    if(Menuindex < lastIndex){
         Menuindex = Menuindex +1;
         }
         else{
         Menuindex = 1;
         }
         
         
         Ui.requestUpdate();
         
    }
    
    function onPreviousPage()
    {
      if(Menuindex > 1){
         Menuindex = Menuindex -1;
         }
         else{
         Menuindex = lastIndex;
         }
         
         
         
         Ui.requestUpdate();
         
    }


    
    function onBack()
    {
     Ui.pushView(new WingManV2View(),new WatchFaceDelegate(), Ui.SLIDE_IMMEDIATE); 

    }
    

}