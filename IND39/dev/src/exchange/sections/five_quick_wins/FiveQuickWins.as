////////////////////////////////////////////////////////////////////////////////
// Project: Orange Exchange issue 39
// FileName: FiveQuickWins.as
// Created by: Angel 
// updated : 16 Feb 2014
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
// IMPORTS
////////////////////////////////////////////////////////////////////////////////
import mx.events.EventDispatcher;
import mx.utils.Delegate;

import com.greensock.TweenMax;
import com.greensock.easing.*;
////////////////////////////////////////////////////////////////////////////////
// CLASS: FiveQuickWins 
////////////////////////////////////////////////////////////////////////////////
class exchange.sections.five_quick_wins.FiveQuickWins extends MovieClip
{
	////////////////////////////////////////////////////////////////////////////
	// PROPERTIES
	////////////////////////////////////////////////////////////////////////////
	public var page_name 				: String = "five_quick_wins";
	
	private var view_width				: Number = 960;
	private var view_height				: Number = 500;
	
	private var ID						: Number = 99;
	private var numOfIcons				: Number = 5;

	public var page_mc					: MovieClip;
	public var intro_text_mc			: MovieClip;
	public var roundel_mc				: MovieClip;
	public var main_mc					: MovieClip;
	public var quickWins_mc				: MovieClip;
	public var plus_lines_mc			: MovieClip;
	public var tooltip_mc				: MovieClip;
	
	public var positions				: Array = [ { x: -180, y: -542, scale:240 }, { x:-1278, y:-688, scale:255 }, { x:-2416, y:-993, scale:290 }, { x:-2445, y:-1197, scale:262 }, { x:196, y:-1126, scale:200 } ];
	public var glowColors 				: Array = [0x6DCED0, 0xF7F4E9, 0xFEE600, 0x6DCED0, 0xF7F4E9];
	public var tracking 				: Array = ["VIDEO MEETINGS", "GET YOUR COMMS TOGETHER", "SHARING CONTENT", "MOBILE SECURITY", "HOW DO YOU LOOK ONLINE"];
	public var tooltip_pos				: Array = [ { x:25, y:155}, { x:500, y:98}, { x:638, y:180 }, { x:760, y:355 }, { x:156, y:411 } ];
	
	// DISPATCH
	public var addEventListener			: Function; 
	public var removeEventListener		: Function; 
	public var dispatchEvent			: Function;	
	////////////////////////////////////////////////////////////////////////////
	// Constructor
	////////////////////////////////////////////////////////////////////////////
	public function FiveQuickWins()
	{		
		EventDispatcher.initialize(this);
	}

	////////////////////////////////////////////////////////////////////////////
	// On Load
	///////////////////////////////////////////////////////////////////////////
	public function onLoad() : Void
	{
		initPage();
	}
	
	////////////////////////////////////////////////////////////////////////////
	// Initialise
	///////////////////////////////////////////////////////////////////////////
	public function initPage() : Void
	{
		quickWins_mc = main_mc.quickWins_mc;
		findObjects(this);
		hideAssets();
		disableAll();
		setupIconsLinks();
		intro_text_mc.btn.onRelease = Delegate.create(this, showMainText);
	}
	
	////////////////////////////////////////////////////////////////////////////
	// Hide on stage assets
	///////////////////////////////////////////////////////////////////////////
	public function hideAssets() : Void
	{
		TweenMax.to(intro_text_mc, 0, { autoAlpha:0 } );	
		
		TweenMax.to(roundel_mc, 0, { _xscale:0, _yscale:0 } );
		
		for (var i:Number = 0; i< numOfIcons; i++) 
		{
			var icon : MovieClip = main_mc["icon"+i];
			var plus : MovieClip = main_mc["plus" + i];
			var pline : MovieClip = main_mc.plus_lines_mc["line" + i];
			
			TweenMax.to(plus, 0, { autoAlpha:0, _xscale:0, _yscale:0 } );			
			TweenMax.to(pline, 0, { _xscale:0 } );
			TweenMax.to(icon, 0, { autoAlpha:0, _xscale:0, _yscale:0 } );
		}
		
		TweenMax.to(quickWins_mc.logo_colour, 0, { autoAlpha:0, _xscale:0, _yscale:0 } );
		TweenMax.to(quickWins_mc.logo_lines_thin, 0, { autoAlpha:0} );
		TweenMax.to(quickWins_mc.logo_lines_thick, 0, { autoAlpha:0 } );
		TweenMax.to(quickWins_mc.lines_outer, 0, { autoAlpha:0 } );
	}		
	
	////////////////////////////////////////////////////////////////////////////
	// Show assets
	///////////////////////////////////////////////////////////////////////////		
	public function showAssets( ) : Void
	{
		var dtime : Number = 0;
		
		TweenMax.to(quickWins_mc.logo_colour, 1, { autoAlpha:100, _xscale:100, _yscale:100, ease:Back.easeOut, delay:dtime } );
		TweenMax.to(quickWins_mc.logo_lines_thin, 1, { autoAlpha:100, delay:dtime+=1 } );
		TweenMax.to(quickWins_mc.logo_lines_thick, 1, { autoAlpha:100, delay:dtime+=1 } );
		TweenMax.to(quickWins_mc.lines_outer, 1, { autoAlpha:100, delay:dtime+=1 } );

		for (var i:Number = 0; i< numOfIcons; i++) 
		{
			var icon : MovieClip = main_mc["icon"+i];
			var plus : MovieClip = main_mc["plus" + i];
			var pline : MovieClip = main_mc.plus_lines_mc["line" + i];
			
			TweenMax.to(icon, 3, { autoAlpha:100, _xscale:icon.iv._xscale, _yscale:icon.iv._yscale, _x:icon.iv._x, _y:icon.iv._y, ease:Elastic.easeOut, delay:dtime } );		
					
			TweenMax.to(pline, 2, { _xscale:pline.iv._xscale, ease:Cubic.easeOut, delay:dtime+1 } );
		
			TweenMax.to(plus, 4, { autoAlpha:100, _xscale:100, _yscale:100, ease:Elastic.easeOut, delay:dtime+1.5 } );	
			
			dtime += .2;
		}
		
		TweenMax.to(intro_text_mc, .5, { autoAlpha:100, delay:dtime+=.1 } );
	
		TweenMax.to(roundel_mc, 1, { _xscale:100, _yscale:100, ease:Back.easeOut, delay:dtime+=.5 } );
		
		enableAll();
	}
		
	////////////////////////////////////////////////////////////////////////////
	// Set up icons
	///////////////////////////////////////////////////////////////////////////
	private function setupIconsLinks() : Void
	{
		for (var i:Number = 0; i< numOfIcons; i++) 
		{
			var icon : MovieClip = main_mc["icon"+i];
			var plus : MovieClip = main_mc["plus"+i];
			icon.id = i;
			plus.id = i;
			
			icon.gc = glowColors[i];
			plus.gc = 0xcccccc;
			
			var icon_link = icon.onRelease = Delegate.create(this, onItemClicked);
			icon_link.mc = icon;
			
			var plus_link = plus.onRelease = Delegate.create(this, onItemClicked);
			plus_link.mc = plus;
			
			icon.onRollOver = onItemOver;
			icon.onRollOut = onItemOut;		
			
			plus.onRollOver = onItemOver;
			plus.onRollOut = onItemOut;
		}
	}		
	
	////////////////////////////////////////////////////////////////////////////
	// On Icon or plus sign clicked
	///////////////////////////////////////////////////////////////////////////
	public function onItemClicked() : Void
	{
		var mc = arguments.caller.mc;
		
		openPageByID(mc.id);
		
		removeTooltip();
		
		var word_array:Array = tracking[mc.id].split(" "); 
		var tracking_data : String = word_array.join("_");

		Tracker.trackClick(page_name, tracking_data);
	}
	
	////////////////////////////////////////////////////////////////////////////
	// On item mouse over
	///////////////////////////////////////////////////////////////////////////	
	public function onItemOver():Void
	{
		var mcTarget : MovieClip = this;
		var i : Number = mcTarget.id;
		var icon : MovieClip = this._parent["icon" + i];
		var plus : MovieClip = this._parent["plus" + i];
		var _colour = icon.gc;

		TweenMax.to(icon, .5, {glowFilter:{color:_colour, alpha:1, blurX:12, blurY:12, strength:1, quality:3}, _xscale:icon.iv._xscale+10, _yscale:icon.iv._yscale+10, yoyo:true, repeat:-1, repeatDelay:0 });
		TweenMax.to(plus, .5, { _xscale:60, _yscale:60, yoyo:true, repeat: -1, repeatDelay:0 } );
		
		this._parent._parent.showTooltip(i);	
	}
	
	////////////////////////////////////////////////////////////////////////////
	// On item mouse out
	///////////////////////////////////////////////////////////////////////////	
	public function onItemOut():Void
	{
		var mcTarget : MovieClip = this;
		var i : Number = mcTarget.id;
		var icon : MovieClip = this._parent["icon" + i];
		var plus : MovieClip = this._parent["plus" + i];
		var _colour = icon.gc;
		
		TweenMax.to(icon, .5, {glowFilter:{color:_colour, alpha:1, blurX:0, blurY:0, strength:1, quality:3, remove:true}, _xscale:icon.iv._xscale, _yscale:icon.iv._yscale});
		TweenMax.to(plus, .5, { _xscale:plus.iv._xscale, _yscale:plus.iv._yscale } );
		
		this._parent._parent.removeTooltip();
	}
	
	////////////////////////////////////////////////////////////////////////////
	// On Icon or plus sign clicked open page
	///////////////////////////////////////////////////////////////////////////
	public function openPageByID( _id : Number ) : Void
	{
		TweenMax.killAll();
		
		ID = _id;
		
		var dtime : Number = 0;
		
		TweenMax.to(intro_text_mc, .5, { _alpha:0 } );	
		
		TweenMax.to(roundel_mc, .5, { _xscale:0, _yscale:0, ease:Back.easeIn } );
		 
		TweenMax.to(main_mc, 1.5, { _xscale:positions[ID].scale, _yscale:positions[ID].scale, _x:positions[ID].x, _y:positions[ID].y, ease:Cubic.easeInOut, delay:dtime + .2 } );
		
		for (var i:Number = 0; i< numOfIcons; i++) 
		{
			var icon : MovieClip = main_mc["icon"+i];
			var plus : MovieClip = main_mc["plus" + i];
			var pline : MovieClip = main_mc.plus_lines_mc["line" + i];
			
			TweenMax.to(plus, .5, { autoAlpha:0, _xscale:0, _yscale:0, ease:Back.easeIn, delay:dtime } );			
			
			TweenMax.to(pline, .5, { _xscale:0, ease:Back.easeIn, delay:dtime } );
			
			if ( icon.id == ID )
			{
				TweenMax.to(icon, .5, { _xscale:icon.iv._xscale, _yscale:icon.iv._yscale, ease:Back.easeIn, delay:dtime, glowFilter:{color:icon.gc, alpha:1, blurX:0, blurY:0, strength:1, quality:3, remove:true} } );
			}
		}
		
		TweenMax.delayedCall(dtime + 1, attachPage, null, this);
		
		TweenMax.to(quickWins_mc.logo_lines_thin, .5, { autoAlpha:0, delay:dtime+=1 } );
		TweenMax.to(quickWins_mc.logo_lines_thick, .5, { autoAlpha:0, delay:dtime } );
		TweenMax.to(quickWins_mc.logo_colour, .5, { autoAlpha:0, delay:dtime } );
		TweenMax.to(quickWins_mc.lines_outer.linestohide, .5, { autoAlpha:0, delay:dtime} );
		TweenMax.delayedCall(dtime, hideInactiveIcons, null, this);
		
		disableAll();
		intro_text_mc.btn.enabled = false;
	}
	
	
	////////////////////////////////////////////////////////////////////////////
	// Hide inactive icons
	///////////////////////////////////////////////////////////////////////////	
	private function hideInactiveIcons() : Void
	{
		for (var i:Number = 0; i< numOfIcons; i++) 
		{
			var icon : MovieClip = main_mc["icon"+i];
			
			if ( icon.id != ID )
			{
				TweenMax.to(icon, .5, { autoAlpha:0 } );
			}
		}
	}	
	////////////////////////////////////////////////////////////////////////////
	// show all icons and reset to original states
	///////////////////////////////////////////////////////////////////////////	
	private function showAllIcons() : Void
	{
		for (var i:Number = 0; i< numOfIcons; i++) 
		{
			var icon : MovieClip = main_mc["icon"+i];

			TweenMax.to(icon, .5, { autoAlpha:100, _xscale:icon.iv._xscale, _yscale:icon.iv._yscale, _x:icon.iv._x, _y:icon.iv._y } );
		}
	}	
	
	////////////////////////////////////////////////////////////////////////////
	// Attach page by ID from library
	///////////////////////////////////////////////////////////////////////////
	private function attachPage() : Void
	{
		var libraryMC : String = "page" + ID;
		page_mc = this.attachMovie(libraryMC, "page_mc", this.getNextHighestDepth(), { _alpha:0 } );
		page_mc.close_btn.onRelease = Delegate.create(this, closePage);
		TweenMax.to(page_mc, .5, { autoAlpha:100, delay:0 } );
	}		
	
	////////////////////////////////////////////////////////////////////////////
	// Close page
	///////////////////////////////////////////////////////////////////////////
	public function closePage() : Void
	{
		TweenMax.to(page_mc, .5, { autoAlpha:0, onComplete:pageClosed, onCompleteScope:this } );
		
		buildMainScreen();
	}	
	
	////////////////////////////////////////////////////////////////////////////
	// on page closed
	///////////////////////////////////////////////////////////////////////////	
	private function pageClosed() : Void
	{
		page_mc.removeMovieClip();
		page_mc = null;
	}	

	////////////////////////////////////////////////////////////////////////////
	// Rebuild the main screen after page closed
	///////////////////////////////////////////////////////////////////////////
	private function buildMainScreen( ) : Void
	{
		var dtime : Number = 0;
		
		TweenMax.to(quickWins_mc.logo_lines_thin, .5, { autoAlpha:100, delay:dtime } );
		TweenMax.to(quickWins_mc.logo_lines_thick, .5, { autoAlpha:100, delay:dtime } );
		TweenMax.to(quickWins_mc.logo_colour, .5, { autoAlpha:100, delay:dtime } );
		TweenMax.to(quickWins_mc.lines_outer.linestohide, .5, { autoAlpha:100, delay:dtime } );
		TweenMax.delayedCall(dtime, showAllIcons, null, this);
		
		TweenMax.to(main_mc, 1.5, { _xscale:main_mc.iv._xscale, _yscale:main_mc.iv._yscale, _x:main_mc.iv._x, _y:main_mc.iv._y, ease:Cubic.easeInOut, delay:dtime } );
		
		for (var i:Number = 0; i< numOfIcons; i++) 
		{
			var plus : MovieClip = main_mc["plus" + i];
			var pline : MovieClip = main_mc.plus_lines_mc["line" + i];
			
			TweenMax.to(pline, .5, { _xscale:pline.iv._xscale, ease:Back.easeIn, delay:dtime+.5 } );
		
			TweenMax.to(plus, 4, { autoAlpha:100, _xscale:100, _yscale:100, ease:Elastic.easeOut, delay:dtime+1.5 } );	
			
			dtime += .3;
		}
		
		TweenMax.to(intro_text_mc, .5, { autoAlpha:100, delay:dtime+=.2 } );
		TweenMax.to(roundel_mc, .5, { _xscale:roundel_mc.iv._xscale, _yscale:roundel_mc.iv._yscale, ease:Back.easeOut, delay:dtime+=.5 } );
		//TweenMax.to(tags_mc, 1, { autoAlpha:100, delay:dtime+=.5  } );
		
		enableAll();
		intro_text_mc.btn.enabled = true;
	}	

	////////////////////////////////////////////////////////////////////////////
	// show main text
	///////////////////////////////////////////////////////////////////////////
	private function showMainText() : Void
	{
		disableAll();

		TweenMax.to(intro_text_mc, 1, { _y:20, ease:Cubic.easeOut } );
		
		TweenMax.to(roundel_mc, .5, { _alpha:0, delay:.3 } );
		TweenMax.to(intro_text_mc.pull_up_mc, .3, { _alpha:0, delay:.3 } );
		
		TweenMax.to(intro_text_mc.bg1, .6, { _alpha:0, delay:.4 } );
		TweenMax.to(intro_text_mc.bg2, .6, { _alpha:100, delay:.4 } );
		
		TweenMax.to(intro_text_mc.btn, 0, { _y:445, delay:0 } );
		intro_text_mc.btn.onRelease = Delegate.create(this, hideMainText);
		
		Tracker.trackClick(page_name, "main_text_read_more");

	}
	////////////////////////////////////////////////////////////////////////////
	// hide main text
	///////////////////////////////////////////////////////////////////////////
	private function hideMainText() : Void
	{
		enableAll();
		
		TweenMax.to(intro_text_mc, 1, { _y:intro_text_mc.iv._y, ease:Cubic.easeOut} );
		
		TweenMax.to(intro_text_mc.bg1, .5, { _alpha:100, delay:.1 } );
		TweenMax.to(intro_text_mc.bg2, .5, { _alpha:0, delay:.1 } );

		TweenMax.to(intro_text_mc.pull_up_mc, .5, { _alpha:100, delay:.3 } );

		TweenMax.to(roundel_mc, .5, { _alpha:100, delay:.3 } );
		
		TweenMax.to(intro_text_mc.btn, 0, { _y:0, delay:0 } );
		intro_text_mc.btn.onRelease = Delegate.create(this, showMainText);
		
	}
	
	////////////////////////////////////////////////////////////////////////////
	// Disable all 
	///////////////////////////////////////////////////////////////////////////			
	public function disableAll():Void
	{
		for (var i:Number = 0; i< numOfIcons; i++) 
		{
			var icon : MovieClip = main_mc["icon"+i];
			
			var plus : MovieClip = main_mc["plus" + i];
			
			icon.enabled = false;
			
			plus.enabled = false;
		}
	}
	////////////////////////////////////////////////////////////////////////////
	// Enable all 
	///////////////////////////////////////////////////////////////////////////	
	public function enableAll():Void
	{
		for (var i:Number = 0; i< numOfIcons; i++) 
		{
			var icon : MovieClip = main_mc["icon"+i];
			
			var plus : MovieClip = main_mc["plus" + i];
			
			icon.enabled = true;
			
			plus.enabled = true;
		}

	}
	
	////////////////////////////////////////////////////////////////////////////
	// tool tip
	///////////////////////////////////////////////////////////////////////////	
	private function showTooltip(i:Number):Void
	{
		tooltip_mc = this.attachMovie("tooltip", "tooltip_mc", 100, { _x:tooltip_pos[i].x, _y:tooltip_pos[i].y, _alpha:0 } );
		tooltip_mc.txt.autoSize = "LEFT";
		tooltip_mc.txt.htmlText = tracking[i];
		tooltip_mc.bg._width = tooltip_mc.txt.textWidth +15;
		
		TweenMax.to(tooltip_mc, .5, {_alpha:100});
	}
	private function removeTooltip():Void
	{
		tooltip_mc.removeMovieClip();
	}
	
	
	////////////////////////////////////////////////////////////////////////////
	// Get the competition link
	///////////////////////////////////////////////////////////////////////////	
	public function getLink( url : String ):Void
	{
		Tracker.getLink( page_name, url );
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
		obj.iv = new Object();
		obj.iv._name = "initValues";
		
		obj.iv._x = obj._x;
		obj.iv._y = obj._y;
		obj.iv._width = obj._width;
		obj.iv._height = obj._height;
		obj.iv._alpha = obj._alpha;
		obj.iv._rotation = obj._rotation;
		obj.iv._xscale = obj._xscale;
		obj.iv._yscale = obj._yscale;
	}
	
	////////////////////////////////////////////////////////////////////////////
	// Resets the object to its' initial values.
	///////////////////////////////////////////////////////////////////////////
	public function resetValues(obj:Object):Void 
	{
		if (obj.iv != undefined) 
		{
			for (var i in obj.iv) 
			{
				if (i != "_name") obj[i] = obj.iv[i];
			}
		}
	}
	
	////////////////////////////////////////////////////////////////////////////
	// Set params to a selection of objects 
	///////////////////////////////////////////////////////////////////////////	
	public function setParams(baseName:String, properties:Object):Void 
	{
		var mc:MovieClip;
		for (var i:Number = 0; mc = this[baseName + i]; i++) 
		{
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