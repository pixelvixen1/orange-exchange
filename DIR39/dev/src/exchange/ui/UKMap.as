////////////////////////////////////////////////////////////////////////////////
// Project: Orange Exchange issue 38
// FileName: UKMap.as
// Created by: Angel 
// updated : 6 September 2013
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// IMPORTS
////////////////////////////////////////////////////////////////////////////////
import mx.events.EventDispatcher;
import mx.utils.Delegate;

import com.greensock.TweenMax;
import com.greensock.easing.*;
////////////////////////////////////////////////////////////////////////////////
// CLASS: UKMap 
////////////////////////////////////////////////////////////////////////////////
class exchange.ui.UKMap extends MovieClip
{
	
	////////////////////////////////////////////////////////////////////////////
	// PROPERTIES
	////////////////////////////////////////////////////////////////////////////
	public var outline_map_mc			: MovieClip;
	public var circles_large_mc			: MovieClip;
	public var circles_small_mc			: MovieClip;
	
	private var small_circles			: MovieClip;
	private var large_circles			: MovieClip;
	
	// DISPATCH
	public var addEventListener			: Function; 
	public var removeEventListener		: Function; 
	public var dispatchEvent			: Function;	
	////////////////////////////////////////////////////////////////////////////
	// Constructor
	////////////////////////////////////////////////////////////////////////////
	public function UKMap()
	{		
		EventDispatcher.initialize(this);
	}

	////////////////////////////////////////////////////////////////////////////
	// On Load
	///////////////////////////////////////////////////////////////////////////
	public function onLoad() : Void
	{
		initComponet();
		
	}
	
	////////////////////////////////////////////////////////////////////////////
	// Initialise
	///////////////////////////////////////////////////////////////////////////
	public function initComponet() : Void
	{
		findObjects(this);
		setupUI();
		redrawMap(circles_large_mc, large_circles);
		redrawMap(circles_small_mc, small_circles);
	}
	
	////////////////////////////////////////////////////////////////////////////
	// Show / animate map
	///////////////////////////////////////////////////////////////////////////	
	public function showMap() :  Void
	{
		TweenMax.killAll();
		buildMap(large_circles, .2);
		buildMap(small_circles, .5);
	}
	////////////////////////////////////////////////////////////////////////////
	// Reset
	///////////////////////////////////////////////////////////////////////////		
	public function reset() : Void
	{
		resetMapAssets(large_circles);
		resetMapAssets(small_circles);
	}
	

	////////////////////////////////////////////////////////////////////////////
	// Set up Map UI
	///////////////////////////////////////////////////////////////////////////			
	private function setupUI(): Void
	{
		circles_large_mc._visible = false;
		circles_small_mc._visible = false;
		large_circles = this.createEmptyMovieClip('large_circles', this.getNextHighestDepth() );
		small_circles = this.createEmptyMovieClip('small_circles', this.getNextHighestDepth() );
	}

	////////////////////////////////////////////////////////////////////////////
	// Reset Map
	///////////////////////////////////////////////////////////////////////////		
	private function resetMapAssets( mc : MovieClip  ) : Void
	{
		for (var i in mc) 
		{
			if (typeof(mc[i]) == "movieclip")
			{
				var map_asset : MovieClip = mc[i];
				TweenMax.to(map_asset, 0, {  _xscale:0, _yscale:0 } );
			}
		}
	}
	
	
	////////////////////////////////////////////////////////////////////////////
	// Redraw the Map
	///////////////////////////////////////////////////////////////////////////		
	private function redrawMap( mc : MovieClip, mc_holder : MovieClip ) : Void
	{
		var dtime : Number = 0;
		var inc : Number = 0;
		
		for (var i in mc) 
		{
			if (typeof(mc[i]) == "movieclip")
			{
				var map_asset : MovieClip = mc[i];
				var circle_mc : MovieClip = mc_holder.attachMovie("circ", "circle_mc"+inc.toString(), mc_holder.getNextHighestDepth());
				circle_mc._width = circle_mc._height = map_asset._width;
				circle_mc._x = map_asset._x + (map_asset._width / 2);
				circle_mc._y = map_asset._y + (map_asset._height / 2);
				inc++;
				
				//hide original asset
				TweenMax.to(map_asset, 0, {  _xscale:0, _yscale:0 } );
			}
		}
		
		findObjects(mc_holder);
		resetMapAssets(mc_holder);
	}	
	
	////////////////////////////////////////////////////////////////////////////
	// Build the Map
	///////////////////////////////////////////////////////////////////////////		
	private function buildMap( mc : MovieClip, dtime : Number ) : Void
	{
		for (var i in mc) 
		{
			if (typeof(mc[i]) == "movieclip")
			{
				var map_asset : MovieClip = mc[i];
				TweenMax.to(map_asset, .3, {  _xscale:map_asset.init._xscale, _yscale:map_asset.init._yscale, delay:dtime += .05, ease:Back.easeOut } );
			}
		}
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