package 
{
	
	import org.flixel.*;
	
	public class Player extends FlxSprite	
	{
		[Embed(source="../assets/sounds/jump.mp3")] private var JumpSound:Class;
		
		public function Player() {
			super(FlxG.width/2 - 5);
			this.makeGraphic(10,12,0xff7FFF00);
			this.maxVelocity.x = 80;
			this.maxVelocity.y = 250;
			this.acceleration.y = 250;
			this.drag.x = this.maxVelocity.x*4;
		}
		
		//Player movement and controls
		override public function update():void {
			super.update();
			
			this.acceleration.x = 0;
			if(FlxG.keys.LEFT)
				this.acceleration.x = -this.maxVelocity.x*4;
			if(FlxG.keys.RIGHT)
				this.acceleration.x = this.maxVelocity.x*4;
			if (this.isTouching(FlxObject.FLOOR) && this.acceleration.y > 0)
			{
				if (FlxG.keys.justPressed("SPACE") || FlxG.keys.justPressed("UP")) {
					FlxG.play(JumpSound);
					this.velocity.y = -this.maxVelocity.y / 2;
				}
			}
			else if (this.isTouching(FlxObject.CEILING) && this.acceleration.y < 0)
			{
				if (FlxG.keys.justPressed("SPACE") || FlxG.keys.justPressed("DOWN")) {
					FlxG.play(JumpSound);
					this.velocity.y = this.maxVelocity.y / 2;
				}
			}
		}
	}
	
}