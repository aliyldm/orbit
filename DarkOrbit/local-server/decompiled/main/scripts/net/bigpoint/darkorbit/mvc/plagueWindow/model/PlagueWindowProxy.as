package net.bigpoint.darkorbit.mvc.plagueWindow.model
{
   import net.bigpoint.darkorbit.com.module.SpacePlagueBossSummoningProgressCommand;
   import net.bigpoint.darkorbit.com.module.SpacePlagueInfectionStatusCommand;
   import net.bigpoint.darkorbit.com.module.SpacePlagueRatingStatusCommand;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.gui.common.abstract.model.DOAbstractProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.warpControls.mode.WarpControlsProxy;
   import net.bigpoint.darkorbit.mvc.plagueWindow.PlagueWindowNotifications;
   
   public class PlagueWindowProxy extends DOAbstractProxy
   {
      
      public static const NAME:String = "PlagueWindowProxy";
      
      public function PlagueWindowProxy(param1:Object = null)
      {
         super(NAME,param1);
      }
      
      private function get model() : PlagueModel
      {
         return data as PlagueModel;
      }
      
      override public function onRegister() : void
      {
         super.onRegister();
         this.model.timeLeft.changed.add(this.updateTimer);
         this.updateMapId();
         ScreenManager.getInstance().mapChanged.add(this.updateMapId);
      }
      
      override public function onRemove() : void
      {
         super.onRemove();
         this.model.timeLeft.changed.remove(this.updateView);
         ScreenManager.getInstance().mapChanged.remove(this.updateMapId);
      }
      
      public function updateView() : void
      {
         sendNotification(PlagueWindowNotifications.UPDATE_VIEW,this.model);
      }
      
      public function setBossSummoningInfos(param1:Vector.<SpacePlagueBossSummoningProgressCommand>) : void
      {
         this.model.setBossSummoningInfos(param1);
         this.updateView();
      }
      
      public function setInfection(param1:SpacePlagueInfectionStatusCommand) : void
      {
         this.model.setInfection(param1);
         this.updateView();
      }
      
      public function setRating(param1:SpacePlagueRatingStatusCommand) : void
      {
         this.model.setRating(param1);
         this.updateView();
      }
      
      private function updateTimer() : void
      {
         sendNotification(PlagueWindowNotifications.UPDATE_TIMER,this.model);
      }
      
      private function updateMapId() : void
      {
         this.model.setCurrentMapId(ScreenManager.getInstance().map.mapID);
         WarpControlsProxy.getProxy(GameFacade.getInstance()).sendListRequest();
         this.updateView();
      }
   }
}

