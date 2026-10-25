package net.bigpoint.darkorbit.fui.system.utils
{
   import flash.display.DisplayObjectContainer;
   
   public class FuiComponentSelectorUtil
   {
      
      public function FuiComponentSelectorUtil()
      {
         super();
      }
      
      public static function selectComponent(param1:String, param2:DisplayObjectContainer) : DisplayObjectContainer
      {
         var _loc3_:DisplayObjectContainer = null;
         var _loc5_:String = null;
         var _loc4_:Array = param1.split(".");
         _loc3_ = param2.getChildByName(_loc4_.shift()) as DisplayObjectContainer;
         for each(_loc5_ in _loc4_)
         {
            if(!_loc3_)
            {
               break;
            }
            _loc3_ = _loc3_.getChildByName(_loc5_) as DisplayObjectContainer;
         }
         return _loc3_;
      }
   }
}

