////////////////////////////////////////////////////////////////////////////////
// Project: Orange Exchange issue 38
// FileName: Speedometer.as
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
// CLASS: Speedometer 
////////////////////////////////////////////////////////////////////////////////
class exchange.ui.Speedometer extends MovieClip
{
	
	////////////////////////////////////////////////////////////////////////////
	// PROPERTIES
	////////////////////////////////////////////////////////////////////////////
	private var mask_mc					: MovieClip;
	private var dial_handle				: MovieClip;
	
	// DISPATCH
	public var addEventListener			: Function; 
	public var removeEventListener		: Function; 
	public var dispatchEvent			: Function;	
	////////////////////////////////////////////////////////////////////////////
	// Constructor
	////////////////////////////////////////////////////////////////////////////
	public function Speedometer()
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
	private function initComponet() : Void
	{
		findObjects(this);
	}
	

	////////////////////////////////////////////////////////////////////////////
	// Play Speedometer
	///////////////////////////////////////////////////////////////////////////		
	public function playAnimation( _animationTime : Number, _delay: Number ) : Void
	{
		animateSpeedometer(_animationTime, _delay);
	}	
	
	////////////////////////////////////////////////////////////////////////////
	// Animate speedometer
	///////////////////////////////////////////////////////////////////////////			
	public function animateSpeedometer( _animationTime : Number, _delay: Number ) : Void
	{
		resetAnimation();
		TweenMax.to(mask_mc, _animationTime/4, { _rotation:285, delay:_delay, ease:Linear.easeNone } );
		TweenMax.to(dial_handle, _animationTime/4, { _rotation:14, delay:_delay, ease:Linear.easeNone } );		
		
		TweenMax.to(mask_mc, _animationTime/2, { shortRotation:{ _rotation:180 }, delay:_delay+=_animationTime/4, ease:Linear.easeNone } );
		TweenMax.to(dial_handle, _animationTime/2, { shortRotation:{ _rotation:-90 }, delay:_delay, ease:Linear.easeNone } );
		
		TweenMax.to(mask_mc, _animationTime, {  _rotation:0, delay:_delay+=_animationTime/2, ease:Bounce.easeOut } );
		TweenMax.to(dial_handle, _animationTime, {  _rotation:90, delay:_delay, ease:Bounce.easeOut } );
	}		
	
	////////////////////////////////////////////////////////////////////////////
	// Animate speedometer to a specific angle to show speed strength
	///////////////////////////////////////////////////////////////////////////			
	public function animateSpeedometerToAngle( _animationTime : Number, _delay: Number, dial_angle:Number, handle_angle:Number ) : Void
	{
		resetAnimation();
		TweenMax.to(mask_mc, _animationTime/4, { _rotation:285, delay:_delay, ease:Linear.easeNone } );
		TweenMax.to(dial_handle, _animationTime/4, { _rotation:14, delay:_delay, ease:Linear.easeNone } );		
		
		TweenMax.to(mask_mc, _animationTime/2, { shortRotation:{ _rotation:180 }, delay:_delay+=_animationTime/4, ease:Linear.easeNone } );
		TweenMax.to(dial_handle, _animationTime/2, { shortRotation:{ _rotation:-90 }, delay:_delay, ease:Linear.easeNone } );
		
		TweenMax.to(mask_mc, _animationTime, {  shortRotation:{_rotation:dial_angle}, delay:_delay+=_animationTime/2, ease:Bounce.easeOut } );
		TweenMax.to(dial_handle, _animationTime, { shortRotation:{ _rotation:handle_angle}, delay:_delay, ease:Bounce.easeOut } );
	}	
	
	
	
	////////////////////////////////////////////////////////////////////////////
	// Animate speedometer to off
	///////////////////////////////////////////////////////////////////////////			
	public function turnOffSpeedometer( _animationTime : Number, _delay: Number ) : Void
	{
		TweenMax.to(mask_mc, _animationTime, { _rotation:180, delay:_delay, ease:Linear.easeNone } );
		TweenMax.to(dial_handle, _animationTime, { _rotation:-90, delay:_delay, ease:Linear.easeNone } );		
	}	
	
	////////////////////////////////////////////////////////////////////////////
	// Reset the speedometer
	///////////////////////////////////////////////////////////////////////////		
	public function resetAnimation():Void
	{
		TweenMax.killAll();
		resetValues(mask_mc);
		resetValues(dial_handle);
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