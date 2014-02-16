////////////////////////////////////////////////////////////////////////////////
// Project: Orange Exchange issue 39
// FileName: ImageSlideShow.as
// Created by: Angel 
// Last edit : 15 Dec 2013
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// IMPORTS
////////////////////////////////////////////////////////////////////////////////
import mx.events.EventDispatcher;
import mx.utils.Delegate;
import flash.display.BitmapData;

import com.greensock.TweenMax;
import com.greensock.easing.*;
//import com.greensock.plugins.*;

import org.casalib.load.LoadGroup;
import org.casalib.load.media.MediaLoad;
import org.casalib.load.base.LoadInterface;
import org.casalib.math.Percent;
import org.casalib.load.base.BytesLoadInterface;

////////////////////////////////////////////////////////////////////////////////
// CLASS: ImageSlideShow 
////////////////////////////////////////////////////////////////////////////////
class exchange.sections.apps.ImageSlideShow extends MovieClip
{
	////////////////////////////////////////////////////////////////////////////
	// Properties
	////////////////////////////////////////////////////////////////////////////
	public var ID						: Number = 0;
	public var appID					: String;
	public var PLAYING	 				: Boolean = true;
	public var load_directory			: String;
	public var numOfImages				: Number;
	
	public var tweenTime				: Number = 1;
	public var pauseTime				: Number = 2;
	
	private var slideshow_width			: Number;
	private var lastX					: Number;
	public var image_width				: Number;
	public var image_height				: Number;
	private var image_array				: Array;
	public var slideIsTweening			: Boolean = false;

	public var loadingGroup 			: LoadGroup;
	public var loadProgress				: String;
	public var progress_textfield		: TextField;
	
	//Assets
	public var image_mc					: MovieClip;	
	public var mask_mc					: MovieClip;
	public var container				: MovieClip;
	public var loading_progress_mc		: MovieClip;
	public var bg_mc					: MovieClip;
	
	public var controls_mc				: MovieClip;
	public var play_btn					: Button;
	public var pause_btn				: Button;
	public var previous_btn				: Button;
	public var next_btn					: Button;
	
	// Dispatch
	public var addEventListener			: Function; 
	public var removeEventListener		: Function; 
	public var dispatchEvent			: Function;

	////////////////////////////////////////////////////////////////////////////
	// Constructor
	////////////////////////////////////////////////////////////////////////////
	public function ImageSlideShow()
	{		
		EventDispatcher.initialize(this);
	}
	
	////////////////////////////////////////////////////////////////////////////
	// On Load
	///////////////////////////////////////////////////////////////////////////
	public function onLoad() : Void
	{
		resetAll();	
	}
	
	////////////////////////////////////////////////////////////////////////////
	// Destroy slideshow
	///////////////////////////////////////////////////////////////////////////	
	public function destroy(): Void
	{
		loadingGroup.destroy();
		PLAYING = false;
		TweenMax.killChildTweensOf(this, false);
		TweenMax.killDelayedCallsTo(startSlideShow);
		TweenMax.killDelayedCallsTo(moveLeft);
		emptyMC(container);
	}

	////////////////////////////////////////////////////////////////////////////
	// Reset all for slideshow
	///////////////////////////////////////////////////////////////////////////		
	public function resetAll():Void
	{
		container._x = 0;
		loading_progress_mc._alpha = 0;
		container._alpha = 0;
		controls_mc._alpha = 0;
		controls_mc._visible = false;
	}

	////////////////////////////////////////////////////////////////////////////
	// Initialise
	///////////////////////////////////////////////////////////////////////////
	public function initSlideShow(  image_path : String, total_items : Number, slide_width : Number, slide_height: Number ) : Void
	{
		resetAll();
		
		setSize(slide_width, slide_height);
		
		progress_textfield = loading_progress_mc.progress_textfield;

		load_directory = image_path;
		numOfImages = total_items;
		
		setupLoaderGroup( );
		createLoads();
		
		TweenMax.to(loading_progress_mc, .1, {_alpha:100, overwrite:true} );
		
	}
	
	////////////////////////////////////////////////////////////////////////////
	// Create the image loads
	////////////////////////////////////////////////////////////////////////////
	public function createLoads() : Void
	{
		var imgx : Number = 0;
		var imgy : Number = 0;
		
		image_array = new Array();
		
		for (var i:Number = 0; i < numOfImages; i++) 
		{
						
			var img_mc : MovieClip  = container.createEmptyMovieClip( 'image_' + i.toString(), i);
			img_mc.id = i;
			img_mc._x = imgx;
			img_mc._y = imgy;
			

			var is : String = (i+1).toString();
			var imgSRC : String = load_directory + is + ".jpg";
			
			//add image to load to queue
			var mediaLoad:MediaLoad = new MediaLoad(img_mc, imgSRC, true);
			loadingGroup.addLoad(mediaLoad);
						
			imgx = imgx + image_width;
			
			image_array[i] = img_mc;
		}
		
		startLoadingProcess();
	}
	
	////////////////////////////////////////////////////////////////////////////
	// Setup Loader
	////////////////////////////////////////////////////////////////////////////
	public function setupLoaderGroup( ) : Void
	{		 
		loadingGroup = new LoadGroup();
		loadingGroup.addEventObserver(this, LoadGroup.EVENT_LOAD_COMPLETE, "onLoadComplete");
		loadingGroup.addEventObserver(this, LoadGroup.EVENT_LOAD_PERCENT, "onGroupLoadPercent");
		loadingGroup.addEventObserver(this, LoadGroup.EVENT_LOAD_ERROR, "onGroupLoadError");
	}
	
	////////////////////////////////////////////////////////////////////////////
	// Start the Loading process
	////////////////////////////////////////////////////////////////////////////
	private function startLoadingProcess() : Void
	{
		loadingGroup.start();
	}

	////////////////////////////////////////////////////////////////////////////
	// On Group Loading event - get the amount loaded and display in textfield
	////////////////////////////////////////////////////////////////////////////	
	public function onGroupLoadPercent(sender:LoadGroup, progress:Percent):Void 
	{
		loadProgress = String( Math.ceil(progress.getPercentage()) );

		progress_textfield.text = loadProgress + " %";
		
	}
	////////////////////////////////////////////////////////////////////////////////
	// If there is an Loading error then remove the data continue and keep loading
	//////////////////////////////////////////////////////////////////////////////////
	public function onGroupLoadError(sender:LoadGroup, failedLoad:BytesLoadInterface):Void 
	{
		loadingGroup.removeLoad(failedLoad);
		loadingGroup.start();
	}
	////////////////////////////////////////////////////////////////////////////
	// On Group Load Complete - 
	////////////////////////////////////////////////////////////////////////////	
	public function	onLoadComplete(sender:LoadGroup) : Void
	{
			TweenMax.to(loading_progress_mc, 0, { _alpha:0, delay:0, overwrite:true } );
			
			( numOfImages > 1 ) ? finaliseSlideItems() : showOnlyOneImage();
	}

	////////////////////////////////////////////////////////////////////////////
	// If number of images is only 1 - just display that image 
	////////////////////////////////////////////////////////////////////////////	
	private function showOnlyOneImage():Void
	{
		image_array[0].forceSmoothing = true;
		
		TweenMax.to(container, 1, {autoAlpha:100, overwrite:false, delay:.5} );
		
	}
	
	////////////////////////////////////////////////////////////////////////////
	// Finialise slideshow items before starting
	////////////////////////////////////////////////////////////////////////////	
	private function finaliseSlideItems():Void
	{
		var lastIndex   : Number = image_array.length - 1;
		var newIndex 	: Number = image_array.length;		
		var first_image : MovieClip  = image_array[0];
		var imgx 		: Number = image_array[lastIndex]._x + image_width;
		
		var bdata : BitmapData = new BitmapData(first_image._width, first_image._height, true, 0);
		bdata.draw(first_image);
		
		var last_image : MovieClip = container.createEmptyMovieClip('image_'+newIndex, container.getNextHighestDepth());
		last_image.attachBitmap(bdata, 0);
		last_image.forceSmoothing = true;
		last_image.cacheAsBitmap = true;
		last_image._x = imgx;
		
		image_array.push(last_image);
		
		for ( var i in image_array )
		{
			image_array[i].forceSmoothing = true;
		}
		
	
		slideshow_width = container._width;
		lastX = -(slideshow_width - image_width);
		
		
		//start now
		setupSlideShowControls();
		
		TweenMax.to(container, 1, { autoAlpha:100, overwrite:false, delay:.5 } );
		TweenMax.to(controls_mc, 1, {autoAlpha:100, overwrite:false, delay:1});	
		
		( PLAYING ) ? TweenMax.delayedCall(2, startSlideShow, null, this) : null;
	}
	
	
	////////////////////////////////////////////////////////////////////////////
	// Setup the slideshow controls
	////////////////////////////////////////////////////////////////////////////
	private function setupSlideShowControls() : Void
	{		
		play_btn = controls_mc.play_btn;
		pause_btn = controls_mc.pause_btn;			
		previous_btn = controls_mc.previous_btn;				
		next_btn = controls_mc.next_btn;

		play_btn.onRelease = Delegate.create(this, playSlideShow);
		pause_btn.onRelease = Delegate.create(this, pauseSlideShow);
		previous_btn.onRelease = Delegate.create(this, slideShowGoPrevious);
		next_btn.onRelease = Delegate.create(this, slideShowGoNext);
		
		if( PLAYING ) 
		{
			play_btn._visible = false;
			pause_btn._visible = true;
		}
		else if( !PLAYING ) 
		{
			play_btn._visible = true;
			pause_btn._visible = false;
		}
		
	}
	
	////////////////////////////////////////////////////////////////////////////
	// Pause the slideshow
	////////////////////////////////////////////////////////////////////////////
	public function pauseSlideShow() : Void
	{
		PLAYING = false;
		
		TweenMax.killDelayedCallsTo(startSlideShow);
		TweenMax.killDelayedCallsTo(moveLeft);
		
		play_btn._visible = true;
		pause_btn._visible = false;
	}
	
	
	////////////////////////////////////////////////////////////////////////////
	// Pause the slideshow
	////////////////////////////////////////////////////////////////////////////
	public function playSlideShow() : Void
	{
		PLAYING = true;
		play_btn._visible = false;
		pause_btn._visible = true;
		startSlideShow();
		
	}
		
	////////////////////////////////////////////////////////////////////////////
	// get next image in the slideshow
	////////////////////////////////////////////////////////////////////////////
	private function slideShowGoNext() : Void
	{
		pauseSlideShow();
		slideIsTweening = TweenMax.isTweening(container);
		( !slideIsTweening ) ? 	goNext() : null;
		
	}
		
	////////////////////////////////////////////////////////////////////////////
	// get next image in the slideshow
	////////////////////////////////////////////////////////////////////////////
	private function slideShowGoPrevious() : Void
	{
		pauseSlideShow();
		slideIsTweening = TweenMax.isTweening(container);
		( !slideIsTweening ) ? goPrevious() : null;
	}
						
	
	
	
	////////////////////////////////////////////////////////////////////////////
	// Move the slideshow left 
	////////////////////////////////////////////////////////////////////////////	
	private function goNext() : Void
	{
		var newx : Number = container._x - image_width;
		var cw : Number =	-(container._width - image_width);
		
		if ( !PLAYING && !slideIsTweening )
		{
			if (newx >= cw)
			{
				TweenMax.to(container, tweenTime, {  _x:newx, delay:0, ease:Cubic.easeOut, overwrite:true } );	
			}
			else
			{
				container._x = 0;
				newx = container._x - image_width;
				TweenMax.to(container, tweenTime, {  _x:newx, delay:0.1, ease:Cubic.easeOut, overwrite:true } );	
			}
		}		
	}
	
	
	////////////////////////////////////////////////////////////////////////////
	// Move the slideshow right 
	////////////////////////////////////////////////////////////////////////////	
	private function goPrevious() : Void
	{
		var newx : Number = container._x + image_width;
		var cw : Number = -(container._width - image_width);
		
		if ( !PLAYING && !slideIsTweening )
		{
			if (newx <= 0)
			{
				TweenMax.to(container, tweenTime, {  _x:newx, delay:0, ease:Cubic.easeOut, overwrite:true } );	
			}
			else
			{
				container._x = cw;
				newx = container._x + image_width;
				TweenMax.to(container, tweenTime, {  _x:newx, delay:0.1, ease:Cubic.easeOut, overwrite:true } );	
			}
		}	
	}
		
	
	
	
	////////////////////////////////////////////////////////////////////////////
	// Start the slideshow
	////////////////////////////////////////////////////////////////////////////
	private function startSlideShow() : Void
	{
		( PLAYING ) ? 	TweenMax.delayedCall(pauseTime, moveLeft, null, this) : null;
	}

	
	////////////////////////////////////////////////////////////////////////////
	// Move the slideshow left 
	////////////////////////////////////////////////////////////////////////////	
	private function moveLeft() : Void
	{
		var newx : Number = container._x - image_width;
		TweenMax.to(container, tweenTime, {  _x:newx, delay:0, ease:Cubic.easeOut, overwrite:true, onComplete: moveComplete, onCompleteScope:this } );	
	}
	////////////////////////////////////////////////////////////////////////////
	// On Move Left complete
	////////////////////////////////////////////////////////////////////////////		
	private function moveComplete() : Void
	{
		var newx : Number = container._x - image_width;
		var cw : Number =	-(container._width - image_width);
		
		if ( PLAYING )
		{
			if (newx >= cw)
			{
				startSlideShow();
			}
			else
			{
				TweenMax.to(container, 0, {  _x:0, delay:pauseTime, overwrite:true, onComplete:moveLeft, onCompleteScope:this } );	
			}
		}
	}
	
	////////////////////////////////////////////////////////////////////////////
	// Set a different size for the slideshow 
	///////////////////////////////////////////////////////////////////////////	
	public function setSize( slide_width : Number, slide_height: Number ):Void
	{
		image_width = slide_width;
		image_height = slide_height
		
		mask_mc._width = image_width;
		mask_mc._height = image_height;
		bg_mc._width = image_width;
		bg_mc._height = image_height;
		
		loading_progress_mc._x = Math.ceil( image_width / 2 - loading_progress_mc._width / 2 );
		loading_progress_mc._y = Math.ceil( image_height / 2 - loading_progress_mc._height / 2 ) - 20;
	}

	
	public function positionControls( px : Number, py : Number ):Void
	{
		controls_mc._x = px;
		controls_mc._y = py;
	}	
	
	public function tintControls( _col : Number, _amount : Number ):Void
	{
		TweenMax.to(controls_mc, 1, { colorTransform: { tint:_col, tintAmount:_amount } } );
	}
	
	public function removeTint( ):Void
	{
		TweenMax.to(controls_mc, 0, { colorTransform: { tintAmount:0 } } );
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