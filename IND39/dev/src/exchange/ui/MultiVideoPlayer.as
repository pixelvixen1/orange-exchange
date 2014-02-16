////////////////////////////////////////////////////////////////////////////////
// Project: Orange Exchange - VIDEO PLAYER
// FileName: MultiVideoPlayer.as
// Created by: Angel 
// LAST UPDATE : 20 Feb 2013
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// IMPORTS
////////////////////////////////////////////////////////////////////////////////
import mx.events.EventDispatcher;
import mx.utils.Delegate;

import org.casalib.load.LoadGroup;
import org.casalib.load.media.video.FlvLoad;
import org.casalib.load.base.LoadInterface;
import org.casalib.math.Percent;
import org.casalib.load.base.BytesLoadInterface;

import com.greensock.TweenMax;
import com.greensock.easing.*;
//import com.greensock.plugins.*;

////////////////////////////////////////////////////////////////////////////////
// CLASS: MultiVideoPlayer 
////////////////////////////////////////////////////////////////////////////////
class exchange.ui.MultiVideoPlayer extends MovieClip
{
	////////////////////////////////////////////////////////////////////////////
	// Properties
	////////////////////////////////////////////////////////////////////////////
	private static var instance			: MultiVideoPlayer;
	
	public var videoURL 				: String;
	public var autoplay  				: Boolean = false;
	public var startTime				: Number = 0;
	
	public var videoPlayedOnce			: Boolean = false;
	
	private var flvLoad					: FlvLoad;
	private var nc						: NetConnection;
	private var ns						: NetStream;
	private var so						: Sound;
	public var theVideo					: Video;
	public var vSound					: MovieClip;
	
	public var perecent_loaded 			: Number;
	public var amountLoaded				: Number;
	public var videoHasLoaded 			: Boolean = false;
	public var duration					: Number = 1;
	
	private var loadBar_width 			: Number = 100;
	
	private var soundON		 			: Boolean = true;
	
	
	//ASSETS
	public var playButton				: Button;
	public var pauseButton				: Button;
	public var muteon					: Button;
	public var muteoff					: Button;
	
	public var loader					: MovieClip;
	public var loadbar					: MovieClip;
	public var scrub					: MovieClip;
		

	// Dispatch
	public var addEventListener			: Function; 
	public var removeEventListener		: Function; 
	public var dispatchEvent			: Function;

	////////////////////////////////////////////////////////////////////////////
	// Constructor
	////////////////////////////////////////////////////////////////////////////
	public function MultiVideoPlayer()
	{		
		EventDispatcher.initialize(this);
	}

	////////////////////////////////////////////////////////////////////////////
	// Return singleton instance of MultiVideoPlayer
	///////////////////////////////////////////////////////////////////////////	
	public static function getInstance() : MultiVideoPlayer 
	{
		if (instance == null)
		{
			instance = new MultiVideoPlayer();
		}
		return instance;
	}
	
	////////////////////////////////////////////////////////////////////////////
	// On Load
	///////////////////////////////////////////////////////////////////////////
	public function onLoad() : Void
	{
		instance = this;
		
		loadbar = this.loader.loadbar;
		scrub = this.loader.scrub;
		loadBar_width = loadbar._width;
		
		setControls( );
		
		muteon._visible = false;
		muteoff._visible = true;
	}
	
	
	
	////////////////////////////////////////////////////////////////////////////
	// Set video url and play or pause
	///////////////////////////////////////////////////////////////////////////
	public function setAndPlayVideo( vid_url : String, _autoplay : Boolean ) : Void
	{
		destroyVideo( );
		
		videoURL = vid_url;
		autoplay = _autoplay;
		
		
		flvLoad = new FlvLoad(theVideo, videoURL, true);
		theVideo.smoothing = true;
		flvLoad.addEventObserver(this, FlvLoad.EVENT_BUFFER_PROGRESS);
		flvLoad.addEventObserver(this, FlvLoad.EVENT_BUFFER_COMPLETE);
		flvLoad.addEventObserver(this, FlvLoad.EVENT_META_DATA);
		flvLoad.addEventObserver(this, FlvLoad.EVENT_STATUS);
		flvLoad.start();
		
		this.onEnterFrame = getVidTime;
		
	}	
	
	
		
	public function getVidTime():Void
	{
		
		//trace('ns time = '+ns.time);
		loader.scrub._x = ns.time / duration * loadBar_width;
		loader.loadbar._xscale = perecent_loaded;
	}
	

	private function onBufferProgress(sender:FlvLoad, percentBuffered:Percent, secondsTillBuffered:Number):Void 
	{
	   //loadingText.text =  (Math.round(percentBuffered.getPercentage()) +"%");
	   perecent_loaded = Math.round(percentBuffered.getPercentage());
	   
	   trace(Math.round(percentBuffered.getPercentage()) +"%");
	   
	   
	   
	   amountLoaded = perecent_loaded / 100;
	   //loader.loadbar._xscale = perecent_loaded;
	   //loader.scrub._x = ns.time / duration * loadBar_width;
	   

		
		if ( !videoPlayedOnce)
		{
			trace('videoPlayedOnce = '+videoPlayedOnce);
			if (perecent_loaded >= 10 ) 
			{
				trace('perecent_loaded >= 10');
				if (autoplay)
				{
					videoPlayedOnce = true;
					//flvLoad.removeEventObserver(this, FlvLoad.EVENT_BUFFER_PROGRESS);
					trace('Autoplay video @ '+perecent_loaded);
					ns =  flvLoad.getNetStream();
					//flvLoad.getNetStream().seek(0);
					setSoundControl( );
					playVideo();
				}
			}
		}
	   
	   
	}

	private function onBufferComplete(sender:FlvLoad):Void 
	{

		   videoHasLoaded = true;
		   trace('---video loaded----');
		   if (!autoplay)
		   {
			    ns =  flvLoad.getNetStream();
				trace('**onBufferComplete pause as autoplay false :  '+autoplay);
		 
				//flvLoad.getNetStream().seek(0);
				flvLoad.getNetStream().pause(true);
				
				setSoundControl( );
				pauseVideo();
		   }
			
		   //perecent_loaded = 0;
		  
	}

	
	

	
	////////////////////////////////////////////////////////////////////////////
	// Set video sound
	///////////////////////////////////////////////////////////////////////////
	private function setSoundControl( ) : Void
	{
		vSound.removeMovieClip();
		vSound = this.createEmptyMovieClip("vSound", this.getNextHighestDepth());
		vSound.attachAudio(ns);
		so = new Sound(vSound);
		checkSound();
		
		
	}

	////////////////////////////////////////////////////////////////////////////
	// destroy
	///////////////////////////////////////////////////////////////////////////
	public function destroyVideo( ) : Void
	{
		this.onEnterFrame = null;
		ns.close();
		flvLoad.destroy();
		vSound.removeMovieClip();
		videoHasLoaded = false;
		videoPlayedOnce = false;
	}
	
	
	////////////////////////////////////////////////////////////////////////////
	// Set vvideo controls
	///////////////////////////////////////////////////////////////////////////
	private function setControls( ) : Void
	{
		playButton.onRelease = Delegate.create(this, playVideo);
		pauseButton.onRelease = Delegate.create(this, pauseVideo);
		muteon.onRelease = Delegate.create(this, unMuteVideo);
		muteoff.onRelease = Delegate.create(this, muteVideo);
		
		loader.scrub.onPress = Delegate.create(this, scrubOnPress);
		loader.scrub.onRelease = Delegate.create(this, scrubOnRelease);
		loader.scrub.onReleaseOutside = Delegate.create(this, scrubOnRelease);
	}
		
	
	
	////////////////////////////////////////////////////////////////////////////
	// Play video
	///////////////////////////////////////////////////////////////////////////
	public function playVideo() : Void
	{
		ns.pause(false);
		playButton._visible = false;
		pauseButton._visible = true;
	}
	
	
	////////////////////////////////////////////////////////////////////////////
	// Pause video
	///////////////////////////////////////////////////////////////////////////
	public function pauseVideo() : Void
	{
		ns.pause(true);
		playButton._visible = true;
		pauseButton._visible = false;
	}
		
	////////////////////////////////////////////////////////////////////////////
	// rewind video
	///////////////////////////////////////////////////////////////////////////
	public function rewindVideo() : Void
	{
		ns.play(videoURL);
		ns.seek(0);
		pauseVideo();
	}
	
	
	////////////////////////////////////////////////////////////////////////////
	// close video
	///////////////////////////////////////////////////////////////////////////
	public function closeVideo() : Void
	{
		pauseVideo();
		ns.close();
	}
		
	////////////////////////////////////////////////////////////////////////////
	// Mute the video sound
	///////////////////////////////////////////////////////////////////////////
	public function muteVideo() : Void
	{
		so.setVolume(0);
		muteon._visible = true;
		muteoff._visible = false;
		soundON = false;
	}

	
	////////////////////////////////////////////////////////////////////////////
	// Unmute the video sound
	///////////////////////////////////////////////////////////////////////////
	public function unMuteVideo() : Void
	{
		so.setVolume(100);
		muteon._visible = false;
		muteoff._visible = true;
		soundON = true;
	}	
	
	
	private function checkSound():Void
	{
		(soundON) ? unMuteVideo() : muteVideo();
		
	}
	

	
	////////////////////////////////////////////////////////////////////////////
	// On scrub pressed, allow to drag and set video position
	///////////////////////////////////////////////////////////////////////////
	public function scrubOnPress() : Void
	{
		this.onEnterFrame = null;
		this.onEnterFrame = Delegate.create(this, scrubit);
		scrub.startDrag(false,0,scrub._y,loadBar_width,scrub._y);
	}	

	////////////////////////////////////////////////////////////////////////////
	// Stop scrub drag
	///////////////////////////////////////////////////////////////////////////
	public function scrubOnRelease() : Void
	{
		this.onEnterFrame = null;
		scrub.stopDrag();
		this.onEnterFrame = Delegate.create(this, getVidTime);
	}	
	
	////////////////////////////////////////////////////////////////////////////
	// Seek video position according to scrub position
	///////////////////////////////////////////////////////////////////////////
	public function scrubit() : Void
	{
		ns.seek(Math.floor((loader.scrub._x/loadBar_width)*duration));
	}	

	
	////////////////////////////////////////////////////////////////////////////
	// Get the loading / play status of the video
	///////////////////////////////////////////////////////////////////////////
	public function videoStatus() : Void
	{
		//amountLoaded = ns.bytesLoaded / ns.bytesTotal;
		//loader.loadbar._width = amountLoaded * loadBar_width;
		//loader.scrub._x = ns.time / duration * loadBar_width;
	}	
		
	
	
	////////////////////////////////////////////////////////////////////////////
	// On Meta Data
	///////////////////////////////////////////////////////////////////////////
	public function onMetaData(sender:FlvLoad, infoObject:Object) : Void
	{
		duration = infoObject.duration;
		
		for (var propName:String in infoObject)
		{
			//trace(propName + " = " + infoObject[propName]);
		}
	}		
	
	
	
	////////////////////////////////////////////////////////////////////////////
	// On NetStatus
	///////////////////////////////////////////////////////////////////////////
	public function onStatus( sender:FlvLoad, infoObject : Object) : Void
	{
		   for (var prop in infoObject) 
		   {
				//trace("\t"+prop+":\t"+infoObject[prop]);
			   
			}
			//trace("");
		   
		   
		   switch(infoObject.code)
		   {
			   case "NetStream.Play.Stop" :
			   trace('end vid ');
					rewindVideo();
					break;
			  default:
			 
			   
		   }   		

	}	
	
	
	
	
	
}