////////////////////////////////////////////////////////////////////////////////
// Project: Orange Exchange - VIDEO PLAYER
// FileName: VideoPlayer.as
// Created by: Angel 
// LAST UPDATE : 11 March 2013
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
// CLASS: VideoPlayer 
////////////////////////////////////////////////////////////////////////////////
class exchange.ui.VideoPlayer extends MovieClip
{
	////////////////////////////////////////////////////////////////////////////
	// Properties
	////////////////////////////////////////////////////////////////////////////
	private static var instance			: VideoPlayer;
	
	public var PERCENT_LOADED_TO_PLAY	: Number = 2;
	
	public var videoURL 				: String;
	public var autoplay  				: Boolean = false;
	
	private var nc						: NetConnection;
	private var ns						: NetStream;
	private var so						: Sound;
	
	public var playButton				: Button;
	public var pauseButton				: Button;
	public var muteon					: Button;
	public var muteoff					: Button;
	
	public var loader					: MovieClip;
	public var loadbar					: MovieClip;
	public var scrub					: MovieClip;
		
	public var theVideo					: Video;
	public var vSound					: MovieClip;
	private var soundON		 			: Boolean = true;
	
	public var amountLoaded				: Number;
	public var duration					: Number = 1;
	private var loadBar_width 			: Number = 100;
	private var perecent_loaded : Number;

	// Dispatch
	public var addEventListener			: Function; 
	public var removeEventListener		: Function; 
	public var dispatchEvent			: Function;

	////////////////////////////////////////////////////////////////////////////
	// Constructor
	////////////////////////////////////////////////////////////////////////////
	public function VideoPlayer()
	{		
		EventDispatcher.initialize(this);
	}

	////////////////////////////////////////////////////////////////////////////
	// Return singleton instance of VideoPlayer
	///////////////////////////////////////////////////////////////////////////	
	public static function getInstance() : VideoPlayer 
	{
		if (instance == null)
		{
			instance = new VideoPlayer();
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
		
		setupNetstreamVideo();
		setControls( );
	}
	

		
	////////////////////////////////////////////////////////////////////////////
	// Set up the Netsream
	///////////////////////////////////////////////////////////////////////////
	public function setupNetstreamVideo( ) : Void
	{
		nc = new NetConnection();
		nc.connect(null);
		
		ns = new NetStream(nc);
		
		theVideo.attachVideo(ns);
		theVideo.smoothing = true;
		ns.play(videoURL);
		ns.seek(0);
		//pauseVideo();
		playVideo();
			
		//sound
		setSoundControl();
		
		//add listeners for NS events
		ns.onMetaData = Delegate.create(this, onMetaData);
		ns.onStatus = Delegate.create(this, onNetStatus);
		
		this.onEnterFrame = Delegate.create(this, videoStatus);
		
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
	// Set video url and play or pause
	///////////////////////////////////////////////////////////////////////////
	public function setAndPlayVideo( vid_url : String, _autoplay : Boolean ) : Void
	{
		destroyVideo( );
		autoplay = _autoplay;
		videoURL = vid_url;
		ns.play(videoURL);
		ns.seek(0);
		
		//pauseVideo();
		this.onEnterFrame = Delegate.create(this, videoStatus);
		//( autoplay ) ?  playVideo() : pauseVideo();
	}

	////////////////////////////////////////////////////////////////////////////
	// destroy
	///////////////////////////////////////////////////////////////////////////
	public function destroyVideo( ) : Void
	{
		this.onEnterFrame = null;
		ns.close();
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
	// Play video
	///////////////////////////////////////////////////////////////////////////
	public function playVideo() : Void
	{
		ns.pause(false);
		playButton._visible = false;
		pauseButton._visible = true;
		this.dispatchEvent({type:"playPauseVideoSelected"});
	}
	
	
	////////////////////////////////////////////////////////////////////////////
	// Pause video
	///////////////////////////////////////////////////////////////////////////
	public function pauseVideo() : Void
	{
		ns.pause(true);
		playButton._visible = true;
		pauseButton._visible = false;
		this.dispatchEvent({type:"playPauseVideoSelected"});
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
		this.onEnterFrame = Delegate.create(this, videoStatus);
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
		amountLoaded = ns.bytesLoaded / ns.bytesTotal;
		perecent_loaded = amountLoaded * 100;
		
		loader.loadbar._xscale = perecent_loaded;
		
		loader.scrub._x = ns.time / duration * loadBar_width;
		
		if (autoplay && perecent_loaded >= PERCENT_LOADED_TO_PLAY  ) 
		{
			autoplay = false;
			playVideo();
		}
	}	
		
	
	
	////////////////////////////////////////////////////////////////////////////
	// On Meta Data
	///////////////////////////////////////////////////////////////////////////
	public function onMetaData( e: Object ) : Void
	{
		duration = e.duration;
		
	}		
	
	////////////////////////////////////////////////////////////////////////////
	// On NetStatus
	///////////////////////////////////////////////////////////////////////////
	public function onNetStatus( infoObject : Object) : Void
	{
		   
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