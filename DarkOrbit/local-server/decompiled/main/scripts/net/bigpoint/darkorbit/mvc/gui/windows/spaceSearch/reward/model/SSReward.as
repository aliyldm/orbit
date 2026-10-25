package net.bigpoint.darkorbit.mvc.gui.windows.spaceSearch.reward.model
{
   public class SSReward
   {
      
      public var lootId:String;
      
      public var amount:int;
      
      public function SSReward(param1:String, param2:int)
      {
         super();
         this.lootId = param1;
         this.amount = param2;
      }
   }
}

