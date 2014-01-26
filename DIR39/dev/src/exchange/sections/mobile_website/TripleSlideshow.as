////////////////////////////////////////////////////////////////////////////////
// Project: Orange Exchange issue 38
// FileName: TripleSlideshow.as
// Created by: Angel 
// updated : 18 September 2013
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// IMPORTS
////////////////////////////////////////////////////////////////////////////////
import mx.events.EventDispatcher;
import mx.utils.Delegate;

import com.greensock.TweenMax;
import com.greensock.easing.*;
////////////////////////////////////////////////////////////////////////////////
// CLASS: TripleSlideshow 
////////////////////////////////////////////////////////////////////////////////
class exchange.sections.mobile_website.TripleSlideshow extends MovieClip
{
	
	////////////////////////////////////////////////////////////////////////////
	// PROPERTIES
	////////////////////////////////////////////////////////////////////////////
	private static var instance			: TripleSlideshow;
	public var page_name 				: String;
	
	public var speed					: Number = 3;
	public var delay					: Number = 0;
	private var id						: Number = 1;
	private var numOfItems				: Number = 3;
	
	//on stage assets
	private var pic						: MovieClip;
	private var oldpic					: MovieClip;
	private var pic1					: MovieClip;
	private var pic2					: MovieClip;
	private var pic3					: MovieClip;

	// DISPATCH
	public var addEventListener			: Function; 
	public var removeEventListener		: Function; 
	public var dispatchEvent			: Function;	
	////////////////////////////////////////////////////////////////////////////
	// Constructor
	////////////////////////////////////////////////////////////////////////////
	public function TripleSlideshow()
	{		
		EventDispatcher.initialize(this);
	}
	
	public static function getInstance() : TripleSlideshow 
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
		pic2._alpha = 0;
		pic3._alpha = 0;
		startSlideshow();
	}
	
	////////////////////////////////////////////////////////////////////////////
	// Start the slideshow
	///////////////////////////////////////////////////////////////////////////
	private function startSlideshow() : Void
	{
		TweenMax.delayedCall(speed, getNextImage, [], this);
	}		

	////////////////////////////////////////////////////////////////////////////
	// Get the next slide image
	///////////////////////////////////////////////////////////////////////////		
	private function getNextImage( ) : Void
	{
		oldpic = this["pic" + id];

		id++;
		(id > numOfItems) ? id = 1 : null;
		pic = this["pic" + id];
		TweenMax.to(pic, 1, { _alpha:100, onComplete:slidedone, onCompleteScope:this, delay:delay } );
	}	

	////////////////////////////////////////////////////////////////////////////
	// on slide image done
	///////////////////////////////////////////////////////////////////////////
	private function slidedone() : Void
	{
		oldpic._alpha = 0;
		oldpic.swapDepths(pic);
		startSlideshow();
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