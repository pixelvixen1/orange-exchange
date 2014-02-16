////////////////////////////////////////////////////////////////////////////////
// Project: Orange Exchange issue 38
// FileName: PhonePage.as
// Created by: Angel 
// updated : 24 October 2013
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// IMPORTS
////////////////////////////////////////////////////////////////////////////////
import mx.events.EventDispatcher;
import mx.utils.Delegate;

import com.greensock.TweenMax;
import com.greensock.easing.*;
////////////////////////////////////////////////////////////////////////////////
// CLASS: PhonePage 
////////////////////////////////////////////////////////////////////////////////
class exchange.sections.hero_phone.PhonePage extends MovieClip
{
	////////////////////////////////////////////////////////////////////////////
	// PROPERTIES
	////////////////////////////////////////////////////////////////////////////
	private static var instance			: PhonePage;
	public var page_name 				: String  = "hero_smartphones";
	public var phone_name 				: String;
	
	public var videoURL					: String;
	public var ID		 				: Number;
	public var vidx		 				: Number;
	public var vidy		 				: Number;	
	public var specsx	 				: Number;
	public var specsy	 				: Number;
	public var rotateX	 				: Number;
	public var currentID 				: Number;

	private var title_mc				: MovieClip;	
	private var phone_mc				: MovieClip;
	private var phone360				: MovieClip;
	private var specs_mc				: MovieClip;	
	private var video_player			: MovieClip;
	private var phone_full				: MovieClip;
	private var pen_mc					: MovieClip;

	public var rotate_btn				: Button;
	private var specs_btn				: Button;
	private var video_btn				: Button;
	private var close_btn				: Button;
	
	private var mb0						: MovieClip;
	private var mb1						: MovieClip;
	private var mb2						: MovieClip;
	private var mb3						: MovieClip;
	
	// DISPATCH
	public var addEventListener			: Function; 
	public var removeEventListener		: Function; 
	public var dispatchEvent			: Function;	
	
	////////////////////////////////////////////////////////////////////////////
	// Constructor
	////////////////////////////////////////////////////////////////////////////
	public function PhonePage()
	{		
		EventDispatcher.initialize(this);
	}
	
	public static function getInstance() : PhonePage 
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
		hideAssets();
		
		rotate_btn.onRelease = Delegate.create(this, showRotateView);
		close_btn.onRelease = Delegate.create(this, closePage);
	}
	
	////////////////////////////////////////////////////////////////////////////
	// Hide assets on load
	///////////////////////////////////////////////////////////////////////////
	public function hideAssets() : Void
	{
		TweenMax.to(close_btn, 0, { autoAlpha:0 } );	
	}		
	
	
	////////////////////////////////////////////////////////////////////////////
	// Open information for the yellow buttons contents
	///////////////////////////////////////////////////////////////////////////
	private function openButtonInfo() : Void
	{
		this.dispatchEvent( { type:"pageOpened", _id:ID } );
	}	
	
		
	////////////////////////////////////////////////////////////////////////////
	// Change page layout when menu buttons are selected with info
	///////////////////////////////////////////////////////////////////////////
	public function onMenuOpened() : Void
	{
		TweenMax.to(close_btn, 1, { autoAlpha:0 } );	
	}
	
	////////////////////////////////////////////////////////////////////////////
	// Show phone specs
	///////////////////////////////////////////////////////////////////////////		
	public function showPhoneSpecs( ) : Void
	{
		TweenMax.killAll();
		closeVideo( );
		phone_full.spin_mc.gotoAndStop(1);
		phone_full.gotoAndStop(1);
		TweenMax.to(phone_full, .5, { _x:phone_full.init._x, autoAlpha:100, ease:Cubic.easeOut } );
		
		TweenMax.to(specs_mc, 1, { _x:specsx, ease:Cubic.easeOut } );
		TweenMax.to(close_btn, .5, { autoAlpha:100, delay:1 } );
		this.dispatchEvent( { type:"pageSelected", _id:ID } );
		
		enableAll ( );
		specs_btn.enabled = false;
		TweenMax.to(specs_btn, .5, { _alpha:40, delay:0 } );
		
		Tracker.trackClick(page_name, phone_name + "/phone_specs");
	}
		
	////////////////////////////////////////////////////////////////////////////
	// Show 360 view
	///////////////////////////////////////////////////////////////////////////		
	public function showRotateView( ) : Void
	{
		closeVideo( );
		var dtime : Number = 0;
		TweenMax.to(specs_mc, .5, { _x:1000, ease:Cubic.easeOut, delay:dtime } );
		
		TweenMax.to(pen_mc, .5, { autoAlpha:0, delay:dtime } );
		TweenMax.to(rotate_btn, .5, { autoAlpha:0, delay:0 } );
		
		TweenMax.to(phone_full, .5, { _x:rotateX,  autoAlpha:100, ease:Cubic.easeOut, delay:dtime, onComplete:spinPhone, onCompleteScope:this } );
		
		TweenMax.to(close_btn, .5, { autoAlpha:100, delay:dtime } );

		this.dispatchEvent( { type:"pageSelected", _id:ID } );
		
		enableAll ( );
		rotate_btn.enabled = false;
		
		Tracker.trackClick(page_name, phone_name + "/phone_360_view");
	}	
	
	////////////////////////////////////////////////////////////////////////////
	// Spin phone once like 360 view
	///////////////////////////////////////////////////////////////////////////			
	public function spinPhone() :Void
	{
		phone_full.spin_mc.gotoAndPlay(2);
	}	
	////////////////////////////////////////////////////////////////////////////
	// Reset the phone to normal view
	///////////////////////////////////////////////////////////////////////////			
	public function resetPhone() :Void
	{
		phone_full.spin_mc.gotoAndStop(1);
		phone_full.gotoAndStop(1);
		phone_full._x = phone_full.init._x;
	}
	////////////////////////////////////////////////////////////////////////////
	// Show video
	///////////////////////////////////////////////////////////////////////////		
	public function showVideo( ) : Void
	{
		closeVideo( );
		var dtime : Number = 0;

		TweenMax.to(specs_mc, .5, { _x:specs_mc.init._x, ease:Cubic.easeOut, delay:dtime } );
		TweenMax.to(phone_full, .5, { autoAlpha:0, delay:dtime, onComplete:resetPhone, onCompleteScope:this } );
		
		video_player = this.attachMovie('full_screen_video_mc', "video_player", this.getNextHighestDepth(), { _x:vidx, _y:vidy, _alpha:0 });
		video_player.video_mc.videoURL = videoURL;
		
		TweenMax.to(video_player, 1, { autoAlpha:100, delay:dtime += 1 } ); 
		
		TweenMax.to(close_btn, .5, { autoAlpha:100, delay:dtime } );
		
		this.dispatchEvent( { type:"pageSelected", _id:ID } );

		enableAll ( );
		video_btn.enabled = false;
		TweenMax.to(video_btn, .5, { _alpha:40, delay:0 } );
		
		Tracker.trackClick(page_name, phone_name + "/" + videoURL);
	}		
	////////////////////////////////////////////////////////////////////////////
	// Close video
	///////////////////////////////////////////////////////////////////////////			
	public function closeVideo( ) : Void
	{
		video_player.removeMovieClip();
		video_player = null;
	}

	////////////////////////////////////////////////////////////////////////////
	// Enable all buttons / links
	///////////////////////////////////////////////////////////////////////////			
	public function enableAll ( ) : Void
	{
		video_btn.enabled = true;
		specs_btn.enabled = true;		
		rotate_btn.enabled = true;
		close_btn.enabled = true;
		video_btn._alpha = 100;
		specs_btn._alpha = 100;		
		rotate_btn._alpha = 100;
		close_btn._alpha = 100;
	}
	
		
	////////////////////////////////////////////////////////////////////////////
	// on close button clicked
	///////////////////////////////////////////////////////////////////////////	
	public function closePage( ) : Void
	{
		var dtime : Number = 0;
		closeVideo( );
		phone_full.spin_mc.gotoAndStop(1);
		phone_full.gotoAndStop(1);
		TweenMax.to(close_btn, .5, { autoAlpha:0, delay:dtime } );
		TweenMax.to(phone_full, .5, { _x:phone_full.init._x, autoAlpha:100, ease:Cubic.easeOut, delay:dtime } );
		
		TweenMax.to(pen_mc, .5, { autoAlpha:100, delay:dtime+=.5 } );
		TweenMax.to(rotate_btn, .5, { autoAlpha:100, delay:dtime } );
		
		TweenMax.to(specs_mc, .5, { _x:specs_mc.init._x, ease:Cubic.easeOut, delay:dtime } );
		
		enableAll ( );
		
		this.dispatchEvent({type:"closePage"});
	}	
	
	public function closeRotateView( ) : Void
	{
		var dtime : Number = 0;

		phone_full.spin_mc.gotoAndStop(1);
		phone_full.gotoAndStop(1);
		TweenMax.to(close_btn, .5, { autoAlpha:0, delay:dtime } );
		TweenMax.to(phone_full, .5, { _x:phone_full.init._x, autoAlpha:100, ease:Cubic.easeOut, delay:dtime } );
		TweenMax.to(close_btn, .5, { autoAlpha:0, delay:dtime } );
		TweenMax.to(pen_mc, .5, { autoAlpha:100, delay:dtime+=.5 } );
		
		TweenMax.to(specs_mc, .5, { _x:specs_mc.init._x, ease:Cubic.easeOut, delay:dtime } );
		
		enableAll ( );
		
		this.dispatchEvent({type:"closePage"});
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
		for (var i:Number = 0; mc = this[baseName + i]; i++) 
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