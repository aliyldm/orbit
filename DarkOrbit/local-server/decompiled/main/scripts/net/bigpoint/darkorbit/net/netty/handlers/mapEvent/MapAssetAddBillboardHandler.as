package net.bigpoint.darkorbit.net.netty.handlers.mapEvent
{
   import net.bigpoint.darkorbit.com.module.AssetTypeModule;
   import net.bigpoint.darkorbit.com.module.MapAssetAddBillboardCommand;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.model.env.Billboard;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class MapAssetAddBillboardHandler extends BaseHandler
   {
      
      public function MapAssetAddBillboardHandler()
      {
         super();
      }
      
      public static function run(param1:MapAssetAddBillboardCommand) : void
      {
         var _loc2_:Billboard = null;
         if(param1.type.typeValue == AssetTypeModule.ASSETTYPE_BILLBOARD_ASTEROID)
         {
            _loc2_ = new Billboard(param1.uid,param1.x,param1.y,param1.partnerType.typeValue);
            ScreenManager.getInstance().map.addEntity(_loc2_);
         }
      }
   }
}

