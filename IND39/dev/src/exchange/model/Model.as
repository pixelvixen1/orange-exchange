////////////////////////////////////////////////////////////////////////////////
// Project: Orange Exchange issue 36
// FileName: Model.as
// Created by: Angel 
////////////////////////////////////////////////////////////////////////////////
import mx.events.EventDispatcher;
import mx.utils.Delegate;
import exchange.data.StructureXML;
import exchange.data.EventsCSS;
import exchange.data.XMLDeserializer;
//import exchange.model.valueObjects.PageVO;
import TextField.StyleSheet;

////////////////////////////////////////////////////////////////////////////////
// CLASS : Model
////////////////////////////////////////////////////////////////////////////////
class exchange.model.Model
{
	////////////////////////////////////////////////////////////////////////////
	// Properties
	////////////////////////////////////////////////////////////////////////////
	private static var instance			: Model;
	
	public var CSSDoc					: String = "css/main.css";
	public var XMLDoc					: String = "xml/data.xml";
	
	public var structureXML				: StructureXML;
	public var _EventsCSS				: EventsCSS;
	
	public var cssFile					: StyleSheet;
	
	public var xmlRootNode				: XMLNode;
	public var xmlObj					: Object;
	
	public var model_complete 			: Boolean = false;
	
	public var issue 					: String;
	public var siteTitle				: String;
	
	//Value Objects
	public var pages					: Array;
	public var numOfItems 				: Number;
	
	public var videoWallMenu			: Array;
	public var videoWallInfo			: Array;
	
	// Dispatch
	public var addEventListener 		: Function; 
	public var removeEventListener		: Function; 
	public var dispatchEvent			: Function; 
	
	////////////////////////////////////////////////////////////////////////////
	// Private Constructor
	///////////////////////////////////////////////////////////////////////////	
	private function Model()
	{
		EventDispatcher.initialize(this);
	}

	////////////////////////////////////////////////////////////////////////////
	// Return singleton instance of Model
	///////////////////////////////////////////////////////////////////////////	
	public static function getInstance() : Model 
	{
		if (instance == null)
		{
			instance = new Model();
		}
		return instance;
	}
	
	
	////////////////////////////////////////////////////////////////////////////
	// Initialise Model
	///////////////////////////////////////////////////////////////////////////	
	public function init() : Void
	{
		loadXMLData();
	}


	////////////////////////////////////////////////////////////////////////////
	// Load XML Data
	////////////////////////////////////////////////////////////////////////////
	private function loadXMLData() : Void
	{
		structureXML = new StructureXML();
		structureXML.addEventListener("structureXMLLoaded", this);
		structureXML.loadXMLfile( XMLDoc );
	}
	
	////////////////////////////////////////////////////////////////////////////
	// XML Data Loaded - load CSS
	////////////////////////////////////////////////////////////////////////////
	private function structureXMLLoaded() : Void
	{
		_EventsCSS = EventsCSS.getInstance();
		_EventsCSS.addEventListener("cssLoaded", this);
		_EventsCSS.loadCSS(CSSDoc);
	}
	
	///////////////////////////////////////////////////////////////////////////////////
	// CSS LOADED
	//////////////////////////////////////////////////////////////////////////////////
	private function cssLoaded() : Void
	{
		_EventsCSS.removeEventListener("cssLoaded", this);
		cssFile = _EventsCSS.cssFile;
		storeXMLData();
	}

	////////////////////////////////////////////////////////////////////////////
	// Store XML Data
	///////////////////////////////////////////////////////////////////////////	
	private function storeXMLData() : Void
	{
		var userXML : XML = structureXML.XMLDoc;
		xmlRootNode = userXML;
		xmlObj = XMLDeserializer.getDeserialisedXML( userXML );
		structureData();
	}
	
	
	////////////////////////////////////////////////////////////////////////////
	// Structure Data
	////////////////////////////////////////////////////////////////////////////
	private function structureData( ) : Void
	{		
		structureMainSiteData();
		
		structureSectionData( ) ;
		
		modelComplete();
		
	}
	
	////////////////////////////////////////////////////////////////////////////
	// Structure main data
	////////////////////////////////////////////////////////////////////////////
	private function structureMainSiteData( ) : Void
	{		
		pages = new Array();
		issue =  xmlObj.root.structure.issueName;
		siteTitle =  xmlObj.root.structure.siteTitle;
		numOfItems = xmlObj.root.structure.page.length;
		
		for (var i : Number = 0; i < numOfItems; i++) 
		{
			var node_data:Object = new Object();
			node_data = xmlObj.root.structure.page[i];
			
			node_data.id = i + 1;
			node_data.button_number = String(i + 1); 
			node_data.name = xmlObj.root.structure.page[i].name;
			(xmlObj.root.structure.page[i].notInContents == 'true') ? 	node_data.notInContents = true : node_data.notInContents = false;
			
			pages[node_data.id] = node_data;	
		}
		
	}
	
	////////////////////////////////////////////////////////////////////////////
	// Structure section data
	////////////////////////////////////////////////////////////////////////////
	private function structureSectionData( ) : Void
	{		
		videoWallMenu = new Array();
		
		var sl : Number  = xmlObj.root.sections.video_wall.menu.item.length;
		
		for (var i : Number = 0; i < sl; i++) 
		{
			//for each item
			var node_data:Object = new Object();
			var ItemXML:XML = xmlRootNode.childNodes[0].childNodes[1].childNodes[0].childNodes[0].childNodes[i];
			var itemsDataLength : Number  = xmlRootNode.childNodes[0].childNodes[1].childNodes[0].childNodes[0].childNodes[i].childNodes.length;
			
	
			for (var j : Number = 0; j < itemsDataLength; j++) 
			{
				var ItemChildNodeXML:XML = ItemXML.childNodes[j];
				
				var nodeName_str:String = ItemChildNodeXML.nodeName;
				
				node_data[nodeName_str] = ItemChildNodeXML.firstChild.nodeValue;
			}
				
			videoWallMenu[i] = node_data;
	
		}
		
		
		structureVideoWallInfo( );
	}

	
	////////////////////////////////////////////////////////////////////////////
	// Structure section data
	////////////////////////////////////////////////////////////////////////////
	private function structureVideoWallInfo( ) : Void
	{		
		videoWallInfo = new Array();
		
		var sl : Number  = xmlObj.root.sections.video_wall.videos_information.item.length;
		
		for (var i : Number = 0; i < sl; i++) 
		{
			//for each item
			var node_data:Object = new Object();
			var ItemXML:XML = xmlRootNode.childNodes[0].childNodes[1].childNodes[0].childNodes[1].childNodes[i];
			var itemsDataLength : Number  = xmlRootNode.childNodes[0].childNodes[1].childNodes[0].childNodes[1].childNodes[i].childNodes.length;
			
	
			for (var j : Number = 0; j < itemsDataLength; j++) 
			{
				var ItemChildNodeXML:XML = ItemXML.childNodes[j];
				
				var nodeName_str:String = ItemChildNodeXML.nodeName;
				
				node_data[nodeName_str] = ItemChildNodeXML.firstChild.nodeValue;
			}
				
			videoWallInfo[i] = node_data;
	
		}
	}
	

	
	///////////////////////////////////////////////////////////////////////////////////
	// MODEL COMPLETE
	//////////////////////////////////////////////////////////////////////////////////
	private function modelComplete() : Void
	{
		model_complete = true;
		this.dispatchEvent({type:"modelComplete"});
	}
	
}