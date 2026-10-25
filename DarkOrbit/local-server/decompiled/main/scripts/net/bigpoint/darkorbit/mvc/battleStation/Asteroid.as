package net.bigpoint.darkorbit.mvc.battleStation
{
   import com.bigpoint.utils.PointLite;
   import net.bigpoint.darkorbit.com.module.AssetCreateCommand;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.traits.LabelTrait;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.BattleStationNotification;
   import net.bigpoint.darkorbit.mvc.common.model.assets.UberAssetsLib;
   
   public class Asteroid extends MapEntity
   {
      
      public function Asteroid(param1:AssetCreateCommand)
      {
         super(param1.assetId,new PointLite(param1.posX,param1.posY));
         UberAssetsLib.instance.fillTraits(this,"asteroid",UberAssetsLib.LIB_BATTLE_STATION,param1.showBubble ? this.handleIconClick : null,null,param1.userName);
      }
      
      private function handleIconClick() : void
      {
         GameFacade.getInstance().sendNotification(BattleStationNotification.BATTLE_STATION_ASSET_CLICKED,[id,LabelTrait(getFirstTrait(LabelTrait)).text.value]);
      }
   }
}

