package net.bigpoint.darkorbit.mvc.sectorControl.map
{
   import com.bigpoint.utils.PointLite;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.com.module.AssetCreateCommand;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.traits.HealBeamSourceTrait;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.common.model.assets.UberAssetsLib;
   import net.bigpoint.darkorbit.mvc.sectorControlWindow.SectorControlWindowNotifications;
   
   public class SectorControllExitPoint extends MapEntity
   {
      
      public function SectorControllExitPoint(param1:AssetCreateCommand)
      {
         super(param1.assetId,new PointLite(param1.posX,param1.posY));
         UberAssetsLib.instance.fillTraits(this,"sectorControlExit_" + param1.factionId,UberAssetsLib.LIB_DEFAULT,param1.showBubble && param1.factionId == Hero.factionID.value ? this.openLeaveMatchDialog : null);
         addTrait(new HealBeamSourceTrait());
      }
      
      private function openLeaveMatchDialog() : void
      {
         GameFacade.getInstance().sendNotification(SectorControlWindowNotifications.OPEN_SECTOR_CONTROL_LEAVEMATCH_WINDOW);
      }
   }
}

