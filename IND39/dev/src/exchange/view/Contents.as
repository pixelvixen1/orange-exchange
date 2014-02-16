////////////////////////////////////////////////////////////////////////////////
// Project: Orange Exchange issue 36 / edited for issue 39
// FileName: Contents.as
// Created by: Angel 
// LAST UPDATE : 21 Jan 2014
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// IMPORTS
////////////////////////////////////////////////////////////////////////////////
import mx.events.EventDispatcher;
import mx.utils.Delegate;
import flash.display.BitmapData;
import exchange.model.Model;
import exchange.view.ContentsButton;

import org.casalib.load.LoadGroup;
import org.casalib.load.media.MediaLoad;
import org.casalib.load.base.LoadInterface;
import org.casalib.math.Percent;
import org.casalib.load.base.BytesLoadInterface;

import com.greensock.TweenMax;
import com.greensock.easing.*;
import com.greensock.plugins.*;

////////////////////////////////////////////////////////////////////////////////
// CLASS: Contents 
////////////////////////////////////////////////////////////////////////////////
class exchange.view.Contents extends MovieClip
{
	////////////////////////////////////////////////////////////////////////////
	// Properties
	////////////////////////////////////////////////////////////////////////////
	private static var instance			: Contents;
	public var _Model					: Model;
	public var issue_name 				: String = 'Contents';
	public var ID						: Number = 1;
	public var issue 					: String;
	
	public var loadingGroup 			: LoadGroup;
	public var menu_mc 					: MovieClip;
	private var menu_array 				: Array;
	private var pages	 				: Array;
	private var previews				: MovieClip;
	private var preview_mc				: MovieClip;
	private var cover_mc				: MovieClip;
	private var contact_mc				: MovieClip;
	private var ee_logo_mc				: MovieClip;
	
	private var tp 						: String;
	
	private var MENUX					: Number = 385;
	private var MENUY					: Number = 250;	
	private var PREVIEWX				: Number = 27;
	private var PREVIEWY				: Number = 275;

	// Dispatch
	public var addEventListener			: Function; 
	public var removeEventListener		: Function; 
	public var dispatchEvent			: Function;

	////////////////////////////////////////////////////////////////////////////
	// Constructor
	////////////////////////////////////////////////////////////////////////////
	public function Contents()
	{		
		EventDispatcher.initialize(this);
	}

	////////////////////////////////////////////////////////////////////////////
	// Return singleton instance of Contents
	///////////////////////////////////////////////////////////////////////////	
	public static function getInstance() : Contents 
	{
		return instance;
	}
	
	////////////////////////////////////////////////////////////////////////////
	// On Load
	///////////////////////////////////////////////////////////////////////////
	public function onLoad() : Void
	{
		instance = this;
		TweenPlugin.activate([TransformMatrixPlugin]);
		
		if (_level0.application_mc)
		{
			_Model = Model.getInstance();
			setupAssets();
		}
		else
		{
			initModel();
		}
	}
	
	////////////////////////////////////////////////////////////////////////////
	// Initialise Model
	////////////////////////////////////////////////////////////////////////////
	private function initModel() : Void
	{
		_Model = Model.getInstance();
		_Model.addEventListener("modelComplete", this);
		_Model.init();
	}
	public function modelComplete() : Void
	{
		_Model.removeEventListener("modelComplete", this);
		setupAssets();
	}
	
	

	////////////////////////////////////////////////////////////////////////////
	// SETUP ASSETS
	////////////////////////////////////////////////////////////////////////////
	public function setupAssets( ) : Void
	{		 
		issue = Model.getInstance().issue;
		var temp: Array  = Model.getInstance().pages;	
		pages = new Array();
		for (var i:Number = 0; i< temp.length; i++) 
		{
			if ( temp[i].notInContents == false )
			{
				pages.push( temp[i] );
			}
			
		}
		
		menu_array  = new Array();
		loadingGroup = new LoadGroup();
		
		loadingGroup.addEventObserver(this, LoadGroup.EVENT_LOAD_COMPLETE, "onLoadComplete");
		loadingGroup.addEventObserver(this, LoadGroup.EVENT_LOAD_PERCENT, "onGroupLoadPercent");
		loadingGroup.addEventObserver(this, LoadGroup.EVENT_LOAD_ERROR, "onGroupLoadError");
			
		createPreviewClips();
		populateMenu();
		
	}

	////////////////////////////////////////////////////////////////////////////
	// Create Preview Clips
	////////////////////////////////////////////////////////////////////////////
	public function createPreviewClips() : Void
	{		
	    
		previews = this.createEmptyMovieClip('previews', 400);
		
		previews._x = PREVIEWX;
		previews._y = PREVIEWY;
			
		for (var i:Number = 0; i< pages.length; i++) 
		{
			var menu_ID  : Number = pages[i].id;
			var _id : String = menu_ID.toString();
			
			var pmc : MovieClip  = previews.attachMovie("PREVIEWMC", "pmc" + _id,  i);
			pmc._visible = false;
			
			//add image to load to queue
			var mediaLoad:MediaLoad = new MediaLoad(pmc.image_mc, pages[i].menu_image);
			loadingGroup.addLoad(mediaLoad);
			
			pmc.page_number_txt.text = _id;

			var ts : String = pages[i].contents_info;
			if ( ts == undefined )
			{
				//ts = pages[menu_ID].menu_title + " : " + pages[menu_ID].menu_info;
				ts = pages[i].menu_info;
			}
			
			pmc.info_txt.htmlText = ts;
			
			var io : Object = new Object();
			io.preview_mc = pmc;
			menu_array[menu_ID] = io;
		}

	}
	

	////////////////////////////////////////////////////////////////////////////
	// POPULATE MENU
	////////////////////////////////////////////////////////////////////////////
	private function populateMenu() : Void
	{		
		menu_mc = this.createEmptyMovieClip('menu_mc', 200);
		var menuItemX : Number = 0;
		var menuItemY : Number = 0;
		
		var spacex : Number = 23;
		var spacey : Number = 17;
		
		var maxNumber : Number  = 17;
		
		var numItems : Number  = ( pages.length) ;
		if ( numItems < maxNumber )
		{
			spacex = 23;
			spacey = 17;
		}
		else if ( numItems == 17 )
		{
			spacex = 23;
			spacey = 17;
			MENUX = 380;
			MENUY = 265;
			
		}
		else if ( numItems == 18 )
		{
			spacex = 21;
			spacey = 16;
			MENUY = 260;
		}
		else if ( numItems == 19 )
		{
			spacex = 21;
			spacey = 16;
			MENUX = 380;
			MENUY = 280;
		}
		else if ( numItems >= 20 )
		{
			spacex = 19;
			spacey = 16;
			MENUX = 375;
			MENUY = 285;
		}

		for (var i:Number = 0; i< pages.length; i++) 
		{
			var menu_ID  : Number = pages[i].id;
			var _id : String = menu_ID.toString();
			
			var item_container : MovieClip = menu_mc.createEmptyMovieClip('item_container'+_id, pages.length-i);
			item_container._visible = false;
			
			var menu_item : MovieClip  = item_container.attachMovie("contentsButtonMC", "menu_item" + _id,  2);
			
			//item_container._xscale = 92;
			//item_container._yscale = 96;
			
			menu_item.init(menu_ID);
			menu_item.addEventListener("onMenuItemOver", this);
			menu_item.addEventListener("onMenuItemOut", this);
			menu_item.addEventListener("onMenuItemClicked", this);
			
			//for black bg
			//TweenMax.to(menu_item, 0, {transformMatrix:{_xscale:80, _yscale:100, skewY:20}, dropShadowFilter:{color:0x000000, alpha:1, blurX:5, blurY:5, strength:0.5, angle:325, distance:5}});
			//for white bg
			//TweenMax.to(menu_item, 0, {transformMatrix:{_xscale:80, _yscale:100, skewY:20} });
		
			menu_item._x = menuItemX;
			menu_item._y = menuItemY;
			
			//load image
			var mediaLoad:MediaLoad = new MediaLoad(menu_item.image_mc, pages[i].contents_image);
			loadingGroup.addLoad(mediaLoad);
			
			//calculate next item position
			menuItemX = menu_item._x + spacex;
			menuItemY = menu_item._y - spacey;

			menu_array[menu_ID].item_container = item_container;
			menu_array[menu_ID].menu_item = menu_item;
		}
		
		menu_mc._x = MENUX;
		menu_mc._y = MENUY;
		
		loadingGroup.start();
	}

	////////////////////////////////////////////////////////////////////////////
	// LOADING EVENTS
	////////////////////////////////////////////////////////////////////////////
	public function onGroupLoadPercent(sender:LoadGroup, progress:Percent):Void 
	{
		tp = String( Math.ceil(progress.getPercentage()) );
		_parent.infodisplay.text = tp + " %";	
	}

	public function onGroupLoadError(sender:LoadGroup, failedLoad:BytesLoadInterface):Void 
	{
		loadingGroup.removeLoad(failedLoad);
		loadingGroup.start();
	}
	
	public function	onLoadComplete (sender:LoadGroup) : Void
	{
			_parent.gotoAndStop('loaded');
			TweenMax.to(this, .5, { _alpha:100 } );
			
			//populateMenuReflections();
			populateMenuReflectionsWhite();
			storeInitValues();
			showMenu(1.5);			
	}
	
	
	////////////////////////////////////////////////////////////////////////////
	// POPULATE MENU REFLECTIONS on a white bg - exception
	////////////////////////////////////////////////////////////////////////////
	private function populateMenuReflectionsWhite() : Void
	{		
		for (var i:Number = 0; i< pages.length; i++) 
		{
			var menu_ID  : Number = pages[i].id;
			var _id : String = menu_ID.toString();
			
			var item_container : MovieClip = menu_array[menu_ID].item_container;
			
			var menu_item : MovieClip  = menu_array[menu_ID].menu_item;
			menu_item.image_mc.forceSmoothing = true;
			menu_item.removeRef();
		
			var menu_ref : MovieClip = item_container.createEmptyMovieClip('menu_ref' + _id, 4);

			reflect(menu_item, menu_ref, 100, menu_item._width, menu_item._height);
			
			menu_ref._x = menu_item._x;
			menu_ref._y = menu_item._y + menu_item._height +2;
			
			TweenMax.to(menu_ref, 0, { transformMatrix:{_xscale:80, skewY:20}, blurFilter:{blurX:10, blurY:10, quality:1} });
			
			TweenMax.to(menu_item, 0, {transformMatrix:{_xscale:80, _yscale:100, skewY:20} });
	
			menu_array[menu_ID].menu_ref = menu_ref;
		}
		
	}	
	
	////////////////////////////////////////////////////////////////////////////
	// POPULATE MENU REFLECTIONS - original - for black bg
	////////////////////////////////////////////////////////////////////////////
	private function populateMenuReflections() : Void
	{		
		for (var i:Number = 0; i< pages.length; i++) 
		{
			var menu_ID  : Number = pages[i].id;
			var _id : String = menu_ID.toString();
			
			var item_container : MovieClip = menu_array[menu_ID].item_container;
			
			var menu_item : MovieClip  = menu_array[menu_ID].menu_item;
			menu_item.image_mc.forceSmoothing = true;
			
			var bdata : BitmapData = new BitmapData(menu_item._width+100, menu_item._height, true, 0);
			bdata.draw(menu_item);
		
			var menu_ref : MovieClip = item_container.createEmptyMovieClip('menu_ref' + _id, 4);
			menu_ref.attachBitmap(bdata, 0);
			menu_ref.cacheAsBitmap = true;
			
			TweenMax.to(menu_ref, 0, { transformMatrix:{_xscale:80, skewY:20, skewX:180}, blurFilter:{blurX:10, blurY:10, quality:1} });
			menu_ref._x = menu_item._x;
			menu_ref._y = menu_item._y + menu_item._height +85;
			
			menu_item.removeRef();
	
			menu_array[menu_ID].menu_ref = menu_ref;
		}
		
	}
	////////////////////////////////////////////////////////////////////////////
	// Store initial values of objects
	////////////////////////////////////////////////////////////////////////////
	private function storeInitValues(  ) : Void
	{	
		for (var i:Number = 0; i< pages.length; i++) 
		{
			var menu_ID  : Number = pages[i].id;
			var menu_item : MovieClip  = menu_array[menu_ID].menu_item;
			var menu_ref : MovieClip =  menu_array[menu_ID].menu_ref;
			setInitValues(menu_item);
			setInitValues(menu_ref);
		}
	}	
	
	////////////////////////////////////////////////////////////////////////////
	// Show menu - animate in
	////////////////////////////////////////////////////////////////////////////
	public function showMenu( _delayTime : Number ) : Void
	{	
		contact_mc.removeMovieClip();
		
		for (var i:Number = 0; i< pages.length; i++) 
		{
			var menu_ID  : Number = pages[i].id;
			var _id : String = menu_ID.toString();
			
			var item_container : MovieClip = menu_array[menu_ID].item_container;
			
			var menu_item : MovieClip  = menu_array[menu_ID].menu_item;
			var menu_ref : MovieClip =  menu_array[menu_ID].menu_ref;

			menu_item._y = menu_item.init._y - 550;
			menu_ref._y = menu_ref.init._y + 550;
			
			item_container._visible = true;
			
			TweenMax.to(menu_item, 1.2, { _y:menu_item.init._y, delay:_delayTime, ease:Cubic.easeOut, overwrite:true } );
			TweenMax.to(menu_ref, 1.2, {_y:menu_ref.init._y, delay:_delayTime, ease:Cubic.easeOut, overwrite:true });

			_delayTime += 0.1;
		}
		
		//TweenMax.delayedCall(_delayTime + 1.2, addContactButton, null, this);
		menu_mc.swapDepths(ee_logo_mc);
	}
	

	////////////////////////////////////////////////////////////////////////////
	// Set Page when menu item clicked
	///////////////////////////////////////////////////////////////////////////
	private function onMenuItemClicked( e : Object ) : Void
	{
		ID = e.target.ID;
		Tracker.trackClick(issue_name, "menu item clicked" + ID);
		_level0.application_mc.selectID(ID);
	}
	
	
	////////////////////////////////////////////////////////////////////////////
	// On Menu Item rollover
	///////////////////////////////////////////////////////////////////////////
	private function onMenuItemOver( e : Object ) : Void
	{
		var idd:Number = e.target.ID;
				
		var pmc : MovieClip = menu_array[idd].preview_mc;
		pmc._visible = true;
		cover_mc._visible = false;
		
		for (var i:Number = 1; i< idd; i++) 
		{
			var num:Number = idd-i;
			var menu_item : MovieClip = menu_array[num].item_container;
			TweenMax.to(menu_item, .5, {_alpha:0, overwrite:true});
		}
	}
	
	
	////////////////////////////////////////////////////////////////////////////
	// On Menu Item rollout
	///////////////////////////////////////////////////////////////////////////
	private function onMenuItemOut( e : Object ) : Void
	{
		var idd:Number = e.target.ID;
		
		var pmc : MovieClip = menu_array[idd].preview_mc;
		pmc._visible = false;
		cover_mc._visible = true;
		
		for (var i:Number = 1; i < idd; i++) 
		{
			var num:Number = idd-i;
			var menu_item : MovieClip = menu_array[num].item_container;
			TweenMax.to(menu_item, .5, {_alpha:100, overwrite:true});
		}
	}
	

	////////////////////////////////////////////////////////////////////////////
	//Add a special contact button
	///////////////////////////////////////////////////////////////////////////	
	private function addContactButton(): Void
	{
		contact_mc = this.attachMovie('getintouchmc', 'contact_mc', this.getNextHighestDepth(), { _x:780, _y:368, _alpha:0 } );
		TweenMax.to(contact_mc, 1, { _alpha:100, overwrite:true } );
		contact_mc.btn.onRelease = Delegate.create(this, gotoContactPage);
	}
	
	////////////////////////////////////////////////////////////////////////////
	// Go to contact page
	///////////////////////////////////////////////////////////////////////////	
	private function gotoContactPage(): Void
	{
		var temp: Array  = Model.getInstance().pages;
		var lastID : Number = temp.length-1;
		Tracker.trackClick(issue_name, 'get in touch link');
		_level0.application_mc.selectID(lastID);
	}

	////////////////////////////////////////////////////////////////////////////
	// Store an objects values
	////////////////////////////////////////////////////////////////////////////
	private function setInitValues(obj:Object):Void 
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
	// Reflect MC
	///////////////////////////////////////////////////////////////////////////	
	private function reflect(src, target, alpha, wi, he) :Void
	{
		removeMovieClip(target.refmc);
		removeMovieClip(target.rmask);
		
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
	

}