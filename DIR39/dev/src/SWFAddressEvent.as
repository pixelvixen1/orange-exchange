/**
 * SWFAddress 2.0: Deep linking for Flash and Ajax - http://www.asual.com/swfaddress/
 * 
 * SWFAddress is (c) 2006-2007 Rostislav Hristov and is released under the MIT License:
 * http://www.opensource.org/licenses/mit-license.php
 *
 */

class SWFAddressEvent {

    public static var INIT:String = 'init';
    public static var CHANGE:String = 'change';
        
    private var _type:String;
    private var _value:String;
    private var _path:String;
    private var _parameters:Object;
    
    public function SWFAddressEvent(type:String) {
        _type = type;
        _value = SWFAddress.getValue();
        _path = SWFAddress.getPath();
        _parameters = new Array();
        var names:Array = SWFAddress.getParameterNames();
        for (var i:Number = 0, n:String; n = names[i]; i++) {
            _parameters[n] = SWFAddress.getParameter(n);
        }
    }

    public function get type():String {
        return _type;
    }

    public function get target():Object {
        return SWFAddress;
    }

    public function get value():String {
        return _value;
    }

    public function get path():String {
        return _path;
    }

    public function get parameters():Object {
        return _parameters;
    }
}