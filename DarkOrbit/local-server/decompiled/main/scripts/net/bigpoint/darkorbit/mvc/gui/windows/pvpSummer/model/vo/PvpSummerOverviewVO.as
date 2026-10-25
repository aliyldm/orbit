package net.bigpoint.darkorbit.mvc.gui.windows.pvpSummer.model.vo
{
   import com.bigpoint.utils.bindables.BindableCountDown;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class PvpSummerOverviewVO
   {
      
      public const changed:ISignal = new Signal();
      
      public const tooltipChanged:ISignal = new Signal();
      
      public const countdown:BindableCountDown = new BindableCountDown();
      
      private var _rep:uint;
      
      private var _repPerKill:uint;
      
      private var _nextRepMilestone:uint;
      
      private var _nextRepMilestoneRewards:PvPSummerMilestoneRewardsToolTipVO;
      
      public function PvpSummerOverviewVO()
      {
         super();
      }
      
      public function get rep() : uint
      {
         return this._rep;
      }
      
      public function get repPerKill() : uint
      {
         return this._repPerKill;
      }
      
      public function set rep(param1:uint) : void
      {
         this._rep = param1;
         this.changed.dispatch();
      }
      
      public function set repPerKill(param1:uint) : void
      {
         this._repPerKill = param1;
         this.changed.dispatch();
      }
      
      public function get nextRepMilestone() : uint
      {
         return this._nextRepMilestone;
      }
      
      public function set nextRepMilestone(param1:uint) : void
      {
         this._nextRepMilestone = param1;
         this.changed.dispatch();
      }
      
      public function get nextRepMilestoneRewards() : PvPSummerMilestoneRewardsToolTipVO
      {
         return this._nextRepMilestoneRewards;
      }
      
      public function set nextRepMilestoneRewards(param1:PvPSummerMilestoneRewardsToolTipVO) : void
      {
         this._nextRepMilestoneRewards = param1;
         this.tooltipChanged.dispatch();
      }
   }
}

