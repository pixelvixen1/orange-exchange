////////////////////////////////////////////////////////////////////////////////
// Project: Orange Exchange issue 36
// FileName: DevicesSection.as
// Created by: Angel 
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// IMPORTS
////////////////////////////////////////////////////////////////////////////////
import exchange.sections.devices.Carousel;
import mx.events.EventDispatcher;
import mx.utils.Delegate;

import exchange.data.StructureXML;
import exchange.data.XMLDeserializer;
import exchange.model.Model;

import com.greensock.TweenMax;
import com.greensock.easing.*;
////////////////////////////////////////////////////////////////////////////////
// CLASS: DevicesSection 
////////////////////////////////////////////////////////////////////////////////
class exchange.sections.devices.DevicesSection extends MovieClip
{
	////////////////////////////////////////////////////////////////////////////
	// Properties
	////////////////////////////////////////////////////////////////////////////
	private static var instance			: DevicesSection;
	public var _Model					: Model;
	public var page_name 				: String;  		//this is set onstage
	
	//XML
	public var xmlLocation				: String; 		 //this is set onstage
	public var structureXML				: StructureXML;
	public var xmlRootNode				: XMLNode;
	public var xmlObj					: Object;
	
	//DATA
	public var items					: Array;
	public var numOfItems 				: Number;
	public var settingsVO				: Object;

	//PROPERTIES
	public var CLONE_MC_X				: Number = 640;
	public var CLONE_MC_Y				: Number = 19;	
	
	//Conditions
	public var clonePhoneOpen			: Boolean = false;
	public var CLONE_PHONE_ACTIVE 		: Boolean = false;
	
	//Assets
	public var header_mc 				: MovieClip;
	public var sub_header_mc 			: MovieClip;
	public var bg_details				: MovieClip;
	public var clone_phone_button		: MovieClip;
	public var clone_mc					: MovieClip;
	public var carousel_mc				: Carousel;
	
	// Dispatch
	public var addEventListener			: Function; 
	public var removeEventListener		: Function; 
	public var dispatchEvent			: Function;
	////////////////////////////////////////////////////////////////////////////
	// Constructor
	////////////////////////////////////////////////////////////////////////////
	public function DevicesSection()
	{		
		EventDispatcher.initialize(this);
	}
	
	public static function getInstance() : DevicesSection 
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
		loadXMLData();
		bg_details._alpha = 0;
		header_mc._alpha = 0;
		sub_header_mc._alpha = 0;
		clone_phone_button._alpha = 0;
		clone_phone_button._visible = false;
	}
	
		
	////////////////////////////////////////////////////////////////////////////
	// Load XML Data
	////////////////////////////////////////////////////////////////////////////
	private function loadXMLData() : Void
	{
		structureXML = new StructureXML();
		structureXML.addEventListener("structureXMLLoaded", this);
		structureXML.loadXMLfile( xmlLocation );
	}

	////////////////////////////////////////////////////////////////////////////
	// Store XML Data when xml loaded
	///////////////////////////////////////////////////////////////////////////	
	private function structureXMLLoaded() : Void
	{
		var userXML : XML = structureXML.XMLDoc;
		xmlRootNode = userXML;
		xmlObj = XMLDeserializer.getDeserialisedXML( userXML );
		
		structureSettings();
		structureData();
		setupAssets();
	}
	
	////////////////////////////////////////////////////////////////////////////
	// Structure settings
	////////////////////////////////////////////////////////////////////////////
	private function structureSettings( ) : Void
	{		
		settingsVO =  xmlObj.settings;
	}
	
	
	////////////////////////////////////////////////////////////////////////////
	// Structure data
	////////////////////////////////////////////////////////////////////////////
	private function structureData( ) : Void
	{		
		items = new Array();
		numOfItems = xmlObj.thumbs.thumb.length;
		
		for (var i : Number = 0; i < numOfItems; i++) 
		{
			var node_data:Object = new Object();
			node_data.xmlObj = XML(xmlObj.thumbs.thumb[i]);
			items[i] = xmlObj.thumbs.thumb[i];	
		}
		
	}
	
	////////////////////////////////////////////////////////////////////////////
	// Set up stage assets 
	///////////////////////////////////////////////////////////////////////////
	private function setupAssets() : Void
	{
		formatHeaders();
		setupClonePhone();
		initCarousel();
	}
	
	////////////////////////////////////////////////////////////////////////////
	// Format Headers
	///////////////////////////////////////////////////////////////////////////
	private function formatHeaders() : Void
	{
		var ht : String = xmlObj.extras.header_text;
		var sht : String = xmlObj.extras.sub_header_text;		
		formatText(header_mc.txt, ht, false, 480, true);
		formatText(sub_header_mc.txt, sht, true, 450, true);
	}	

	////////////////////////////////////////////////////////////////////////////
	// Inialise the Carousel
	///////////////////////////////////////////////////////////////////////////
	private function initCarousel() : Void
	{
		carousel_mc.initCarousel(page_name, settingsVO, items );
		carousel_mc.addEventListener("carouselFullyLoaded", this);
		carousel_mc.addEventListener("contentDetailsOpening", this);
	}	
	////////////////////////////////////////////////////////////////////////////
	// When Carousel items loaded show page items
	///////////////////////////////////////////////////////////////////////////	
	private function carouselFullyLoaded() : Void
	{
		showAssets();
	}
	
	////////////////////////////////////////////////////////////////////////////
	// Called when a carousel items' product detail is opening
	// hide stage assets to make room for product details
	///////////////////////////////////////////////////////////////////////////	
	private function contentDetailsOpening() : Void
	{
		TweenMax.to(header_mc, .5, { _alpha:0, overwrite:true } );
		TweenMax.to(sub_header_mc, .5, { _alpha:0, overwrite:true } );
		( CLONE_PHONE_ACTIVE ) ? TweenMax.to(clone_phone_button, .5, { autoAlpha:0, overwrite:true } ) : null;
		TweenMax.to(bg_details, 1, { _alpha:100, overwrite:true, onComplete:hideAllComplete, onCompleteScope:this } );
	}	
	private function hideAllComplete() : Void
	{

	}
	////////////////////////////////////////////////////////////////////////////
	// Called when a carousel items' product detail is closed
	// show stage assets and restore back to normal
	///////////////////////////////////////////////////////////////////////////		
	private function restoreAll() : Void
	{		
		TweenMax.to(header_mc, .6, { _alpha:100, overwrite:true } );
		TweenMax.to(sub_header_mc, .6, { _alpha:100, overwrite:true } );
		TweenMax.to(bg_details, 1, { _alpha:0, overwrite:true } );
		( CLONE_PHONE_ACTIVE ) ? TweenMax.to(clone_phone_button, .6, { autoAlpha:100, overwrite:true } ) : null;
	}	
	
	////////////////////////////////////////////////////////////////////////////
	// Show stage assets 
	///////////////////////////////////////////////////////////////////////////
	public function showAssets() : Void
	{
		TweenMax.to(header_mc, .5, { _alpha:100 } );
		TweenMax.to(sub_header_mc, .5, { _alpha:100 } );
		
		if ( CLONE_PHONE_ACTIVE ) 
		{
			clone_phone_button._visible = true;
			TweenMax.to(clone_phone_button, .5, { _alpha:100 } );
		}
	}


	////////////////////////////////////////////////////////////////////////////
	// Clone Phone Functions
	///////////////////////////////////////////////////////////////////////////	
	private function setupClonePhone():Void
	{
		CLONE_PHONE_ACTIVE = convertStringToBoolean(settingsVO.showClonePhone);
		
		if (CLONE_PHONE_ACTIVE)
		{
			clone_phone_button.btn.onRelease = Delegate.create(this, openClonePhoneInfo);
		}
	}

	private function openClonePhoneInfo():Void
	{
		if (CLONE_PHONE_ACTIVE && !clonePhoneOpen)
		{
			clone_mc = this.attachMovie('clone_phone_clip', 'clone_mc', 20, { _x:1100, _y:CLONE_MC_Y} );
			clone_mc.close_btn.onRelease = Delegate.create(this, closeClonePhoneInfo);
			TweenMax.to(clone_mc, 1, { _x:CLONE_MC_X, _y:CLONE_MC_Y, delay:0, ease:Cubic.easeOut});
			clonePhoneOpen = true;
			Tracker.trackClick(page_name, "clone_phone");
		}
	}

	private function closeClonePhoneInfo():Void
	{
		TweenMax.to(clone_mc, .5, { _x:1100, delay:0, ease:Cubic.easeOut, overwrite:true, onComplete:removeClonePhoneInfo, onCompleteScope:this});
	}

	private function removeClonePhoneInfo():Void
	{
		clone_mc.removeMovieClip();
		clonePhoneOpen = false;
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
		txtF.styleSheet = _Model.cssFile;
		txtF.condenseWhite = true;
		txtF.htmlText = txtStr;

	}	
	
	////////////////////////////////////////////////////////////////////////////
	// Convert String to Boolean function
	////////////////////////////////////////////////////////////////////////////	
	public function convertStringToBoolean( value : String ) : Boolean
	{
		switch(value) 
		{
			case "1":
			case "true":
			case "yes":
				return true;
			case "0":
			case "false":
			case "no":
				return false;
			default:
				return Boolean(value);
		}	
	}	

	////////////////////////////////////////////////////////////////////////////
	// Remove all child movieclips from a movieclip
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
	// FIND MOVIE CLIPS
	//-------------------------------------------------------------------------
	// Searches through all movieClips and sets init values. 
	// This will not add init values for buttons and other non-movieClips.
	///////////////////////////////////////////////////////////////////////////	
	public function findMovieClips(mc:MovieClip):Void 
	{
		setInitValues(mc);
		
		for (var i in mc) 
		{
			if (typeof(mc[i]) == "movieclip")
			{
				setInitValues(mc[i]);
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
	

}