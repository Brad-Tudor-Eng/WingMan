using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.WatchUi as Ui;
using Toybox.Application as App;



var end;
var inc;
var scale;
var index;



class TargetAltitudeView extends Ui.View {


//********************************************************************
// Built in functions below
//********************************************************************
function setAlt(i){
return i*inc;
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
    index = 0;
    end = 20000;
    inc = 100;
    }

    function onHide() {

    }
    
    //! Update the view
    function onUpdate(dc) {
    var width = dc.getWidth();
    app = App.getApp();
    
    //draw the index item
    targetAlt = setAlt(index);
    app.setProperty("TargetAlt_prop", targetAlt );
    
    dc.setColor( Gfx.COLOR_BLACK, Gfx.COLOR_BLACK );
    dc.clear();
    dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
    dc.drawText((width/2),(width/2)-3,Gfx.FONT_NUMBER_MEDIUM,targetAlt.toString(),Gfx.TEXT_JUSTIFY_CENTER);
	// draw the menu title
     dc.setColor( Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT );
     dc.drawText((width/2),(width/2)-100,Gfx.FONT_LARGE,"TARGET",Gfx.TEXT_JUSTIFY_CENTER);
     dc.drawText((width/2),(width/2)-72,Gfx.FONT_LARGE,"ALTITUDE",Gfx.TEXT_JUSTIFY_CENTER);

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
class TargetAltitudeViewDelegate extends Ui.BehaviorDelegate
{
    function onSelect()
    {
  	
    Ui.pushView(new WingManMainMenu(),new MainMenuDelegate(), Ui.SLIDE_IMMEDIATE);

    }
    
    function onNextPage()
    {
         if(index > 0){
         index = index -1;
         }
         else{
         index = end/inc;
         }
                
         Ui.requestUpdate();
         
    }
    
    function onPreviousPage()
    {
    
         if(index < end/inc){
         index = index +1;
         }
         else{
         index = 1;
         }

         Ui.requestUpdate();
         
    }
    
    function onBack()
    {
   Ui.pushView(new WingManMainMenu(),new MainMenuDelegate(), Ui.SLIDE_IMMEDIATE);
    }
    

}