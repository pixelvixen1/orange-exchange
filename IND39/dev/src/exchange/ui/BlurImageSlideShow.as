////////////////////////////////////////////////////////////////////////////////
// Project: Orange Exchange issue 36
// FileName: BlurImageSlideShow.as
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
// CLASS: BlurImageSlideShow 
////////////////////////////////////////////////////////////////////////////////
class exchange.ui.BlurImageSlideShow extends MovieClip
{
	////////////////////////////////////////////////////////////////////////////
	// Properties
	////////////////////////////////////////////////////////////////////////////
	public var ID						: Number = 0;
	public var text_array				: Array;
	public var image_array				: Array;
	public var numOfImages				: Number;
	
	public var tweenTime				: Number = 1;
	public var pauseTime				: Number = 2;
	
	private var stoppedState			: String;
	private var offLeft					: Number;
	private var offRight				: Number;

	//Assets
	public var image_mc					: MovieClip;	
	public var image_mask				: MovieClip;
	public var text_mask				: MovieClip;
	public var label_mc					: MovieClip;
	public var label_txt				: TextField;

	// Dispatch
	public var addEventListener			: Function; 
	public var removeEventListener		: Function; 
	public var dispatchEvent			: Function;

	////////////////////////////////////////////////////////////////////////////
	// Constructor
	////////////////////////////////////////////////////////////////////////////
	public function BlurImageSlideShow()
	{		
		EventDispatcher.initialize(this);
	}
	
	////////////////////////////////////////////////////////////////////////////
	// On Load
	///////////////////////////////////////////////////////////////////////////
	public function onLoad() : Void
	{
		setupAssets();
	}
	

	////////////////////////////////////////////////////////////////////////////
	// Setup assets
	///////////////////////////////////////////////////////////////////////////		
	public function setupAssets():Void
	{
		findObjects(this);
		
		image_mask.cacheAsBitmap = true;
		text_mask.cacheAsBitmap = true;		
		
		label_mc.cacheAsBitmap = true;
		image_mc.cacheAsBitmap = true;

		label_mc.setMask(text_mask);
		image_mc.setMask(image_mask);
		
		offLeft = Math.round(image_mask._x - image_mask._width - 200);
		offRight = Math.round(image_mask._x + image_mask._width + 300);
		
		label_mc._x = offRight;
		label_txt = label_mc.label_txt;
		
		setImages();	
	}

	////////////////////////////////////////////////////////////////////////////
	// Set text array
	///////////////////////////////////////////////////////////////////////////
	public function setTextArray( __text_array : Array ) : Void
	{
		text_array = __text_array;
		setText();
	}
	
	////////////////////////////////////////////////////////////////////////////
	// set text
	///////////////////////////////////////////////////////////////////////////
	public function setText(  ) : Void
	{
		label_txt = label_mc.label_txt;
		label_txt.htmlText = text_array[ID];
	}

	
	////////////////////////////////////////////////////////////////////////////
	// Start the slide show
	///////////////////////////////////////////////////////////////////////////
	public function start(  ) : Void
	{
		var mc : MovieClip = image_array[ID];
		showImage(mc);
	}	

	
	////////////////////////////////////////////////////////////////////////////
	// stop show
	///////////////////////////////////////////////////////////////////////////
	public function stopShow( ) : Void
	{	
		TweenMax.killDelayedCallsTo(showNextImage);
		TweenMax.killDelayedCallsTo(hideImage);
	}
		
	////////////////////////////////////////////////////////////////////////////
	// Restart the show
	///////////////////////////////////////////////////////////////////////////		
	public function startShow( ) : Void
	{	
		var mc : MovieClip = image_array[ID];
		
		if (stoppedState == 'onShow')
		{
			TweenMax.delayedCall(pauseTime, hideImage, [mc], this);
		}
		else if (stoppedState == 'onHide')
		{
			TweenMax.delayedCall(pauseTime, showNextImage, [0], this);
		}

	}
	
	////////////////////////////////////////////////////////////////////////////
	// Set Image from on stage assets in image_mc
	////////////////////////////////////////////////////////////////////////////
	public function setImages() : Void
	{
		image_array = new Array();

		for (var i in image_mc) 
		{
			if (typeof(image_mc[i]) == "movieclip")
			{
				var mc : MovieClip = image_mc[i];
				setInitValues(mc);
				hideImageClip(mc);
				image_array.push(mc);
			}
		}
		
		numOfImages = image_array.length;
		image_array.reverse();
	
	}

	
	
/*	
	////////////////////////////////////////////////////////////////////////////
	// Hide image initial state
	///////////////////////////////////////////////////////////////////////////
	private function hideImageClip( mc : MovieClip  ) : Void
	{	
		TweenMax.to(mc, 0, {  _x:offRight } );
	}
	
	////////////////////////////////////////////////////////////////////////////
	// Show Image
	///////////////////////////////////////////////////////////////////////////
	private function showImage(  mc : MovieClip  ) : Void
	{	
		var dtime : Number = 0;
		
		//set
		TweenMax.to(mc, 0, { blurFilter: { blurX:80, blurY:80 },  _x:offRight } );
		TweenMax.to(label_mc, 0, {  _x:offRight,  delay:0 } );
		
		//show
		TweenMax.to(mc, .5, {   _x:mc.init._x, delay:dtime+=.1  } );
		TweenMax.to(mc, .5, { blurFilter: { blurX:0, blurY:0 }, delay:dtime += .5 } );
		
		TweenMax.to(label_mc, 1, {  _x:label_mc.init._x,  delay:dtime  } );
		
		//next
		TweenMax.delayedCall(pauseTime + 2, hideImage, [mc], this);
		
		stoppedState = 'onShow';
	}

	////////////////////////////////////////////////////////////////////////////
	// hide Image
	///////////////////////////////////////////////////////////////////////////
	private function hideImage(  mc : MovieClip  ) : Void
	{	
		var dtime : Number = 0;
		
		//hide
		TweenMax.to(label_mc, 1, {  _x:offLeft,  delay:dtime } );
		TweenMax.to(mc, .5, { blurFilter:{blurX:80, blurY:80 }, delay:dtime } );
		TweenMax.to(mc, .5, { _x:offLeft, delay:dtime+= .2  } );
		
		//next
		TweenMax.delayedCall(dtime, showNextImage, [0], this);
		
		stoppedState = 'onHide';	
	}
	
	////////////////////////////////////////////////////////////////////////////
	// show next Image
	///////////////////////////////////////////////////////////////////////////
	private function showNextImage( dtime : Number ) : Void
	{	
		( ID < numOfImages-1 ) ? ID += 1 : ID = 0;
		var nextmc : MovieClip = image_array[ID];
		setText();
		showImage(nextmc);
	}
		
	
*/	
	
	

	
	////////////////////////////////////////////////////////////////////////////
	// Hide image
	///////////////////////////////////////////////////////////////////////////
	private function hideImageClip( mc : MovieClip  ) : Void
	{	
		TweenMax.to(mc, 0, { _xscale:0, _yscale:0 } );
		
	}	
	
	////////////////////////////////////////////////////////////////////////////
	// Show Image
	///////////////////////////////////////////////////////////////////////////
	private function showImage(  mc : MovieClip  ) : Void
	{	
		var dtime : Number = 0;
		
		//set
		TweenMax.to(mc, 0, { blurFilter: { blurX:20, blurY:20 }, _xscale:0, _yscale:0 } );
		
		//show
		TweenMax.to(mc, .5, {  _xscale:100, _yscale:100, delay:dtime+=.1  } );
		TweenMax.to(mc, .5, { blurFilter: { blurX:0, blurY:0 }, delay:dtime += .5 } );
		
		TweenMax.to(label_mc, 1, {  _x:label_mc.init._x,  delay:dtime  } );
		
		//next
		TweenMax.delayedCall(pauseTime+2, hideImage, [mc], this);
		
		stoppedState = 'onShow';

	}

	////////////////////////////////////////////////////////////////////////////
	// hide Image
	///////////////////////////////////////////////////////////////////////////
	private function hideImage(  mc : MovieClip  ) : Void
	{	
		var dtime : Number = 0;
		
		//hide
		TweenMax.to(mc, tweenTime, { blurFilter:{blurX:140, blurY:140 }, delay:dtime } );
		TweenMax.to(mc, .3, {   _xscale:0, _yscale:0, delay:dtime + .8  } );
		TweenMax.to(label_mc, .3, {  _x:offLeft,  delay:dtime } );
		
		//next
		TweenMax.delayedCall(dtime+=.2, showNextImage, [0], this);
		
		stoppedState = 'onHide';
		
	}
	
	////////////////////////////////////////////////////////////////////////////
	// show next Image
	///////////////////////////////////////////////////////////////////////////
	private function showNextImage( dtime : Number ) : Void
	{	
		//get next image
		( ID < numOfImages-1 ) ? ID += 1 : ID = 0;
		var nextmc : MovieClip = image_array[ID];
		setText();
		
		//set
		TweenMax.to(nextmc, 0, { blurFilter: { blurX:140, blurY:140 }, _xscale:0, _yscale:0, _alpha:100, delay:0 } );
		TweenMax.to(label_mc, 0, {  _x:offRight,  delay:0 } );
		
		
		//show
		TweenMax.to(nextmc, tweenTime, { _xscale:100, _yscale:100, delay:dtime+=.1 } );
		TweenMax.to(nextmc, tweenTime, { blurFilter: { blurX:0, blurY:0 }, delay:dtime += .5 } );
		TweenMax.to(label_mc, 1, {  _x:label_mc.init._x,  delay:dtime  } );
		
		//next
		TweenMax.delayedCall(dtime+tweenTime+pauseTime, hideImage, [nextmc], this);
		
		stoppedState = 'onShow';

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