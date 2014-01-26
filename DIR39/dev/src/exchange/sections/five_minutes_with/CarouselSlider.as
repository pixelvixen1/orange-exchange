////////////////////////////////////////////////////////////////////////////////
// Project: Orange Exchange issue 39
// FileName: CarouselSlider.as
// Created by: Angel 
// Last edit : 16 Jan 2014
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// IMPORTS
////////////////////////////////////////////////////////////////////////////////
import mx.events.EventDispatcher;
import mx.utils.Delegate;

import com.greensock.TweenMax;
import com.greensock.easing.*;
//import com.greensock.plugins.*;

////////////////////////////////////////////////////////////////////////////////
// CLASS: CarouselSlider 
////////////////////////////////////////////////////////////////////////////////
class exchange.sections.five_minutes_with.CarouselSlider extends MovieClip
{
	////////////////////////////////////////////////////////////////////////////
	// Properties
	////////////////////////////////////////////////////////////////////////////
	public var assetsLibraryName		: String = "carousel_item_";
	public var numberOfSlides			: Number = 4;
	public var indexStartNumber			: Number = 1;
	public var SLIDE_X					: Number = 60;
	public var SLIDE_Y					: Number = 8;
	
	////////////////////////
	public var ID						: Number = 0;
	public var container				: MovieClip;
	public var mask_mc					: MovieClip;
	private var mask_width				: Number;
	private var mask_height				: Number;
	private var current_slide			: MovieClip;
	private var old_slide				: MovieClip;
	
	public var next_btn					: Button;
	public var previous_btn				: Button;

	// Dispatch
	public var addEventListener			: Function; 
	public var removeEventListener		: Function; 
	public var dispatchEvent			: Function;

	////////////////////////////////////////////////////////////////////////////
	// Constructor
	////////////////////////////////////////////////////////////////////////////
	public function CarouselSlider() 
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
	// Init
	///////////////////////////////////////////////////////////////////////////	
	public function setupAssets(): Void
	{
		mask_width = mask_mc._width;
		mask_height = mask_mc._height;
		
		next_btn.onRelease = Delegate.create(this, getNextSlide);
		previous_btn.onRelease = Delegate.create(this, getPreviousSlide);
		
		TweenMax.to(next_btn, 0, { autoAlpha: 0 } );
		TweenMax.to(previous_btn, 0, { autoAlpha: 0 } );

	}
	
	
	
	////////////////////////////////////////////////////////////////////////////
	// Add slide
	///////////////////////////////////////////////////////////////////////////	
	public function showFirstSlide( ): Void
	{
		showSlideByID(indexStartNumber);
	}
	
	
	////////////////////////////////////////////////////////////////////////////
	// Get next slide
	///////////////////////////////////////////////////////////////////////////	
	private function getNextSlide( ): Void
	{
		( ID < numberOfSlides ) ? ID++ : ID = indexStartNumber;
		
		showSlideByID(ID);
	}
	
	////////////////////////////////////////////////////////////////////////////
	// Get previous slide
	///////////////////////////////////////////////////////////////////////////	
	private function getPreviousSlide( ): Void
	{
		( ID > indexStartNumber ) ? ID-- : ID = numberOfSlides;
		
		showSlideByID(ID);
	}
	
	
	////////////////////////////////////////////////////////////////////////////
	// show next slide
	///////////////////////////////////////////////////////////////////////////	
	private function showSlideByID( _id : Number ): Void
	{
		ID = _id;	
		
		deleteOldSlide();

		old_slide = current_slide;
		
		var library_asset : String = assetsLibraryName + ID.toString();
		
		current_slide = container.attachMovie(library_asset, "slide_mc", container.getNextHighestDepth(), { _x:SLIDE_X, _y:SLIDE_Y, _visible:true } );
		
		findObjects(current_slide);
		
		//position assets off stage
		current_slide.header_mc._x += mask_width;
		current_slide.text_mc._x += mask_width;
		current_slide.image_mc._x += mask_width;
		
		
		var tweenTime:Number = .5;
		var dTime:Number = 0;
		var _stepTime:Number = 0.2;
				
		var _ease  = Quint.easeOut;
		var _easeOff  = Back.easeIn;
		
		if (old_slide)
		{
			//animate old slide out
			TweenMax.to(old_slide.header_mc, tweenTime, { _x:-mask_width, delay:(dTime), ease:_easeOff } );
			TweenMax.to(old_slide.text_mc, tweenTime, { _x:-mask_width, delay:(dTime+=_stepTime), ease:_easeOff } );
			TweenMax.to(old_slide.image_mc, tweenTime, { _x:-mask_width, delay:(dTime+=_stepTime), ease:_easeOff, onComplete:deleteOldSlide, onCompleteScope:this } );
			dTime += tweenTime;
		}
		
		//animate new slide in
		TweenMax.to(current_slide.header_mc, tweenTime, { _x:current_slide.header_mc.init._x, delay:(dTime), ease:_ease } );
		TweenMax.to(current_slide.text_mc, tweenTime, { _x:current_slide.text_mc.init._x, delay:(dTime+=_stepTime), ease:_ease } );
		TweenMax.to(current_slide.image_mc, tweenTime, { _x:current_slide.image_mc.init._x, delay:(dTime+=_stepTime), ease:_ease, onComplete:slideViewComplete, onCompleteScope:this } );
		
	}
	

	
	////////////////////////////////////////////////////////////////////////////
	// Remove and delete old slide after animating out
	///////////////////////////////////////////////////////////////////////////	
	private function deleteOldSlide():Void
	{
		old_slide.removeMovieClip();
		old_slide = null;
	}
	
	////////////////////////////////////////////////////////////////////////////
	// Slide Complete
	///////////////////////////////////////////////////////////////////////////	
	private function slideViewComplete():Void
	{
		if ( next_btn._alpha == 0 )
		{
			TweenMax.to(next_btn, 1, { autoAlpha: 100 } );
			TweenMax.to(previous_btn, 1, { autoAlpha: 100 } );
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

	
	
	
	
}