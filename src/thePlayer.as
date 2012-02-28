﻿package {
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Text;
	
	public class thePlayer extends Entity {
		private var power:Number = 0.2;
		private var jumpPower:Number = 10;
		private var hFriction:Number = 0.95;
		private var vFriction:Number = 0.99;
		private var xSpeed:Number = 0;
		private var ySpeed:Number = 0;
		private var gravity:Number = 0.3;
		private var health:Number = 100;
		private var lives:Number = 3;
		private const superSpeed:Number = 3.5;
		
		[Embed(source='assets/player.png')]
		private const PLAYER:Class;
		
		public function thePlayer() {
			graphic = new Image(PLAYER);			
			setHitbox(13, 26);
			x = 305;
			y = 225;
		}
		
		public function getHealth():Number
		{
			return health;
		}

		override public function update():void {
			var pressed:Boolean = false;
			var superSpeedPressed:Boolean = false;
			
			if (Input.check(Key.B))
				superSpeedPressed = true;
			else
				superSpeedPressed = false;
			
			if (Input.check(Key.LEFT)) {
				
				if(!superSpeedPressed)
				xSpeed -= power;
				else
				xSpeed -= power*superSpeed;
				pressed = true;
			}

				
			if (Input.check(Key.RIGHT)) {
				if(!superSpeedPressed)
				xSpeed += power;
				else
				xSpeed += power*superSpeed;
				pressed = true;
			}
			if (collide("wall", x, y + 1) || collide("water", x, y + 1) && superSpeedPressed) {
				ySpeed = 0;
				if (Input.check(Key.UP)) {
					ySpeed -= jumpPower;
				}
			} else {
				ySpeed += gravity;
			}
			if (Math.abs(xSpeed) < 1 && !pressed) {
				xSpeed = 0;
			}
			xSpeed *= hFriction;
			ySpeed *= vFriction;
			adjustXPosition();
			adjustYPosition();
		}
		
		private function adjustXPosition():void {
			for (var i:int = 0; i < Math.abs(xSpeed); i++) {
				if (!collide("wall", x + FP.sign(xSpeed), y)) {
					x += FP.sign(xSpeed);
				} else {
					xSpeed = 0;
					break;
				}
			}
		}
		
		private function adjustYPosition():void {
			for (var i:int = 0; i < Math.abs(ySpeed); i++) {
				if (!collide("wall", x, y + FP.sign(ySpeed))) {
					y += FP.sign(ySpeed);
				} else {
					ySpeed = 0;
					break;
				}
			}
		}
	}
}