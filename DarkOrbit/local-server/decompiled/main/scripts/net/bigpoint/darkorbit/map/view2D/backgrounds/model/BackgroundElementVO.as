package net.bigpoint.darkorbit.map.view2D.backgrounds.model
{
   public class BackgroundElementVO
   {
      
      private var _parallaxFactor:Number = 1;
      
      private var _depth:Number = -1;
      
      public function BackgroundElementVO(param1:int, param2:Number)
      {
         super();
         this._parallaxFactor = param2;
         this._depth = 1000 / this._parallaxFactor + param1;
      }
      
      public function get parallaxFactor() : Number
      {
         return this._parallaxFactor;
      }
      
      public function get depth() : int
      {
         return this._depth;
      }
   }
}

