package net.bigpoint.darkorbit.mvc.gui.windows.roguelite.model.vo
{
   import com.bigpoint.utils.bindables.BindableInt;
   import net.bigpoint.darkorbit.com.module.RewardContentModule;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class RogueLiteRankRewardVO
   {
      
      public const rewardListChanged:ISignal = new Signal();
      
      private var _rewardList:Vector.<RewardContentModule> = new Vector.<RewardContentModule>(0);
      
      private var _placement:BindableInt = new BindableInt(0,0);
      
      public function RogueLiteRankRewardVO(param1:BindableInt)
      {
         super();
         this._placement = param1;
      }
      
      public static function sort(param1:RogueLiteRankRewardVO, param2:RogueLiteRankRewardVO) : int
      {
         return param1.min - param2.min;
      }
      
      public function get rewards() : Vector.<RewardContentModule>
      {
         return this._rewardList;
      }
      
      public function set rewards(param1:Vector.<RewardContentModule>) : void
      {
         this._rewardList = param1;
         this.rewardListChanged.dispatch();
      }
      
      public function get min() : int
      {
         return this._placement.minValue;
      }
      
      public function get max() : int
      {
         return this._placement.maxValue;
      }
   }
}

