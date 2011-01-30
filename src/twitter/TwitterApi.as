package twitter
{
	import com.adobe.serialization.json.JSON;
	
	import flash.display.StageAlign;
	import flash.events.Event;
	
	import mx.containers.VBox;
	import mx.controls.Alert;
	import mx.controls.Image;
	import mx.controls.Label;
	import mx.controls.Text;
	import mx.managers.CursorManager;
	import mx.managers.PopUpManager;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	import mx.validators.StringValidator;
	import mx.validators.Validator;
	
	import spark.components.TextInput;
	import spark.components.VGroup;

	public class TwitterApi
	{
		private var view:TwitterFriends = null;
		private var validators:Array = new Array();
		
		public function TwitterApi(view:Object)
		{
			this.view = view as TwitterFriends;
			
			initValidators();
		}
		
		private function initValidators() : void
		{
			validators.push(this.view.svUsername);
		}
		
		private function sucessCall(event:Event) : void
		{
			CursorManager.removeAllCursors();
			Alert.show((event as ResultEvent).toString(), "Sucess", Alert.OK);
		}
		
		private function failCall(event:Event) : void
		{
			CursorManager.removeAllCursors();
			Alert.show((event as FaultEvent).toString(), "Failure", Alert.OK);
		}
		
		private function onReturnGetFriends(event:ResultEvent) : void {
			CursorManager.removeAllCursors();
			
			var jsonFriends : String = String(event.result);
			var friends : Array = JSON.decode(jsonFriends) as Array;
			
			this.view.friendsFrame.removeAllElements();
			for each(var friend:Object in friends)
			{
				var userImage : Image = new Image();
				userImage.source = friend.profile_image_url;
				userImage.scaleContent = false;
				userImage.width = 48;
				userImage.height = 48;
				
				var userLabel : Text = new Text();
				userLabel.text = "@" + friend.screen_name;
				
				var vgroup : VGroup = new VGroup();
				vgroup.horizontalAlign = "center";
				vgroup.addElement(userImage);
				vgroup.addElement(userLabel);
				
				this.view.friendsFrame.addElement(vgroup);
			}
		}
		
		public function submit(e:Event) : void
		{
			var errors:Array = Validator.validateAll(validators);
			if(errors.length == 0) {
				
				var username : String = this.view.username.text;
				var twitterUrl : String = "http://api.twitter.com/1/statuses/friends.json?screen_name=" + username;
				
				var http : HTTPService = new HTTPService();
				http.url = "http://localhost:7777/";
				http.method = "POST";
				http.useProxy = false;
				http.addEventListener(ResultEvent.RESULT, onReturnGetFriends);
				http.addEventListener(FaultEvent.FAULT, failCall);
				CursorManager.setBusyCursor();
				http.send({'url' : twitterUrl});
			}
		}
	}
}