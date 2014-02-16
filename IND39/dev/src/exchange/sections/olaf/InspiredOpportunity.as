////////////////////////////////////////////////////////////////////////////////
// Project: Orange Exchange issue 39 - Olaf section
// FileName: InspiredOpportunity.as
// Created by: Angel 
// updated : 22 Jan 2014
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// IMPORTS
////////////////////////////////////////////////////////////////////////////////
import mx.events.EventDispatcher;
import mx.utils.Delegate;

import com.greensock.TweenMax;
import com.greensock.easing.*;
////////////////////////////////////////////////////////////////////////////////
// CLASS: InspiredOpportunity 
////////////////////////////////////////////////////////////////////////////////
class exchange.sections.olaf.InspiredOpportunity extends MovieClip
{
	////////////////////////////////////////////////////////////////////////////
	// PROPERTIES
	////////////////////////////////////////////////////////////////////////////
	private static var instance			: InspiredOpportunity;
	public var page_name 				: String = "inspired_opportunity";
	
	//on stage assets
	private var header_mc_0				: MovieClip;
	private var header_mc_1				: MovieClip;	
	private var olaf_pic_mc				: MovieClip;
	private var image_mc				: MovieClip;	
	private var scroller_mc				: MovieClip;
	private var video_mc				: MovieClip;
	
	// DISPATCH
	public var addEventListener			: Function; 
	public var removeEventListener		: Function; 
	public var dispatchEvent			: Function;	
	////////////////////////////////////////////////////////////////////////////
	// Constructor
	////////////////////////////////////////////////////////////////////////////
	public function InspiredOpportunity()
	{		
		EventDispatcher.initialize(this);
	}
	
	public static function getInstance() : InspiredOpportunity 
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
	}

	////////////////////////////////////////////////////////////////////////////
	// Hide on stage assets
	///////////////////////////////////////////////////////////////////////////
	public function hideAssets() : Void
	{
		header_mc_0._x = Stage.width + 10;
		header_mc_1._x = Stage.width + 10;

		TweenMax.to(olaf_pic_mc, 0, { autoAlpha:0, _x:-300});
		TweenMax.to(scroller_mc, 0, { autoAlpha:0});
		TweenMax.to(image_mc, 0, { autoAlpha:0});
	}	

	////////////////////////////////////////////////////////////////////////////
	// Show assets
	///////////////////////////////////////////////////////////////////////////		
	public function showAssets( ) : Void
	{
		var dtime : Number = 0;
		
		TweenMax.to(olaf_pic_mc, 1, { autoAlpha:100, _y:olaf_pic_mc.init._y, _x:olaf_pic_mc.init._x, ease:Back.easeOut, delay:dtime});
		TweenMax.to(header_mc_0, 1, {_x:header_mc_0.init._x, ease:Cubic.easeOut, delay:dtime});
		TweenMax.to(header_mc_1, 1, {_x:header_mc_1.init._x, ease:Cubic.easeOut, delay:dtime+=.5});
		
		TweenMax.to(scroller_mc, 1, { autoAlpha:100, ease:Linear.easeNone, delay:dtime+=1});
		TweenMax.to(image_mc, 1, { autoAlpha:100, ease:Linear.easeNone, delay:dtime+=.5});
		
		
	}	
	
	////////////////////////////////////////////////////////////////////////////
	// Move the video background animation left - called from video
	///////////////////////////////////////////////////////////////////////////			
	public function moveVideoLeft() : Void
	{
		TweenMax.to(video_mc, .5, {_x:-40, _y:0});
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