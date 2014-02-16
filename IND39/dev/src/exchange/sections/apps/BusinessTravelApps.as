////////////////////////////////////////////////////////////////////////////////
// Project: Orange Exchange issue 39
// FileName: BusinessTravelApps.as
// Created by: Angel 
// updated : 20 January 2014
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// IMPORTS
////////////////////////////////////////////////////////////////////////////////
import mx.data.types.Int;
import mx.events.EventDispatcher;
import mx.utils.Delegate;

import exchange.data.StructureXML;
import exchange.data.XMLDeserializer;
import exchange.model.Model;

import com.greensock.TweenMax;
import com.greensock.easing.*;

import exchange.utils.LoadUtil;
import exchange.sections.apps.ImageSlideShow;

////////////////////////////////////////////////////////////////////////////////
// CLASS: BusinessTravelApps 
////////////////////////////////////////////////////////////////////////////////
class exchange.sections.apps.BusinessTravelApps extends MovieClip
{
	
	////////////////////////////////////////////////////////////////////////////
	// PROPERTIES
	////////////////////////////////////////////////////////////////////////////
	private static var instance			: BusinessTravelApps;
	public var _Model					: Model;
	public var page_name 				: String;  		//this is set onstage
	
	//XML
	public var xmlLocation				: String = "xml/business_apps.xml";
	public var structureXML				: StructureXML;
	public var xmlRootNode				: XMLNode;
	public var xmlObj					: Object;
	
	//DATA
	public var sections					: Array;
	public var sections_data			: Array;
	public var items					: Array;
	public var numOfItems 				: Number;
	public var numOfSections			: Number = 4;
	public var settingsVO				: Object;
	public var name_array				: Array;
			
	//VARIABLES
	private var SELECTED_SECTION		: Number  = 0;
	private var SELECTED_APP			: Number = 0;
	private var numinc					: Number = 1;
	private var phoneID					: Number = 1;
	
	//STAGE ASSETS
	public var main_menu_mc				: MovieClip;
	public var phone_mc					: MovieClip;
	public var slideshow_mc				: MovieClip;
	public var apps_container			: MovieClip;
	public var app_menu_mc 				: MovieClip;
	public var app_info_mc 				: MovieClip;
	public var old_info_mc 				: MovieClip;	
	public var tooltip_mc 				: MovieClip;
	
	public var sub_cta_mc				: MovieClip;
	public var mbb_mc					: MovieClip;
	
	// POSITIONS
	private var APP_MENU_X				: Number = 0;
	private var APP_MENU_Y				: Number = 0;
	private var APP_INFO_X				: Number = 193;
	private var APP_INFO_Y				: Number = 0;
	private var PHONE_OFF_X				: Number = 980;
	private var PHONE_ON_X				: Number = 734;

	// DISPATCH
	public var addEventListener			: Function; 
	public var removeEventListener		: Function; 
	public var dispatchEvent			: Function;	
	////////////////////////////////////////////////////////////////////////////
	// Constructor
	////////////////////////////////////////////////////////////////////////////
	public function BusinessTravelApps()
	{		
		EventDispatcher.initialize(this);
	}
	
	public static function getInstance() : BusinessTravelApps 
	{
		return instance;
	}
	
	
	////////////////////////////////////////////////////////////////////////////
	// On Load
	///////////////////////////////////////////////////////////////////////////
	public function onLoad() : Void
	{
		instance = this;
		if (_level0.application_mc)
		{
			_Model = Model.getInstance();
			initPage();
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
		initPage();
	}	
	
	
	////////////////////////////////////////////////////////////////////////////
	// Initialise
	///////////////////////////////////////////////////////////////////////////
	private function initPage() : Void
	{
		loadXMLData();
		findObjects(this);
		phone_mc._x = PHONE_OFF_X;
		//hideMenuButtons();
		
		name_array = new Array();
		name_array[0] = "PLAN_YOUR_DIARY";
		name_array[1] = "INVENTORY_APPS";
		name_array[2] = "MANAGE_YOUR_CONTACTS";
		name_array[3] = "PROJECT/DATA_MANAGEMENT";
		name_array[5] = "BUSINESS_FINANCE";
		
		

	}
	
	////////////////////////////////////////////////////////////////////////////
	// Load XML Data
	////////////////////////////////////////////////////////////////////////////
	private function loadXMLData() : Void
	{
		structureXML = new StructureXML();
		structureXML.addEventListener("structureXMLLoaded", this);
		structureXML.loadXMLfile( xmlLocation );
	}

	////////////////////////////////////////////////////////////////////////////
	// Store XML Data when xml loaded
	///////////////////////////////////////////////////////////////////////////	
	private function structureXMLLoaded() : Void
	{
		var userXML : XML = structureXML.XMLDoc;
		xmlRootNode = userXML;
		xmlObj = XMLDeserializer.getDeserialisedXML( userXML );
		storeAppSections( );
		showMainMenu();
	}
	
	////////////////////////////////////////////////////////////////////////////
	// Structure data
	////////////////////////////////////////////////////////////////////////////
	private function structureData( ) : Void
	{		
		items = new Array();
		numOfItems = xmlObj.data.section.app.length;
		
		for (var i : Number = 0; i < numOfItems; i++) 
		{
			var node_data:Object = new Object();
			node_data.xmlObj = XML(xmlObj.data.section.app[i]);
			items[i] = xmlObj.data.section.app[i];	
		}
	}	
	
	////////////////////////////////////////////////////////////////////////////
	// Store the app sections data
	////////////////////////////////////////////////////////////////////////////
	private function storeAppSections( ) : Void
	{		
		sections = new Array();
		
		numOfSections = xmlObj.data.section.length;
		
		for (var i : Number = 0; i < numOfSections; i++) 
		{
			sections[i] = xmlObj.data.section[i];	
		}
	}	

	////////////////////////////////////////////////////////////////////////////
	// ---------------------  Main menu functions ---------------------------//
	///////////////////////////////////////////////////////////////////////////
	private function showMainMenu():Void
	{
		disableMainMenu();
		main_menu_mc.open_button._visible = false;
		TweenMax.to(main_menu_mc, 0, { _x:26, ease:Cubic.easeOut, onComplete:enableMainMenu, onCompleteScope:this }  );
		
		for (var i : Number = 0; i < numOfSections; i++) 
		{
			var menuItemButton : MovieClip = this.main_menu_mc['menu_item' + i];
			menuItemButton._x = -350;
			
			TweenMax.to(menuItemButton, 1, { _x:0, ease:Cubic.easeOut, delay:i/4} );
		}
	}	


	////////////////////////////////////////////////////////////////////////////
	// Enable main menu
	////////////////////////////////////////////////////////////////////////////	
	private function enableMainMenu() : Void
	{
		for (var i : Number = 0; i < numOfSections; i++) 
		{
			var menuItemButton : MovieClip = this.main_menu_mc['menu_item' + i];
			menuItemButton.enabled = true;
			var mb = menuItemButton.onRelease = Delegate.create(this, mainMenuClicked);
			mb.id = i;
			menuItemButton.id = i;
			
			var mo = menuItemButton.onRollOver = Delegate.create(this, mainMenuOver);
			mo.mc = menuItemButton;
			
			var ma = menuItemButton.onRollOut = Delegate.create(this, mainMenuOut);
			ma.mc = menuItemButton;
		}

	}
	
	////////////////////////////////////////////////////////////////////////////
	// On menu button over
	////////////////////////////////////////////////////////////////////////////
	private function mainMenuOver():Void
	{
		var mc = arguments.caller.mc;
		TweenMax.to(mc.icon_mc, 1, {_xscale:150, _yscale:150, ease:Cubic.easeOut});
		TweenMax.to(mc.bg, 1, {colorMatrixFilter:{brightness:3}, ease:Cubic.easeOut});
	}
	////////////////////////////////////////////////////////////////////////////
	// On menu button out
	////////////////////////////////////////////////////////////////////////////
	private function mainMenuOut():Void
	{
		var mc = arguments.caller.mc;
		TweenMax.to(mc.bg, 1, { colorMatrixFilter: { brightness:1 }, ease:Cubic.easeOut } );
		TweenMax.to(mc.icon_mc, 1, {_xscale:mc.icon_mc.init._xscale, _yscale:mc.icon_mc.init._yscale, ease:Cubic.easeOut});
	}
	////////////////////////////////////////////////////////////////////////////
	// Disable the main menu
	////////////////////////////////////////////////////////////////////////////
	private function disableMainMenu() : Void
	{
		for (var i : Number = 0; i < numOfSections; i++) 
		{
			var menuItemButton : MovieClip = this.main_menu_mc['menu_item'+i];
			menuItemButton.enabled = false;
			TweenMax.to(menuItemButton.bg, 0, { colorMatrixFilter: { brightness:1 }, ease:Cubic.easeOut } );
			TweenMax.to(menuItemButton.icon_mc, 0, {_xscale:100, _yscale:100, ease:Cubic.easeOut});
		}
	}
	////////////////////////////////////////////////////////////////////////////
	// On menu item clicked
	////////////////////////////////////////////////////////////////////////////
	private function mainMenuClicked():Void
	{
		SELECTED_SECTION = arguments.caller.id;
		hideMainMenu();
	}

	////////////////////////////////////////////////////////////////////////////
	// Hide the main menu buttons when app screen is open
	////////////////////////////////////////////////////////////////////////////
	private function hideMainMenu():Void
	{
		disableMainMenu();
		//TweenMax.to(main_menu_mc, 1, { _x: -550, ease:Cubic.easeOut, onComplete:menuHiddenComplete, onCompleteScope:this }  );
		
		var dd : Number = 0;
		for (var i : Number = 0; i < numOfSections; i++) 
		{
			var menuItemButton : MovieClip = this.main_menu_mc['menu_item' + i];
			dd = i / 10;
			TweenMax.to(menuItemButton, .5, { _x:-350, ease:Cubic.easeOut, delay:dd} );
		}
		
		TweenMax.to(main_menu_mc, 0, { _x: -550, ease:Cubic.easeOut,  delay:.5 + dd, onComplete:menuHiddenComplete, onCompleteScope:this }  );		
		
	}

	////////////////////////////////////////////////////////////////////////////////////////////////
	// On animation of hiding menu complete, show the open menu button and build app page
	////////////////////////////////////////////////////////////////////////////////////////////////	
	private function menuHiddenComplete() : Void
	{
		main_menu_mc.open_button._visible = true;
		main_menu_mc.open_button.onRelease = Delegate.create(this, closeSection);
		main_menu_mc.open_button.onRollOver = Delegate.create(this, addMenuTooltip);
		main_menu_mc.open_button.onRollOut = Delegate.create(this, removeMenuTooltip);
		
		TweenMax.to(main_menu_mc, 1, { _x: -500, ease:Cubic.easeOut, delay:1.5 }  );
		openAppSection(SELECTED_SECTION);
	}
	
	////////////////////////////////////////////////////////////////////////////
	// Hide the menu buttons to animate in
	///////////////////////////////////////////////////////////////////////////	
	private function hideMenuButtons():Void
	{
		for (var i : Number = 0; i < numOfSections; i++) 
		{
			var menuItemButton : MovieClip = this.main_menu_mc['menu_item' + i];
			TweenMax.to(menuItemButton, 0, { _x: -500 }  );
		}
	}

	////////////////////////////////////////////////////////////////////////////
	// Add a tooltip to the open menu button
	////////////////////////////////////////////////////////////////////////////
	private function addMenuTooltip():Void
	{
		removeMenuTooltip();
		tooltip_mc = this.attachMovie('tooltip', 'tooltip_mc', this.getNextHighestDepth(), { _alpha:0 } );
		tooltip_mc._x = (_xmouse - tooltip_mc._width / 2 + 10 - tooltip_mc._x) / 2;
		tooltip_mc._y = (_ymouse + 30-tooltip_mc._y)/2;
		this.onEnterFrame = Delegate.create(this, setTooltipPosition);
		TweenMax.to(tooltip_mc, .6, {_alpha:100});
	}
	////////////////////////////////////////////////////////////////////////////
	// Remove Tooltip
	////////////////////////////////////////////////////////////////////////////			
	private function removeMenuTooltip():Void
	{
		tooltip_mc.removeMovieClip();
		this.onEnterFrame = null;
	}

	////////////////////////////////////////////////////////////////////////////
	//Set the tooltip position depending on Mouse Move
	////////////////////////////////////////////////////////////////////////////
	private function setTooltipPosition():Void
	{
		tooltip_mc._x += (_xmouse - tooltip_mc._width / 2 + 10 - tooltip_mc._x) / 2;
		tooltip_mc._y += (_ymouse + 30-tooltip_mc._y)/2;

			if(tooltip_mc._x < 0) 
			{
				tooltip_mc._x = 0;
			}
			if (tooltip_mc._y + tooltip_mc._height > 500) 
			{
				tooltip_mc._y = 500-tooltip_mc._height;
			}
	}	

	////////////////////////////////////////////////////////////////////////////
	// Open an apps section
	///////////////////////////////////////////////////////////////////////////	
	private function openAppSection( appSectionID : Number ):Void
	{
		SELECTED_SECTION = appSectionID;
		createAppsMenu( SELECTED_SECTION );
		TweenMax.delayedCall(.1, createAppsInfoPage, [], this );
		Tracker.trackClick(page_name, name_array[SELECTED_SECTION]);
	}		
	

	////////////////////////////////////////////////////////////////////////////
	// Open Mobile Business Banking apps section // Exception
	///////////////////////////////////////////////////////////////////////////		
	private function openMobileBusinessBankingSection():Void
	{
		mbb_mc = this.attachMovie("MBB_MC", "mbb_mc", this.getNextHighestDepth(), { _x:980, _y:155 } );
		
		TweenMax.to(main_menu_mc, .5, { autoAlpha:0 } );
		TweenMax.to(phone_mc, .5, { autoAlpha:0 } );
		TweenMax.to(apps_container, .5, { autoAlpha:0 } );
		TweenMax.to(mbb_mc, 1, { _x:18, ease:Cubic.easeOut, delay:0 } );
		
		mbb_mc.close_btn.onRelease = Delegate.create(this, closeMobileBusinessBankingSection);
		
		Tracker.trackClick(page_name, "MOBILE_BUSINESS_BANKING");
	}	
		
	
	////////////////////////////////////////////////////////////////////////////
	// Close Mobile Business Banking apps section // Exception
	///////////////////////////////////////////////////////////////////////////		
	private function closeMobileBusinessBankingSection():Void
	{
		TweenMax.to(mbb_mc, 1, { _x:980, ease:Cubic.easeInOut, delay:0, onComplete:removeMovieClip, onCompleteParams:[mbb_mc], onCompleteScope:mbb_mc } );
		TweenMax.to(main_menu_mc, .5, { autoAlpha:100, delay:0.8 } );
		TweenMax.to(phone_mc, .5, {  autoAlpha:100, delay:0.8  } );
		TweenMax.to(apps_container, .5, {  autoAlpha:100, delay:0.8  } );
	}	
	

	////////////////////////////////////////////////////////////////////////////
	// Create the siderbar APPS MENU for the selected section
	///////////////////////////////////////////////////////////////////////////	
	private function createAppsMenu( appSectionID : Number ):Void
	{
		SELECTED_SECTION = appSectionID;
		
		//create a new menu
		app_menu_mc = apps_container.attachMovie('APP_MENU', 'app_menu_mc', apps_container.getNextHighestDepth(), {_x:-550, _y:APP_MENU_Y} );

		//Create the menu items
		var numOfApps : Number = sections[SELECTED_SECTION].app.length;
		var appButtonY : Number = 10;
		
		for (var i : Number = 0; i < numOfApps; i++) 
		{
			// get app data for menu item
			var appXML = sections[SELECTED_SECTION].app[i];
			
			//create a menu button for the app
			var app_button : MovieClip = app_menu_mc.attachMovie('APP_MENU_ITEM', 'app_button'+i, i+1, {_x:8, _y:appButtonY});
			app_button.id = i;
			
			//format button title with app name
			formatText(app_button.app_name_txt, appXML.menu_title, true);
			(app_button.app_name_txt.textHeight > 20) ? app_button.app_name_txt._y = app_button.app_name_txt._y - 6 : null;
	
			
			//load app image icon
			var imgURL : String = appXML.menu_icon;
			if (imgURL != undefined )
			{
				var loaderU : LoadUtil = new LoadUtil();
				loaderU.loadItem(app_button.icon_holder, imgURL);
				//loaderU.addEventListener('itemFullyLoaded', this);
			}
			
			//make the app a button with an id
			var abtn = app_button.onRelease = Delegate.create(this, appButtonClicked);
			abtn.id = i;
			
			//increment Y vertical position of next app button
			(numOfApps > 5) ? appButtonY += 48 : appButtonY += 60;
		}
		
		
		//--------exception for mobile banking in issue 39  --------------//
		if (SELECTED_SECTION == 4)
		{
			sub_cta_mc = app_menu_mc.attachMovie('mbbCTA_mc', 'sub_cta_mc', app_menu_mc.getNextHighestDepth(), { _x:12, _y:210 } );
			sub_cta_mc.onRelease = Delegate.create(this, openMobileBusinessBankingSection);
		}
		
		//TweenMax.to(phone_mc, 1, { _x:PHONE_ON_X, ease:Cubic.easeOut }  );	
		TweenMax.to(app_menu_mc, 1.5, { _x:APP_MENU_X, _y:APP_MENU_Y, ease:Cubic.easeOut }  );	
		
	}	
	
	////////////////////////////////////////////////////////////////////////////
	// On App Button clicked from apps menu
	////////////////////////////////////////////////////////////////////////////
	private function appButtonClicked():Void
	{		
		if (SELECTED_APP != arguments.caller.id)
		{
			SELECTED_APP = arguments.caller.id;
			createAppsInfoPage( );
		}
	}
	////////////////////////////////////////////////////////////////////////////
	// Create App Information page
	///////////////////////////////////////////////////////////////////////////	
	private function createAppsInfoPage( ):Void
	{
		//increment this number always so it is unique -  used to create the ID for the app page
		numinc++;
		
		//assign the current app page to a variable
		old_info_mc = app_info_mc;
		
		//create the new app page
		var app_mc : MovieClip = apps_container.attachMovie('APPS_INFO_PAGE', 'app_info_mc_'+numinc, apps_container.getNextHighestDepth(), {_x:905, _y:APP_INFO_Y} );
		app_info_mc = app_mc;
		
		//Get data for selected app
		var appXML = sections[SELECTED_SECTION].app[SELECTED_APP];

		//format app text
		formatText(app_mc.app_title_txt, appXML.app_name, true);
		formatText(app_mc.app_header_txt, appXML.app_header, true);
		formatText(app_mc.app_info_txt, appXML.app_info, true);
		app_mc.app_info_txt._y = Math.round(app_mc.app_header_txt._y + app_mc.app_header_txt.textHeight + 10);
		
		if (appXML.app_header == undefined)
		{
			formatText(app_mc.app_header_txt, "", true);
			app_mc.app_info_txt._y = Math.round(app_mc.app_title_txt._y + app_mc.app_title_txt.textHeight + 10);	
		}
	
		//load app image icon
		var imgURL : String = appXML.app_icon;
		if (imgURL != undefined )
		{
				var loaderU : LoadUtil = new LoadUtil();
				loaderU.loadItem(app_mc.icon_holder, imgURL);
				//loaderU.addEventListener('itemFullyLoaded', this);
		}
			
		sortAppLinks(app_mc, appXML);
		
		//select which type of phone to view the slideshow images in
		var app_phone_id : Number = appXML.phoneID;
		selectPhone(app_phone_id);

		var tt : String = name_array[SELECTED_SECTION] + "/" + appXML.name;
		Tracker.trackClick(page_name, tt);
	}
	
	////////////////////////////////////////////////////////////////////////////
	// sort the app link buttons
	////////////////////////////////////////////////////////////////////////////
	private function sortAppLinks( app_mc : MovieClip, appXML : Object ):Void
	{
		var xpos : Number = 153;
		var numOfLinks : Number = 0;
		
		if(appXML.app_availability.android.length > 4)
		{
			app_mc.android_link.filters = null;
			var al = app_mc.android_link.onRelease = Delegate.create(this, getAppLink);
			al.link = appXML.app_availability.android;
			app_mc.android_link._x = xpos;
			xpos += 60;
			numOfLinks++;
		}
		else
		{
			app_mc.android_link._visible = false;
		}
		
		if(appXML.app_availability.ios.length > 4)
		{
			app_mc.ios_link.filters = null;
			var al = app_mc.ios_link.onRelease = Delegate.create(this, getAppLink);
			al.link = appXML.app_availability.ios;
			app_mc.ios_link._x = xpos;
			xpos += 60;
			numOfLinks++;
		}
		else
		{
			app_mc.ios_link._visible = false;
		}
		
		if(appXML.app_availability.windows.length > 4)
		{
			app_mc.windows_link.filters = null;
			var al = app_mc.windows_link.onRelease = Delegate.create(this, getAppLink);
			al.link = appXML.app_availability.windows;
			app_mc.windows_link._x = xpos;
			xpos += 60;
			numOfLinks++;
		}
		else
		{
			app_mc.windows_link._visible = false;
		}
		
		if(appXML.app_availability.blackberry.length > 4)
		{
			app_mc.bb_link.filters = null;
			var al = app_mc.bb_link.onRelease = Delegate.create(this, getAppLink);
			al.link = appXML.app_availability.blackberry;
			app_mc.bb_link._x = xpos;
			xpos += 60;
			numOfLinks++;
		}
		else
		{
			app_mc.bb_link._visible = false;
		}
		
		if (numOfLinks > 1)
		{
			app_mc.info_txt.text = "click on icons below to link through to app";
		}
		else
		{
			app_mc.info_txt.text = "click on icon below to link through to app";
		}
		
	}

	////////////////////////////////////////////////////////////////////////////
	// Get the app link for all platforms
	////////////////////////////////////////////////////////////////////////////
	private function getAppLink():Void
	{
		var url : String = arguments.caller.link;
		Tracker.getLink(page_name, url);
	}

	////////////////////////////////////////////////////////////////////////////
	// Clear and remove the old apps page after new one has loaded
	////////////////////////////////////////////////////////////////////////////
	private function removeOldAppsPage():Void
	{
		old_info_mc.removeMovieClip();
	}
	
	////////////////////////////////////////////////////////////////////////////
	// Select Phone Platform to be shown
	///////////////////////////////////////////////////////////////////////////
	public function selectPhone( _id : Number ) : Void
	{
		phoneID = _id;
		if (phone_mc.phones._currentframe != phoneID )
		{
			(phone_mc._x != PHONE_OFF_X) ? TweenMax.to( phone_mc, .5, { _x:PHONE_OFF_X, ease:Strong.easeOut, onComplete:showPhoneSlideshow, onCompleteScope:this } ) : showPhoneSlideshow();
		}
		else
		{
			showPhoneSlideshow();
		}
	}
	////////////////////////////////////////////////////////////////////////////
	// Select app slideshow
	///////////////////////////////////////////////////////////////////////////
	private function showPhoneSlideshow( ) : Void
	{
		removeAppSlideShow();
		
		phone_mc.phones.gotoAndStop(phoneID);
		
		//set up slideshow for this app
		var appXML = sections[SELECTED_SECTION].app[SELECTED_APP];
		var pics_folder_url : String = appXML.slideshow.url;
		var numberOfImages : Number = Number(appXML.slideshow.numOfImages);
		selectAppSlideshow(pics_folder_url, numberOfImages);
		
		//tween in all the assets - phone slideshow and app page info
		showAppPage();
	}

	////////////////////////////////////////////////////////////////////////////
	// Tween in to show the phone info page and phone slideshow
	///////////////////////////////////////////////////////////////////////////
	private function showAppPage() : Void
	{
		var dtime : Number = 0;
		(phone_mc._x != PHONE_ON_X) ? dtime = .5 : dtime = 0;
		TweenMax.to( phone_mc, 1, { _x:PHONE_ON_X, ease:Cubic.easeOut } );
		TweenMax.to(app_info_mc, 1, { _x:APP_INFO_X, _y:APP_INFO_Y, ease:Cubic.easeOut, delay:dtime}  );		
		TweenMax.to(old_info_mc, 0, { _x:980, ease:Cubic.easeOut, onComplete:removeOldAppsPage, onCompleteScope:this, delay:dtime+=1 }  );
	}
	
	////////////////////////////////////////////////////////////////////////////
	// Select app slideshow
	///////////////////////////////////////////////////////////////////////////
	public function selectAppSlideshow ( photos_url : String, numberOfImgs : Number ) : Void
	{
		removeAppSlideShow();
		
		var slideContainer : MovieClip = phone_mc.phones.slideshow_container;
		var sw : Number = slideContainer._width;
		var sh : Number = slideContainer._height;
		
		slideshow_mc = slideContainer.attachMovie('SLIDESHOWMC', 'slideshow_mc', 10);
		
		( phoneID == 1) ? slideshow_mc.positionControls( 60, 300 ) : null;
		( phoneID == 2) ? slideshow_mc.positionControls( 60, 300 ) : null;
		( phoneID == 3) ? slideshow_mc.positionControls( 57, 283 ) : null;
		( phoneID == 4) ? slideshow_mc.positionControls( 70, 375 ) : null;
		( phoneID == 5) ? slideshow_mc.positionControls( 175, 281 ) : null;
		
		//because of white phone - change colour of controls
		( phoneID == 2 ) ? 	TweenMax.to(slideshow_mc.controls_mc, 0, { colorTransform: { tint:0x000000, tintAmount:.5 }} ) : null;


		slideshow_mc.initSlideShow( photos_url, numberOfImgs, sw, sh);
		
		if ( phoneID == 5 ) 
		{
			//TweenMax.to(slideshow_mc.controls_mc, 0, { colorTransform: { tint:0x000000, tintAmount:.5 }} );
			slideshow_mc.pauseSlideShow();
		}
	}
	
	
	////////////////////////////////////////////////////////////////////////////
	// Destroy and remove app slideshow
	///////////////////////////////////////////////////////////////////////////	
	public function removeAppSlideShow():Void
	{
		if (slideshow_mc)
		{
			TweenMax.killChildTweensOf(slideshow_mc, false);
			slideshow_mc.destroy();
			slideshow_mc.removeMovieClip();
			slideshow_mc = null;
			emptyMC(phone_mc.slideshow_container);
		}
	}
	
	
	////////////////////////////////////////////////////////////////////////////
	// Close apps section 
	///////////////////////////////////////////////////////////////////////////		
	private function closeSection():Void
	{
		//removeAppSlideShow();
		TweenMax.killDelayedCallsTo(createAppsInfoPage);
		TweenMax.killAll();
	
		removeMenuTooltip();

		TweenMax.to(main_menu_mc, .5, { _x: -600, ease:Cubic.easeOut }  );
		TweenMax.to(app_menu_mc, .5, { _x: -300, ease:Cubic.easeOut }  );
		
		TweenMax.to(app_info_mc, 1, { _x:905, ease:Cubic.easeOut}  );
		TweenMax.to(phone_mc, .5, { _x:980, ease:Cubic.easeOut, delay:.3,  onComplete:sectionClosed, onCompleteScope:this  }  );
		
		TweenMax.delayedCall(.5, showMainMenu, null, this);
	}
	
	private function sectionClosed():Void
	{
		removeAppSlideShow();
		emptyMC(apps_container);
		SELECTED_APP = 0;
		SELECTED_SECTION = 0;
	}		
	
	////////////////////////////////////////////////////////////////////////////
	// REMOVE ALL CHILDREN MOVIECLIPS FROM A MOVIECLIP
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
		//txtF.styleSheet = _Model.cssFile;
		txtF.condenseWhite = true;
		txtF.htmlText = txtStr;

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