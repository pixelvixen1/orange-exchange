////////////////////////////////////////////////////////////////////////////////
// Project: Orange Exchange issue 36
// FileName: CarouselItem.as
// Created by: Angel 
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// IMPORTS
////////////////////////////////////////////////////////////////////////////////
import mx.data.encoders.Num;
import mx.events.EventDispatcher;
import mx.utils.Delegate;
import flash.display.BitmapData;
import flash.filters.BlurFilter;

import exchange.model.Model;
import com.greensock.TweenMax;
import com.greensock.easing.*;

import org.casalib.load.LoadGroup;
import org.casalib.load.media.MediaLoad;
import org.casalib.load.base.LoadInterface;
import org.casalib.math.Percent;
import org.casalib.load.base.BytesLoadInterface;

////////////////////////////////////////////////////////////////////////////////
// CLASS: CarouselItem 
////////////////////////////////////////////////////////////////////////////////
class exchange.sections.devices.CarouselItem extends MovieClip 
{
	////////////////////////////////////////////////////////////////////////////
	// Properties
	////////////////////////////////////////////////////////////////////////////
	private static var instance		: CarouselItem;
	public var page_name 			: String;
	public var dataObj				: Object;

	//Properties
	public var num					: Number;
	public var screenType			: String;
	public var minScale 			: Number;
	public var captionText			: String;
	public var captionText2			: String;
	public var tooltip_text			: String;
			
	public var overNumber			: String = "";
	public var reflected			: Boolean = false;
	public var detailIsOpen   		: Boolean = false;
	public var over			   		: Boolean = false;
	public var enableButtonWhenInFront:Boolean = true;
	
	public var MOVING		   		: Boolean = false;
	public var stoppedX				: Number;

	public var w					: Number;
	public var h					: Number;
	public var imageScale			: Number;
	public var imageWidth			: Number;
	public var imageHeight			: Number;
	public var darknessTo 			: Number = 0;
	public var darknessTweened 		: Number = 0;
	
	//On stage Assets
	public var button				: Button;
	public var reflection			: MovieClip;
	public var borderMask			: MovieClip;
	public var loader				: MovieClip;

	// Dispatch
	public var addEventListener		: Function; 
	public var removeEventListener	: Function; 
	public var dispatchEvent		: Function;

	////////////////////////////////////////////////////////////////////////////
	// Constructor
	////////////////////////////////////////////////////////////////////////////
	public function CarouselItem()
	{		
		EventDispatcher.initialize(this);
	}
	
	public static function getInstance() : CarouselItem 
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
	public function initItem( _page_name : String, _id : Number, _dataObj : Object ) : Void
	{
		page_name = _page_name;
		num = _id;
		dataObj = _dataObj;

		screenType = dataObj.screenType;
		captionText = dataObj.captionText;
		captionText2 = dataObj.captionText2;
		imageScale = dataObj.imageScale;		
	}

	
	////////////////////////////////////////////////////////////////////////////
	//  Item successfully loaded from parent load group 
	///////////////////////////////////////////////////////////////////////////
	public function itemLoaded() : Void
	{
		var mc : MovieClip = this.loader;
		
		loader.forceSmoothing = true;
		
		
		loader._xscale = imageScale;
		loader._yscale = imageScale;
			
			if (imageWidth != "" && imageWidth != undefined)
			{
				w = imageWidth;
			}
			else
			{
				w = loader._width;
			}
				
			if (imageHeight != "" && imageHeight != undefined)
			{
				h = imageHeight;
			}
			else
			{
				h = loader._height;
			}
		
			
			
		loader.phone_mc.shadow_mc._alpha = 50;
		size();
		
		
		setMainButtonFunctions();
		
		tooltip_text = captionText;
		tooltip_text = tooltip_text.toUpperCase();
		startItem();
		

	}
			
	
	////////////////////////////////////////////////////////////////////////////
	//  Resize image item to scale in xml
	///////////////////////////////////////////////////////////////////////////
	public function size() : Void
	{
		loader._visible = true; 
		loader._xscale = imageScale;
		loader._yscale = imageScale;
		loader._x = -w/2;
		loader._y = -h;
		button._width = w;
		button._height = h;
		button._y = loader._y;
		button._x = loader._x;
		
		//set up reflection
		if (_parent.useReflection) 
		{
			reflectItem();
			reflection._x = loader._x;
			reflection._y = loader._y + Number(loader._height);
		}

	}
	
	
	////////////////////////////////////////////////////////////////////////////
	//  Start Item in Carousel
	///////////////////////////////////////////////////////////////////////////
	public function startItem() : Void
	{
		this.onEnterFrame = Delegate.create(this, checkItem);
	}
		
	////////////////////////////////////////////////////////////////////////////
	// On enter Frame check and move item position if needed
	///////////////////////////////////////////////////////////////////////////
	public function checkItem() : Void
	{
		 var thumbRotation	: Number;
		 var prevThumbRotation: Number;
		 var prevSpanX	: Number;
		 var prevSpanY: Number;
		 var prevCenterX: Number;
		 var prevCenterY: Number;
		 var prevPerspectiveRatio: Number;
		 var prevMinimumscale: Number;
		 var prevDistanceValue: Number;	
		 var sc	: Number;
		 var rh	: Number;	
		
		if (_parent.rotationKind == 1) 
		{
			if (!enableButtonWhenInFront && ((num == _parent.rotImageNumber && _parent.rotationKind == 1) || _parent.rotationKind == 0)) 
			{
				button._visible = false;
			} 
			else 
			{
				button._visible = true;
			}
		}
		
		//rollover fading  
		if (_parent.useFadeOnMouseOver)
		{
			
			if (_parent.overNumber != num && _parent.overNumber != "") 
			{
				darknessTo = _parent.mouseOverDarkness;
			}
			
			if (_parent.overNumber == num || _parent.overNumber == "") 
			{
				darknessTo = 0;
			}
			
		}

			
		thumbRotation = _parent.rot + (num * _parent.perinstance);
			
			if (thumbRotation != prevThumbRotation || _parent.centerX != prevCenterX || _parent.centerY != prevCenterY || _parent.spanX != prevSpanX || _parent.spanY != prevSpanY || _parent.perspectiveRatio != prevPerspectiveRatio || minScale != prevMinimumscale || _parent.distanceValue != prevDistanceValue)
			{
				
				stoppedX = _x;
				
				_x = _parent.centerX+(1-_parent.distanceValue)*_parent.spanX*(Math.cos(thumbRotation))*(_parent.perspectiveRatio+(1-_parent.perspectiveRatio)*(Math.sin(thumbRotation)+1)/2)
				_y = _parent.centerY+(1-_parent.distanceValue)*_parent.spanY*(Math.sin(thumbRotation));
				sc = ((minScale+(1-minScale)*(1+(Math.sin(thumbRotation)))/2)*100)*(1-_parent.distanceValue);
				_xscale = sc;
				_yscale = sc;
				
				
			
				if (stoppedX == _x)
				{
					MOVING = false;
					
				}
				else if (stoppedX != _x)
				{
					MOVING = true;
					
				}
	
	
				//prevent two items from having the exact same depth
				while (_parent.getInstanceAtDepth(Math.round(sc * 1000)) != undefined) 
				{
					sc += 1;
				}
				
				this.swapDepths(Math.round(sc*1000));
				_parent.tooltip.swapDepths(Math.round(sc * 4001));
				
				rh = _parent.spanY;
		
				if (rh < 0)
				{
					rh = 0;
				}
				if (rh > 100)
				{
					rh = 100;
				}
				
				reflection.rmask._yscale = rh;
			}
			
			prevThumbRotation = thumbRotation;
			prevSpanX = _parent.spanX;
			prevSpanY = _parent.spanY;
			prevCenterX = _parent.centerX;
			prevCenterY = _parent.centerY;
			prevPerspectiveRatio = _parent.perspectiveRatio;
			prevMinimumscale = minScale;
			prevDistanceValue = _parent.distanceValue;
			
			var prevx : Number;
			var prevy : Number;
			var prevf : Number;
			var fb : Number;
			var f : Number;
			
			this.filters = null;
			var tmpFilters:Array = this.filters;
			
			if (_parent.useFocalBlur) 
			{
				fb = 12*_parent.focalBlurValue;
				f = 6*_parent.distanceValue+fb-fb*(1+(Math.sin(thumbRotation)))/2;
				
				if (f != prevf)
				{
					var focalBlur : BlurFilter = new flash.filters.BlurFilter(f, f, 1);
				}
				
				prevf = f;
				
				tmpFilters.push(focalBlur);
			}
			
			

			if (_parent.useMotionBlur && ((prevx != _x && prevy != _y) || blurX != 0 || blurY != 0)) 
			{
				var blurX = Math.abs(_x-prevx)*_parent.motionBlurValue;
				var blurY = Math.abs(_y-prevy)*_parent.motionBlurValue;
				var motionBlur = new flash.filters.BlurFilter(blurX, blurY, 1);
				
				tmpFilters.push(motionBlur);
			}
			
			prevx = _x;
			prevy = _y;

			//brightness filter
			darknessTweened += (darknessTo-darknessTweened)/4;
			//add z-darkness
			var darknessZ = _parent.distanceValue+_parent.distanceDarken*(1-(1+Math.sin(thumbRotation))/2);
			var darkness = (darknessTweened*-255)-(255-(darknessTweened*255))*darknessZ;
			var coma = [1, 0, 0, 0, darkness,
						0, 1, 0, 0, darkness,
						0, 0, 1, 0, darkness,
						0, 0, 0, 1, 0];
			var brightness = new flash.filters.ColorMatrixFilter(coma);
			tmpFilters.push(brightness);
			
			//apply all filters
			this.filters = tmpFilters;
	}
		
	
	
	////////////////////////////////////////////////////////////////////////////
	//  On mouse over of Item
	///////////////////////////////////////////////////////////////////////////
	public function onButtonOver() : Void
	{
		
		over = true;
		_parent.overNumber = num;
		
		_parent.tooltip.alphaTo = 100;

		_parent.tooltip.field.htmlText = '<b>'+tooltip_text+'</b>';
		
		//set contents of tooltip
		if (_parent.rotationKind == 1) 
		{

			if (num == _parent.rotImageNumber)
			{
				_parent.tooltip.field2.text = _parent.tooltipHelpLink;
			}
			else
			{
				_parent.tooltip.field2.text = _parent.tooltipHelpMove;
			}
			
		}
		else
		{		
			_parent.tooltip.field2.text = _parent.tooltipHelpLink;		
		}
		
		if (_parent.useTooltip)
		{
			_parent.setTooltip();
		}
	}


	////////////////////////////////////////////////////////////////////////////
	//  On mouse out of Item
	///////////////////////////////////////////////////////////////////////////
	public function onButtonOut() : Void
	{
		over = false;
		_parent.tooltip.alphaTo = 0;
		
		if (_parent.overNumber == num) 
		{
			_parent.overNumber = "";
		}
		
	}

	////////////////////////////////////////////////////////////////////////////
	//  On Item clicked
	///////////////////////////////////////////////////////////////////////////
	public function onButtonClicked() : Void
	{
		
		if (_parent.stopAutoRotateOnClick) 
		{
			clearInterval(_parent.autoRotateIntervalID);
		}
		
		if (_parent.rotationKind == 0 || (num == _parent.rotImageNumber && enableButtonWhenInFront)) 
		{
				openDetail(); 	
		}
			
		if (_parent.rotationKind == 1 && num != _parent.rotImageNumber)
		{
				_parent.moveToFront(num);
		}	

	}	

	////////////////////////////////////////////////////////////////////////////
	//  Open details for Item 
	///////////////////////////////////////////////////////////////////////////	
	public function openDetail() : Void
	{
		if (!detailIsOpen && !MOVING)
		{
			disableItem();
			detailIsOpen = true;
			_parent.openDetail(this);
			
			over = false;
			_parent.tooltip.alphaTo = 0;
			_parent.tooltip._alpha = 0;
			
			if (_parent.overNumber == num) 
			{
				_parent.overNumber = "";
			}
		}
	}
		
	
	////////////////////////////////////////////////////////////////////////////
	//  Disable Item
	///////////////////////////////////////////////////////////////////////////
	public function disableItem() : Void
	{
		this.onEnterFrame = null;
		button.enabled = false;
	}

	////////////////////////////////////////////////////////////////////////////
	//  Enable Item
	///////////////////////////////////////////////////////////////////////////
	public function enableItem() : Void
	{
		detailIsOpen = false;
		setMainButtonFunctions();
		this.onEnterFrame = Delegate.create(this, checkItem);
	}

	public function setMainButtonFunctions() : Void
	{
		button.onRollOver = Delegate.create(this, onButtonOver);
		button.onRollOut = Delegate.create(this, onButtonOut);
		button.onRelease = Delegate.create(this, onButtonClicked);
		button.enabled = true;
		button._visible = true;
	}
	public function removeButtonFunctions() : Void
	{
		button.onRollOver = null;
		button.onRollOut = null;
		button.onRelease = null;
		button.enabled = false;
		button._visible = false;
	}	
	
	//reset phone back to normal view
	public function resetPhone() : Void
	{
		this.onEnterFrame = null;
		var mc = this.loader.phone_mc;
		mc.gotoAndStop(1);
		
		if (_parent.useReflection) 
		{
			reflectItem();
			reflection._visible = true;
		}
	}

	//enable the 360 rotation view
	public function enable360RotateFunction() : Void
	{
		removeButtonFunctions();
		var mc = this.loader.phone_mc;
		trace(mc.rotationMode);
		
		if(mc.rotationMode)
		{
			
			mc.gotoAndStop('view360');
			
			var mcr = mc.phone360;
			var buttonleft = mcr.left_btn;
			var buttonright = mcr.right_btn;
			
			TweenMax.to(buttonleft, 1, { autoAlpha:100 } );
			TweenMax.to(buttonright, 1, { autoAlpha:100 } );
			
			(_parent.useReflection) ? this.onEnterFrame = Delegate.create(this, reflect360) : null;
		}
	}

	////////////////////////////////////////////////////////////////////////////
	// Reflect on 360 view - called on enter frame
	////////////////////////////////////////////////////////////////////////////
	public function reflect360() : Void
	{
		_parent.reflect(loader, reflection, _parent.reflectionAlphaValue*100,w,h);
	}


	
	////////////////////////////////////////////////////////////////////////////
	// Reflect the item 
	////////////////////////////////////////////////////////////////////////////
	public function reflectItem() : Void
	{
		if (_parent.useReflection) 
		{
			_parent.reflect(loader, reflection, _parent.reflectionAlphaValue * 100, w, h);
		}
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