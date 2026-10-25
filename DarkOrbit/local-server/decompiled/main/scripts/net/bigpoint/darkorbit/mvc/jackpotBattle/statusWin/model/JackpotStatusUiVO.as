package net.bigpoint.darkorbit.mvc.jackpotBattle.statusWin.model
{
   public class JackpotStatusUiVO
   {
      
      public var registerdUsersCount:int;
      
      public var registerdUsersTotal:int;
      
      public var leftUserName:String = "";
      
      public var rightUserName:String = "";
      
      public var roundCount:int;
      
      public var remainingTime:Number = 0;
      
      public var matchType:int;
      
      public function JackpotStatusUiVO()
      {
         super();
      }
   }
}

