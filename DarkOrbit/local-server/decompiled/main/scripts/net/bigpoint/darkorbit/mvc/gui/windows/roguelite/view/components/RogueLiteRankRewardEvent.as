package net.bigpoint.darkorbit.mvc.gui.windows.roguelite.view.components
{
   import flash.events.Event;
   import net.bigpoint.darkorbit.mvc.gui.windows.roguelite.model.vo.RogueLiteRankRewardVO;
   
   public class RogueLiteRankRewardEvent extends Event
   {
      
      public static const REQUEST_RANK_REWARD_INFO:String = "RogueLiteRankRewardEvent.REQUEST_RANK_REWARD_INFO";
      
      private var _vo:RogueLiteRankRewardVO;
      
      public function RogueLiteRankRewardEvent(param1:String, param2:RogueLiteRankRewardVO, param3:Boolean = true, param4:Boolean = false)
      {
         super(param1,param3,param4);
         this._vo = param2;
      }
      
      public function get VO() : RogueLiteRankRewardVO
      {
         return this._vo;
      }
   }
}

