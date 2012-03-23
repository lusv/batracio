﻿package characters {
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.FP;
	
	public class Batracio extends Entity {
		private var animations:Spritemap;
		private var gravity:Number = 0.3;
		private var walkAccel:Number = 0.2;
		private var jumpAccel:Number = 8.0;
		private var hFriction:Number = 0.95;
		private var vFriction:Number = 0.99;
		private var xSpeed:Number = 0.0;
		private var ySpeed:Number = 0.0;
		private var isOnFloor:Boolean = false;
		private var state:String = 'standing';
		
		public function Batracio(posX:int, posY:int) {
			x = posX; y = posY;
			width = GC.TILE_SIZE * 2; height = GC.TILE_SIZE;
			animations = new Spritemap(GC.BATRACIO_PNG, width, height);
			animations.add('standing', [0], 0, false);
			animations.add('walking', [1, 2], 8, true);
			animations.add('jumping', [3, 4], 8, false);
			animations.add('falling', [5, 6], 20, true);
			graphic = animations;
			Input.define('walking', Key.LEFT, Key.RIGHT, Key.A, Key.D);
			Input.define('walkLeft', Key.LEFT, Key.A);
			Input.define('walkRight', Key.RIGHT, Key.D);
			Input.define('jump', Key.UP, Key.W, Key.SPACE);
		}
		
		override public function update():void {
			updateMovement();
			adjustXPosition(); adjustYPosition();
			updateAnimation();
		}
		
		private function updateMovement():void {
			if (collideTypes(['level' , 'cloud'], x, y + 1)) isOnFloor = true; else { isOnFloor = false; ySpeed += gravity; }
			if (Input.pressed('jump') && isOnFloor) ySpeed -= jumpAccel;
			if (Input.check('walkRight')) { xSpeed += walkAccel; animations.flipped = false; }
			if (Input.check('walkLeft')) { xSpeed -= walkAccel; animations.flipped = true; }
			xSpeed *= hFriction; ySpeed *= vFriction;
			xSpeed = Math.abs(xSpeed) < 1 && !Input.check('walking') ? 0 : xSpeed;
		}
			
		private function adjustXPosition():void {
			for (var i:int = 0; i < Math.abs(xSpeed); i++) {
				switch (FP.sign(xSpeed)) {
					case -1: if (!collideTypes(['level'], x - 1, y)) x--; else xSpeed = 0; break;
					case 1: if (!collideTypes(['level'], x + 1, y)) x++; else xSpeed = 0; break;
				}
			}
		}
		
		private function adjustYPosition():void {
			for (var i:int = 0; i < Math.abs(ySpeed); i++) {
				switch (FP.sign(ySpeed)) {
					case -1: if (!collideTypes(['level'], x, y - 1)) y--; else ySpeed = 0; break;
					case 1: if (!collideTypes(['level', 'cloud'], x, y + 1)) y++; else ySpeed = 0; break;
				}
			}
		}
		
		private function updateAnimation():void {
			state = isOnFloor ? xSpeed != 0 ? 'walking' : 'standing' : ySpeed < 0 ? 'jumping' : 'falling';
			animations.play(state);
		}
	}
}