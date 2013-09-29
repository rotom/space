package 
{
	
	import org.flixel.*;
	
	public class Exit extends FlxSprite	
	{
		[Embed(source="../assets/images/closedDoor.png")] private var closedDoor:Class;
		[Embed(source="../assets/images/openDoor.png")] private var openDoor:Class;
		
		public function Exit(X:Number, Y:Number) {
			super(X, Y);
			this.loadGraphic(closedDoor);
		}
		
		//Change the Door's Graphics
		public function open():void {
			this.loadGraphic(openDoor);
		}
	}
	
}