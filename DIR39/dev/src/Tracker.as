/**
 * ...
 * @author Angel
 * Tracking static class for quick access to get url and tracking user actions
 * 
 */

class Tracker
{
	public static var ISSUE_NAME : String = "DIR39";
	public static var trackingON : Boolean = true;
	public static var traceON : Boolean = false;
	
	
	 public function Tracker() 
	 {
		 
	 }
	 
	
	
	// USED INSTEAD OF getURL FUNCTION
	// will get an external link and set a tracking link based on the URL link and section name param passed through
	// @section___name - is the page name you want to include in the tracking data
	// @linkURL - the url to open and this will also be included in tracking reference
	public static function getLink( section___name : String, linkURL : String ):Void 
	{
		getURL( linkURL, "_blank" );
		
		var trackingREF : String = 'link_out/' + linkURL;
		var tracking___url : String = "javascript: pageTracker._trackPageview('/" + ISSUE_NAME + "/" + section___name + "/"  + trackingREF + "');";
		
		(trackingON) ? 	getURL( tracking___url ) : null;
		(traceON) ? trace( tracking___url ) : null;
		
	}
	
	
	// TRACK A USER ACTION / CLICK OR ANYTHING
	// Params - 
	// 	@section_name - is the page name you want to include in the tracking data
	// 	@trackREF - any string to describe what you are tracking
	//  example use :  
	//                 Tracker.trackClick( 'incoming_news', 'watch_video' );
	//
	public static function trackClick( section_name : String, trackREF : String ):Void 
	{
		var tracking_url : String = "javascript: pageTracker._trackPageview('/" + ISSUE_NAME + "/" + section_name + "/"  + trackREF + "');";
		
		(trackingON) ? 	getURL( tracking_url ) : null;
		(traceON) ? trace( tracking_url ) : null;
	}
		
	
	
	
	
	
}