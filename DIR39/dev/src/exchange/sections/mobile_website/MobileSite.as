////////////////////////////////////////////////////////////////////////////////
// Project: Orange Exchange issue 37
// FileName: MobileSite.as
// Created by: Angel 
// updated : 12 September 2013
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
// CLASS: MobileSite 
////////////////////////////////////////////////////////////////////////////////
class exchange.sections.mobile_website.MobileSite extends MovieClip
{
	
	////////////////////////////////////////////////////////////////////////////
	// PROPERTIES
	////////////////////////////////////////////////////////////////////////////
	private static var instance			: MobileSite;
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
	private var roundel_mc				: MovieClip;
	private var container_mc			: MovieClip;
	private var images_mc				: MovieClip;	

	
	//positions
	private static var MENU_ON			: Number = 26;
	private static var MENU_LEFT		: Number = -250;
	private static var MENU_RIGHT		: Number = 300;
	
	private var CONTENT_OPEN			: Boolean = false;
	
	// DISPATCH
	public var addEventListener			: Function; 
	public var removeEventListener		: Function; 
	public var dispatchEvent			: Function;	
	
	//DATA
	public var menu_titles 				: Array = ["decide what you want", "create your content", "build a site", "online sales", "track your success"];

	
	////////////////////////////////////////////////////////////////////////////
	// Constructor
	////////////////////////////////////////////////////////////////////////////
	public function MobileSite()
	{		
		EventDispatcher.initialize(this);
	}
	
	public static function getInstance() : MobileSite 
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
		
		line_mc._xscale = 0;
		roundel_mc._xscale = roundel_mc._yscale = 0;
		
		iphone_menu_mc._y = 700;
	}	
	
	////////////////////////////////////////////////////////////////////////////
	// Set up iphone menu
	///////////////////////////////////////////////////////////////////////////
	private function setupmenu() : Void
	{
		for (var i : Number = 0; i < menu_titles.length; i++)
		{
			var menu_button : MovieClip = this.iphone_menu_mc.buttons_mc["mb"+i];
			var num : String = (i + 1).toString() + ".";
			menu_button.text_mc.menu_txt.text = num + " " + menu_titles[i];
			
			var mb = menu_button.onRollOver = Delegate.create(this, onMenuOver);
			mb.mc = menu_button;
			
			var mb = menu_button.onRollOut = Delegate.create(this, onMenuOut);
			mb.mc = menu_button;			
			
			var mbb = menu_button.onRelease = Delegate.create(this, onMenuClicked);
			mbb.id = i;
			mbb.mc = menu_button;
			
			menu_button._x = -300;
		}
		
		iphone_menu_mc.content_mc.close_btn.onRelease = Delegate.create(this, closeSection);
		
	}
	private function onMenuClicked():Void
	{
		var mc = arguments.caller.mc;
		var id = arguments.caller.id;
		TweenMax.to(mc.text_mc, .5, { colorTransform: { tint:0xFFFFFF, tintAmount:1 }} );
		openSection(id);
	}	
	
	private function onMenuOver():Void
	{
		var mc = arguments.caller.mc;
		TweenMax.to(mc.text_mc, .5, { colorTransform: { tint:0xFF6600, tintAmount:1 }} );
	}	
	
	private function onMenuOut():Void
	{
		var mc = arguments.caller.mc;
		TweenMax.to(mc.text_mc, .5, { colorTransform: { tint:0xFFFFFF, tintAmount:1 }} );
	}

	////////////////////////////////////////////////////////////////////////////
	// Open section selected from iphone menu
	///////////////////////////////////////////////////////////////////////////		
	private function openSection(secID : Number ) : Void
	{
		iphone_menu_mc.content_mc.gotoAndStop(secID + 1);
		TweenMax.to(iphone_menu_mc.buttons_mc, 1, { _x: MENU_LEFT, ease:Cubic.easeOut } );
		TweenMax.to(iphone_menu_mc.content_mc, 1, { _x: MENU_ON, ease:Cubic.easeOut, onComplete:contentOpened, onCompleteScope:this } );	
		Tracker.trackClick(page_name, menu_titles[secID]);
	}
	
	////////////////////////////////////////////////////////////////////////////
	// Close content section 
	///////////////////////////////////////////////////////////////////////////		
	private function closeSection( ) : Void
	{
		TweenMax.to(iphone_menu_mc.buttons_mc, 1, { _x: MENU_ON, ease:Cubic.easeOut } );
		TweenMax.to(iphone_menu_mc.content_mc, 1, { _x: MENU_RIGHT, ease:Cubic.easeOut  } );
		contentClosed();
	}
	
	////////////////////////////////////////////////////////////////////////////
	// On content section closed - disable the mouse over images
	///////////////////////////////////////////////////////////////////////////		
	private function contentClosed() : Void
	{
		CONTENT_OPEN = false;
	}
	////////////////////////////////////////////////////////////////////////////
	// On content section opened - enable the mouse over images
	///////////////////////////////////////////////////////////////////////////		
	private function contentOpened() : Void
	{
		CONTENT_OPEN = true;
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
		
		TweenMax.to(intro_phone, 1, {_x:714.4, _y:395.6, _xscale:171.5, _yscale:170.6, ease:Cubic.easeOut } );
				
		TweenMax.to(iphone_menu_mc, 0, { _y:iphone_menu_mc.init._y, _alpha:0, delay:1.5 } );
		
		TweenMax.to(intro_phone, 1.5, { _alpha:0, delay:2 } );
		TweenMax.to(iphone_menu_mc, 1.5, { _alpha:100, delay:2 } );
		
		TweenMax.delayedCall(1.5, buildMenu, [], this);
		
		TweenMax.to(text_mc0, 1, { _x:text_mc0.init._x, ease:Cubic.easeOut, delay:dtime += 1 } );
		TweenMax.to(text_mc1, 1, { _x:text_mc1.init._x, ease:Cubic.easeOut, delay:dtime += .5 } );		
		TweenMax.to(line_mc, 2, { _xscale:100, ease:Quad.easeOut, delay:dtime += .5 } );
		TweenMax.to(text_mc2, 1, { _x:text_mc2.init._x, ease:Cubic.easeOut, delay:dtime += .5 } );
		TweenMax.to(text_mc3, 1, { _x:text_mc3.init._x, ease:Cubic.easeOut, delay:dtime += .5 } );
		TweenMax.to(roundel_mc, 1, {_xscale:roundel_mc.init._xscale, _yscale:roundel_mc.init._yscale, ease:Back.easeOut, delay:dtime+=.5} );
	}
	
	////////////////////////////////////////////////////////////////////////////
	// Build show menu after intro has finished and page is building
	///////////////////////////////////////////////////////////////////////////			
	private function buildMenu(): Void
	{
		var dtime : Number = 0;
		
		for (var i : Number = 0; i < menu_titles.length; i++)
		{
			var menu_button : MovieClip = this.iphone_menu_mc.buttons_mc["mb" + i];
			
			TweenMax.to(menu_button, 1, {_x:menu_button.init._x, ease:Back.easeOut, delay:dtime+=.4} );
		}
	}
	////////////////////////////////////////////////////////////////////////////
	// Show the large screen shot image on mouse over of thumbs
	///////////////////////////////////////////////////////////////////////////			
	public function showImageSlide( asset : MovieClip ): Void
	{
		if (iphone_menu_mc.buttons_mc._x == MENU_LEFT )
		{
			deleteImageSlide();
			TweenMax.killAll();
			var nameID : String = asset._name.slice(5);
			var frameID  : Number = Number(nameID);
			images_mc = container_mc.attachMovie("image_slides", "image_mc", this.getNextHighestDepth(), { _x:35, _y:125, _alpha:0 } );
			images_mc.gotoAndStop(frameID);
			TweenMax.to(images_mc, .5, { _alpha:100, _x:35, _y:195, ease:Cubic.easeOut } );
		}
	}
	
	////////////////////////////////////////////////////////////////////////////
	// Hide the image slides on mouse out
	///////////////////////////////////////////////////////////////////////////			
	public function removeImageSlide() : Void 
	{
		(iphone_menu_mc.buttons_mc._x == MENU_LEFT ) ? TweenMax.killAll() : null;

		TweenMax.to(images_mc, .3, { _alpha:0, _x:35, _y:125, ease:Cubic.easeOut, onComplete:deleteImageSlide, onCompleteScope:this } );
	}
	
	////////////////////////////////////////////////////////////////////////////
	// Delete and remove the image slides after tweening out
	///////////////////////////////////////////////////////////////////////////		
	private function deleteImageSlide() : Void 
	{
		images_mc.removeMovieClip();
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