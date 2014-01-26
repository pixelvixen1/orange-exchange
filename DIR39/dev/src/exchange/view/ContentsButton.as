﻿////////////////////////////////////////////////////////////////////////////////
// Orange Exchange - Contents page - Page Content Button
// FileName: ContentsButton.as
// Created by: Angel
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// IMPORTS
////////////////////////////////////////////////////////////////////////////////
import mx.events.EventDispatcher;
import mx.utils.Delegate;

import exchange.Application;
import exchange.data.EventsCSS;
import exchange.model.Model;

import com.greensock.TweenMax;
//import com.greensock.easing.*;

////////////////////////////////////////////////////////////////////////////////
// CLASS: ContentsButton
////////////////////////////////////////////////////////////////////////////////
class exchange.view.ContentsButton extends MovieClip
{
	////////////////////////////////////////////////////////////////////////////
	// Properties
	////////////////////////////////////////////////////////////////////////////
	public var ID					: Number;
	public var selected				: Boolean = false;
	
	private var title_mc			: MovieClip;
	private var title_txt			: TextField;
	private var title_str 			: String;
	private var arrow_mc			: MovieClip;
	private var black_cover			: MovieClip;
	public var image_mc				: MovieClip;

	// Dispatch
	public var addEventListener		: Function; 
	public var removeEventListener	: Function; 
	public var dispatchEvent		: Function;

	////////////////////////////////////////////////////////////////////////////
	// Constructor
	////////////////////////////////////////////////////////////////////////////
	public function ContentsButton()
	{		
		EventDispatcher.initialize(this);
	}
	
	////////////////////////////////////////////////////////////////////////////
	// Initialise and Set item ID
	////////////////////////////////////////////////////////////////////////////
	public function init( item_id : Number ) : Void
	{		
		this.ID = item_id;
		setText();
		setupUI();
		
	}
	
	////////////////////////////////////////////////////////////////////////////
	// Remove black cover for reflect
	////////////////////////////////////////////////////////////////////////////
	public function removeRef(  ) : Void
	{
		black_cover._visible = false;
	}

	////////////////////////////////////////////////////////////////////////////
	// Set Text
	////////////////////////////////////////////////////////////////////////////
	public function setText() : Void
	{		
		title_str = Model.getInstance().pages[ID].contents_title;
		( title_str == undefined ) ? title_str = Model.getInstance().pages[ID].menu_title : null;
		title_txt = title_mc.title_txt;
		setTextProperties(title_txt, title_str, false, false);
	}
	
	
	////////////////////////////////////////////////////////////////////////////
	// SET UP UI
	////////////////////////////////////////////////////////////////////////////
	private function setupUI() : Void
	{
		this.onRollOver = buttonRollOver;
		this.onRollOut = buttonRollOut;
		this.onRelease = buttonReleased;
	}

	////////////////////////////////////////////////////////////////////////////
	// BUTTON ROLLOVER
	////////////////////////////////////////////////////////////////////////////
	public function buttonRollOver( ) : Void
	{
		TweenMax.to(title_mc, 0, { colorTransform: { tint:0xff6600, tintAmount:1 }} );
		this.dispatchEvent({type:"onMenuItemOver", _id:ID});
	}
	
	////////////////////////////////////////////////////////////////////////////
	// BUTTON ROLLOUT
	////////////////////////////////////////////////////////////////////////////
	public function buttonRollOut( ) : Void
	{
		TweenMax.to(title_mc, 0, { colorTransform: { tint:0xffffff, tintAmount:1 }} );
		this.dispatchEvent({type:"onMenuItemOut", _id:ID});
	}
	
	////////////////////////////////////////////////////////////////////////////
	// BUTTON RELEASED
	////////////////////////////////////////////////////////////////////////////
	public function buttonReleased( ) : Void
	{
		this.dispatchEvent({type:"onMenuItemClicked", _id:ID});
	}

	////////////////////////////////////////////////////////////////////////////
	//FORMAT TEXT FIELD PROPERTIES
	////////////////////////////////////////////////////////////////////////////
	public function setTextProperties( tf : TextField, txtStr : String, _multiline : Boolean, _html : Boolean ) : Void
	{
		tf.border = false;
		tf.background = false;
		tf.autoSize = false;
		tf.wordWrap = _multiline;
		tf.multiline = _multiline;
		tf.selectable = false;
		//tf.embedFonts = true;
		tf.html = _html;
		//tf.styleSheet = EventsCSS.getInstance().cssFile;
		tf.condenseWhite = true;
		tf.htmlText = txtStr;

	}


}