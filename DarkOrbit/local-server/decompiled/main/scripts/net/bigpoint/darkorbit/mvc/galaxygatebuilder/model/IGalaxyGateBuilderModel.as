package net.bigpoint.darkorbit.mvc.galaxygatebuilder.model
{
   import flash.events.IEventDispatcher;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.GalaxyGateBuilderDecorator;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.model.vo.GateVO;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.model.vo.ProbabilityVO;
   
   public interface IGalaxyGateBuilderModel extends IEventDispatcher
   {
      
      function handleKeyDown(param1:uint) : void;
      
      function getUridium() : Number;
      
      function getExtraEnergy() : int;
      
      function produce() : void;
      
      function getLastOutput() : String;
      
      function getProgress() : String;
      
      function getLivesLeft() : int;
      
      function getLifePrice() : int;
      
      function getProbability() : ProbabilityVO;
      
      function getEnergyCost() : int;
      
      function getErrorMessage() : String;
      
      function setGate(param1:int) : void;
      
      function prepareJump() : void;
      
      function getGateImages(param1:int) : GateVO;
      
      function getMultiplierValue() : int;
      
      function getMultiplierState() : Boolean;
      
      function setMultiplierState(param1:Boolean) : void;
      
      function getGateState() : Boolean;
      
      function isGateComplete(param1:int) : Boolean;
      
      function setAppRunning() : void;
      
      function showProbability() : void;
      
      function showHelp() : void;
      
      function hideHelp() : void;
      
      function getHelp() : String;
      
      function showReward() : void;
      
      function hideReward() : void;
      
      function getCurrentRewardData() : Array;
      
      function initGateLifePurchase(param1:int) : void;
      
      function purchaseGateLife() : void;
      
      function purchaseUridium() : void;
      
      function init(param1:GalaxyGateBuilderDecorator) : void;
      
      function setSpinAmount(param1:int) : void;
      
      function getSpinAmount() : int;
      
      function showLoadingAnimation() : void;
      
      function hideLoadingAnimation() : void;
      
      function getTotalWaveCount() : int;
      
      function getCurrentWaveCount() : int;
      
      function showAdditionalInformationDialog() : void;
      
      function isHadesGate() : Boolean;
      
      function getGateVO(param1:int) : GateVO;
   }
}

