package net.bigpoint.darkorbit.net.netty.handlers
{
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ActivationZoneStatusCommand;
   import net.bigpoint.darkorbit.map.model.poizones.POIZone;
   import net.bigpoint.darkorbit.map.model.poizones.POIZoneManager;
   import net.bigpoint.darkorbit.map.model.poizones.circle.CircleZone;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class ActivationZoneStatusHandler extends BaseHandler
   {
      
      public function ActivationZoneStatusHandler()
      {
         super();
      }
      
      public static function run(param1:IModule) : void
      {
         var _loc2_:ActivationZoneStatusCommand = null;
         var _loc3_:POIZoneManager = null;
         var _loc4_:POIZone = null;
         if(map != null)
         {
            _loc2_ = param1 as ActivationZoneStatusCommand;
            _loc3_ = map.poiManager;
            _loc4_ = _loc3_.getZoneById(_loc2_.poiId);
            if((Boolean(_loc4_)) && _loc4_ is CircleZone)
            {
               CircleZone(_loc4_).radius.value = _loc2_.currentValue;
            }
         }
      }
   }
}

