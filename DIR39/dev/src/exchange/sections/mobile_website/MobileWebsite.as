////////////////////////////////////////////////////////////////////////////////
// Project: Orange Exchange issue 37
// FileName: MobileWebsite.as
// Created by: Angel 
// updated : 18 September 2013
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// IMPORTS
////////////////////////////////////////////////////////////////////////////////
import mx.events.EventDispatcher;
import mx.utils.Delegate;

import exchange.model.Model;

import com.greensock.TweenMax;
import com.greensock.easing.*;
////////////////////////////////////////////////////////////////////////////////
// CLASS: MobileWebsite 
////////////////////////////////////////////////////////////////////////////////
class exchange.sections.mobile_website.MobileWebsite extends MovieClip
{
	
	////////////////////////////////////////////////////////////////////////////
	// PROPERTIES
	////////////////////////////////////////////////////////////////////////////
	private static var instance			: MobileWebsite;
	public var _Model					: Model;
	public var page_name 				: String;  		//this is set onstage
	
	//on stage assets
	private var text_mc0				: MovieClip;
	private var text_mc1				: MovieClip;
	private var text_mc2				: MovieClip;	
	private var text_mc3				: MovieClip;	
	private var iphone_menu_mc			: MovieClip;	
	private var intro_mc				: MovieClip;
	private var intro_phone				: MovieClip;	
	private var line_mc					: MovieClip;
	private var instructions_mc			: MovieClip;
	private var menu_mc					: MovieClip;	
	private var content_holder			: MovieClip;
	private var content_mc				: MovieClip;
	
	private var numOfItems				: Number;
	
	
	private var CONTENT_OPEN			: Boolean = false;
	
	// DISPATCH
	public var addEventListener			: Function; 
	public var removeEventListener		: Function; 
	public var dispatchEvent			: Function;	
	
	//DATA
	public var menu_titles 				: Array = ["decide what you want", "create your content", "build a site", "online and offline sales", "track your success", "real world examples"];

	
	////////////////////////////////////////////////////////////////////////////
	// Constructor
	////////////////////////////////////////////////////////////////////////////
	public function MobileWebsite()
	{		
		EventDispatcher.initialize(this);
	}
	
	public static function getInstance() : MobileWebsite 
	{
		return instance;
	}
	
	
	////////////////////////////////////////////////////////////////////////////
	// On Load
	///////////////////////////////////////////////////////////////////////////
	public function onLoad() : Void
	{
		instance = this;

		if (_level0.application_mc)
		{
			_Model = Model.getInstance();
			initPage();
		}
		else
		{
			initModel();
		}
	}
	
	////////////////////////////////////////////////////////////////////////////
	// Initialise Model
	////////////////////////////////////////////////////////////////////////////
	private function initModel() : Void
	{
		_Model = Model.getInstance();
		_Model.addEventListener("modelComplete", this);
		_Model.init();
	}
	public function modelComplete() : Void
	{
		_Model.removeEventListener("modelComplete", this);
		initPage();
	}	
	
	
	////////////////////////////////////////////////////////////////////////////
	// Initialise
	///////////////////////////////////////////////////////////////////////////
	private function initPage() : Void
	{
		numOfItems = menu_titles.length;
		findObjects(this);
		hideAssets();
		setupmenu();
	}
	
	////////////////////////////////////////////////////////////////////////////
	// Hide on stage assets
	///////////////////////////////////////////////////////////////////////////
	public function hideAssets() : Void
	{
		setParams("text_mc", { _x: -Stage.width } );
		
		instructions_mc._x = 980;
		
		line_mc._xscale = 0;
		
		iphone_menu_mc._y = 700;
		
		TweenMax.to(menu_mc, 0, { _xscale:0, _yscale:0 } );
		
		TweenMax.to(menu_mc.menu_text, 0, {_alpha:0 } );
	}	
	////////////////////////////////////////////////////////////////////////////
	// Show assets
	///////////////////////////////////////////////////////////////////////////		
	public function showAssets( ) : Void
	{
		intro_mc = this.attachMovie("INTRO", "intro_mc", this.getNextHighestDepth());
	}	
	
	////////////////////////////////////////////////////////////////////////////
	// Intro Finished
	///////////////////////////////////////////////////////////////////////////		
	public function introFinished( ) : Void
	{
		intro_phone = this.attachMovie("iphone_responsive", "intro_phone", this.getNextHighestDepth(), {_x:481.1, _y:248.65});
		intro_mc.removeMovieClip();
		
		var dtime : Number = 0;
		
		TweenMax.to(intro_phone, 1, {_x:729.4, _y:433.6, _xscale:107, _yscale:107, ease:Cubic.easeOut, dropShadowFilter:{color:0x000000, alpha:100, blurX:14, blurY:14, strength:1, angle:146, distance:14} } );
				
		TweenMax.to(iphone_menu_mc, 0, { _y:iphone_menu_mc.init._y, _alpha:0, delay:1.5, dropShadowFilter:{color:0x000000, alpha:100, blurX:14, blurY:14, strength:1, angle:146, distance:14} } );
		
		TweenMax.to(intro_phone, 1.5, { _alpha:0, delay:2 } );
		TweenMax.to(iphone_menu_mc, 1.5, { _alpha:100, delay:2 } );	
	
		TweenMax.to(text_mc0, 1, { _x:text_mc0.init._x, ease:Cubic.easeOut, delay:dtime += 1 } );
		TweenMax.to(text_mc1, 1, { _x:text_mc1.init._x, ease:Cubic.easeOut, delay:dtime += .5 } );		
		TweenMax.to(line_mc, 2, { _xscale:100, ease:Quad.easeOut, delay:dtime += .5 } );
		TweenMax.to(text_mc2, 1, { _x:text_mc2.init._x, ease:Cubic.easeOut, delay:dtime += .5 } );
		TweenMax.to(text_mc3, 1, { _x:text_mc3.init._x, ease:Cubic.easeOut, delay:dtime += .5 } );		

		TweenMax.to(menu_mc, 1, {_xscale:100, _yscale:100, ease:Back.easeOut, delay:dtime  } );
		TweenMax.to(instructions_mc, 1, { _x:instructions_mc.init._x, ease:Cubic.easeOut, delay:dtime += 1 } );
	}
	
	////////////////////////////////////////////////////////////////////////////
	// Set up iphone menu
	///////////////////////////////////////////////////////////////////////////
	private function setupmenu() : Void
	{
		for (var i : Number = 0; i < numOfItems; i++)
		{
			var menu_button : MovieClip = this.menu_mc["mb"+i];
			
			var mb = menu_button.onRollOver = Delegate.create(this, onMenuOver);
			mb.mc = menu_button;
			mb.id = i;
			
			var mb = menu_button.onRollOut = Delegate.create(this, onMenuOut);
			mb.mc = menu_button;
			mb.id = i;
			
			var mbb = menu_button.onRelease = Delegate.create(this, onMenuClicked);
			mbb.id = i;
			mbb.mc = menu_button;

		}
	}
	////////////////////////////////////////////////////////////////////////////
	// On menu button clicked
	///////////////////////////////////////////////////////////////////////////	
	private function onMenuClicked():Void
	{
		var mc = arguments.caller.mc;
		var id = arguments.caller.id;
		openSection(id);
	}	
	
	////////////////////////////////////////////////////////////////////////////
	// On menu button mouse over
	///////////////////////////////////////////////////////////////////////////	
	private function onMenuOver():Void
	{
		var mc = arguments.caller.mc;
		var id = arguments.caller.id;
		TweenMax.to(mc.icon_mc, .5, { colorTransform: { tint:0xFF6600, tintAmount:1 }} );
		TweenMax.to(mc.bg, .5, { colorTransform: { tint:0xFFFFFF, tintAmount:1 }} );
		
		menu_mc.menu_text.txt.htmlText = menu_titles[id];
		menu_mc.menu_text._x = menu_mc.menu_text.init._x + 50;
		
		TweenMax.to(menu_mc.menu_text, .5, {_alpha:100, _x:menu_mc.menu_text.init._x, ease:Cubic.easeOut } );
	}	
	////////////////////////////////////////////////////////////////////////////
	// On menu button mouse out
	///////////////////////////////////////////////////////////////////////////		
	private function onMenuOut():Void
	{
		var mc = arguments.caller.mc;
		var id = arguments.caller.id;
		TweenMax.to(mc.icon_mc, .5, { colorTransform: { tint:0xFFFFFF, tintAmount:1 }} );
		TweenMax.to(mc.bg, .5, { colorTransform: { tint:0xFF6600, tintAmount:1 }} );
		TweenMax.to(menu_mc.menu_text, .2, {_alpha:0} );
	}

	////////////////////////////////////////////////////////////////////////////
	// Open section selected from iphone menu
	///////////////////////////////////////////////////////////////////////////		
	private function openSection(secID : Number ) : Void
	{
		emptyMC(content_holder);
		
		var dtime : Number = 0;
		
		TweenMax.to(text_mc2, .5, { _alpha:0 } );
		TweenMax.to(text_mc3, .5, { _alpha:0} );				
		
		var content_identifier : String = "content" + secID.toString();
		
		content_mc = content_holder.attachMovie(content_identifier, "content_mc", content_holder.getNextHighestDepth(), { _alpha:0 } );
		
		(CONTENT_OPEN) ? dtime = 0 : dtime = .5;
		
		TweenMax.to(content_mc, dtime, { _alpha:100, delay:dtime, onComplete:contentOpened, onCompleteScope:this} );
		
		content_mc.close_btn.onRelease = Delegate.create(this, closeSection);
		
		Tracker.trackClick(page_name, menu_titles[secID]);
	}
	
	////////////////////////////////////////////////////////////////////////////
	// Close content section 
	///////////////////////////////////////////////////////////////////////////		
	private function closeSection( ) : Void
	{
		TweenMax.to(content_mc, .5, { _alpha:0, delay:0 } );
		TweenMax.to(text_mc2, .5, { _alpha:100, delay:.5 } );
		TweenMax.to(text_mc3, .5, { _alpha:100, delay:.8, onComplete:contentClosed, onCompleteScope:this} );		
	}
	
	////////////////////////////////////////////////////////////////////////////
	// On content section closed - disable the mouse over images
	///////////////////////////////////////////////////////////////////////////		
	private function contentClosed() : Void
	{
		CONTENT_OPEN = false;
		emptyMC(content_holder);
	}
	////////////////////////////////////////////////////////////////////////////
	// On content section opened - enable the mouse over images
	///////////////////////////////////////////////////////////////////////////		
	private function contentOpened() : Void
	{
		CONTENT_OPEN = true;
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
	//FORMAT TEXT FIELD PROPERTIES
	////////////////////////////////////////////////////////////////////////////
	private function formatText(txtF:TextField, txtStr:String, multiline:Boolean, txt_width : Number, _autosize:Boolean ) : Void
	{
		(!isNaN(txt_width)) ? txtF._width = txt_width : null;
		
		(_autosize == undefined) ? _autosize = true : null;
		
		txtF.border = false;
		txtF.background = false;
		txtF.autoSize = _autosize;
		txtF.wordWrap = multiline;
		txtF.selectable = false;
		txtF.multiline = multiline;
		txtF.embedFonts = true;
		txtF.html = true;
		//txtF.styleSheet = _Model.cssFile;
		txtF.condenseWhite = true;
		txtF.htmlText = txtStr;

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