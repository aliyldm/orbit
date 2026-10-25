package net.bigpoint.darkorbit.mvc.galaxygatebuilder.model
{
   import net.bigpoint.darkorbit.com.module.GalaxyGateBuilderBuyLifeCommand;
   import net.bigpoint.darkorbit.com.module.GalaxyGateBuilderGateCompleteCommand;
   import net.bigpoint.darkorbit.com.module.GalaxyGateBuilderGateLifeLostCommand;
   import net.bigpoint.darkorbit.com.module.GalaxyGateBuilderGateWaveUpdateCommand;
   import net.bigpoint.darkorbit.com.module.GalaxyGateBuilderGetGatePartsCommand;
   import net.bigpoint.darkorbit.com.module.GalaxyGateBuilderInfoCommand;
   import net.bigpoint.darkorbit.com.module.GalaxyGateBuilderMultiEnergyCommand;
   import net.bigpoint.darkorbit.com.module.GalaxyGateBuilderSetupGateCommand;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.view.events.ApplicationEvent;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.view.events.MachineEvent;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.model.SimpleWindowProxy;
   
   public class GalaxyGateBuilderProxy extends SimpleWindowProxy
   {
      
      public function GalaxyGateBuilderProxy(param1:String, param2:IGalaxyGateBuilderModel)
      {
         super(param1,param2);
      }
      
      public function get viewData() : GalaxyGateBuilderModel
      {
         return data as GalaxyGateBuilderModel;
      }
      
      public function investEnergy() : void
      {
         this.viewData.produce();
      }
      
      public function confirmGateLifePurchase() : void
      {
         this.viewData.purchaseGateLife();
      }
      
      public function confirmUridiumPurchase() : void
      {
         this.viewData.purchaseUridium();
      }
      
      public function setGateHandler(param1:int) : void
      {
         this.viewData.setGate(param1);
         this.viewData.dispatchEvent(new ApplicationEvent(ApplicationEvent.LIVES_LEFT_UPDATE));
         this.viewData.dispatchEvent(new ApplicationEvent(ApplicationEvent.LIFE_PRICE_UPDATE));
         this.viewData.dispatchEvent(new ApplicationEvent(ApplicationEvent.BUY_BUTTON_VISIBILITY));
      }
      
      public function prepareJumpHandler() : void
      {
         this.viewData.prepareJump();
      }
      
      public function setAppRunningHandler() : void
      {
         this.viewData.setAppRunning();
      }
      
      public function setMultiplierStateHandler(param1:Boolean) : void
      {
         this.viewData.setMultiplierState(param1);
      }
      
      public function showProbabilityHandler() : void
      {
         this.viewData.showProbability();
      }
      
      public function showHelpHandler() : void
      {
         this.viewData.showHelp();
      }
      
      public function hideHelpHandler() : void
      {
         this.viewData.hideHelp();
      }
      
      public function showAdditionalInformationDialog() : void
      {
         this.viewData.showAdditionalInformationDialog();
      }
      
      public function hideAdditionalInformationDialog() : void
      {
      }
      
      public function showRewardHandler() : void
      {
         this.viewData.showReward();
      }
      
      public function hideRewardHandler() : void
      {
         this.viewData.hideReward();
      }
      
      public function setSpinAmountHandler(param1:int) : void
      {
         this.viewData.setSpinAmount(param1);
      }
      
      public function resizeMachineHandler(param1:int) : void
      {
         var _loc2_:MachineEvent = new MachineEvent(MachineEvent.ON_RESIZE);
         _loc2_.offsetY = param1;
         this.viewData.dispatchEvent(_loc2_);
      }
      
      public function showLoadingAnimationHandler() : void
      {
         this.viewData.showLoadingAnimation();
      }
      
      public function hideLoadingAnimationHandler() : void
      {
         this.viewData.hideLoadingAnimation();
      }
      
      public function handleInitUser(param1:GalaxyGateBuilderInfoCommand) : void
      {
         this.viewData.handleInitUserComplete(param1);
      }
      
      public function handleGateLifePurchase(param1:GalaxyGateBuilderBuyLifeCommand) : void
      {
         this.viewData.handleGateLifePurchaseComplete(param1);
      }
      
      public function handlePrepareJump(param1:GalaxyGateBuilderSetupGateCommand) : void
      {
         this.viewData.handlePrepareJumpComplete(param1);
      }
      
      public function handleProduceResponse(param1:GalaxyGateBuilderMultiEnergyCommand) : void
      {
         this.viewData.parseProduceResponse(param1);
      }
      
      public function handleGateParts(param1:GalaxyGateBuilderGetGatePartsCommand) : void
      {
         if(!param1)
         {
            return;
         }
         if(param1.errorCode > 0)
         {
            this.viewData.handleGateImageError(param1.gateId,param1.errorCode);
            return;
         }
         this.viewData.loadGateImage(param1.gateId,param1.gatePartIds,true);
      }
      
      public function handleGateComplete(param1:GalaxyGateBuilderGateCompleteCommand) : void
      {
         this.viewData.updateGateComplete(param1);
      }
      
      public function handleGateLifeLost(param1:GalaxyGateBuilderGateLifeLostCommand) : void
      {
         this.viewData.updateGateLifeLost(param1);
      }
      
      public function handleGateWaveUpdate(param1:GalaxyGateBuilderGateWaveUpdateCommand) : void
      {
         this.viewData.updateGateWaves(param1);
      }
   }
}

