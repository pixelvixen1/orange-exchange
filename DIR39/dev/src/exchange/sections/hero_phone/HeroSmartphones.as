////////////////////////////////////////////////////////////////////////////////
// Project: Orange Exchange issue 38
// FileName: HeroSmartphones.as
// Created by: Angel 
// updated : 24 October 2013
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// IMPORTS
////////////////////////////////////////////////////////////////////////////////
import mx.data.encoders.Num;
import mx.events.EventDispatcher;
import mx.utils.Delegate;

import com.greensock.TweenMax;
import com.greensock.easing.*;
////////////////////////////////////////////////////////////////////////////////
// CLASS: HeroSmartphones 
////////////////////////////////////////////////////////////////////////////////
class exchange.sections.hero_phone.HeroSmartphones extends MovieClip
{
	
	////////////////////////////////////////////////////////////////////////////
	// PROPERTIES
	////////////////////////////////////////////////////////////////////////////
	private static var instance			: HeroSmartphones;
	public var page_name 				: String  = "hero_smartphones";
	
	//on stage assets
	private var page_mc1				: MovieClip;	
	private var page_mc2				: MovieClip;
	private var main_text_mc			: MovieClip;
	private var instructions_mc			: MovieClip;
	
	private var mb0						: MovieClip;
	private var mb1						: MovieClip;
	private var mb2						: MovieClip;
	private var mb3						: MovieClip;
	private var selectedItem			: MovieClip;
	
	public var currentID 				: Number;
	
	private var trackingData			: Array;
	
	// DISPATCH
	public var addEventListener			: Function; 
	public var removeEventListener		: Function; 
	public var dispatchEvent			: Function;	
	
	////////////////////////////////////////////////////////////////////////////
	// Constructor
	////////////////////////////////////////////////////////////////////////////
	public function HeroSmartphones()
	{		
		EventDispatcher.initialize(this);
	}
	
	public static function getInstance() : HeroSmartphones 
	{
		return instance;
	}
	
	
	////////////////////////////////////////////////////////////////////////////
	// On Load
	///////////////////////////////////////////////////////////////////////////
	public function onLoad() : Void
	{
		instance = this;
		trackingData = new Array();
		trackingData[0] = "FULL HD DISPLAY";
		trackingData[1] = "ADVANCED MULTITASKING";
		trackingData[2] = "ENHANCED S-PEN";
		trackingData[3] = "SCRAPBOOK YOUR LIFE";
		initPage();
	}
	
	////////////////////////////////////////////////////////////////////////////
	// Initialise
	///////////////////////////////////////////////////////////////////////////
	private function initPage() : Void
	{
		findObjects(this);
		setupMenu( );
		page_mc1.addEventListener("pageSelected", this); 
		page_mc1.addEventListener("closePage", this); 
		page_mc1.addEventListener("pageOpened", this); 
	}
	
	////////////////////////////////////////////////////////////////////////////
	// On page selected
	///////////////////////////////////////////////////////////////////////////
	public function pageSelected(e : Object) : Void
	{
		currentID = e.target.ID;		
	}	
	
	////////////////////////////////////////////////////////////////////////////
	// On page selected closed
	///////////////////////////////////////////////////////////////////////////
	public function closePage(e : Object) : Void
	{
		currentID = e.target.ID;
		
		pageClosed( );
	}	

	////////////////////////////////////////////////////////////////////////////
	// Show assets when page is selected and opens
	///////////////////////////////////////////////////////////////////////////		
	public function showAssets( ) : Void
	{
		var dtime : Number = 0;
	}	
	
	////////////////////////////////////////////////////////////////////////////
	// When user interacts with sub menu - hide main page assets
	///////////////////////////////////////////////////////////////////////////		
	public function pageOpened( e: Object ) : Void
	{
		TweenMax.to(main_text_mc, 1, {autoAlpha:0} );
		TweenMax.to(instructions_mc, 1, {autoAlpha:0} );
	}	
	
	////////////////////////////////////////////////////////////////////////////
	// When user closed sub page - show main page assets
	///////////////////////////////////////////////////////////////////////////		
	public function pageClosed( ) : Void
	{
		TweenMax.to(main_text_mc, 1, {autoAlpha:100} );
		TweenMax.to(instructions_mc, 1, {autoAlpha:100} );
	}	
		
	////////////////////////////////////////////////////////////////////////////
	// Set up menu
	///////////////////////////////////////////////////////////////////////////		
	private function setupMenu( ) : Void
	{
		for (var i : Number = 0; i < 4; i++ )
		{
			var mb : MovieClip = this["mb" + i];
			mb.id = i;
			TweenMax.to(mb.text_mc, 0, {autoAlpha:0} );
			TweenMax.to(mb.close_btn, 0, { autoAlpha:0 } );
			TweenMax.to(mb.mask_mc, 0, { _xscale:0 } );
			TweenMax.to(mb.vmask_mc, 0, { _yscale:0 } );
			var mbv = mb.click_btn.onRelease = Delegate.create(this, onMenuButtonClicked);
			mbv.id = i;
			mbv.mc = mb;

		}
	}	
	
	////////////////////////////////////////////////////////////////////////////
	// Menu button clicked
	///////////////////////////////////////////////////////////////////////////	
	private function onMenuButtonClicked( )
	{
		
		page_mc1.closeRotateView();
		
		selectedItem  = arguments.caller.mc;
		
		for (var i : Number = 0; i < 4; i++ )
		{
			var mb : MovieClip = this["mb" + i];
			
			if (mb != selectedItem)
			{
				TweenMax.to(mb, .5, { autoAlpha:0 } );
			}
		}
		
		var dtime : Number = 0;
		
		if (page_mc1.rotate_btn._visible)
		{
			TweenMax.to(page_mc1.rotate_btn, .5, { autoAlpha:0 } );
		}
		
		TweenMax.to(main_text_mc, .5, {autoAlpha:0} );
		TweenMax.to(instructions_mc, .5, {autoAlpha:0} );
		
		TweenMax.to(selectedItem, .5, { _y:260, ease:Cubic.easeOut, delay:dtime+=.5 } );
		
		TweenMax.to(selectedItem.text_mc, .5, { autoAlpha:100, delay:dtime+=.5 } );
		TweenMax.to(selectedItem.close_btn, .5, { autoAlpha:100, delay:dtime } );
		
		TweenMax.to(selectedItem.mask_mc, 1, { _xscale:selectedItem.mask_mc.init._xscale, delay:dtime+=.5, ease:Cubic.easeOut  } );
		TweenMax.to(selectedItem.vmask_mc, 1, { _yscale:selectedItem.vmask_mc.init._yscale, delay:dtime+=1, ease:Cubic.easeOut  } );
		
		selectedItem.close_btn.onRelease = Delegate.create(this, closeMenu);
		
		Tracker.trackClick(page_name, trackingData[selectedItem.id]);
	}
	
	////////////////////////////////////////////////////////////////////////////
	// Close menu
	///////////////////////////////////////////////////////////////////////////		
	private function closeMenu() : Void
	{
		var dtime : Number = 0;
		
		TweenMax.to(selectedItem.text_mc, .5, { autoAlpha:0, delay:dtime } );
		TweenMax.to(selectedItem.vmask_mc, .5, { _yscale:0, delay:dtime, ease:Cubic.easeOut  } );
		TweenMax.to(selectedItem.mask_mc, .5, { _xscale:0, delay:dtime+=.5, ease:Cubic.easeOut  } );
		TweenMax.to(selectedItem.close_btn, .5, { autoAlpha:0, delay:dtime+=.5 } );
		
		TweenMax.to(selectedItem, .5, { _y:selectedItem.init._y, ease:Cubic.easeOut, delay:dtime+=.5  } );
		
		dtime += .5;
		
		for (var i : Number = 0; i < 4; i++ )
		{
			var mb : MovieClip = this["mb" + i];
			
			TweenMax.to(mb, .5, { autoAlpha:100, delay:dtime} );
		}
		
		TweenMax.to(main_text_mc, .5, {autoAlpha:100, delay:dtime+=.5} );
		TweenMax.to(instructions_mc, .5, { autoAlpha:100, delay:dtime } );
		
		TweenMax.to(page_mc1.rotate_btn, .5, { autoAlpha:100, delay:dtime+=.5  } );
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