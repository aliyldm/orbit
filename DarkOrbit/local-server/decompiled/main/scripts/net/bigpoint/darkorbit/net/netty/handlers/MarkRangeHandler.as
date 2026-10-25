package net.bigpoint.darkorbit.net.netty.handlers
{
   import com.greensock.TweenLite;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.text.TextField;
   import net.bigpoint.darkorbit.com.module.MarkRangeCommand;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class MarkRangeHandler extends BaseHandler
   {
      
      private static var activeRangeClips:Vector.<DisplayObjectContainer> = new Vector.<DisplayObjectContainer>();
      
      public function MarkRangeHandler()
      {
         super();
      }
      
      public static function run(param1:MarkRangeCommand) : void
      {
         var _loc3_:Shape = null;
         var _loc4_:TextField = null;
         var _loc6_:Number = NaN;
         var _loc2_:DisplayObjectContainer = new Sprite();
         _loc3_ = new Shape();
         _loc3_.cacheAsBitmap = true;
         _loc3_.graphics.lineStyle(2,param1.color);
         _loc3_.graphics.drawCircle(0,0,param1.range);
         _loc4_ = new TextField();
         _loc4_.appendText(param1.range.toString());
         _loc4_.textColor = param1.color;
         _loc4_.x = param1.range - _loc4_.textWidth - 5;
         _loc2_.addChild(_loc3_);
         _loc2_.addChild(_loc4_);
         var _loc5_:Ship = ScreenManager.getInstance().map.getEntityById(param1.uid) as Ship;
         if((Boolean(_loc5_)) && Boolean(_loc5_))
         {
            activeRangeClips.push(_loc2_);
            _loc6_ = param1.durationMillis;
            if(_loc6_ != -1)
            {
               _loc6_ /= 1000;
               TweenLite.delayedCall(_loc6_,removeSavely,[_loc2_]);
            }
         }
      }
      
      public static function removeAll() : void
      {
         while(activeRangeClips.length > 0)
         {
            removeSavely(activeRangeClips.pop() as DisplayObjectContainer);
         }
      }
      
      private static function removeSavely(param1:DisplayObject) : void
      {
         var _loc2_:int = 0;
         if(Boolean(param1) && Boolean(param1.parent))
         {
            param1.parent.removeChild(param1);
            _loc2_ = activeRangeClips.indexOf(param1);
            if(_loc2_ != -1)
            {
               activeRangeClips.slice(_loc2_,_loc2_ + 1);
            }
         }
      }
   }
}

