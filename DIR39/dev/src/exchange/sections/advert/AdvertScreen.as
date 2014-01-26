﻿////////////////////////////////////////////////////////////////////////////////// Project: Orange Exchange issue 39 - DIR version// FileName: AdvertScreen.as// Created by: Angel // updated : 19 Jan 2014////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// IMPORTS////////////////////////////////////////////////////////////////////////////////import mx.events.EventDispatcher;import mx.utils.Delegate;import com.greensock.TweenMax;import com.greensock.easing.*;////////////////////////////////////////////////////////////////////////////////// CLASS: AdvertScreen ////////////////////////////////////////////////////////////////////////////////class exchange.sections.advert.AdvertScreen extends MovieClip{	////////////////////////////////////////////////////////////////////////////	// PROPERTIES	////////////////////////////////////////////////////////////////////////////	public var page_name 				: String = "Samsung_advert";	public var buynow_link 				: String = "http://shop.ee.co.uk/samsung-galaxy-note-3-group/pay-monthly/details/";		//on stage assets	private var logo_mc					: MovieClip;	private var headline_mc				: MovieClip;		private var ee_mc					: MovieClip;		private var sub_text_mc				: MovieClip;		private var galaxy_logo_mc			: MovieClip;		private var footer_mc				: MovieClip;	private var bgwhite_mc				: MovieClip;	private var sunRaysMain				: MovieClip;	private var phone_mc				: MovieClip;	private var mask_mc					: MovieClip;	private var buynow_btn				: Button;		// DISPATCH	public var addEventListener			: Function; 	public var removeEventListener		: Function; 	public var dispatchEvent			: Function;		////////////////////////////////////////////////////////////////////////////	// Constructor	////////////////////////////////////////////////////////////////////////////	public function AdvertScreen()	{				EventDispatcher.initialize(this);	}	////////////////////////////////////////////////////////////////////////////	// On Load	///////////////////////////////////////////////////////////////////////////	public function onLoad() : Void	{		initPage();	}		////////////////////////////////////////////////////////////////////////////	// Initialise	///////////////////////////////////////////////////////////////////////////	private function initPage() : Void	{		findObjects(this);		setupUI( );		hideAssets();	}		////////////////////////////////////////////////////////////////////////////	// Set up UI	///////////////////////////////////////////////////////////////////////////			private function setupUI( ) : Void	{		buynow_btn.onRelease = Delegate.create(this, getBuyNow);	}			////////////////////////////////////////////////////////////////////////////	// Get URL link for buy now button	///////////////////////////////////////////////////////////////////////////				private function getBuyNow() : Void	{		Tracker.getLink(page_name, buynow_link);	}	////////////////////////////////////////////////////////////////////////////	// Hide on stage assets	///////////////////////////////////////////////////////////////////////////	public function hideAssets() : Void	{		TweenMax.to(sunRaysMain, 0, { _alpha:0, _x:485, _y:250, _xscale:100, _yscale:100 } );				TweenMax.to(logo_mc, 0, { _alpha:0, _x:480, _y:250,  glowFilter: { color:0xffffff, alpha:1, blurX:50, blurY:50, strength:8, quality:3, knockout:true } } );				TweenMax.to(phone_mc, 0, { _alpha:0,  _xscale:90, _yscale:90 } );				TweenMax.to(headline_mc, 0, { _alpha:0 } );		TweenMax.to(ee_mc, 0, { _alpha:0 } );		TweenMax.to(sub_text_mc, 0, { _alpha:0 } );		TweenMax.to(buynow_btn, 0, { _alpha:0 } );		TweenMax.to(galaxy_logo_mc, 0, { _alpha:0 } );		TweenMax.to(footer_mc, 0, { _alpha:0 } );	}			////////////////////////////////////////////////////////////////////////////	// Show assets	///////////////////////////////////////////////////////////////////////////			public function showAssets( ) : Void	{		var dtime :  Number = 0;				//show rays and knockout logo		TweenMax.to(sunRaysMain, 1, { _alpha:100, delay:dtime} );		TweenMax.to(logo_mc, 1, { _alpha:100, delay:dtime } );				//start moving rays up		TweenMax.to(sunRaysMain, 8, { _y:sunRaysMain.iv._y, _x:sunRaysMain.iv._x, _xscale:100, _yscale:100, ease:Cubic.easeInOut, delay:dtime += 1 } );				//remove glow from logo		TweenMax.to(logo_mc, 2, { glowFilter: { color:0xffffff, alpha:1, blurX:50, blurY:50, strength:4, quality:3 }, delay:dtime += 1 } );				//fade out logo		TweenMax.to(logo_mc, 3, { _alpha:0, glowFilter:{color:0xffffff, alpha:1, blurX:0, blurY:0, strength:0, quality:3, remove:true}, delay:dtime+=3 } );				TweenMax.to(phone_mc, 3, { delay:dtime+=1, _alpha:100, _xscale:100, _yscale:100, glowFilter:{color:0xffffff, alpha:1, blurX:220, blurY:220, strength:2, quality:3} } );		TweenMax.to(phone_mc, 3, { delay:dtime+=3,  glowFilter:{color:0xffffff, alpha:1, blurX:0, blurY:0, strength:0, quality:3} } );				TweenMax.delayedCall(dtime, animateImage, [headline_mc, 'SlideFromRight'], this);				TweenMax.delayedCall(dtime += 2, mask_mc.play, [], mask_mc);				TweenMax.to(logo_mc, 0, { _alpha:0, _x:logo_mc.iv._x, _y:logo_mc.iv._y, delay:dtime } );				TweenMax.to(ee_mc, 1, { _alpha:100, delay:dtime += .5 } );		TweenMax.to(sub_text_mc, 1, { _alpha:100, delay:dtime } );		TweenMax.to(galaxy_logo_mc, 1, { _alpha:100, delay:dtime } );		TweenMax.to(footer_mc, 1, { _alpha:100, delay:dtime } );		TweenMax.to(buynow_btn, 1, { _alpha:100, delay:dtime } );		TweenMax.to(logo_mc, 2, { _alpha:100, delay:dtime+=1 } );					}			////////////////////////////////////////////////////////////////////////////	// ANIMATE IMAGE IN	////////////////////////////////////////////////////////////////////////////	private function animateImage( image_mc : MovieClip,  predefinedAnimation  : String ) : Void	{				image_mc._visible = true;		image_mc._alpha = 100;				switch( predefinedAnimation ) 		{			case 'BounceFromTop':				var imgMCTE : MCTE = new MCTE(image_mc, true, "show", "Slide", 3, 30, "Elastic", "easeOut", 40, "", "", "", "", "");				break;			case 'SlideFromLeft':				var imgMCTE : MCTE = new MCTE(image_mc, true, "show", "Slide", 1, 100, "Regular", "easeOut", 20, "", "", "", "", "");				break;			case 'SlideFromRight':				var imgMCTE : MCTE = new MCTE(image_mc, true, "show", "Slide", 2, 80, "Strong", "easeOut", 20, "", "", "", "", "");				break;			case 'Blur':				var imgMCTE : MCTE = new MCTE(image_mc, true, "show", "Blur", 0xFFFFFF, 100, "Strong", "easeOut", 40, "", "", "", "", "");				break;			case 'WavesDown':				var imgMCTE : MCTE = new MCTE(image_mc, true, "show", "Waves", 5, 10, "Regular", "easeOut", 25, "100", "", "", "", "");				break;			case 'SquareBoxes':				var imgMCTE : MCTE = new MCTE(image_mc, true, "show", "SquareScale", 4, 25, "Regular", "easeOut", 25, "", "", "", "", "");				break;			case 'ScaleBounce':				var imgMCTE : MCTE = new MCTE(image_mc, true, "transitionFrom", "Scale", 1, 20, "Bounce", "easeOut", 25, "10", "", "", "", "");				break;			case 'AlphaDown':				var imgMCTE : MCTE = new MCTE(image_mc, true, "show", "Alpha", 3, 100, "Strong", "easeNone", 40, "", "", "", "", "");				break;			case 'AlphaBars':				var imgMCTE : MCTE = new MCTE(image_mc, true, "show", "AlphaBars", 2, 25, "Regular", "easeOut", 50, "", "", "", "", "");				break;			case 'VerticalBars':				var imgMCTE : MCTE = new MCTE(image_mc, true, "show", "FlipBars", 3, 50, "Strong", "easeInOut", 20, "", "", "", "", "");				break;			case 'FlipSquare':				var imgMCTE : MCTE = new MCTE(image_mc, true, "show", "FlipSquare", 1, 100, "Strong", "easeOut", 25, "80", "", "", "", "");				break;			case 'WhiteSquares':				var imgMCTE : MCTE = new MCTE(image_mc,  true, "show", "SquareAlpha", 16, 100, "Strong", "easeOut", 1200, "20", "", "", "", "");				break;			case 'FadingSquares':				var imgMCTE : MCTE = new MCTE(image_mc,  true, "show", "SquareFade", 1, 50, "Strong", "easeNone", 30, "50", "50", "", "", "");				break;								default:				var imgMCTE : MCTE = new MCTE(image_mc, true, "show", "Slide", 3, 30, "Elastic", "easeOut", 40, "", "", "", "", "");		}	}		////////////////////////////////////////////////////////////////////////////	// REMOVE ALL CHILDREN MOVIECLIPS FROM A MOVIECLIP	///////////////////////////////////////////////////////////////////////////		public function emptyMC(mc:MovieClip):Void 	{		for (var i in mc) 		{			if (typeof(mc[i]) == "movieclip")			{				(mc[i]).removeMovieClip();			}		}	}			////////////////////////////////////////////////////////////////////////////	// sets init values if the object has an "_x" value	///////////////////////////////////////////////////////////////////////////		public function findObjects(obj:Object):Void	{		if (obj._x != undefined)		{			setInitValues(obj);		}				for (var i in obj) 		{			if (obj[i]._x != undefined || obj._name == "initValues") 			{				setInitValues(obj[i]);			}						if (typeof(obj[i]) == "movieclip")			{				findObjects(obj[i]);			}		}	}		////////////////////////////////////////////////////////////////////////////	// Sets init values of an Object - Movieclip / Button	///////////////////////////////////////////////////////////////////////////	public function setInitValues(obj:Object):Void 	{		obj.iv = new Object();		obj.iv._name = "initValues";				obj.iv._x = obj._x;		obj.iv._y = obj._y;		obj.iv._width = obj._width;		obj.iv._height = obj._height;		obj.iv._alpha = obj._alpha;		obj.iv._rotation = obj._rotation;		obj.iv._xscale = obj._xscale;		obj.iv._yscale = obj._yscale;	}		////////////////////////////////////////////////////////////////////////////	// Resets the object to its' initial values.	///////////////////////////////////////////////////////////////////////////	public function resetValues(obj:Object):Void 	{		if (obj.iv != undefined) 		{			for (var i in obj.iv) 			{				if (i != "_name") obj[i] = obj.iv[i];			}		}	}		////////////////////////////////////////////////////////////////////////////	// Set params to a selection of objects 	///////////////////////////////////////////////////////////////////////////		public function setParams(baseName:String, properties:Object):Void 	{		var mc:MovieClip;		for (var i:Number = 0; mc = this[baseName + i]; i++) 		{			for (var j:String in properties) 			{				if (typeof(properties[j]) == "string") 				{					properties[j] = mc[j] + parseFloat(properties[j]);				}				mc[j] = properties[j];			}		}	}	}