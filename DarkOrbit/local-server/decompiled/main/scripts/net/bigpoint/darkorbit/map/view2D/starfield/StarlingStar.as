package net.bigpoint.darkorbit.map.view2D.starfield
{
   import starling.display.Quad;
   
   public class StarlingStar extends Quad implements IStar
   {
      
      private var _speed:Number;
      
      public function StarlingStar()
      {
         super(1,1);
      }
      
      public function set speed(param1:Number) : void
      {
         this._speed = param1;
      }
      
      public function get speed() : Number
      {
         return this._speed;
      }
   }
}

