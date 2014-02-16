/**
 * @title:       XMLDeserialiser
 * @description: Simlpe xml deserialiser - deserialises in exactly the same way as Flash remoting
 */
 
class exchange.data.XMLDeserializer
{
	
	/**
	 * 	@description getDeserialisedXML - returns an array of deserilised xml...
	 * 	@param		arg_xml - the xml to deserialise
	 * 	@return		an object containing deserilised xml
	 */
	public static function getDeserialisedXML(arg_xml:XML):Object
	{	
		return getDeserialisedNode(arg_xml,new Object());
	}
	
	private static function getDeserialisedNode(arg_xmlnode:XMLNode,arg_currentNode_array:Object):Object
	{	
		//iterate through all childnodes
		var childLen_num:Number = arg_xmlnode.childNodes.length;
		var i:Number = 0;
		do{
			
			var node_array:Object	= new Object();
			var nodeName_str:String = arg_xmlnode.childNodes[i].nodeName;
			var nodeType_str:Number = arg_xmlnode.childNodes[i].nodeType;
				
			if(nodeType_str==3)continue;
			
			if(arg_xmlnode.childNodes[i].firstChild.nodeType==3)
				node_array = arg_xmlnode.childNodes[i].firstChild.nodeValue;
				
			//iterate through the nodes attribute object
			/*
			NOTE: should really push attributes into an attribute object/array...  
			currently - if an element has an attribute with the same name as a 
			child node data will be lost/overwriten - which is bad
			*/
			for(var attName_str:String in arg_xmlnode.childNodes[i].attributes)	
				node_array[attName_str] = arg_xmlnode.childNodes[i].attributes[attName_str];

			//if array node doesnt exsist 
			if(!arg_currentNode_array[nodeName_str]){

				//if this node unique
				var uniqueNodeName:Boolean = isUniqueNodeName(nodeName_str,arg_xmlnode.childNodes);

				if(uniqueNodeName)
					arg_currentNode_array[nodeName_str] = node_array;			
				else{
					arg_currentNode_array[nodeName_str] = new Array();
					arg_currentNode_array[nodeName_str].push(node_array);
				}
				
			//if array of this name exsists then push data into it
			}else arg_currentNode_array[nodeName_str].push(node_array);
								
			//if this node has children then we need to recurse through them to	
			if(arg_xmlnode.childNodes[i].childNodes.length>0)
				getDeserialisedNode(arg_xmlnode.childNodes[i],node_array);
				
		}while(++i<childLen_num);
		
		return (arg_currentNode_array);
		
	}
	
	private static function isUniqueNodeName(arg_nodeName_str:String,arg_node_array:Array):Boolean
	{
		var len:Number		= arg_node_array.length;
		//if only 1 node then must be unqiue
		if(len==1)
			return (true);

		//check all nodes for more than 1 occurace of nodeName
		var count:Number	= 0;
		var i:Number 		= 0;
		while( i<len ){

			if(arg_nodeName_str==arg_node_array[i].nodeName)
				if(++count>1) return (false);
			
			i++;
		}
		return (true);
	}
}




