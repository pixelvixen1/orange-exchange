﻿////////////////////////////////////////////////////////////////////////////////
// Project: Orange Exchange issue 36
// FileName: LoadUtil.as
// Created by: Angel 
// LAST UPDATE : 17 March 2013
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// IMPORTS
////////////////////////////////////////////////////////////////////////////////
import mx.events.EventDispatcher;
import mx.utils.Delegate;

import org.casalib.load.LoadGroup;
import org.casalib.load.media.MediaLoad;
import org.casalib.load.base.LoadInterface;
import org.casalib.math.Percent;
import org.casalib.load.base.BytesLoadInterface;

////////////////////////////////////////////////////////////////////////////////
// CLASS:  LoadUtil
////////////////////////////////////////////////////////////////////////////////
class exchange.utils.LoadUtil extends MovieClip
{
	////////////////////////////////////////////////////////////////////////////
	// Properties
	////////////////////////////////////////////////////////////////////////////
	public var loadingGroup 			: LoadGroup;
	public var loadProgress				: String;
	public var progress_textfield		: TextField;
	public var loadingStr				: String;

	//Assets
	public var container				: MovieClip;
	public var contents_mc				: MovieClip;
	
	public var loadsData				: Array;

	// Dispatch
	public var addEventListener			: Function; 
	public var removeEventListener		: Function; 
	public var dispatchEvent			: Function;

	////////////////////////////////////////////////////////////////////////////
	// Constructor
	////////////////////////////////////////////////////////////////////////////
	public function LoadUtil()
	{		
		EventDispatcher.initialize(this);
	}

	
	////////////////////////////////////////////////////////////////////////////
	// On Load
	///////////////////////////////////////////////////////////////////////////
	public function onLoad() : Void
	{
		
		
	}
	////////////////////////////////////////////////////////////////////////////
	// Initialise Loader
	////////////////////////////////////////////////////////////////////////////
	public function init(  loads_array : Array, _displayTF : TextField, _loadingStr : String ) : Void
	{
		loadsData = loads_array;
		loadingStr = _loadingStr;
		setupLoaderGroup( );
		createLoads();
		
		( _displayTF != undefined ) ? progress_textfield = _displayTF : null;
	}
	
	
	////////////////////////////////////////////////////////////////////////////
	// Load one item
	////////////////////////////////////////////////////////////////////////////
	public function loadItem( _target_clip : MovieClip,  __loadURL : String ) : Void
	{
		var mm:MediaLoad = new MediaLoad(_target_clip, __loadURL, true );
		mm.addEventObserver(this, MediaLoad.EVENT_LOAD_COMPLETE, 'onItemLoaded');
		mm.start();
	}
	
	////////////////////////////////////////////////////////////////////////////
	// On Load Complete - 
	////////////////////////////////////////////////////////////////////////////	
	public function	onItemLoaded() : Void
	{	
		dispatchEvent( { type:"itemFullyLoaded" } );
	}	
	
	////////////////////////////////////////////////////////////////////////////
	// Setup Loader
	////////////////////////////////////////////////////////////////////////////
	public function setupLoaderGroup( ) : Void
	{		 
		loadingGroup = new LoadGroup();
		loadingGroup.addEventObserver(this, LoadGroup.EVENT_LOAD_COMPLETE, "onLoadComplete");
		loadingGroup.addEventObserver(this, LoadGroup.EVENT_LOAD_PERCENT, "onGroupLoadPercent");
		loadingGroup.addEventObserver(this, LoadGroup.EVENT_LOAD_ERROR, "onGroupLoadError");
	}
		
	
	
	////////////////////////////////////////////////////////////////////////////
	// Start the Loading process
	////////////////////////////////////////////////////////////////////////////
	public function startLoadingProcess() : Void
	{
		loadingGroup.start();
	}
	
	
	////////////////////////////////////////////////////////////////////////////
	// On Group Loading event - get the amount loaded and display in textfield
	////////////////////////////////////////////////////////////////////////////	
	public function onGroupLoadPercent(sender:LoadGroup, progress:Percent):Void 
	{
		loadProgress = String( Math.ceil(progress.getPercentage()) );
		progress_textfield.text = loadingStr +' '+ loadProgress + "%";
		
	}
	////////////////////////////////////////////////////////////////////////////////
	// If there is an Loading error then remove the data continue and keep loading
	//////////////////////////////////////////////////////////////////////////////////
	public function onGroupLoadError(sender:LoadGroup, failedLoad:BytesLoadInterface):Void 
	{
		trace('onGroupLoadError ' +failedLoad);
		loadingGroup.removeLoad(failedLoad);
		loadingGroup.start();
	}
	////////////////////////////////////////////////////////////////////////////
	// On Group Load Complete - 
	////////////////////////////////////////////////////////////////////////////	
	public function	onLoadComplete(sender:LoadGroup) : Void
	{
			//trace('Fully Loaded ');	
			dispatchEvent( { type:"contentFullyLoaded" } );
	}
	
	
	////////////////////////////////////////////////////////////////////////////
	// Search through loads array and add to loading group
	////////////////////////////////////////////////////////////////////////////
	public function createLoads() : Void
	{
		//var mediaLoad:MediaLoad = new MediaLoad(_targetMC, loadURL, _hideUntilLoaded);
		//loadingGroup.addLoad(mediaLoad);

		for ( var i : Number=0; i < loadsData.length; i++ )
		{
			var mediaLoad:MediaLoad = loadsData[i];
			loadingGroup.addLoad(mediaLoad);
		}
	}
	
	
	
	
}