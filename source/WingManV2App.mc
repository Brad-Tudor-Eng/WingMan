using Toybox.Application as App;
using Toybox.Position as Position;
using Toybox.Sensor as Snsr;
using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

// This is the entry point for the App


var HR = null;
var posnInfo = null;
//0 = metric 1 = inches
var settings = Sys.getDeviceSettings();
var earthRadius;

//position variables
var dzX;
var dzY;
var dzZ;
var targetAlt;
var app;

//stats var
var statsArray = [0,0,0,100000,0,0,100000,0,0,100000,0,10000];


    function setPosition(info) {
        posnInfo = info;
       Ui.requestUpdate(); 
    }
    
    function onSnsr(sensor_info){
      HR = sensor_info.heartRate;
      Ui.requestUpdate();
    }


class WingManV2App extends App.AppBase {

    //! onStart() is called on application start up
    function onStart() {
        Position.enableLocationEvents( Position.LOCATION_CONTINUOUS, method( :setPosition ) );
        Snsr.setEnabledSensors( [Snsr.SENSOR_HEARTRATE] );
        Snsr.enableSensorEvents( method(:onSnsr) );
    }

    //! onStop() is called when your application is exiting
    function onStop() {
        Position.enableLocationEvents( Position.LOCATION_DISABLE, method( :setPosition ) );
    }

    //! Return the initial view of your application here
    function getInitialView() {
        return [ new WingManV2View(),new WatchFaceDelegate() ];
    }

}