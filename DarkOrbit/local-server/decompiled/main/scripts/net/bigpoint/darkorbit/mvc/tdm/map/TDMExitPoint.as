package net.bigpoint.darkorbit.mvc.tdm.map
{
   import com.bigpoint.utils.PointLite;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.com.module.AssetCreateCommand;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.traits.HealBeamSourceTrait;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.common.model.assets.UberAssetsLib;
   import net.bigpoint.darkorbit.mvc.tdm.spawnPoint.controller.TDMShowLeaveMatchDialogCommand;
   import net.bigpoint.darkorbit.mvc.tdm.spawnPoint.notifications.TDMSpawPointNotifications;
   
   public class TDMExitPoint extends MapEntity
   {
      
      public function TDMExitPoint(param1:AssetCreateCommand)
      {
         super(param1.assetId,new PointLite(param1.posX,param1.posY));
         UberAssetsLib.instance.fillTraits(this,"tdm_exit_" + param1.factionId,UberAssetsLib.LIB_DEFAULT,param1.showBubble && param1.factionId == Hero.factionID.value ? this.openLeaveMatchDialog : null);
         addTrait(new HealBeamSourceTrait());
      }
      
      private function openLeaveMatchDialog() : void
      {
         if(!GameFacade.getInstance().hasCommand(TDMSpawPointNotifications.OPEN_TDM_LEAVEMATCH_WINDOW))
         {
            GameFacade.getInstance().registerCommand(TDMSpawPointNotifications.OPEN_TDM_LEAVEMATCH_WINDOW,TDMShowLeaveMatchDialogCommand);
         }
         GameFacade.getInstance().sendNotification(TDMSpawPointNotifications.OPEN_TDM_LEAVEMATCH_WINDOW);
      }
   }
}

