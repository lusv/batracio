package  {
	import net.flashpunk.Engine;
	
	import net.flashpunk.Engine;
	import net.flashpunk.FP;
	public class Main extends Engine {
		public function Main() {
			super(640,480,60,false);
		}
		override public function init():void {
			FP.screen.color = 0x222233;
			FP.world=new theWorld();
		}
	}
}