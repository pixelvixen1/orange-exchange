////////////////////////////////////////////////////////////////////////////////
// Project: Orange Exchange issue 36
// FileName: Application.as
// Created by: Angel 
// LAST UPDATE : 19 march 2013
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// IMPORTS
////////////////////////////////////////////////////////////////////////////////
import mx.events.EventDispatcher;
import mx.utils.Delegate;

import exchange.model.Model;
import exchange.view.MenuItem;

import org.casalib.load.LoadGroup;
import org.casalib.load.media.MediaLoad;
import org.casalib.load.base.LoadInterface;
import org.casalib.math.Percent;
import org.casalib.load.base.BytesLoadInterface;

import SWFAddress;
import SWFAddressEvent;

import com.greensock.TweenMax;
//import com.greensock.easing.*;
//import com.greensock.plugins.*;

////////////////////////////////////////////////////////////////////////////////
// CLASS: APPLICATION 
////////////////////////////////////////////////////////////////////////////////
class exchange.Application extends MovieClip
{
	////////////////////////////////////////////////////////////////////////////
	// Properties
	////////////////////////////////////////////////////////////////////////////
	private static var instance			: Application;
	public var _Model					: Model;
	public var ID						: Number = 1;
	public var issue 					: String;
	public var siteTitle				: String;
	
	public var plansPlayedOnce 			: Boolean = false;

	public var loadingGroup 			: LoadGroup;
	private var tp 						: String;
	private var menu_array 				: Array;
	private var pages	 				: Array;
	
	//Assets
	public var container				: MovieClip;
	public var contents_mc				: MovieClip;
	public var first_btn				: Button;
	public var last_btn					: Button;
	public var previous_btn				: Button;
	public var next_btn					: Button;
	
	public var sectionLoader_mc			: MovieClip;
	public var loadProgress				: String;
	public var progress_textfield		: TextField;
	private var sectionLoad				: MediaLoad;
	
	private var menuY					: Number = 570;
	private var menuHeight				: Number = 40;

	// Dispatch
	public var addEventListener			: Function; 
	public var removeEventListener		: Function; 
	public var dispatchEvent			: Function;

	////////////////////////////////////////////////////////////////////////////
	// Constructor
	////////////////////////////////////////////////////////////////////////////
	public function Application()
	{		
		EventDispatcher.initialize(this);
	}

	////////////////////////////////////////////////////////////////////////////
	// Return singleton instance of Application
	///////////////////////////////////////////////////////////////////////////	
	public static function getInstance() : Application 
	{
		return instance;
	}
	
	////////////////////////////////////////////////////////////////////////////
	// On Load
	///////////////////////////////////////////////////////////////////////////
	public function onLoad() : Void
	{
		instance = _level0.application_mc;
		initModel();
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
	
	///////////////////////////////////////////////////////////////////////////////////
	// MODEL COMPLETE
	//////////////////////////////////////////////////////////////////////////////////
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
		siteTitle = Model.getInstance().siteTitle;
		
		loadingGroup = new LoadGroup();
		loadingGroup.addEventObserver(this, LoadGroup.EVENT_LOAD_COMPLETE, "onLoadComplete");
		loadingGroup.addEventObserver(this, LoadGroup.EVENT_LOAD_PERCENT, "onGroupLoadPercent");
		loadingGroup.addEventObserver(this, LoadGroup.EVENT_LOAD_ERROR, "onGroupLoadError");
		
		createMainContainer();
		populateMenu();

		//after creating menu items and adding images to load group, start the loading process
		startLoadingProcess();
		
		renderControls();
		setupSWFAddress( );
	}
	////////////////////////////////////////////////////////////////////////////
	// LOADING EVENTS
	////////////////////////////////////////////////////////////////////////////
	public function onGroupLoadPercent(sender:LoadGroup, progress:Percent):Void 
	{
		tp = String( Math.ceil(progress.getPercentage()) );
		_level0.infodisplay.text = tp + " %";	
	}

		
	////////////////////////////////////////////////////////////////////////////
	// Start the Loading process
	////////////////////////////////////////////////////////////////////////////
	private function startLoadingProcess() : Void
	{
		loadingGroup.start();
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
	public function	onLoadComplete (sender:LoadGroup) : Void
	{
			loadingGroup.removeAllEventObservers();
			
			_level0.gotoAndStop('loaded');
			TweenMax.to(this, .5, { _alpha:100 } );
			
			contents_mc.loadMovie( pages[1].swf_location );
			
			checkButtons( );
			
			tp = '';
			
			
	}
	
	
	////////////////////////////////////////////////////////////////////////////
	//  Create container to load pages into
	////////////////////////////////////////////////////////////////////////////
	private function createMainContainer( ) : Void
	{		 
		contents_mc = this.createEmptyMovieClip("contents_mc", 10);
		contents_mc._x = 0;
		contents_mc._y = -18;
		
		container = this.createEmptyMovieClip("container", 20);
		container._x = 0;
		container._y = -18;
	}


	/////////////////////////////////////////////////////////////////////////////////////////////////
	// POPULATE MENU - Number buttons will be created at the bottom of the stage
	/////////////////////////////////////////////////////////////////////////////////////////////////
	private function populateMenu() : Void
	{		
		var menu_mc : MovieClip = this.createEmptyMovieClip('menu_mc', 200);
		menu_mc._y = menuY;
		var menuItemX : Number = 0;
		
		menu_array  = new Array();
		pages = Model.getInstance().pages;		
		
		for (var i:Number = 1; i< pages.length; i++) 
		{
			var menu_ID  : Number = i;
			var menu_item : MovieClip  = menu_mc.attachMovie("number_button_template", "menu_item" + (i.toString()), i);
			
			menu_item.init(menu_ID);
			menu_item.addEventListener("onMenuItemClicked", this);
			
			menu_item._x = menuItemX;
			menu_item._y = 0;

			menuItemX += Number(menu_item._width);
			
			menu_array[i] = menu_item;
			
			( i == pages.length - 1) ? menu_item.hideLine() : null;
		}
		
		//center menu on screen
		var start_pos_x : Number = Math.floor(previous_btn._x + previous_btn._width);
		var end_pos_x : Number = Math.floor(next_btn._x); 
		var available_space : Number = end_pos_x - start_pos_x; 
		
		menu_mc._x = Math.floor( (  start_pos_x + (available_space / 2)  ) - ( menu_mc._width / 2) );
		
		createThumbs();
		
	}
	

	
	///////////////////////////////////////////////////////////////////////////////////////////////////////
	// Create thumbnails for the menu items - load all thumbnail images with a group load
	///////////////////////////////////////////////////////////////////////////////////////////////////////	
	private function createThumbs() : Void
	{			
		for (var i:Number = 1; i< pages.length; i++) 
		{
			var menu_ID  : Number = i;
			var menu_item : MovieClip  = menu_array[i];
			menu_item.createThumbnail();
			
			//load image
			var mediaLoad:MediaLoad = new MediaLoad(menu_item.thumb_mc.img_holder, pages[menu_ID].menu_image);
			loadingGroup.addLoad(mediaLoad);
		}
	}
	
	
	////////////////////////////////////////////////////////////////////////////
	// Set Page Screen when menu item clicked
	///////////////////////////////////////////////////////////////////////////
	private function onMenuItemClicked( e : Object ) : Void
	{
		ID = e.target.ID;
		selectID(ID);
	}
	
	////////////////////////////////////////////////////////////////////////////
	// CHECK WHICH BUTTON SELECTED
	///////////////////////////////////////////////////////////////////////////
	private function checkButtons( ) : Void
	{
		for (var i:Number = 1; i < menu_array.length; i++) 
		{
			var num_button : MovieClip = menu_array[i];
			var buttonID   : Number = num_button.ID;
			
			if(buttonID != ID)
			{
				num_button.unSelectButton();
			}
			else if(buttonID == ID)
			{
				num_button.selectButton();
			}
		}
	}
	
	////////////////////////////////////////////////////////////////////////////
	// Set Page Screen
	///////////////////////////////////////////////////////////////////////////
	public function selectID( _id : Number ) : Void
	{
		ID = _id;
		checkButtons( );
		loadPage(ID);
			
		Tracker.trackClick('pagination', pages[ID].name);
	}	
	
	////////////////////////////////////////////////////////////////////////////
	// Load page by ID
	////////////////////////////////////////////////////////////////////////////
	private function loadPage( pageID : Number ) : Void
	{		 
		sectionLoader_mc.removeMovieClip();
		sectionLoad.destroy();
		TweenMax.killAll();
		
		if ( pageID == 1 )
		{
			container.unloadMovie();
			
			contents_mc._y = -18;
			contents_mc._alpha = 0;
			contents_mc._visible = true;
			TweenMax.to(contents_mc, .5, {_alpha:100, delay:.2 });
			contents_mc.contents_mc.showMenu(1.2);
		}
		else
		{
			//contents page
			contents_mc._visible = false;
			contents_mc._y = 1000;
			
			//section
			container.unloadMovie();
			loadPageSWF( container, pages[pageID].swf_location, true );
			container.gotoAndStop(1);
			
		}
		
		var urlValue : String = pages[pageID].name;
		SWFAddress.setValue("/"+urlValue+"/");
	}
	
	////////////////////////////////////////////////////////////////////////////
	// LOAD NEW PAGE SWF AND DISPLAY PROGRESS
	////////////////////////////////////////////////////////////////////////////
	private function loadPageSWF(_targetMC : MovieClip, _loadURL : String, _hideUntilLoaded : Boolean ) :  Void
	{
		sectionLoad = new MediaLoad( _targetMC, _loadURL, _hideUntilLoaded );
		
		sectionLoad.addEventObserver(this, MediaLoad.EVENT_LOAD_COMPLETE, "onSectionLoadComplete");
		sectionLoad.addEventObserver(this, MediaLoad.EVENT_LOAD_PROGRESS, "onSectionLoadPercent");
		sectionLoad.addEventObserver(this, MediaLoad.EVENT_LOAD_ERROR, "onSectionLoadError");
		
		sectionLoader_mc = this.attachMovie('site_loader', 'sectionLoader_mc', this.getNextHighestDepth(), { _x:380, _y:250 } );

		sectionLoad.start();
	}
	
	////////////////////////////////////////////////////////////////////////////
	// On Group Loading event - get the amount loaded and display in textfield
	////////////////////////////////////////////////////////////////////////////	
	public function onSectionLoadPercent(sender:MediaLoad, bytesLoaded:Number, bytesTotal:Number):Void 
	{
		loadProgress = String( Math.ceil( bytesLoaded/bytesTotal * 100) );
		sectionLoader_mc.load_info_txt.text = loadProgress + " %";
		container.gotoAndStop(1);
	}
	
	////////////////////////////////////////////////////////////////////////////////
	// If there is an Loading error then remove the data continue and keep loading
	//////////////////////////////////////////////////////////////////////////////////
	public function onSectionLoadError(sender:MediaLoad, failedLoad:BytesLoadInterface):Void 
	{
		sectionLoad.destroy();
		trace('-------onSectionLoadError-----'+failedLoad);
		loadPage(1);
	}
	////////////////////////////////////////////////////////////////////////////
	// On Group Load Complete - 
	////////////////////////////////////////////////////////////////////////////	
	public function	onSectionLoadComplete(sender:MediaLoad) : Void
	{
			sectionLoader_mc.removeMovieClip();
			sectionLoad.destroy();	
			container.gotoAndStop(1);
			TweenMax.delayedCall(1, initLoadedSection, null, this);
	}	
	
	////////////////////////////////////////////////////////////////////////////
	// On Group Load Complete - 
	////////////////////////////////////////////////////////////////////////////	
	public function	initLoadedSection( ) : Void
	{
		container.gotoAndPlay(2);
	}	
	
	////////////////////////////////////////////////////////////////////////////
	// Render Controls
	////////////////////////////////////////////////////////////////////////////
	private function renderControls() :  Void
	{
		first_btn.onRelease = Delegate.create(this, getFirstPage);
		last_btn.onRelease = Delegate.create(this, getLastPage);
		previous_btn.onRelease = Delegate.create(this, getPreviousScreen);
		next_btn.onRelease = Delegate.create(this, getNextScreen);
	}

	////////////////////////////////////////////////////////////////////////////
	// Get first page
	////////////////////////////////////////////////////////////////////////////
	private function getFirstPage() :  Void
	{
		selectID(1);
	}
		
	////////////////////////////////////////////////////////////////////////////
	// Get last page
	////////////////////////////////////////////////////////////////////////////
	private function getLastPage() :  Void
	{
		selectID(pages.length-1);
	}	
	////////////////////////////////////////////////////////////////////////////
	// Get Next Screen
	////////////////////////////////////////////////////////////////////////////
	public function getNextScreen() : Void
	{
		(ID < pages.length-1) ? ID++ : ID = 1;
		selectID(ID);
	}
	////////////////////////////////////////////////////////////////////////////
	// Get Previous Screen
	////////////////////////////////////////////////////////////////////////////
	public function getPreviousScreen() : Void
	{
		(ID > 1) ? 	ID-- : ID = pages.length-1;
		selectID(ID);
	}
			
	////////////////////////////////////////////////////////////////////////////
	// Set up SWF Address
	////////////////////////////////////////////////////////////////////////////
	private function setupSWFAddress( ) : Void
	{		 
		SWFAddress.setStrict(false);
		SWFAddress.onChange = Delegate.create(this, changePageFromSWFaddress);
	
	}
	////////////////////////////////////////////////////////////////////////////
	// On SWFAdress event change
	////////////////////////////////////////////////////////////////////////////	
	private function changePageFromSWFaddress( ) : Void
	{		 
		var value : String;
		value = SWFAddress.getValue();
		
		var pageNameId : String = value.substr(1, value.length - 2);
		var pn_array:Array = pageNameId.split("_"); 
		var page_title : String = pn_array.join(" ");
		//page_title = page_title.substr(0, 1).toUpperCase() + page_title.substr(1);
		
	
		if ( page_title.length > 1 )
		{
			var title : String  = siteTitle +" | " + page_title;
			SWFAddress.setTitle(title);
		}
		else
		{
			SWFAddress.setTitle(siteTitle);
		}
		
		for (var i:Number = 1; i < pages.length; i++) 
		{
			if (pages[i].name == pageNameId)
			{
				var nameID : Number = pages[i].id;
				
				if ( nameID != ID )
				{
					ID = pages[i].id;
					selectID(ID);
				}
				
			}
				
		}

	}
	
	////////////////////////////////////////////////////////////////////////////
	// Set if plans page has played once
	////////////////////////////////////////////////////////////////////////////
	public function setPlansPlayed( _boolean : Boolean ) : Void
	{
		plansPlayedOnce = _boolean;
	}
	


}