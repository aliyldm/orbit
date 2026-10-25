package net.bigpoint.darkorbit.mvc.galaxygatebuilder.model
{
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.model.vo.ProbabilityVO;
   
   public class GalaxyGateBuilderAssets implements IGalaxyGateBuilderAssets
   {
      
      private var _multiplierValue:int;
      
      private var _multiplierState:Boolean;
      
      private var _probability:ProbabilityVO;
      
      private var _energyUrlSuffix:String;
      
      private var _rewards:Array;
      
      public function GalaxyGateBuilderAssets(param1:String = "")
      {
         super();
         this._energyUrlSuffix = param1;
      }
      
      public function getMultiplierValue() : int
      {
         return this._multiplierValue;
      }
      
      public function getMultiplierState() : Boolean
      {
         return this._multiplierState;
      }
      
      public function setMultiplierValue(param1:int) : void
      {
         this._multiplierValue = param1;
      }
      
      public function setMultiplierState(param1:Boolean) : void
      {
         this._multiplierState = param1;
      }
      
      public function getProbability() : ProbabilityVO
      {
         return this._probability;
      }
      
      public function setProbability(param1:ProbabilityVO) : void
      {
         this._probability = param1;
      }
      
      public function setEnergyUrlSuffix(param1:String) : void
      {
         this._energyUrlSuffix = param1;
      }
      
      public function getEnergyUrlSuffix() : String
      {
         return this._energyUrlSuffix;
      }
      
      public function setRewards(param1:Array) : void
      {
         this._rewards = param1;
      }
      
      public function getRewards() : Array
      {
         return this._rewards;
      }
   }
}

