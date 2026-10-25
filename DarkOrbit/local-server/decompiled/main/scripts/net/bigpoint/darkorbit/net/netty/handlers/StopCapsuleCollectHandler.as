package net.bigpoint.darkorbit.net.netty.handlers
{
   import net.bigpoint.darkorbit.com.module.StopCapsuleCollectCommand;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class StopCapsuleCollectHandler extends BaseHandler
   {
      
      public function StopCapsuleCollectHandler()
      {
         super();
      }
      
      public static function run(param1:StopCapsuleCollectCommand) : void
      {
         ScreenManager.getInstance().map.effects.removeEffectFromMapObject(param1.collectorId,EffectIDList.COLLECTOR_BEAM);
      }
   }
}

