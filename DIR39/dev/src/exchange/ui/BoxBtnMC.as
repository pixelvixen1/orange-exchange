////////////////////////////////////////////////////////////////////////////////
// Orange Exchange 
// FileName: BoxBtnMC.as
// Created by: Angel
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// IMPORTS
////////////////////////////////////////////////////////////////////////////////
import mx.events.EventDispatcher;
import mx.utils.Delegate;
import com.greensock.TweenMax;
import com.greensock.easing.*;

////////////////////////////////////////////////////////////////////////////////
// CLASS: BoxBtnMC
////////////////////////////////////////////////////////////////////////////////
class exchange.ui.BoxBtnMC extends MovieClip
{
	////////////////////////////////////////////////////////////////////////////
	// Properties
	////////////////////////////////////////////////////////////////////////////
	public var ID					: Number;
	public var selected				: Boolean = false;
	
	private var hit_mc				: MovieClip;
	private var mask_mc				: MovieClip;
	private var text_mc				: MovieClip;
	private var label_txt			: TextField;
	private var label_str 			: String;
	private var front_mc			: MovieClip;
	private var image_mc			: MovieClip;
	
	private var img					: MovieClip;
	private var imageSRC			: String;
	
	private var offUP				: Number;
	private var offDOWN				: Number;
	private var tTime				: Number = .5;
	private var ease 				: Function = Back.easeOut;

	// Dispatch
	public var addEventListener		: Function; 
	public var removeEventListener	: Function; 
	public var dispatchEvent		: Function;

	////////////////////////////////////////////////////////////////////////////
	// Constructor
	////////////////////////////////////////////////////////////////////////////
	public function BoxBtnMC()
	{		
		EventDispatcher.initialize(this);
	}
	
	////////////////////////////////////////////////////////////////////////////
	// Initialise and Set item ID
	////////////////////////////////////////////////////////////////////////////
	public function createItem( item_id : Number, button_text : String, image_linkageID : String ) : Void
	{		
		this.ID = item_id;
		label_str = button_text;
		imageSRC = image_linkageID;
		text_mc = front_mc.text_mc;
		setText();
		setImage();
		findMovieClips(this);
		
		offUP = mask_mc._y - mask_mc._height;
		offDOWN = mask_mc._y + mask_mc._height;
		
		setupUI();
		
		image_mc._y = offUP;
		
	}
	
	////////////////////////////////////////////////////////////////////////////
	// Set up an image from the library if passed in
	////////////////////////////////////////////////////////////////////////////
	private function setImage(  ) : Void
	{
		if ( imageSRC != undefined)
		{
			img = this.image_mc.attachMovie( imageSRC, 'img', 1);
		}
	}

	
	
	////////////////////////////////////////////////////////////////////////////
	// Set Text
	////////////////////////////////////////////////////////////////////////////
	private function setText() : Void
	{		
		
		label_txt = text_mc.label_txt;
		setTextProperties(label_txt, label_str, true, true);
	}
	
	
	////////////////////////////////////////////////////////////////////////////
	// SET UP UI
	////////////////////////////////////////////////////////////////////////////
	private function setupUI() : Void
	{
		this.hit_mc.onRollOver = Delegate.create(this, buttonRollOver);
		this.hit_mc.onRollOut = Delegate.create(this, buttonRollOut);
		this.hit_mc.onRelease = Delegate.create(this, buttonReleased);
	}

	////////////////////////////////////////////////////////////////////////////
	// BUTTON ROLLOVER
	////////////////////////////////////////////////////////////////////////////
	private function buttonRollOver( ) : Void
	{
		TweenMax.to(image_mc, tTime, {  _y:image_mc.init._y, ease:ease } );
		TweenMax.to(front_mc, tTime, {  _y:offDOWN, ease:ease } );
		this.dispatchEvent( { type:"onItemOver", _id:ID } );
		
	}
	
	////////////////////////////////////////////////////////////////////////////
	// BUTTON ROLLOUT
	////////////////////////////////////////////////////////////////////////////
	private function buttonRollOut( ) : Void
	{
		TweenMax.to(image_mc, tTime, {  _y:offUP, ease:ease } );
		TweenMax.to(front_mc, tTime, {  _y:front_mc.init._y, ease:ease } );
		this.dispatchEvent({type:"onItemOut", _id:ID});
	}
	
	////////////////////////////////////////////////////////////////////////////
	// BUTTON RELEASED
	////////////////////////////////////////////////////////////////////////////
	private function buttonReleased( ) : Void
	{
		this.dispatchEvent( { type:"onItemClicked", _id:ID } );
	}
	
	////////////////////////////////////////////////////////////////////////////
	// BUTTON enable
	////////////////////////////////////////////////////////////////////////////
	public function disable( ) : Void
	{
		hit_mc.enabled = false;
		TweenMax.to(image_mc, 0, {  _y:offUP, ease:ease } );
		TweenMax.to(front_mc, 0, {  _y:front_mc.init._y, ease:ease } );
	}

	////////////////////////////////////////////////////////////////////////////
	// BUTTON disable
	////////////////////////////////////////////////////////////////////////////
	public function enable( ) : Void
	{
		hit_mc.enabled = true;
		TweenMax.to(image_mc, 0, {  _y:offUP, ease:ease } );
		TweenMax.to(front_mc, 0, {  _y:front_mc.init._y, ease:ease } );
	}


	////////////////////////////////////////////////////////////////////////////
	//FORMAT TEXT FIELD PROPERTIES
	////////////////////////////////////////////////////////////////////////////
	public function setTextProperties( tf : TextField, txtStr : String, _multiline : Boolean ) : Void
	{
		tf.border = false;
		tf.background = false;
		tf.autoSize = false;
		tf.wordWrap = _multiline;
		tf.multiline = _multiline;
		tf.selectable = false;
		tf.embedFonts = true;
		tf.html = true;
		tf.condenseWhite = true;
		tf.htmlText = txtStr;

	}
	
	
	
	////////////////////////////////////////////////////////////////////////////
	// FIND MOVIE CLIPS
	///////////////////////////////////////////////////////////////////////////	
	public function findMovieClips(mc:MovieClip):Void 
	{
		for (var i in mc) 
		{
			if (typeof(mc[i]) == "movieclip")
			{
				setInitValues(mc[i]);
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