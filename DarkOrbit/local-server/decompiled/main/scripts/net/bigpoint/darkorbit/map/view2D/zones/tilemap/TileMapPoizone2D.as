package net.bigpoint.darkorbit.map.view2D.zones.tilemap
{
   import flash.display.BitmapData;
   import flash.geom.Rectangle;
   import net.bigpoint.darkorbit.map.view2D.backgrounds.model.BackgroundVO;
   import net.bigpoint.darkorbit.pattern.BackgroundPattern;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   
   public class TileMapPoizone2D extends BackgroundVO
   {
      
      private static const LIMITED_WIDTH:int = 5021;
      
      private static const LIMITED_HEIGHT:int = 3132;
      
      private static const MARGIN:int = 5000;
      
      private var _maskBitmapData:BitmapData;
      
      private var _bounds:Rectangle;
      
      private var _maskScale:Number = 0.1;
      
      public function TileMapPoizone2D(param1:int, param2:Rectangle, param3:int, param4:int)
      {
         var _loc12_:Number = NaN;
         this._bounds = param2;
         if(!(PatternManager.backgroundPatterns[param1] as BackgroundPattern).useOutOfMapBorder)
         {
            if(this._bounds.left < -MARGIN)
            {
               this._bounds.left = -MARGIN;
            }
            if(this._bounds.right > param3 + MARGIN)
            {
               this._bounds.right = param3 + MARGIN;
            }
            if(this._bounds.top < -MARGIN)
            {
               this._bounds.top = -MARGIN;
            }
            if(this._bounds.bottom > param4 + MARGIN)
            {
               this._bounds.bottom = param4 + MARGIN;
            }
         }
         var _loc5_:Number = Math.max(1,this._bounds.width / param3,this._bounds.height / param4) * this._maskScale;
         var _loc6_:Number = param3 * _loc5_;
         var _loc7_:Number = param4 * _loc5_;
         if(_loc6_ > LIMITED_WIDTH || _loc7_ > LIMITED_HEIGHT)
         {
            _loc12_ = Math.max(_loc6_ / LIMITED_WIDTH,_loc7_ / LIMITED_HEIGHT);
            this._maskScale /= _loc12_;
            _loc5_ /= _loc12_;
            _loc6_ /= _loc12_;
            _loc7_ /= _loc12_;
         }
         this._maskBitmapData = new BitmapData(int(_loc6_),int(_loc7_),true,0);
         var _loc8_:int = this._maskBitmapData.width * this._maskScale;
         var _loc9_:int = Math.abs(Math.round((param3 - _loc8_) / 2));
         var _loc10_:int = this._maskBitmapData.height * this._maskScale;
         var _loc11_:int = Math.abs(Math.round((param4 - _loc10_) / 2));
         super(param1,false,1,100,this._bounds.x,this._bounds.y,1,0,null,_loc5_ / this._maskScale);
      }
      
      override public function get maskBitmapData() : BitmapData
      {
         return this._maskBitmapData;
      }
      
      public function get maskScale() : Number
      {
         return this._maskScale;
      }
      
      public function dispose() : void
      {
         this._maskBitmapData.dispose();
         this._maskBitmapData = null;
      }
      
      public function get bounds() : Rectangle
      {
         return this._bounds;
      }
   }
}

