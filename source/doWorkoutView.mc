using Toybox.Application as App;
using Toybox.Lang as Lang;
using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Timer as Timer;
using Toybox.Graphics as Gfx;
using Toybox.Attention as Attention; //used for vibration

class doWorkoutView extends Ui.View
{
	private var refreshTimer;
	private var timerCount = 0;
	
	private var screen_width;
	private var screen_height;
	
	private var vibeDataStart = [
	    new Attention.VibeProfile(  75, 500 ),
	    new Attention.VibeProfile(  0, 500 ),
	    new Attention.VibeProfile(  75, 500 ),
	    new Attention.VibeProfile(  0, 500 ),
	    new Attention.VibeProfile( 	100, 1000 )
	];

    function initialize() {
        View.initialize();
        
        refreshTimer = new Timer.Timer();
        timerCount = 0;        
        
        //record_prop = app.getProperty("record_prop");
         Sys.println("DOWORKOUT - INIT");
         
    }
    
    // Load your resources here
    function onLayout(dc) {
    	screen_width = dc.getWidth();
    	screen_height = dc.getHeight();
    }
    
    function refreshTimerCallback() 
	{
	 	timerCount++;		
	 	Ui.requestUpdate();
 	}
 	
    function onShow() {
    	//refreshTimer.start( method(:refreshTimerCallback), 1000, true );
    	
    	if (Attention has :playTone) {
		   Attention.playTone(Attention.TONE_START);
		}
		
		if (Attention has :vibrate) {
			Attention.vibrate(vibeDataStart);
		}
    }
    
    function onHide() 
    {
	    refreshTimer.stop();
    }
    
    // Update the view
    function onUpdate(dc) {
        // Call the parent onUpdate function to redraw the layout
        //View.onUpdate(dc);
        
        var txt, text_height, x, y, width, height, margin;
        var centerX = screen_width / 2;
        var centerY = screen_height / 2;
        
        var app = App.getApp();
        var m = app.model;
        var WO = m.getSelectedWorkout();
        
        //** clear screen
		dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
        dc.clear();
        
        
        //CENTER BOX
        text_height = 22;
        margin = 5;
        y = centerY - (text_height/2) - margin;
        height = text_height + (margin * 2);
        dc.setColor(Gfx.COLOR_PURPLE, Gfx.COLOR_BLACK);
        dc.fillRectangle(0, y, screen_width, height);

		//CENTER TEXT - CURRENT EXCERCISE
		txt = m.getCurrentExcerciseName();
		y = centerY - (text_height/2);
		dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_PURPLE);
        dc.drawText(centerX, y, Gfx.FONT_SMALL, txt, Gfx.TEXT_JUSTIFY_CENTER);
        
        //COUNTER
        txt = m.getWorkoutElapsedSeconds();
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        dc.drawText(centerX, 0, Gfx.FONT_SYSTEM_XTINY, txt, Gfx.TEXT_JUSTIFY_CENTER);
    }
    
}