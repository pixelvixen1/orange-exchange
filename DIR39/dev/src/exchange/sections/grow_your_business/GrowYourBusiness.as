////////////////////////////////////////////////////////////////////////////////
// Project: Orange Exchange issue 38
// FileName: GrowYourBusiness.as
// Created by: Angel 
// updated : 8 October 2013
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// IMPORTS
////////////////////////////////////////////////////////////////////////////////
import mx.events.EventDispatcher;
import mx.utils.Delegate;

import com.greensock.TweenMax;
import com.greensock.easing.*;
////////////////////////////////////////////////////////////////////////////////
// CLASS: GrowYourBusiness 
////////////////////////////////////////////////////////////////////////////////
class exchange.sections.grow_your_business.GrowYourBusiness extends MovieClip
{
	
	////////////////////////////////////////////////////////////////////////////
	// PROPERTIES
	////////////////////////////////////////////////////////////////////////////
	private static var instance			: GrowYourBusiness;
	public var page_name 				: String = "Grow_your_business";
	
	//on stage assets
	private var text_mc0				: MovieClip;
	private var text_mc1				: MovieClip;	
	private var text_mc2				: MovieClip;	
	private var roundel_mc				: MovieClip;	
	private var site_room_mc			: MovieClip;
	private var link_btn				: Button;
	
	private var ROOM_X					: Number = 0;			
	private var ROOM_Y					: Number = -76;	
	
	public var content					: MovieClip;
	public var selectedID				: Number;
	private var data					: Object;
	
	// DISPATCH
	public var addEventListener			: Function; 
	public var removeEventListener		: Function; 
	public var dispatchEvent			: Function;	
	////////////////////////////////////////////////////////////////////////////
	// Constructor
	////////////////////////////////////////////////////////////////////////////
	public function GrowYourBusiness()
	{		
		EventDispatcher.initialize(this);
	}
	
	public static function getInstance() : GrowYourBusiness 
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
		site_room_mc.addEventListener("buttonClicked", this);
		link_btn.onRelease = Delegate.create(this, getPageLink);
	}

	////////////////////////////////////////////////////////////////////////////
	// Hide on stage assets
	///////////////////////////////////////////////////////////////////////////
	public function hideAssets() : Void
	{
		setParams("text_mc", { _x: -Stage.width } );
		TweenMax.to(roundel_mc, 0, { _xscale:0, _yscale:0 } );
		TweenMax.to(site_room_mc, 0, { _x: -2978, _y: -918, _xscale:500, _yscale:500 } );
		TweenMax.to(link_btn, 0, {autoAlpha:0});
	}	

	////////////////////////////////////////////////////////////////////////////
	// Show assets
	///////////////////////////////////////////////////////////////////////////		
	public function showAssets( ) : Void
	{
		var dtime : Number = 6;
		TweenMax.to(site_room_mc, 3, { _x:ROOM_X, _y:ROOM_Y, _xscale:100, _yscale:100, ease:Cubic.easeInOut, onComplete:site_room_mc.playIntro, onCompleteScope:site_room_mc } );
		
		TweenMax.to(text_mc0, 1.2, { _x:text_mc0.init._x, _y:text_mc0.init._y, ease:Cubic.easeOut, delay: dtime } );
		TweenMax.to(text_mc1, 1.2, { _x:text_mc1.init._x, _y:text_mc1.init._y, ease:Cubic.easeOut, delay: dtime+=.6} );
		TweenMax.to(text_mc2, 1, { _x:text_mc2.init._x, _y:text_mc2.init._y, ease:Cubic.easeOut, delay: dtime += .5 } );
		TweenMax.to(roundel_mc, 1, { _xscale:100, _yscale:100, ease:Back.easeOut, delay: dtime += 1 } );
		TweenMax.to(link_btn, 1, {autoAlpha:100, delay: dtime += 1});
	}	
	
	
	////////////////////////////////////////////////////////////////////////////
	// Get external page of site
	///////////////////////////////////////////////////////////////////////////		
	private function getPageLink( ) : Void
	{
		_level0.application_mc.selectID(7);
	}	
	////////////////////////////////////////////////////////////////////////////
	// On button clicked from site room
	///////////////////////////////////////////////////////////////////////////		
	private function buttonClicked( e : Object ) : Void
	{
		var id : Number = e.target.clickedID;
		
		openContent(id);
	}	
	
	////////////////////////////////////////////////////////////////////////////
	// open main content box
	///////////////////////////////////////////////////////////////////////////
	public function openContent( id : Number ) : Void
	{
		if (id != selectedID)
		{
			closeContent();
			
			TweenMax.killAll();
			
			site_room_mc.disableButtons();
			
			selectedID = id;
		
			data = site_room_mc["data" + selectedID];
			
			content = this.attachMovie("content" + selectedID, "content", this.getNextHighestDepth(), { _x:data.xoff } );
			content.close_btn.onRelease = Delegate.create(this, closeContent);
			
			content.boxout_mc._x = data.boxoff;
			content.boxout_mc._y = 330;
			content.boxout_mc.invisible_btn.onRelease = Delegate.create(this, openBoxOut);
			content.boxout_mc.close_btn.onRelease = Delegate.create(this, closeBoxOut);
			
			TweenMax.to(content.boxout_mc.close_btn, 0, { autoAlpha:0 } );
			TweenMax.to(content.boxout_mc.text_mc, 0, { autoAlpha:0 } );
	
			//hide other assets
			TweenMax.to(text_mc0, .5, { _alpha:0 } );
			TweenMax.to(text_mc1, .5, { _alpha:0 } );
			TweenMax.to(text_mc2, .5, { _alpha:0 } );
			TweenMax.to(roundel_mc, .5, { _xscale:0, _yscale:0 } );
			TweenMax.to(link_btn, .5, {autoAlpha:0});
			
			//show new room and content
			TweenMax.to(site_room_mc, 2, { _x:data.roomx, _y:data.roomy, _xscale:data.roomScale, _yscale:data.roomScale, ease:Cubic.easeInOut } );
			
			TweenMax.to(content, 1, { _x:data.xpos, _y:data.ypos, ease:Cubic.easeOut, delay:1 } );
			
			TweenMax.to(content.boxout_mc, 1, { _x:data.boxon, ease:Cubic.easeOut, delay:2 } );
			
			Tracker.trackClick(page_name, data.label);
			
		}

	}		
	////////////////////////////////////////////////////////////////////////////
	// Close main content box
	///////////////////////////////////////////////////////////////////////////
	public function closeContent() : Void
	{
		var dtime : Number = 0;
		
		TweenMax.to(content.boxout_mc, 1, { _x:data.boxoff, ease:Cubic.easeInOut } );
		
		TweenMax.to(site_room_mc, 3, { _x:ROOM_X, _y:ROOM_Y, _xscale:100, _yscale:100, ease:Cubic.easeInOut } );
		
		TweenMax.to(content, 3, { _x:data.xoff, _y:data.ypos, ease:Cubic.easeInOut, delay:dtime, onComplete:removeContent, onCompleteScope:this } );
		
		TweenMax.to(text_mc0, 1, { _alpha:100, _x:text_mc0.init._x, _y:text_mc0.init._y, ease:Cubic.easeOut, delay: dtime+=2 } );
		TweenMax.to(text_mc1, 1, { _alpha:100, _x:text_mc1.init._x, _y:text_mc1.init._y, ease:Cubic.easeOut, delay: dtime} );
		TweenMax.to(text_mc2, 1, { _alpha:100, _x:text_mc2.init._x, _y:text_mc2.init._y, ease:Cubic.easeOut, delay: dtime } );
		TweenMax.to(roundel_mc, 1, { _xscale:100, _yscale:100, ease:Back.easeOut, delay: dtime += 1 } );
		TweenMax.to(link_btn, 1, {autoAlpha:100, delay: dtime += 1});
	}		
	
	////////////////////////////////////////////////////////////////////////////
	// remove main content box
	///////////////////////////////////////////////////////////////////////////
	public function removeContent() : Void
	{
		content.removeMovieClip();
		content = null;
		selectedID = 0;
		site_room_mc.enableButtons();
	}		
	
	////////////////////////////////////////////////////////////////////////////
	// Open content box out
	///////////////////////////////////////////////////////////////////////////
	public function openBoxOut() : Void
	{
		TweenMax.to(content.boxout_mc, 1, { _y:data.boxy, ease:Cubic.easeInOut } );
		TweenMax.to(content.boxout_mc.bg, 1, { _height:data.boxbig, _y:-30, ease:Cubic.easeInOut } );
		TweenMax.to(content.boxout_mc.text_mc, 1, { autoAlpha:100, delay:1 } );
		
		TweenMax.to(content.boxout_mc.clickfor_mc, .5, { autoAlpha:0 } );
		TweenMax.to(content.boxout_mc.close_btn, 1, { autoAlpha:100 } );
		content.boxout_mc.invisible_btn.enabled = false;
		
		Tracker.trackClick(page_name, data.label + "/boxout");
	}			
	
	////////////////////////////////////////////////////////////////////////////
	// close content box out
	///////////////////////////////////////////////////////////////////////////
	public function closeBoxOut() : Void
	{
		TweenMax.to(content.boxout_mc.text_mc, .5, { _alpha:0, delay:0 } );
		TweenMax.to(content.boxout_mc, 1, { _y:330, ease:Cubic.easeInOut, delay:0 } );
		TweenMax.to(content.boxout_mc.bg, 1, { _height:data.boxsmall, _y:0, ease:Cubic.easeInOut, delay:0 } );
		TweenMax.to(content.boxout_mc.clickfor_mc, 1, { autoAlpha:100, delay:.5 } );
		
		content.boxout_mc.invisible_btn.enabled = true;

		TweenMax.to(content.boxout_mc.close_btn, 0, { autoAlpha:0 } );
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