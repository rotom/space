package
{
	import org.flixel.FlxObject;
	import org.flixel.FlxSprite;
	
	public class Player extends FlxSprite
	{
		public var gravityNormal:Boolean = true;
		[Embed(source = '../assets/player.png')] private var playerPNG:Class;
		
		public function Player(X:Number, Y:Number)
		{
			//	As this extends FlxSprite we need to call super() to ensure all of the parent variables we need are created
			super(X, Y);
			
			//	Load the player.png into this sprite.
			//	The 2nd parameter tells Flixel it's a sprite sheet and it should chop it up into 16x18 sized frames.
			loadGraphic(playerPNG, true, true, 15, 20, true);
			
			//	The sprite is 16x18 in size, but that includes a little feather of hair on its head which we don't want to include in collision checks.
			//	We also shave 2 pixels off each side to make it slip through gaps easier. Changing the width/height does NOT change the visual sprite, just the bounding box used for physics.
			width = 12;
			height = 16;
			
			//	Because we've shaved a few pixels off, we need to offset the sprite to compensate
			
			//	The Animation sequences we need
			addAnimation("idle", [0], 0, false);
			addAnimation("walk", [0, 1, 2, 3], 10, true);
			addAnimation("jump", [1], 0, false);
			
			//	Enable the Controls plugin - you only need do this once (unless you destroy the plugin)
			
			//	By default the sprite is facing to the right.
			//	Changing this tells Flixel to flip the sprite frames to show the left-facing ones instead.
			facing = FlxObject.RIGHT;
		}
		
		override public function update():void
		{
			super.update();
			
			if ((touching == FlxObject.FLOOR && gravityNormal) || (touching ==FlxObject.CEILING && !gravityNormal))
			{
				if (velocity.x != 0)
				{
					play("walk");
				}
				else
				{
					play("idle");
				}
			}
			else if (velocity.y != 0)
			{
				play("jump");
			}
		}
		
	}
}
/*
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
			this.maxVelocity.y = 300;
			this.acceleration.y = 300;
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
*/