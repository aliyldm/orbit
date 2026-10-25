package net.bigpoint.darkorbit.net.netty.handlers.poi
{
   import net.bigpoint.darkorbit.com.module.POIVisualModifierCommand;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class POIVisualModifierHandler extends BaseHandler
   {
      
      public function POIVisualModifierHandler()
      {
         super();
      }
      
      public static function run(param1:POIVisualModifierCommand) : void
      {
         ScreenManager.getInstance().map.poiManager.explodePOIZone(param1.poiId);
      }
   }
}

