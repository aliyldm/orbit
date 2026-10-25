package net.bigpoint.darkorbit.mvc.gui.windows.spaceSearch.reward.model
{
   public class SSPlanet
   {
      
      public var planetId:int;
      
      public var pPct:int;
      
      public var pIncrease:int;
      
      public function SSPlanet(param1:int, param2:int, param3:int)
      {
         super();
         this.planetId = param1;
         this.pPct = param2;
         this.pIncrease = param3;
      }
   }
}

