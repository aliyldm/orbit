package net.bigpoint.darkorbit.mvc.jackpotBattle.statusWin.model
{
   public class JackpotTimeVo
   {
      
      public var time:int;
      
      public var timeOffset:int;
      
      public function JackpotTimeVo(param1:int, param2:int)
      {
         super();
         this.time = param1;
         this.timeOffset = param2;
      }
      
      public function toString() : String
      {
         return "time: " + this.time + " offset: " + this.timeOffset;
      }
   }
}

