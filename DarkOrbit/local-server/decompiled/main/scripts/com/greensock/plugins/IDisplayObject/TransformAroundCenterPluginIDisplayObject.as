package com.greensock.plugins.IDisplayObject
{
   import com.greensock.TweenLite;
   import flash.display.DisplayObject;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import net.bigpoint.darkorbit.mvc.display.IDODisplayObject;
   import net.bigpoint.darkorbit.mvc.display.IDOSprite;
   import net.bigpoint.darkorbit.mvc.display.impl.flash.DOFlashSprite;
   import net.bigpoint.darkorbit.mvc.display.impl.starling.DOStarlingSprite;
   
   public class TransformAroundCenterPluginIDisplayObject extends TransformAroundPointPluginIDisplayObject
   {
      
      public static const API:Number = 1;
      
      public function TransformAroundCenterPluginIDisplayObject()
      {
         super();
         this.propName = "transformAroundCenterIDisplayObject";
      }
      
      override public function onInitTween(param1:Object, param2:*, param3:TweenLite) : Boolean
      {
         var _loc8_:IDOSprite = null;
         var _loc4_:Boolean = false;
         var _loc5_:IDODisplayObject = param1 as IDODisplayObject;
         if(_loc5_.untypedParent == null)
         {
            _loc4_ = true;
            _loc8_ = _loc5_ is DisplayObject ? new DOFlashSprite() : new DOStarlingSprite();
            _loc8_.addUntypedChild(_loc5_);
         }
         var _loc6_:Rectangle = _loc5_.getUntypedBounds(_loc5_.untypedParent);
         param2.point = new Point(_loc6_.x + _loc6_.width * 0.5,_loc6_.y + _loc6_.height * 0.5);
         if(_loc4_)
         {
            _loc5_.untypedParent.removeChild(_loc5_);
         }
         var _loc7_:Boolean = super.onInitTween(_loc5_,param2,param3);
         if(_loc6_.width < 1 || _loc6_.height < 1)
         {
            _loc6_ = _loc5_.getUntypedBounds(_loc5_);
            _local = new Point(_loc6_.x + _loc6_.width * 0.5,_loc6_.y + _loc6_.height * 0.5);
         }
         return _loc7_;
      }
   }
}

