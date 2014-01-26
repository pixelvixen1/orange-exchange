////////////////////////////////////////////////////////////////////////////////
// Project: Orange Exchange issue 38
// FileName: MainSection.as
// Created by: Angel 
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// IMPORTS
////////////////////////////////////////////////////////////////////////////////
import mx.events.EventDispatcher;
import mx.utils.Delegate;

import com.greensock.TweenMax;
import com.greensock.easing.*;
////////////////////////////////////////////////////////////////////////////////
// CLASS: MainSection 
////////////////////////////////////////////////////////////////////////////////
class exchange.sections.data_devices.MainSection extends MovieClip
{
	////////////////////////////////////////////////////////////////////////////
	// Properties
	////////////////////////////////////////////////////////////////////////////
	private static var instance			: MainSection;
	public var page_name 				: String = 'data_devices';
	
	//DATA
	public var items					: Array;
	public var numOfItems 				: Number;
	
	//Assets
	public var phone_mc1 				: MovieClip;
	public var phone_mc2 				: MovieClip;
	public var title_mc1				: MovieClip;
	public var title_mc2 				: MovieClip;
	public var selected_item 			: MovieClip;	
	
	public var info_container 			: MovieClip;
	
	// Dispatch
	public var addEventListener			: Function; 
	public var removeEventListener		: Function; 
	public var dispatchEvent			: Function;
	////////////////////////////////////////////////////////////////////////////
	// Constructor
	////////////////////////////////////////////////////////////////////////////
	public function MainSection()
	{		
		EventDispatcher.initialize(this);
	}
	
	public static function getInstance() : MainSection 
	{
		return instance;
	}
	
	
	////////////////////////////////////////////////////////////////////////////
	// On Load
	///////////////////////////////////////////////////////////////////////////
	public function onLoad() : Void
	{
		instance = this;
	    setupAssets();
	}
	
	
	////////////////////////////////////////////////////////////////////////////
	// Save data 
	////////////////////////////////////////////////////////////////////////////
	public function initData( _items_data : Array ) : Void
	{		
		items = _items_data;
		phone_mc1.dataObj = items[0];
		phone_mc2.dataObj = items[1];
	}
	
	
	private function setupAssets() : Void
	{
		phone_mc1.onRelease = Delegate.create(this, openDetailsOne);
		//phone_mc2.onRelease = Delegate.create(this, openDetailsTwo);
	}
	
	
	////////////////////////////////////////////////////////////////////////////
	// Open details for phone 1
	////////////////////////////////////////////////////////////////////////////	
	private function openDetailsOne():Void
	{
		TweenMax.to(phone_mc2, .5, { autoAlpha:0 } );
		TweenMax.to(title_mc2, .5, { autoAlpha:0 } );
		TweenMax.to(title_mc1, .5, { autoAlpha:0 } );
		
		TweenMax.to(phone_mc1, 1, { _xscale:100, _yscale:100, ease:Back.easeOut } );
		
		selected_item = phone_mc1;
		
		createContentDetails();
		
		dispatchEvent( { type:"contentDetailsOpening" } );
	}
	
	
	
	
	
	////////////////////////////////////////////////////////////////////////////////
	// Check which type of Details to create and inialise content
	////////////////////////////////////////////////////////////////////////////////
	public function createContentDetails():Void
	{
		//Tracker.trackClick(page_name, selected_item.dataObj.trackingURL);
		
		trace(selected_item.dataObj.imageURL);
		
		
		var screenType : Number = Number(selected_item.dataObj.screenType);
		
		//info_container.addEventListener('closeDetail', this);
		info_container.initContentDetails(screenType, selected_item, selected_item.dataObj);

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