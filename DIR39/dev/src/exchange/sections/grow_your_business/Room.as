////////////////////////////////////////////////////////////////////////////////
// Project: Orange Exchange issue 38
// FileName: Room.as
// Created by: Angel 
// updated : 27 September 2013
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// IMPORTS
////////////////////////////////////////////////////////////////////////////////
import mx.events.EventDispatcher;
import mx.utils.Delegate;

import com.greensock.TweenMax;
import com.greensock.easing.*;
////////////////////////////////////////////////////////////////////////////////
// CLASS: Room 
////////////////////////////////////////////////////////////////////////////////
class exchange.sections.grow_your_business.Room extends MovieClip
{
	
	////////////////////////////////////////////////////////////////////////////
	// PROPERTIES
	////////////////////////////////////////////////////////////////////////////
	private static var instance			: Room;
	public var page_name 				: String = "Grow_your_business";
	
	//on stage assets
	private var clock_mc				: MovieClip;
	private var wall_pic_mc				: MovieClip;
	
	private var room_btn_1				: MovieClip;
	private var room_btn_2				: MovieClip;
	private var room_btn_3				: MovieClip;
	
	private var area_mc_1				: MovieClip;
	private var area_mc_2				: MovieClip;
	private var area_mc_3				: MovieClip;
	
	public var clickedID				: Number;
	
	public var data1					: Object;
	public var data2					: Object;
	public var data3					: Object;
	
	// DISPATCH
	public var addEventListener			: Function; 
	public var removeEventListener		: Function; 
	public var dispatchEvent			: Function;	
	////////////////////////////////////////////////////////////////////////////
	// Constructor
	////////////////////////////////////////////////////////////////////////////
	public function Room()
	{		
		EventDispatcher.initialize(this);
	}
	
	public static function getInstance() : Room 
	{
		return instance;
	}

	////////////////////////////////////////////////////////////////////////////
	// On Load
	///////////////////////////////////////////////////////////////////////////
	public function onLoad() : Void
	{
		instance = this;
		initPage();
	}
	
	////////////////////////////////////////////////////////////////////////////
	// Initialise
	///////////////////////////////////////////////////////////////////////////
	private function initPage() : Void
	{
		findObjects(this);
		setManualData();
		prepareAssets();
		setupButtons();
		showClock();
	}	
	
	////////////////////////////////////////////////////////////////////////////
	// Set manual data positions
	///////////////////////////////////////////////////////////////////////////
	private function setManualData() : Void
	{
		data1 = { xpos:0, ypos:0,  xoff:-600, roomScale:233, roomx:-1274, roomy:-396, boxoff:130, boxon:370, boxsmall:112, boxbig:415, boxy:80, label:"Recruit" };
		data2 = { xpos:446, ypos:0,  xoff:1000, roomScale:233, roomx:-1206, roomy:-504, boxoff:20, boxon:-234, boxsmall:94, boxbig:398, boxy:90, label:"Technology" };
		data3 = { xpos:0, ypos:0,  xoff:-600, roomScale:200, roomx:-22, roomy:-512, boxoff:200, boxon:446, boxsmall:141, boxbig:480, boxy:40, label:"Deliver" };
	}
	
	////////////////////////////////////////////////////////////////////////////
	// Prepare Assets
	///////////////////////////////////////////////////////////////////////////	
	private function prepareAssets() : Void
	{
		setParams("area_mc_", { _alpha:0 } );
		
		TweenMax.to(area_mc_2, 0, {_x:602, _y:826, _xscale:180, _yscale:180, _alpha:100} );
		TweenMax.to(area_mc_1, 0, {_x:1070, _y:403, _xscale:100, _yscale:100, _alpha:100} );
		TweenMax.to(area_mc_3, 0, { _x: -180, _y:431, _xscale:100, _yscale:100, _alpha:100 } );
		
		wall_pic_mc._alpha = 0;

	}
	
	////////////////////////////////////////////////////////////////////////////
	// Play 3D Room Intro
	///////////////////////////////////////////////////////////////////////////	
	public function playIntro() : Void
	{
		var dtime : Number = 0;

		TweenMax.to(area_mc_2, 2, {_x:area_mc_2.init._x, _y:area_mc_2.init._y, _xscale:100, _yscale:100, ease:Cubic.easeOut, delay:dtime} );
		TweenMax.to(area_mc_1, 2, {_x:area_mc_1.init._x, _y:area_mc_1.init._y, _xscale:100, _yscale:100, ease:Cubic.easeOut, delay:dtime+=1 } );
		TweenMax.to(area_mc_3, 2, { _x:area_mc_3.init._x, _y:area_mc_3.init._y, _xscale:100, _yscale:100, ease:Cubic.easeOut, delay:dtime += .5 } );

		TweenMax.to(room_btn_2, 1, { _xscale: 100, _yscale:100, ease:Back.easeOut, delay:dtime+=1 } );
		TweenMax.to(room_btn_1, 1, { _xscale: 100, _yscale:100, ease:Back.easeOut, delay:dtime+=.5 } );
		TweenMax.to(room_btn_3, 1, { _xscale: 100, _yscale:100, ease:Back.easeOut, delay:dtime += .5 } );
		
		TweenMax.to(wall_pic_mc, 1, { _alpha:100, delay:dtime } );
	}
	
	////////////////////////////////////////////////////////////////////////////
	// Set up buttons
	///////////////////////////////////////////////////////////////////////////
	private function setupButtons() : Void
	{
		for (var i:Number = 1; i< 4; i++) 
		{
			var rb : MovieClip = this["room_btn_" + i];
			rb.id = i;
			
			rb.label_mc._x = rb.label_mc._x + rb.label_mc._width + 20;
			rb.label_mc.off = rb.label_mc._x;
			
			var rbb = rb.onRelease = Delegate.create(this, onButtonClicked);
			rbb.id = i;	
			
			var rbo = rb.onRollOver = Delegate.create(this, onButtonOver);
			rbo.id = i;
			var rboo = rb.onRollOut = Delegate.create(this, onButtonOut);
			rboo.id = i;
			
			TweenMax.to(rb, 0, { _xscale: 0, _yscale:0 } );
		}
	}		
	
	////////////////////////////////////////////////////////////////////////////
	// Disable buttons
	///////////////////////////////////////////////////////////////////////////
	public function disableButtons() : Void
	{
		for (var i:Number = 1; i< 4; i++) 
		{
			var rb : MovieClip = this["room_btn_" + i];
			rb.enabled = false;
			var label_mc : MovieClip = rb.label_mc;
			TweenMax.to(label_mc, 0, { _x:label_mc.off, ease:Cubic.easeOut } );
			TweenMax.to(rb, .5, { _xscale:0, _yscale:0, ease:Cubic.easeOut } );
		}
	}	
	////////////////////////////////////////////////////////////////////////////
	// Enable buttons
	///////////////////////////////////////////////////////////////////////////
	public function enableButtons() : Void
	{
		for (var i:Number = 1; i< 4; i++) 
		{
			var rb : MovieClip = this["room_btn_" + i];
			rb.enabled = true;
			TweenMax.to(rb, 1, { _xscale:100, _yscale:100, ease:Back.easeOut } );
		}
	}	

	////////////////////////////////////////////////////////////////////////////
	// on Button clicked
	///////////////////////////////////////////////////////////////////////////		
	private function onButtonClicked() : Void
	{
		var _id : Number = arguments.caller.id;
		
		openDetail(_id);
	}	
	
	////////////////////////////////////////////////////////////////////////////
	// on Button over
	///////////////////////////////////////////////////////////////////////////		
	private function onButtonOver() : Void
	{
		var i : Number = arguments.caller.id;
		var rb : MovieClip = this["room_btn_" + i];
		var label_mc : MovieClip = rb.label_mc;
		
		TweenMax.to(label_mc, .5, { _x:label_mc.init._x, ease:Cubic.easeOut } );
		
		TweenMax.to(rb, .5, { _xscale:120, _yscale:120, ease:Cubic.easeOut } );
	}		
	
	////////////////////////////////////////////////////////////////////////////
	// on Button over
	///////////////////////////////////////////////////////////////////////////		
	private function onButtonOut() : Void
	{
		var i : Number = arguments.caller.id;
		
		var rb : MovieClip = this["room_btn_" + i];
		var label_mc : MovieClip = rb.label_mc;
		
		TweenMax.to(label_mc, .5, { _x:label_mc.off, ease:Cubic.easeOut } );
		TweenMax.to(rb, .5, { _xscale:100, _yscale:100, ease:Cubic.easeOut } );
		
	}	
	////////////////////////////////////////////////////////////////////////////
	// Open Detail
	///////////////////////////////////////////////////////////////////////////		
	public function openDetail( id : Number ) : Void
	{
		clickedID = id;
		
		dispatchEvent( { type:"buttonClicked", clickedID:clickedID } );
	}	

	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Show and animate clock mc
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////
	private function showClock():Void 
	{
		var dTime:Number = 0;
		
		showRealTime();
		var rh : Number = clock_mc.hands_mc.ndlhr._rotation + (360);
		var rm : Number = clock_mc.hands_mc.ndlmn._rotation + (360);
		var rs : Number = clock_mc.hands_mc.ndlsc._rotation + (360)+10;
		
		//TweenMax.to(clock_mc.hands_mc.ndlhr, 2, { _rotation:rh, delay:(dTime), ease:Quad.easeOut, overwrite:false } );
		TweenMax.to(clock_mc.hands_mc.ndlmn, 2, { _rotation:rm, delay:(dTime), ease:Quad.easeOut, overwrite:false } );
		TweenMax.to(clock_mc.hands_mc.ndlsc, 2, { _rotation:rs, delay:(dTime), ease:Quad.easeOut, overwrite:false, onComplete:startClock, onCompleteScope:this } );

		TweenMax.to(clock_mc, 1, { _alpha:100, _xscale:clock_mc.init._xscale, _yscale:clock_mc.init._yscale, delay:(dTime), ease:Back.easeOut, overwrite:false } );

	}		

	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Start Clock settings
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////	
	private function startClock() : Void
	{
		onEnterFrame = showRealTime;
	}	
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// stop Clock 
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////	
	private function stopClock() : Void
	{
		onEnterFrame = null;
	}	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Show the real time for the analog Clock
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////	
	private function showRealTime() : Void
	{
		var abc : Date = new Date();
		var a = abc.getHours();
		var b = abc.getMinutes();
		var c = abc.getSeconds();
		var d = abc.getMilliseconds();
		var e = a + (b/60) + (c/3600) + (d/3600000);
		var f = b + (c/60) + (d/60000);
		var g = c + (d / 1000);
		
		clock_mc.hands_mc.ndlhr._rotation = e * 30;
		clock_mc.hands_mc.ndlmn._rotation = f*6;
		clock_mc.hands_mc.ndlsc._rotation = g * 6;
	}
		
	////////////////////////////////////////////////////////////////////////////
	// REMOVE ALL CHILDREN MOVIECLIPS FROM A MOVIECLIP
	///////////////////////////////////////////////////////////////////////////	
	public function emptyMC(mc:MovieClip):Void 
	{
		for (var i in mc) 
		{
			if (typeof(mc[i]) == "movieclip")
			{
				(mc[i]).removeMovieClip();
			}
		}
	}	
	

	////////////////////////////////////////////////////////////////////////////
	// sets init values if the object has an "_x" value
	///////////////////////////////////////////////////////////////////////////	
	public function findObjects(obj:Object):Void
	{
		if (obj._x != undefined)
		{
			setInitValues(obj);
		}
		
		for (var i in obj) 
		{
			if (obj[i]._x != undefined || obj._name == "initValues") 
			{
				setInitValues(obj[i]);
			}
			
			if (typeof(obj[i]) == "movieclip")
			{
				findObjects(obj[i]);
			}
		}
	}
	
	////////////////////////////////////////////////////////////////////////////
	// Sets init values of an Object - Movieclip / Button
	///////////////////////////////////////////////////////////////////////////
	public function setInitValues(obj:Object):Void 
	{
		obj.init = new Object();
		obj.init._name = "initValues";
		
		obj.init._x = obj._x;
		obj.init._y = obj._y;
		obj.init._width = obj._width;
		obj.init._height = obj._height;
		obj.init._alpha = obj._alpha;
		obj.init._rotation = obj._rotation;
		obj.init._xscale = obj._xscale;
		obj.init._yscale = obj._yscale;
	}
	
	////////////////////////////////////////////////////////////////////////////
	// Resets the object to its' initial values.
	///////////////////////////////////////////////////////////////////////////
	public function resetValues(obj:Object):Void 
	{
		if (obj.init != undefined) 
		{
			for (var i in obj.init) 
			{
				if (i != "_name") obj[i] = obj.init[i];
			}
		}
	}
	
	////////////////////////////////////////////////////////////////////////////
	// Set params to a selection of objects 
	///////////////////////////////////////////////////////////////////////////	
	private function setParams(baseName:String, properties:Object):Void 
	{
		var mc:MovieClip;
		for (var i:Number = 1; mc = this[baseName + i]; i++) 
		{
			// test property to see if it is a string. 
			// If it is then add it to the current property value
			for (var j:String in properties) 
			{
				if (typeof(properties[j]) == "string") 
				{
					properties[j] = mc[j] + parseFloat(properties[j]);
				}
				mc[j] = properties[j];
			}
		}
	}
	
}