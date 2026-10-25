package net.bigpoint.darkorbit.mvc.stats.model.vo
{
   public class StatsVO
   {
      
      public var lastFPSs:Vector.<int> = new Vector.<int>(0);
      
      public var currentFPS:int = 0;
      
      public var currentMem:Number = 0;
      
      public var joinedParams:String = "";
      
      public function StatsVO()
      {
         super();
      }
   }
}

