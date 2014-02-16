////////////////////////////////////////////////////////////////////////////////
// Project: Orange Exchange - EE STYLE VIDEO PLAYER
// FileName: EEvideoPlayer.as
// Created by: Angel 
// LAST UPDATE : 28 Feb 2013
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
// CLASS: EEvideoPlayer 
////////////////////////////////////////////////////////////////////////////////
class exchange.ui.EEvideoPlayer extends MovieClip
{
	////////////////////////////////////////////////////////////////////////////
	// Properties
	////////////////////////////////////////////////////////////////////////////
	private static var instance			: EEvideoPlayer;
	
	public var videoURL 				: String;
	public var autoplay  				: Boolean = false;
	public var isPlaying  				: Boolean = false;
	
	private var nc						: NetConnection;
	private var ns						: NetStream;
	private var so						: Sound;
	
	public var playButton				: Button;
	public var pauseButton				: Button;
	public var muteon					: Button;
	public var muteoff					: Button;
	
	public var play_mc					: MovieClip;
	public var pause_mc					: MovieClip;
	public var video_over_button		: MovieClip;
	
	public var loader					: MovieClip;
	public var loadbar					: MovieClip;
	public var scrub					: MovieClip;
		
	public var theVideo					: Video;
	public var vSound					: MovieClip;
	private var soundON		 			: Boolean = true;
	
	public var amountLoaded				: Number;
	public var duration					: Number = 1;
	private var loadBar_width 			: Number = 100;
	private var perecent_loaded 		: Number;

	// Dispatch
	public var addEventListener			: Function; 
	public var removeEventListener		: Function; 
	public var dispatchEvent			: Function;

	////////////////////////////////////////////////////////////////////////////
	// Constructor
	////////////////////////////////////////////////////////////////////////////
	public function EEvideoPlayer()
	{		
		EventDispatcher.initialize(this);
	}

	////////////////////////////////////////////////////////////////////////////
	// Return singleton instance of EEvideoPlayer
	///////////////////////////////////////////////////////////////////////////	
	public static function getInstance() : EEvideoPlayer 
	{
		if (instance == null)
		{
			instance = new EEvideoPlayer();
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
		
		TweenMax.to( play_mc, 0, { autoAlpha:0, overwrite:true } );
		TweenMax.to( pause_mc, 0, { autoAlpha:0, overwrite:true } );
		
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
			
		setSoundControl();
		
		ns.onMetaData = Delegate.create(this, onMetaData);
		ns.onStatus = Delegate.create(this, onNetStatus);
		
		this.onEnterFrame = Delegate.create(this, videoStatus);
		
	}

	
	////////////////////////////////////////////////////////////////////////////
	// Set video controls
	///////////////////////////////////////////////////////////////////////////
	private function setControls( ) : Void
	{
		playButton.onRelease = Delegate.create(this, playVideo);
		pauseButton.onRelease = Delegate.create(this, pauseVideo);
		muteon.onRelease = Delegate.create(this, unMuteVideo);
		muteoff.onRelease = Delegate.create(this, muteVideo);
		
		loader.onPress = Delegate.create(this, seektoposition);
		loader.onRelease = loader.onReleaseOutside = loader.onDragOut =  Delegate.create(this, stopseek);
		
		video_over_button.onRollOver = Delegate.create(this, onVideoOver);
		video_over_button.onRollOut = Delegate.create(this, onVideoOut);
		video_over_button.onRelease = Delegate.create(this, onVideoClicked);
		
	}
			
	////////////////////////////////////////////////////////////////////////////
	// On Video over and out show play and pause text
	///////////////////////////////////////////////////////////////////////////
	private function onVideoOver( ) : Void
	{
		if (isPlaying)
		{
			TweenMax.to( play_mc, 0, { autoAlpha:0, overwrite:true } );
			TweenMax.to( pause_mc, 1, { autoAlpha:100, overwrite:true } );
		}
		else
		{
			TweenMax.to( play_mc, 1, { autoAlpha:100, overwrite:true } );
			TweenMax.to( pause_mc, 0, { autoAlpha:0, overwrite:true } );
		}
	}
			
	private function onVideoOut( ) : Void
	{
		if (isPlaying)
		{
			TweenMax.to( play_mc, 0, { autoAlpha:0, overwrite:true } );
			TweenMax.to( pause_mc, .5, { autoAlpha:0, overwrite:true } );
		}
		else
		{
			TweenMax.to( play_mc, .5, { autoAlpha:0, overwrite:true } );
			TweenMax.to( pause_mc, 0, { autoAlpha:0, overwrite:true } );
		}
	}	
	
	////////////////////////////////////////////////////////////////////////////
	// On Video clicked - pause or play
	///////////////////////////////////////////////////////////////////////////	
	private function onVideoClicked( ) : Void
	{
		if (isPlaying)
		{
			TweenMax.to( play_mc, 0, { autoAlpha:0, overwrite:true } );
			TweenMax.to( pause_mc, 0, { autoAlpha:0, overwrite:true } );
			pauseVideo();
		}
		else
		{
			TweenMax.to( play_mc, 0, { autoAlpha:0, overwrite:true } );
			TweenMax.to( pause_mc, 0, { autoAlpha:0, overwrite:true } );
			playVideo();
		}
	}	
	
	////////////////////////////////////////////////////////////////////////////
	// Set video url and play or pause
	///////////////////////////////////////////////////////////////////////////
	public function setAndPlayVideo( vid_url : String, _autoplay : Boolean ) : Void
	{
		autoplay = _autoplay;
		ns.close();
		videoURL = vid_url;
		ns.play(videoURL);
		ns.seek(0);
		
		pauseVideo();
		this.onEnterFrame = Delegate.create(this, videoStatus);
		( autoplay ) ?  playVideo() : pauseVideo();
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
		isPlaying = true;
		this.dispatchEvent( { type:"playPauseVideoSelected" } );
	}
	
	
	////////////////////////////////////////////////////////////////////////////
	// Pause video
	///////////////////////////////////////////////////////////////////////////
	public function pauseVideo() : Void
	{
		ns.pause(true);
		playButton._visible = true;
		pauseButton._visible = false;
		isPlaying = false;
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
	// Seek video position according to scrub position
	///////////////////////////////////////////////////////////////////////////
	public function scrubit() : Void
	{
		var seekto : Number = this._xmouse;
		
		loader.scrub._width = seekto;
		
		ns.seek(Math.floor((loader.scrub._width / loadBar_width) * duration));
		
	}	
	
		
	////////////////////////////////////////////////////////////////////////////
	// Seek video position according to scrub position
	///////////////////////////////////////////////////////////////////////////
	public function seektoposition() : Void
	{
		this.onEnterFrame = null;
		this.onEnterFrame = Delegate.create(this, scrubit);
		
		ns.pause(true);
		
		var seekto : Number = this._xmouse;
		
		loader.scrub._width = seekto;
		
		ns.seek(Math.floor((loader.scrub._width / loadBar_width) * duration));
	}	
	
	public function stopseek() : Void
	{
		this.onEnterFrame = null;
		this.onEnterFrame = Delegate.create(this, videoStatus);
		playVideo();
	}	

	////////////////////////////////////////////////////////////////////////////
	// Get the loading / play status of the video
	///////////////////////////////////////////////////////////////////////////
	public function videoStatus() : Void
	{
		amountLoaded = ns.bytesLoaded / ns.bytesTotal;
		perecent_loaded = amountLoaded * 100;
		
		loader.loadbar._xscale = perecent_loaded;
		
		loader.scrub._xscale = ns.time / duration * 100;
		
		if (autoplay && perecent_loaded >= 10 ) 
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