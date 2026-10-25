package net.bigpoint.darkorbit.net.netty.handlers.combat
{
   import net.bigpoint.darkorbit.com.module.AttackHitAssetCommand;
   import net.bigpoint.darkorbit.mvc.mapElements.assets.MapAssetNotification;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class AttackHitAssetHandler extends BaseHandler
   {
      
      public function AttackHitAssetHandler()
      {
         super();
      }
      
      public static function run(param1:AttackHitAssetCommand) : void
      {
         _facade.forwardNotification(MapAssetNotification.MAP_ASSET_UPDATE_HP,[param1.assetId,param1.hitpointsNow,param1.hitpointsMax]);
      }
   }
}

