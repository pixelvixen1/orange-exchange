////////////////////////////////////////////////////////////////////////////////
// Project: Orange Exchange issue 36
// FileName: Carousel.as
// Created by: Angel 
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// IMPORTS
////////////////////////////////////////////////////////////////////////////////
import mx.events.EventDispatcher;
import mx.utils.Delegate;
import flash.display.BitmapData;
import org.casalib.load.media.MediaLoad;

import exchange.utils.LoadUtil;
import exchange.model.Model;
import exchange.sections.devices.CarouselItem;
import exchange.sections.devices.ContentDetails;

import com.greensock.TweenMax;
import com.greensock.easing.*;
////////////////////////////////////////////////////////////////////////////////
// CLASS: Carousel 
////////////////////////////////////////////////////////////////////////////////
class exchange.sections.devices.Carousel extends MovieClip
{
	////////////////////////////////////////////////////////////////////////////
	// Properties
	////////////////////////////////////////////////////////////////////////////
	private static var instance		: Carousel;
	public var page_name 			: String;

	//DATA
	public var items				: Array;
	public var numOfItems 			: Number;
	public var settingsVO			: Object;
	public var items_array 			: Array;
	public var templateID 			: Number;
	public var loadArray			: Array;
	
	//Assets
	public var info_container		: MovieClip;
	public var selected_item  	 	: MovieClip;
	public var content_holder  		: MovieClip;
	public var navigation_mc		: MovieClip;
	public var tooltip				: MovieClip;
	public var progressTF			: TextField;
	public var progress_mc			: MovieClip;
	private var contentLoader		: LoadUtil;
	
	//Properties
	public var clonePhoneOpen		: Boolean = false;
	public var detailsIsOpen   		: Boolean = false;
	public var opening			   	: Boolean = false;
	public var closing			   	: Boolean = false;
	public var videoPlaying		   	: Boolean = false;

	public var min_scale 			: Number;	
	public var defaultSpeed 		: Number;
	public var highSpeed 			: Number;
	public var perinstance 			: Number;
	public var num 					: Number = 1;
	public var total 				: Number = 0;
	public var rot 					: Number;
	public var rotGoto 				: Number;
	public var rotImageNumber		: Number = 0;
	public var overNumber			: String = "";
	public var autoRotateIntervalID	: Number = 0;
	public var newnum				: Number = 0;
	
	/////////////////////////////////////////
	public var rotationKind        		: Number;	
	public var rotationSpeed        	: Number; 
	public var enableMouseWheel     	: Boolean;
	public var stopRotatingOnMouseOver 	: Boolean;
	
	public var autoRotateMode        	: Number = 0;
	public var autoRotateInterval    	: Number = 0;	
	public var stopAutoRotateOnClick 	: Boolean;	

	public var  useTooltip              : Boolean;
	public var showTooltipHelp         	: Boolean;
	public var tooltipHelpMove        	: String;
	public var tooltipHelpLink         	: String;

	public var useNavigationButtons    	: Boolean;
	public var navigationY              : Number;

	public var spanX             	   : Number;
	public var spanY              	   : Number;
	public var centerX            	   : Number;
	public var centerY                 : Number;
	public var distanceValue           : Number; 
	public var distanceDarken          : Number; 
	public var perspectiveRatio        : Number;
	public var minimumscale            : Number;

	public var useFocalBlur            : Boolean;
	public var focalBlurValue          : Number;
	public var useMotionBlur           : Boolean;
	public var motionBlurValue         : Number;
	public var useFadeOnMouseOver      : Boolean;
	public var mouseOverDarkness       : Number;  
	public var useReflection           : Boolean; 
	public var reflectionAlphaValue    : Number;
	public var frontThumbNumber        : Number;
	public var showClonePhone          : Boolean;	
	
	// Dispatch
	public var addEventListener			: Function; 
	public var removeEventListener		: Function; 
	public var dispatchEvent			: Function;

	////////////////////////////////////////////////////////////////////////////
	// Constructor
	////////////////////////////////////////////////////////////////////////////
	public function Carousel()
	{		
		EventDispatcher.initialize(this);
	}
	
	public static function getInstance() : Carousel 
	{
		return instance;
	}
	

	////////////////////////////////////////////////////////////////////////////
	// On Load
	///////////////////////////////////////////////////////////////////////////
	public function onLoad() : Void
	{
		instance = this;
		navigation_mc._visible = false;
	}

	////////////////////////////////////////////////////////////////////////////
	// Initialise carousel
	///////////////////////////////////////////////////////////////////////////
	public function initCarousel( _page_name : String, settingsObject : Object, items_data_array: Array   ) : Void
	{
		page_name = _page_name;
		settingsVO = settingsObject;
		items = items_data_array;
		numOfItems = items.length;		
		formatSettings();
		setupCarouselItems();
	}
	
	////////////////////////////////////////////////////////////////////////////
	//  Format Carousel settings
	///////////////////////////////////////////////////////////////////////////
	private function formatSettings() : Void
	{
		rot = Math.PI*0.5001+Math.PI*2;
		rotGoto = rot;	
		
		rotationKind = Number(settingsVO.rotationKind);
		rotationSpeed = Number(settingsVO.rotationSpeed); 
		enableMouseWheel = convertStringToBoolean(settingsVO.enableMouseWheel);
		stopRotatingOnMouseOver = convertStringToBoolean(settingsVO.stopRotatingOnMouseOver);
		
		autoRotateMode = Number( settingsVO.autoRotateMode );
		autoRotateInterval = Number( settingsVO.autoRotateInterval );
		stopAutoRotateOnClick = convertStringToBoolean(settingsVO.stopAutoRotateOnClick);
		
		useTooltip = convertStringToBoolean(settingsVO.useTooltip);
		showTooltipHelp = convertStringToBoolean(settingsVO.showTooltipHelp);
		tooltipHelpMove = settingsVO.tooltipHelpMove;
		tooltipHelpLink = settingsVO.tooltipHelpLink;
		
		useNavigationButtons = convertStringToBoolean(settingsVO.useNavigationButtons);
		navigationY = Number(settingsVO.navigationY);
		
		spanX = Number(settingsVO.spanX);
		spanY = Number(settingsVO.spanY);
		centerX = Number(settingsVO.centerX);
		centerY = Number(settingsVO.centerY);
		distanceValue = Number(settingsVO.distanceValue); 		
		distanceDarken = Number(settingsVO.distanceDarken);
		perspectiveRatio = Number(settingsVO.perspectiveRatio);
		minimumscale = Number(settingsVO.minimumscale); 

		useFocalBlur        = convertStringToBoolean(settingsVO.useFocalBlur);
		focalBlurValue      = Number( settingsVO.focalBlurValue);
		useMotionBlur       = convertStringToBoolean(settingsVO.useMotionBlur );
		motionBlurValue     = Number(settingsVO.motionBlurValue );
		useFadeOnMouseOver  = convertStringToBoolean(settingsVO.useFadeOnMouseOver );
		mouseOverDarkness   = Number( settingsVO.mouseOverDarkness  );  
		useReflection       = convertStringToBoolean( settingsVO.useReflection); 
		reflectionAlphaValue= Number(settingsVO.reflectionAlphaValue );
		frontThumbNumber    = Number(settingsVO.frontThumbNumber );
		showClonePhone      = convertStringToBoolean(settingsVO.showClonePhone );	
	}
		
	
	////////////////////////////////////////////////////////////////////////////
	//  Set up Carousel Items
	///////////////////////////////////////////////////////////////////////////
	private function setupCarouselItems() : Void
	{
		loadArray = new Array();
		items_array = new Array();
		
		for (var i : Number = 0; i<numOfItems; i++) 
		{
			var carousel_Item : MovieClip = this.attachMovie('_carousel_item', 'carousel_Item'+i, this.getNextHighestDepth() );
			carousel_Item._visible = false;
			carousel_Item._alpha = 0;
			carousel_Item.initItem(page_name, i, items[i] );
			carousel_Item.enableButtonWhenInFront = true;

			
			if ( items[i].minScale != undefined )
			{
				carousel_Item.minScale = Number( items[i].minScale );
			}
			else
			{
				carousel_Item.minScale = Number(minimumscale);
			}
			
			var mediaLoad:MediaLoad = new MediaLoad(carousel_Item.loader, items[i].imageURL, true);
			loadArray.push(mediaLoad);
			items[i].mc = carousel_Item;
			
			total += 1;
			items_array.push(carousel_Item);
			
		}
	
		
		defaultSpeed = rotationSpeed;

		perinstance = -(2 * Math.PI) / total;
		
		//set right frontThumb if defined so in the xml
		if (!isNaN(frontThumbNumber)) 
		{
			rotImageNumber = frontThumbNumber%total;
			rotGoto = Math.PI*0.5001+Math.PI*2-rotImageNumber*perinstance;
		}
		
		
		//////Start loading carousel items
		addPrgressLoader();
	}

	////////////////////////////////////////////////////////////////////////////
	//  Add a progress loader to show progess
	///////////////////////////////////////////////////////////////////////////
	private function addPrgressLoader(  ) : Void
	{
		progress_mc = this.attachMovie('progress_display', 'progress_mc', this.getNextHighestDepth(), {_x:0, _y:200} );
		progressTF = progress_mc.txt;
		contentLoader = new LoadUtil();
		contentLoader.addEventListener("contentFullyLoaded", this);
		contentLoader.init(loadArray, progressTF, 'LOADING DEVICES');
		contentLoader.startLoadingProcess();
	}
		
	////////////////////////////////////////////////////////////////////////////
	//  Carousel Items loaded 
	///////////////////////////////////////////////////////////////////////////
	public function contentFullyLoaded(  e : Object ) : Void
	{
		progressTF.txt = '';
		progress_mc.removeMovieClip();
		showCarouselItems( );
		setupToolTip();
		setupControls();
		this.onEnterFrame = Delegate.create(this, checkRotation);
		dispatchEvent( { type:"carouselFullyLoaded" } );
		contentLoader.removeEventListener("contentFullyLoaded", this);
	}
	
	
	////////////////////////////////////////////////////////////////////////////
	//  Show Carousel Items  
	///////////////////////////////////////////////////////////////////////////
	public function showCarouselItems( ) : Void
	{
		var dtime : Number = 0;
		for (var i : Number = 0; i<numOfItems; i++) 
		{
			var carousel_Item : CarouselItem = items[i].mc;
			carousel_Item.itemLoaded();
			carousel_Item._visible = true;
			TweenMax.to(carousel_Item, .5, {_alpha:100, delay:dtime});
			dtime += .1;
		}
	}
	
	////////////////////////////////////////////////////////////////////////////
	//  Tooltip Functions
	///////////////////////////////////////////////////////////////////////////	
	private function setupToolTip():Void
	{
		tooltip = this.attachMovie('tooltipClip', 'tooltipmc', 3000, {_x:1500, _alpha:0} );
	}
	////////////////////////////////////////////////////////////////////////////
	//  Set tooltip on mouse over of item
	///////////////////////////////////////////////////////////////////////////	
	public function setTooltip():Void
	{
		tooltip.field.autoSize = true;
		tooltip.field2.autoSize = true;

		tooltip.field2._y = tooltip.field._y + tooltip.field._height - 5;
		tooltip.bg._width = Math.max(tooltip.field._width + 10, tooltip.field2._width + 10);
		
		if (showTooltipHelp) 
		{
			tooltip.bg._height = tooltip.field2._y + tooltip.field2._height+1;
		} 
		else 
		{
			tooltip.bg._height = tooltip.field._y + tooltip.field._height+1;
		}
	}	
	
	
	
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////  Details  //////////////////////////////////////////////////////////////////  
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	////////////////////////////////////////////////////////////////////////////////
	// Open Phone Details
	////////////////////////////////////////////////////////////////////////////////
	public function openDetail( _selectedItem : MovieClip ) : Void
	{
		TweenMax.killDelayedCallsTo(restoreAll);
		TweenMax.killDelayedCallsTo(rotateCarousel);
		
		( _parent.clonePhoneOpen ) ? _parent.closeClonePhoneInfo() : null;
		
		selected_item = _selectedItem;
		disableCarouselItems();
		detailsIsOpen = true;
		opening = true;
		selected_item.filters = [];
		
		setInitValues(selected_item);

		var amountToGrow : Number = (100 - selected_item.imageScale) + 105;
		
		for (var i : Number = 0; i < items_array.length; i++)
		{
			var item_mc : MovieClip = items_array[i];
			
			setInitValues( item_mc );
			
			if ( item_mc == selected_item)
			{
				TweenMax.to(selected_item, 1, {_x:selected_item._x, _y:selected_item._y + 20, _xscale:amountToGrow, _yscale:amountToGrow, ease:Back.easeInOut, onComplete:createContentDetails, onCompleteScope:this});
			}
			else
			{
				TweenMax.to(item_mc, .5, { autoAlpha:0, ease:Circ.easeOut, delay:.2});
			}
		}
		
		navigation_mc._visible = false;
	
		dispatchEvent( { type:"contentDetailsOpening" } );
	}

	
	
	////////////////////////////////////////////////////////////////////////////////
	// Check which type of Details to create and inialise content
	////////////////////////////////////////////////////////////////////////////////
	public function createContentDetails():Void
	{
		Tracker.trackClick(page_name, selected_item.dataObj.trackingURL);
		
		var screenType : Number = Number(selected_item.dataObj.screenType);
		templateID = screenType;
		
		info_container.addEventListener('closeDetail', this);
		info_container.initContentDetails(templateID, selected_item, selected_item.dataObj);

	}
	
	
	////////////////////////////////////////////////////////////////////////////////
	// Close product detail
	////////////////////////////////////////////////////////////////////////////////	
	public function closeDetail() : Void
	{
		closing = true;
		opening = false;
		
		var dtime : Number = 0;
		rotationSpeed = defaultSpeed;

		selected_item.resetPhone();
		
		if ( templateID == 2 )
		{
			TweenMax.to(selected_item, 1, { _x:selected_item.init._x, ease:Back.easeInOut, delay:dtime } );
			dtime += .5;
		}
		
		for (var i : Number = 0; i < items_array.length; i++)
		{
			var item_mc : MovieClip = items_array[i];

			if ( item_mc == selected_item)
			{
				TweenMax.to(selected_item, 1, { _xscale:100, _yscale:100, _x:selected_item.init._x, _y:selected_item.init._y, ease:Back.easeInOut, delay:dtime+.5});
			}
			else
			{
				TweenMax.to(item_mc, .5, {autoAlpha:100, ease:Circ.easeOut, delay:dtime+.9});
			}
		}
		
		TweenMax.killDelayedCallsTo(restoreAll);
		TweenMax.killDelayedCallsTo(rotateCarousel);
			
		TweenMax.delayedCall(2, restoreAll, null, this);
	}

	
	////////////////////////////////////////////////////////////////////////////
	// Restore all after content detail is closed
	///////////////////////////////////////////////////////////////////////////
	public function restoreAll() : Void
	{
		detailsIsOpen = false;
		closing = false;
		navigation_mc._visible = true;
		
		restoreCarouselItems();

		(stopAutoRotateOnClick) ? clearInterval(autoRotateIntervalID) : null;
		
		//show headers
		_parent.restoreAll();
		
	}	
	
	
	////////////////////////////////////////////////////////////////////////////////
	// RESTORE CAROUSEL
	////////////////////////////////////////////////////////////////////////////////
	public function restoreCarouselItems() : Void
	{
		this.onEnterFrame = Delegate.create(this, checkRotation);
		enableMouseWheel = true;
		
		for (var i : Number = 0; i < items_array.length; i++)
		{
			var item_mc : MovieClip = items_array[i];
			item_mc._alpha = 100;
			item_mc.enableItem();
		}
		
	}

	////////////////////////////////////////////////////////////////////////////////
	// Disable Carousel
	////////////////////////////////////////////////////////////////////////////////
	public function disableCarouselItems():Void
	{
		this.onEnterFrame = null;
		tooltip._alpha = 0;
		enableMouseWheel = false;
		clearInterval(autoRotateIntervalID);
		for (var i : Number = 0; i < items_array.length; i++)
		{
			var item_mc : MovieClip = items_array[i];
			item_mc.disableItem();
		}
		
	}
	
	////////////////////////////////////////////////////////////////////////////
	//  On Enter Frame check rotation of Items
	///////////////////////////////////////////////////////////////////////////	
	public function checkRotation() : Void
	{
		
		if (rotationKind == 0)
		{
			navigation_mc._visible = false;
			if (!(stopRotatingOnMouseOver && overNumber != "")) 
			{
				if (autoRotateMode != 0) 
				{
					rotGoto -= rotationSpeed/100;
				} 
				else 
				{
					rotGoto -= (centerX-_xmouse)/10000*rotationSpeed;
				}
			}
			rot += (rotGoto - rot) / rotationSpeed;
			
		} 
		else 
		{
			if (useNavigationButtons) 
			{
				navigation_mc._visible = true;
			} 
			else 
			{
				navigation_mc._visible = false;
			}
			if (!isNaN(rotationSpeed)) 
			{
				var dist = Math.abs(rotGoto-rot);
				if (dist > Math.PI) 
				{
					if (rotGoto > rot) 
					{
						rot += 2*Math.PI;
					} 
					else 
					{
						rot -= 2*Math.PI;
					}
				}
				rot += (rotGoto-rot)/rotationSpeed;
			}
		}
		
		//tooltip 
		if (useTooltip) 
		{
			tooltip._alpha += (tooltip.alphaTo-tooltip._alpha)/3;
			tooltip._x += (_xmouse - tooltip._width / 2 + 10 - tooltip._x) / 2;
			tooltip._y += (_ymouse + 30-tooltip._y)/2;

			if(tooltip._x + tooltip._width > Stage.width) 
			{
				tooltip._x = Stage.width-tooltip._width;
			}
			if (tooltip._y + tooltip._height > Stage.height) 
			{
				tooltip._y = Stage.height-tooltip._height;
			}
		} 
		else 
		{
			tooltip._alpha = 0;
		}
		

	}	
	
	
	////////////////////////////////////////////////////////////////////////////
	// Autorotate function
	///////////////////////////////////////////////////////////////////////////
	public function autoRotateFunction() : Void
	{
		if (rotationKind == 1 && autoRotateMode != 0 && !videoPlaying && !(stopRotatingOnMouseOver && overNumber != "")) 
		{
			rotateCarousel(1);
			if (autoRotateMode == 2) 
			{
				clearInterval(autoRotateIntervalID);
			}
		}
	}
	////////////////////////////////////////////////////////////////////////////
	// Refresh
	///////////////////////////////////////////////////////////////////////////
	public function refreshAutoRotate() : Void
	{
		clearInterval(autoRotateIntervalID);
		autoRotateIntervalID = setInterval(autoRotateFunction, autoRotateInterval*1000);
	}
	////////////////////////////////////////////////////////////////////////////
	// Move item to front by ID
	///////////////////////////////////////////////////////////////////////////
	public function moveToFront( num : Number ) : Void
	{
		rotImageNumber = num;
		rotGoto = Math.PI*0.5001+Math.PI*2-num*perinstance;
		refreshAutoRotate();
	}
	////////////////////////////////////////////////////////////////////////////
	// Rotate carousel by amount
	///////////////////////////////////////////////////////////////////////////
	public function rotateCarousel( amount : Number ) :Void
	{
		newnum = rotImageNumber+amount;
		if (newnum >= total) 
		{
			newnum = 0;
		}
		if (newnum < 0) 
		{
			newnum = total-1;
		}
		
		moveToFront(newnum);
	}	
	
	
	////////////////////////////////////////////////////////////////////////////
	// Set up Carousel Navigation controls
	///////////////////////////////////////////////////////////////////////////
	public function setupControls() : Void
	{
		navigation_mc._y = navigationY;
		navigation_mc.btnLeft.onPress = Delegate.create(this, rotateCarouselLeft);
		navigation_mc.btnRight.onPress = Delegate.create(this, rotateCarouselRight);
		
		var mouseListener:Object = new Object();
		Mouse.addListener(mouseListener);
		mouseListener.onMouseWheel = Delegate.create(this, onWheelRotate);

	}	
	
	
	////////////////////////////////////////////////////////////////////////////
	// On Mouse wheel
	///////////////////////////////////////////////////////////////////////////
	public function onWheelRotate(delta) : Void
	{
		if (enableMouseWheel) 
		{
			rotateCarousel(-delta/Math.abs(delta));
			if (stopAutoRotateOnClick) 
			{
				clearInterval(autoRotateIntervalID);
			}
		}
		
	}			
	
	////////////////////////////////////////////////////////////////////////////
	// Rotate Items left
	///////////////////////////////////////////////////////////////////////////
	public function rotateCarouselLeft() : Void
	{
		rotateCarousel(-1);
		if (stopAutoRotateOnClick) 
		{
			clearInterval(autoRotateIntervalID);
		}
		
	}	
	
	////////////////////////////////////////////////////////////////////////////
	// Rotate Items right
	///////////////////////////////////////////////////////////////////////////
	public function rotateCarouselRight() : Void
	{
		rotateCarousel(1);
		if (stopAutoRotateOnClick) 
		{
			clearInterval(autoRotateIntervalID);
		}
	}	
		
	
	
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////  UTILS  ////////////////////////////////////////////////////////////////////  
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	
	
	////////////////////////////////////////////////////////////////////////////
	// Convert String to Boolean function
	////////////////////////////////////////////////////////////////////////////	
	public function convertStringToBoolean( value : String ) : Boolean
	{
		switch(value) 
		{
			case "1":
			case "true":
			case "yes":
				return true;
			case "0":
			case "false":
			case "no":
				return false;
			default:
				return Boolean(value);
		}	
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
	
	////////////////////////////////////////////////////////////////////////////
	// Reflect MC
	///////////////////////////////////////////////////////////////////////////	
	private function reflect(src, target, alpha, wi, he) :Void
	{
		removeMovieClip(target.refmc);
		removeMovieClip(target.rmask);
		//bdata.dispose();
		
		var bdata:BitmapData = new BitmapData(wi/(src._xscale/100), he/(src._yscale/100), true, 0x00ffffff);
		bdata.draw(src);
		
		var refmc:MovieClip = target.createEmptyMovieClip("refmc", 0);
		refmc.attachBitmap(bdata,refmc.getNextHighestDepth());
		refmc._width = wi;
		refmc._height = he;
		refmc._yscale = -refmc._yscale;
		refmc._y = he;
		
		var rmask = target.createEmptyMovieClip("rmask", 1);
		var matrix = {matrixType:"box", x:0, y:0, w:wi, h:he, r:(90/180)*Math.PI};
		rmask.beginGradientFill("linear",[0xffffff, 0xffffff],[alpha, 0],[0, 100],matrix,"pad");
		rmask.moveTo(0,0);
		rmask.lineTo(0,he);
		rmask.lineTo(wi,he);
		rmask.lineTo(wi,0);
		rmask.lineTo(0,0);
		rmask.endFill();
		refmc.cacheAsBitmap = true;
		rmask.cacheAsBitmap = true;
		refmc.setMask(rmask);
	}

	//Center object
	public function centerObject(ob) : Void
	{
		ob._x = centerX;
		ob._y = centerY-50;
		ob.swapDepths((minimumscale+(1-minimumscale)*(1+(Math.sin(Math.PI)))/2)*10000);
		ob._visible = true;
	}	
	


}