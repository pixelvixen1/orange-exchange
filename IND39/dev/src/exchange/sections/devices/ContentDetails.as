////////////////////////////////////////////////////////////////////////////////
// Project: Orange Exchange issue 36
// FileName: ContentDetails.as
// Created by: Angel 
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// IMPORTS
////////////////////////////////////////////////////////////////////////////////
import mx.events.EventDispatcher;
import mx.utils.Delegate;
import com.greensock.TweenMax;
import com.greensock.easing.*;
import exchange.model.Model;
import exchange.utils.LoadUtil;
import exchange.ui.YellowEEButton;
////////////////////////////////////////////////////////////////////////////////
// CLASS: ContentDetails 
////////////////////////////////////////////////////////////////////////////////
class exchange.sections.devices.ContentDetails extends MovieClip
{
	////////////////////////////////////////////////////////////////////////////
	// Properties
	////////////////////////////////////////////////////////////////////////////
	private static var instance		: ContentDetails;
	public var page_name 			: String;
	public var SPECS_STR 			: String = '<b>SPECIFICATIONS &#62;</b>';
	public var BACK_STR 			: String = '<b>&#60; BACK</b>';
	
	//DATA
	public var dataObj				: Object;
	public var templateID 			: Number;
	
	//Assets
	public var selected_item  	 	: MovieClip;
	public var content_holder  		: MovieClip;
	public var info_container		: MovieClip;
	public var offers_mc 			: MovieClip;
	public var offers_img 			: MovieClip;
	public var vid_button_label 	: MovieClip;
	public var full_screen_video 	: MovieClip;
	public var video_button 		: MovieClip;
	public var specs_button 		: MovieClip;
	
	//Properties
	public var clonePhoneOpen		: Boolean = false;
	public var detailsIsOpen   		: Boolean = false;
	public var opening			   	: Boolean = false;
	public var closing			   	: Boolean = false;
	public var videoPlaying		   	: Boolean = false;
	public var videoActive		   	: Boolean = false;
	
	// Dispatch
	public var addEventListener		: Function; 
	public var removeEventListener	: Function; 
	public var dispatchEvent		: Function;

	////////////////////////////////////////////////////////////////////////////
	// Constructor
	////////////////////////////////////////////////////////////////////////////
	public function ContentDetails()
	{		
		EventDispatcher.initialize(this);
	}
	
	public static function getInstance() : ContentDetails 
	{
		return instance;
	}
	

	////////////////////////////////////////////////////////////////////////////
	// On Load
	///////////////////////////////////////////////////////////////////////////
	public function onLoad() : Void
	{
		instance = this;
	}

	////////////////////////////////////////////////////////////////////////////
	// Initialise
	///////////////////////////////////////////////////////////////////////////
	public function initContentDetails( _id : Number,  __selected_item : MovieClip, _itemDataObj : Object  ) : Void
	{
		templateID = _id;
		selected_item = __selected_item;
		dataObj = _itemDataObj;
		info_container = this;
		(dataObj.main_text.video.active == "true") ? videoActive = true : videoActive = false;
		createContentDetails();
	}
	
	////////////////////////////////////////////////////////////////////////////////
	// Check which type of Details to create
	////////////////////////////////////////////////////////////////////////////////
	private function createContentDetails():Void
	{
		switch (templateID) 
		{
				case 0 : 
					createDefaultContentDetails();
				break;
				case 1: 
					createDefaultContentDetails();
				break;
				case 2: 
					createLargeDeviceContentDetails();
				break;
				case 3: 
					createSpecialContentDetails();
				break;
				default:
				createDefaultContentDetails();
				
		}

	}	
	
	////////////////////////////////////////////////////////////////////////////////
	// Create Details default - template id 0 or 1
	////////////////////////////////////////////////////////////////////////////////
	public function createDefaultContentDetails():Void
	{
		content_holder = info_container.attachMovie('contentholder', 'content_holder', info_container.getNextHighestDepth(), {_alpha:0} );

		createMainText();
		createPhoneSpec();
		createPhoneHighlights();
		createVideoButton();
		
		//close button
		content_holder.close_btn.onRelease = Delegate.create(this, closeDetail);
		
		//store default values after build of content
		findMovieClips(content_holder);
		
		//prepare to tween - hide assets
		content_holder.spec_mc._x = 1000;  //content_holder.spec_mc._x - content_holder.spec_mc._width - 100;

		//Tween and show assets/details
		TweenMax.to(content_holder, .6, { _y:0, _alpha:100, delay:0 } );
		TweenMax.to(content_holder.spec_mc, 1, {_x:content_holder.spec_mc.init._x, _alpha:100, ease:Cubic.easeOut, delay:.6, onComplete:detailsOpenComplete, onCompleteScope:this });
	}

	////////////////////////////////////////////////////////////////////////////////
	// On details open complete, set 360 function of item if present
	////////////////////////////////////////////////////////////////////////////////
	public function detailsOpenComplete():Void
	{
		selected_item.enable360RotateFunction();
	}

	////////////////////////////////////////////////////////////////////////////////
	// Create Details for large devices - template id 2
	////////////////////////////////////////////////////////////////////////////////
	public function createLargeDeviceContentDetails():Void
	{

		//slide phone to right edge of screen
		var vewItemX : Number = Math.floor( 960 -  selected_item._width / 2) - 20;
		TweenMax.to(selected_item, 1, {_x:vewItemX, _y:selected_item._y, ease:Back.easeInOut});
		
		//attach content holder
		content_holder = info_container.attachMovie('contentholder', 'content_holder', info_container.getNextHighestDepth(), {_alpha:0} );
		
		//format main text mc
		createMainText();
		createPhoneHighlights();
		createPhoneSpec();
		createSpecsButton();

		specs_button.hit_btn.onRelease = Delegate.create(this, launchLargeDeviceSpecs);	
		
		if (videoActive)
		{
			createVideoButton();
			video_button._x = Math.ceil(specs_button._x +specs_button._width + 10);
			video_button._y = specs_button._y;
		}
			
		//relayout specs
		if ( dataObj.phone_spec.x == 'auto')
		{
			content_holder.spec_mc._x = content_holder.main_text_mc._x;
		}
		if ( dataObj.phone_spec.y == 'auto')
		{
			content_holder.spec_mc._y = content_holder.main_text_mc._y;
		}
		
		//mask
		content_holder.mask_mc._x  = content_holder.spec_mc._x;
		content_holder.mask_mc._y  = content_holder.spec_mc._y;	
		
		//close button
		content_holder.close_btn.onRelease = Delegate.create(this, closeDetail);
		
		//store default values after build of content
		findMovieClips(content_holder);
		
		//prepare specs offstage to tween in
		content_holder.spec_mc._x = -500;

		//show content
		TweenMax.to(content_holder, .6, { _y:0, autoAlpha:100, delay:.5 } );
	}
	
	////////////////////////////////////////////////////////////////////////////////
	// Launch Specs for template id 2
	////////////////////////////////////////////////////////////////////////////////	
	public function launchLargeDeviceSpecs():Void
	{
		TweenMax.killTweensOf(content_holder.spec_mc);
		TweenMax.killTweensOf(content_holder.main_text_mc);
		TweenMax.killTweensOf(specs_button);
		
		var sx : Number = content_holder.spec_mc._x;
		var sy : Number = Math.ceil(content_holder.spec_mc._y + content_holder.spec_mc._height + 20);
		
		//hide main
		(videoActive) ?  TweenMax.to(video_button, 0, { autoAlpha:0, delay:0 } ) : null;
		TweenMax.to(specs_button, 0, { _x: -500,  _y:sy, autoAlpha:0, delay:0 } );
		TweenMax.to(content_holder.main_text_mc, .5, { autoAlpha:0, delay:0 } );
		TweenMax.to(content_holder.highlights_mc, .5, { autoAlpha:0, delay:0 } );
		
		//reformat specs button to a back button
		specs_button.setText(BACK_STR);
		specs_button.hit_btn.onRelease = Delegate.create(this, closeLargeDeviceSpecs);
		
		//show specs
		TweenMax.to(content_holder.spec_mc, 1, {_x:content_holder.spec_mc.init._x, autoAlpha:100, ease:Back.easeInOut, delay:.5});
		TweenMax.to(specs_button, .5, { _y:sy, _x:specs_button.init._x, ease:Cubic.easeOut, autoAlpha:100, delay:1.5 } );
		
		var tt : String = dataObj.main_text.title;
		
		Tracker.trackClick(_parent.page_name, dataObj.captionText + "/phone_spec");
		
	}
	////////////////////////////////////////////////////////////////////////////////
	// Close Specs for template id 2
	////////////////////////////////////////////////////////////////////////////////	
	public function closeLargeDeviceSpecs():Void
	{
		TweenMax.killTweensOf(content_holder.spec_mc);
		TweenMax.killTweensOf(content_holder.main_text_mc);
		TweenMax.killTweensOf(specs_button);
		
		var dTime : Number = 0;
		
		//hide
		TweenMax.to(specs_button, 0, { _x: -500,  _y:specs_button.init._y, autoAlpha:0, delay:0 } );
		(videoActive) ?  TweenMax.to(video_button, 0, { _x: -500,  _y:video_button.init._y, autoAlpha:0, delay:0 } ) : null;
		TweenMax.to(content_holder.spec_mc, 1, { _x: -500, autoAlpha:0, ease:Back.easeInOut, delay:dTime } );
		
		//reformat specs button to a back button
		specs_button.setText(SPECS_STR);
		specs_button.hit_btn.onRelease = Delegate.create(this, launchLargeDeviceSpecs);	
		
		//show
		TweenMax.to(content_holder.main_text_mc, .6, { autoAlpha:100, delay:dTime += .5 } );
		TweenMax.to(content_holder.highlights_mc, .6, { autoAlpha:100, delay:dTime } );
		(videoActive) ?  TweenMax.to(video_button, .5, { _x: video_button.init._x,  _y:video_button.init._y, autoAlpha:100, delay:dTime } ) : null;
		TweenMax.to(specs_button, .5, { _y:specs_button.init._y, _x:specs_button.init._x, ease:Cubic.easeOut, autoAlpha:100, delay:dTime+=.2 } );
		
	}	
	
	
	////////////////////////////////////////////////////////////////////////////////
	// Create Details for devices with a special offers box -template id - 3
	////////////////////////////////////////////////////////////////////////////////
	public function createSpecialContentDetails():Void
	{
		//attach content holder
		content_holder = info_container.attachMovie('contentholder', 'content_holder', info_container.getNextHighestDepth(), {_alpha:0} );
		
		//create sections
		createMainText();
		createPhoneHighlights();
		createPhoneSpec();
		createSpecialOffersMC();
		
		createSpecsButton();
		specs_button.hit_btn.onRelease = Delegate.create(this, launchLargeDeviceSpecs);	
	
		if (videoActive)
		{
			createVideoButton();
			video_button._x = Math.ceil(specs_button._x +specs_button._width + 10);
			video_button._y = specs_button._y;
		}
		
		//relayout specs
		if ( dataObj.phone_spec.x == 'auto')
		{
			content_holder.spec_mc._x = content_holder.main_text_mc._x;
		}
		if ( dataObj.phone_spec.y == 'auto')
		{
			content_holder.spec_mc._y = content_holder.main_text_mc._y;
		}
	
		//mask
		content_holder.mask_mc._x  = content_holder.spec_mc._x;
		content_holder.mask_mc._y  = content_holder.spec_mc._y;
		
		//close button
		content_holder.close_btn.onRelease = Delegate.create(this, closeDetail);
		
		//store default values after build of content
		findMovieClips(content_holder);
		
		//prepare specs offstage to tween in
		content_holder.spec_mc._x = -500;
		offers_mc._x = 1200;
		offers_mc._alpha = 100;
	}

	////////////////////////////////////////////////////////////////////////////////
	// Create Special offers mc
	////////////////////////////////////////////////////////////////////////////////
	public function createSpecialOffersMC() : Void
	{
		offers_mc  = content_holder.attachMovie("SPECIAL_OFFER_TEMPLATE", "offers_mc", content_holder.getNextHighestDepth());
		
		formatText(offers_mc.title_txt, dataObj.special_offer.title_text, true);
		formatText(offers_mc.txt, dataObj.special_offer.bodyText, true);
		formatText(offers_mc.link_btn.txt, dataObj.special_offer.button, true);
		
		//load image
		var imgURL : String = dataObj.special_offer.imgURL;
		
		if (imgURL != undefined )
		{
			var loaderU : LoadUtil = new LoadUtil();
			loaderU.loadItem(offers_mc.imageHolder, imgURL);
			loaderU.addEventListener('itemFullyLoaded', this);
		}
		
		
		//layout objects
		offers_mc.line_mc._y = Math.round(offers_mc.title_txt._y + offers_mc.title_txt.textHeight + 8);
		offers_mc.txt._y = Math.round(offers_mc.title_txt._y + offers_mc.title_txt.textHeight + 16);
		
		if (dataObj.special_offer.image.imgx != undefined && dataObj.special_offer.image.imgx != 'auto')
		{
			offers_mc.imageHolder._x = Number(dataObj.special_offer.image.imgx);
		}
		if (dataObj.special_offer.image.imgy != undefined && dataObj.special_offer.image.imgy != 'auto')
		{
			offers_mc.imageHolder._y = Number(dataObj.special_offer.image.imgy);
		}		
		if ( dataObj.special_offer.image.imgx == 'auto')
		{
			offers_mc.imageHolder._x =  offers_mc.txt._x;
		}
		if ( dataObj.special_offer.image.imgy == 'auto')
		{
			offers_mc.imageHolder._y = Math.round(offers_mc.txt._y + offers_mc.txt.textHeight + 10) ;
		}
		
	
		//Link image if link exists
		var link : String = dataObj.special_offer.link;
		( link != undefined ) ? offers_mc.link_btn.onRelease = Delegate.create(this, specialOffersClicked) : null;

		offers_mc.link_btn.onRollOver = function()
		{
			TweenMax.to(this.bg, .2, { colorTransform: { tint:0x006666, tintAmount:1, overwrite:true }} );
		}
			
		offers_mc.link_btn.onRollOut = function()
		{
			TweenMax.to(this.bg, .2, {colorTransform:{tint:0x009c9c, tintAmount:1, overwrite:true}});
		}
			
		
		//Layout Special offers mc
		if (dataObj.special_offer.x != undefined && dataObj.special_offer.x != 'auto')
		{
			offers_mc._x = Number(dataObj.special_offer.x);
		}
		if (dataObj.special_offer.y != undefined && dataObj.special_offer.y != 'auto')
		{
			offers_mc._y = Number(dataObj.special_offer.y);
		}
		if ( dataObj.special_offer.x == 'auto')
		{
			offers_mc._x =  Math.floor(selected_item._x/2 + selected_item._width/2   + selected_item._width + 60) ;
		}
		if ( dataObj.special_offer.y == 'auto')
		{
			offers_mc._y =  75;
		}
		
	}
	
	////////////////////////////////////////////////////////////////////////////////
	// Special offers item loaded
	////////////////////////////////////////////////////////////////////////////////
	public function itemFullyLoaded():Void
	{
		offers_mc.link_btn._y = Math.round(offers_mc.imageHolder._y + offers_mc.imageHolder._height + 15) ;
		offers_mc.bg._height = Math.round(offers_mc.link_btn._y + offers_mc.link_btn._height + 10) ;
		
		//show content
		TweenMax.to(content_holder, .6, { _y:0, autoAlpha:100, delay:.5 } );
		TweenMax.to(offers_mc, 1, {autoAlpha:100, _x:offers_mc.init._x, ease:Cubic.easeOut, delay:1.2, onComplete:detailsOpenComplete, onCompleteScope:this});
		
	}
	
	////////////////////////////////////////////////////////////////////////////////
	// get link when special offers button clicked
	////////////////////////////////////////////////////////////////////////////////
	public function specialOffersClicked():Void
	{
		var link : String = dataObj.special_offer.link;
		Tracker.getLink(page_name, link);
	}
	
	////////////////////////////////////////////////////////////////////////////////
	// Create the Main text Movieclip from XML
	////////////////////////////////////////////////////////////////////////////////
	public function createMainText():Void
	{
		//main text mc
		var ct : String = dataObj.main_text.title;
		var dt : String = dataObj.main_text.content;
	
		formatText(content_holder.main_text_mc.title_txt, ct, true, 310, false);
		formatText(content_holder.main_text_mc.content_txt, dt, true, 300, true);
		
		//layout
		content_holder.main_text_mc.line_mc._y = Math.round(content_holder.main_text_mc.title_txt._y +content_holder.main_text_mc.title_txt.textHeight + 10);
		content_holder.main_text_mc.content_txt._y = content_holder.main_text_mc.line_mc._y + 11;
		
		//Layout Main Content
		if (dataObj.main_text.x != undefined && dataObj.main_text.x != 'auto')
		{
			content_holder.main_text_mc._x = Number(dataObj.main_text.x);
		}
		if (dataObj.main_text.y != undefined && dataObj.main_text.y != 'auto')
		{
			content_holder.main_text_mc._y = Number(dataObj.main_text.y);
		}

	}

	////////////////////////////////////////////////////////////////////////////////
	// Create the Phone Specs Movieclip from XML
	////////////////////////////////////////////////////////////////////////////////
	public function createPhoneSpec():Void
	{
		var numOfText : Number = dataObj.phone_spec.spec.length;
		var spec_mc : MovieClip = content_holder.spec_mc;
		var cy : Number = 50;
		
		for (var i : Number = 0; i < numOfText; i++)
		{
			var txt_mc : MovieClip = spec_mc.attachMovie("specstxtmc", "txt_mc"+i, spec_mc.getNextHighestDepth(), {_x:10});	
			formatText(txt_mc.label, dataObj.phone_spec.spec[i].label, true, 225);
			formatText(txt_mc.value, dataObj.phone_spec.spec[i].value, true, 225);
			txt_mc.value._x = Math.round(txt_mc.label._x + txt_mc.label.textWidth + 5);
			
			var real_width : Number = txt_mc.label._x + txt_mc.label.textWidth + txt_mc.value.textWidth + 5;
			
			if (real_width > 240)
			{
				txt_mc.value._y = Math.round(txt_mc.label.textHeight);
				txt_mc.value._x = txt_mc.label._x;
			}
			txt_mc._y = cy;
			cy  = Math.round(txt_mc._y + txt_mc._height);
		}
		
		spec_mc.spec_bg._height = cy + 5;

		//Layout phone spec
		if (dataObj.phone_spec.x != undefined && dataObj.phone_spec.x != 'auto')
		{
			content_holder.spec_mc._x = Number(dataObj.phone_spec.x);
		}
		if (dataObj.phone_spec.y != undefined && dataObj.phone_spec.y != 'auto')
		{
			content_holder.spec_mc._y =  Number(dataObj.phone_spec.y);
		}
		if ( dataObj.phone_spec.x == 'auto')
		{
			content_holder.spec_mc._x = Math.floor(selected_item._x/2 + selected_item._width/2   + selected_item._width + 40) ;
		}

		//move mask----------------------
		content_holder.mask_mc._x  = content_holder.spec_mc._x;
		
	}
	////////////////////////////////////////////////////////////////////////////////
	// Create the Phone Highlights Movieclip from XML
	////////////////////////////////////////////////////////////////////////////////
	public function createPhoneHighlights():Void
	{
		if (dataObj.highlights)
		{
			var numOfText 		: Number = dataObj.highlights.text.length;
			var highlights_mc 	: MovieClip = content_holder.attachMovie("highlights_template", "highlights_mc", content_holder.getNextHighestDepth());

			var cy : Number = 30;
			
			(dataObj.highlights.headerLabel != undefined ) ? highlights_mc.title_txt.text = dataObj.highlights.headerLabel : highlights_mc.title_txt.text = "";
			
			for (var i : Number = 0; i < numOfText; i++)
			{
				var txt_mc : MovieClip = highlights_mc.attachMovie("hightxt_template", "txt_mc"+i, highlights_mc.getNextHighestDepth(), {_x:0});	
				formatText(txt_mc.txt, dataObj.highlights.text[i], true, 260, true);

				txt_mc._y = cy;
				cy  = Math.round(txt_mc._y + txt_mc._height+2);
			}

			//Layout phone spec
			if (dataObj.highlights.x != undefined && dataObj.highlights.x != 'auto')
			{
				content_holder.highlights_mc._x = Number(dataObj.highlights.x);
			}
			if (dataObj.highlights.y != undefined && dataObj.highlights.y != 'auto')
			{
				content_holder.highlights_mc._y =  Number(dataObj.highlights.y);
			}
			if ( dataObj.highlights.x == 'auto')
			{
				content_holder.highlights_mc._x = content_holder.main_text_mc._x;
			}
			if ( dataObj.highlights.y == 'auto')
			{
				content_holder.highlights_mc._y = Math.ceil(content_holder.main_text_mc._y +content_holder.main_text_mc._height + 20);
			}
		
		}
		
	}

	////////////////////////////////////////////////////////////////////////////////
	// Create Video Button if present
	////////////////////////////////////////////////////////////////////////////////
	public function createVideoButton():Void
	{
		var video_button_Y : Number;
		
		if (videoActive)
		{
			var label_str : String = dataObj.main_text.video.label;
			video_button = content_holder.attachMovie('YELLOW_EE_B_MC', 'video_button', content_holder.getNextHighestDepth() );
			video_button.init( label_str );
			video_button.addEventListener("onButtonClicked", Delegate.create(this, launchFullScreenVideo));
			
			//reposition video button
			( dataObj.highlights ) ? video_button_Y  = Math.ceil(content_holder.highlights_mc._y +content_holder.highlights_mc._height + 20) : video_button_Y  = Math.ceil(content_holder.main_text_mc._y +content_holder.main_text_mc._height + 20);
			
			video_button._x = content_holder.main_text_mc._x;
			video_button._y = video_button_Y;
		}
	}
	
	////////////////////////////////////////////////////////////////////////////////
	// Create a specifications button for templates 2 and 3
	////////////////////////////////////////////////////////////////////////////////	
	public function createSpecsButton():Void
	{
		var sy : Number = Math.ceil(content_holder.highlights_mc._y +content_holder.highlights_mc._height + 20);
		var sx : Number = content_holder.highlights_mc._x;
		specs_button = content_holder.attachMovie('YELLOW_EE_B_MC', 'specs_button', content_holder.getNextHighestDepth(), { _x:sx, _y:sy } );
		specs_button.init( SPECS_STR );
	}
	
	////////////////////////////////////////////////////////////////////////////////
	// Close product Content details - used to close all templates
	////////////////////////////////////////////////////////////////////////////////
	public function closeDetail() : Void
	{
		closing = true;
		opening = false;
		
		TweenMax.killDelayedCallsTo(detailsOpenComplete);
		
		TweenMax.to(content_holder, .5, { _alpha:0, ease:Circ.easeOut, delay:0, onComplete:closeComplete, onCompleteScope:this } );
		
		( video_button ) ? TweenMax.to(video_button, .5, { autoAlpha:0, ease:Circ.easeOut, delay:0 } ) : null;
		
		( specs_button ) ? TweenMax.to(specs_button, .5, { autoAlpha:0, ease:Circ.easeOut, delay:0 } ) : null;
		
		dispatchEvent( { type:"closeDetail" } );

	}
	
	////////////////////////////////////////////////////////////////////////////////
	// On Close complete remove and reset all data
	////////////////////////////////////////////////////////////////////////////////
	public function closeComplete() : Void
	{
		offers_mc.removeMovieClip();
		emptyMC(content_holder);
		content_holder.removeMovieClip();
		specs_button.removeMovieClip();
		video_button.removeMovieClip();
		closing = false;
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
	
	////////////////////////////////////////////////////////////////////////////////
	// Launch Full screen video
	////////////////////////////////////////////////////////////////////////////////
	public function launchFullScreenVideo():Void
	{
		var target : MovieClip = info_container._parent._parent;
		
	   full_screen_video = target.attachMovie('full_screen_video_mc', "full_screen_video", target.getNextHighestDepth(), {_alpha:0});
	   
	   full_screen_video.close_btn.onRelease = Delegate.create(this, closeFullScreenVideo);
	   
	   full_screen_video.video_mc.videoURL = dataObj.main_text.video.url;
	   
	   video_button.disable();
	   specs_button.disable();
	   (offers_mc.link_btn) ? offers_mc.link_btn.enabled = false : null;
	   
	   content_holder.close_btn._visible = false;
	   
	   content_holder.enabled = false;
	   
	   TweenMax.to(full_screen_video, 0, { autoAlpha:100, delay:0 } );
	   
	   Tracker.trackClick(_parent.page_name, dataObj.main_text.video.url);
	}

	////////////////////////////////////////////////////////////////////////////////
	// Close Full screen video
	////////////////////////////////////////////////////////////////////////////////
	public function closeFullScreenVideo():Void
	{
	   full_screen_video.videoURL = "";
	   
	   full_screen_video.removeMovieClip();
	  
	   full_screen_video = null;
	   
	   video_button.enable();
	   specs_button.enable();
	   (offers_mc.link_btn) ? offers_mc.link_btn.enabled = true : null;
	   
	   content_holder.close_btn._visible = true;
	   
	   content_holder.enabled = true;
	}
	
	
	
	////////////////////////////////////////////////////////////////////////////
	//FORMAT TEXT FIELD PROPERTIES
	////////////////////////////////////////////////////////////////////////////
	private function formatText(txtF:TextField, txtStr:String, multiline:Boolean, txt_width : Number, _autosize:Boolean ) : Void
	{
		(!isNaN(txt_width)) ? txtF._width = txt_width : null;
		
		(_autosize == undefined) ? _autosize = true : null;
		
		txtF.border = false;
		txtF.background = false;
		txtF.autoSize = _autosize;
		txtF.wordWrap = multiline;
		txtF.selectable = false;
		txtF.multiline = multiline;
		txtF.embedFonts = true;
		txtF.html = true;
		txtF.styleSheet = Model.getInstance().cssFile;
		txtF.condenseWhite = true;
		txtF.htmlText = txtStr;

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