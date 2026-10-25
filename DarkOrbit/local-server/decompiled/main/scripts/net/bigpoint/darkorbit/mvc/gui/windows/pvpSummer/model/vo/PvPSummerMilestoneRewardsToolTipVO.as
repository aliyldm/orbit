package net.bigpoint.darkorbit.mvc.gui.windows.pvpSummer.model.vo
{
   import net.bigpoint.darkorbit.com.module.RewardContentModule;
   
   public class PvPSummerMilestoneRewardsToolTipVO
   {
      
      private var _rewards:Vector.<RewardContentModule>;
      
      private var _titleReputation:int;
      
      public function PvPSummerMilestoneRewardsToolTipVO(param1:Vector.<RewardContentModule>, param2:int)
      {
         super();
         this._rewards = param1;
         this._titleReputation = param2;
      }
      
      public function get rewards() : Vector.<RewardContentModule>
      {
         return this._rewards;
      }
      
      public function set rewards(param1:Vector.<RewardContentModule>) : void
      {
         this._rewards = param1;
      }
      
      public function get titleReputation() : int
      {
         return this._titleReputation;
      }
      
      public function set titleReputation(param1:int) : void
      {
         this._titleReputation = param1;
      }
   }
}

