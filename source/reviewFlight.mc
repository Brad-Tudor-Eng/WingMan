using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Math as Math;
using Toybox.Time as Time;
using Toybox.Time.Gregorian as Calendar;
using Toybox.WatchUi as Ui;
using Toybox.Application as App;

var reviewIndex = 1;
var lastReviewIndex = 11;





class reviewView extends Ui.View {

var width;
var menuItem;
var menuItemII;
var scale;
var centerX;
var centerY;

//********************************************************************
// Built in functions below
//********************************************************************
function setMenuItem(i){

return
       i == 1 ? statsArray[1].toString():
       i == 2 ? statsArray[2].toString():
       i == 3 ? statsArray[3].toString():
       i == 4 ? statsArray[4].toString():
       i == 5 ? statsArray[5].toString():
       i == 6 ? statsArray[6].toString():
       i == 7 ? statsArray[7].toString():
       i == 8 ? statsArray[8].toString():
       i == 9 ? statsArray[9].toString():
       i == 10 ? statsArray[10].toString():
       i == 11 ? statsArray[11].toString():
       "not set";

}

function setMenuItemII(i){

return
       i == 1 ? "V SPEED MAX":
       i == 2 ? "V SPEED AVERAGE":
       i == 3 ? "V SPEED MIN":
       i == 4 ? "H SPEED MAX":
       i == 5 ? "H SPEED AVERAGE":
       i == 6 ? "H SPEED MIN":
       i == 7 ? "GLIDE SLOPE MAX":
       i == 8 ? "GLIDE SLOPE AVERAGE":
       i == 9 ? "GLIDE SLOPE MIN":
       i == 10 ? "MAX ACCEL":
       i == 11 ? "MIN ACCEL":
       "not set";

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
    menuItem = setMenuItem(reviewIndex);
    menuItemII = setMenuItemII(reviewIndex);
    dc.setColor( Gfx.COLOR_BLACK, Gfx.COLOR_BLACK );
    dc.clear();
    dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
    dc.drawText((width/2),(width/2)+6,Gfx.FONT_SMALL,menuItemII,Gfx.TEXT_JUSTIFY_CENTER);
    dc.drawText((width/2),(width/2)+28,Gfx.FONT_SMALL,menuItem,Gfx.TEXT_JUSTIFY_CENTER);
	
	// draw the menu title
     dc.setColor( Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT );
     dc.drawText((width/2),(width/2)-100,Gfx.FONT_LARGE,"FLIGHT",Gfx.TEXT_JUSTIFY_CENTER);
     dc.drawText((width/2),(width/2)-72,Gfx.FONT_LARGE,"REVIEW",Gfx.TEXT_JUSTIFY_CENTER);
	
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
class reviewViewDelegate extends Ui.BehaviorDelegate{

    function onSelect(){       

        Ui.pushView(new WingManV2View(),new WatchFaceDelegate(), Ui.SLIDE_IMMEDIATE); 
  
    }

    function onCancel(){       

        Ui.pushView(new WingManV2View(),new WatchFaceDelegate(), Ui.SLIDE_IMMEDIATE); 
  
    }

    function onNextPage(){
        if(reviewIndex < lastReviewIndex){
            reviewIndex = reviewIndex +1;
        }
        else{
            reviewIndex = 1;
        }
            Ui.requestUpdate();
    }
    
    function onPreviousPage()
    {
        if(reviewIndex > 1){
            reviewIndex = reviewIndex -1;
        }
        else{
            reviewIndex = lastReviewIndex;
        }
         Ui.requestUpdate();
    }
}