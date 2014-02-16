////////////////////////////////////////////////////////////////////////////////
// Project: Orange Exchange - Samsung phone STYLE VIDEO PLAYER
// FileName: SamsungVideoPlayer.as
// Created by: Angel 
// LAST UPDATE : 16 September 2013
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// IMPORTS
////////////////////////////////////////////////////////////////////////////////
import mx.events.EventDispatcher;
import mx.utils.Delegate;

import com.greensock.TweenMax;
import com.greensock.easing.*;
////////////////////////////////////////////////////////////////////////////////
// CLASS: SamsungVideoPlayer 
////////////////////////////////////////////////////////////////////////////////
class exchange.ui.SamsungVideoPlayer extends MovieClip
{
	////////////////////////////////////////////////////////////////////////////
	// Properties
	////////////////////////////////////////////////////////////////////////////
	private static var instance			: SamsungVideoPlayer;
	
	public var videoURL 				: String;
	public var autoplay  				: Boolean = false;
	public var isPlaying  				: Boolean = false;	
	public var FULLSCREEN 				: Boolean = false;
	
	private var nc						: NetConnection;
	private var ns						: NetStream;
	private var so						: Sound;
	
	public var video_over_button		: MovieClip;
	public var video_controls_mc		: MovieClip;
	public var playButton				: Button;
	public var pauseButton				: Button;
	public var muteon					: Button;
	public var muteoff					: Button;	
	public var close_btn				: Button;	
	public var fs_btn					: Button;	
	public var cfs_btn					: Button;
	
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
	
	private var controls_off_y			: Number = 300;	
	private var controls_on_y			: Number = 207;
	
	private var pdata					: Object;	
	private var pdataFS					: Object;
	
	private var XL						: Number;
	private var XR						: Number;	
	private var YL						: Number;
	private var YR						: Number;
	
	// Dispatch
	public var addEventListener			: Function; 
	public var removeEventListener		: Function; 
	public var dispatchEvent			: Function;
	////////////////////////////////////////////////////////////////////////////
	// Constructor
	////////////////////////////////////////////////////////////////////////////
	public function SamsungVideoPlayer()
	{		
		EventDispatcher.initialize(this);
	}

	////////////////////////////////////////////////////////////////////////////
	// Return singleton instance of SamsungVideoPlayer
	///////////////////////////////////////////////////////////////////////////	
	public static function getInstance() : SamsungVideoPlayer 
	{
		if (instance == null)
		{
			instance = new SamsungVideoPlayer();
		}
		return instance;
	}
	
	////////////////////////////////////////////////////////////////////////////
	// On Load
	///////////////////////////////////////////////////////////////////////////
	public function onLoad() : Void
	{
		instance = this;
		
		findObjects(this);
		
		setPositions();
		
		loader = video_controls_mc.loader;
		loadbar = loader.loadbar;
		scrub = loader.scrub;
		loadBar_width = loadbar._width;
		
		playButton = video_controls_mc.playButton;
		pauseButton = video_controls_mc.pauseButton;
		muteon = video_controls_mc.muteon;	
		muteoff = video_controls_mc.muteoff;
		close_btn = video_controls_mc.close_btn;
		fs_btn = video_controls_mc.fs_btn;
		cfs_btn = video_controls_mc.cfs_btn;
		
		video_controls_mc._y = controls_off_y;
		
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
		playVideo();
			
		setSoundControl();
		
		ns.onMetaData = Delegate.create(this, onMetaData);
		ns.onStatus = Delegate.create(this, onNetStatus);
		
		this.onEnterFrame = Delegate.create(this, videoStatus);

	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Set mouse postions of hit area for the over controls animation / changes depending on full screen or normal
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////
	private function setPositions() : Void
	{
		pdata = new Object();
		pdata.xl = -50;
		pdata.xr = 500;
		pdata.yl = -10;
		pdata.yr = 265;		
		
		pdataFS = new Object();
		pdataFS.xl = -200;
		pdataFS.xr = 650;
		pdataFS.yl = -100;
		pdataFS.yr = 370;
		
		XL = pdata.xl;
		XR = pdata.xr;		
		YL = pdata.yl;
		YR = pdata.yr;
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
		
		close_btn.onRelease = Delegate.create(this, closeVideoPlayer);	
		fs_btn.onRelease = Delegate.create(this, goFullScreenVideo);
		cfs_btn.onRelease = Delegate.create(this, exitFullScreenVideo);
		cfs_btn._visible = false;
	}
	
	
	////////////////////////////////////////////////////////////////////////////
	// Close the video player
	///////////////////////////////////////////////////////////////////////////	
	private function closeVideoPlayer() : Void
	{
		if (FULLSCREEN) 
		{
			exitFullScreenVideo(); 
			TweenMax.delayedCall(.1, closeVideo, null, this);
		}
		else
		{
			closeVideo();
		}
	}
	
	////////////////////////////////////////////////////////////////////////////
	// Show the video controls
	///////////////////////////////////////////////////////////////////////////
	private function showControls() : Void
	{
		TweenMax.killChildTweensOf(video_controls_mc);
		TweenMax.to(video_controls_mc, 1, { _y:controls_on_y, ease:Cubic.easeOut } );
	}	
	////////////////////////////////////////////////////////////////////////////
	// Hide the video controls
	///////////////////////////////////////////////////////////////////////////	
	private function hideControls() : Void
	{
		TweenMax.killChildTweensOf(video_controls_mc);
		TweenMax.to(video_controls_mc, 1, { _y:controls_off_y, ease:Cubic.easeOut } );
	}	
	
	////////////////////////////////////////////////////////////////////////////
	// Go to Full Screen Video
	///////////////////////////////////////////////////////////////////////////	
	private function goFullScreenVideo() : Void
	{
		FULLSCREEN = true;
		this.gotoAndStop(2);
		controls_off_y = 400;
		controls_on_y = 322;
		
		XL = pdataFS.xl;
		XR = pdataFS.xr;		
		YL = pdataFS.yl;
		YR = pdataFS.yr;
		
		fs_btn._visible = false;
		cfs_btn._visible = true;
		
		dispatchEvent( {type:"onVideoPlayerFullScreen"} );
	}	
	
	////////////////////////////////////////////////////////////////////////////
	// Exit the Full Screen Video
	///////////////////////////////////////////////////////////////////////////	
	private function exitFullScreenVideo() : Void
	{
		FULLSCREEN = false;
		this.gotoAndStop(1);
		controls_off_y = 300;
		controls_on_y = 207;
		
		XL = pdata.xl;
		XR = pdata.xr;		
		YL = pdata.yl;
		YR = pdata.yr;
		
		fs_btn._visible = true;
		cfs_btn._visible = false;
		
		dispatchEvent( {type:"onExitFullScreen"} );
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
		dispatchEvent( {type:"closeVideoPlayer"} );
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
		var seekto : Number = loadbar._xmouse;
		
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
		
		var seekto : Number = loadbar._xmouse;
		
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
		
		//show and hide video controls depending on mouse position
		if ( this._xmouse > XL && this._xmouse < XR && this._ymouse > YL && this._ymouse < YR )
		{
			showControls();
		}
		else
		{
			hideControls();
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
					rewindVideo();
					break;
			  default:
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