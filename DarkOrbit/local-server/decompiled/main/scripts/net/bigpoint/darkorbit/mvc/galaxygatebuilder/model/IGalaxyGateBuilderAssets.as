package net.bigpoint.darkorbit.mvc.galaxygatebuilder.model
{
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.model.vo.ProbabilityVO;
   
   public interface IGalaxyGateBuilderAssets
   {
      
      function getMultiplierValue() : int;
      
      function getMultiplierState() : Boolean;
      
      function setMultiplierValue(param1:int) : void;
      
      function setMultiplierState(param1:Boolean) : void;
      
      function getProbability() : ProbabilityVO;
      
      function setProbability(param1:ProbabilityVO) : void;
      
      function setEnergyUrlSuffix(param1:String) : void;
      
      function getEnergyUrlSuffix() : String;
      
      function setRewards(param1:Array) : void;
      
      function getRewards() : Array;
   }
}

