package net.bigpoint.darkorbit.mvc.gui.windows.worldBoss.rankingRewards.view
{
   import com.bealearts.collection.VectorCollection;
   import flash.events.MouseEvent;
   import net.bigpoint.darkorbit.com.module.RewardTitleModule;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.view.components.RewardsToolTipAssigner;
   import net.bigpoint.darkorbit.mvc.gui.windows.worldBoss.rankingRewards.model.WorldBossUIRankingRewardsVO;
   
   public class WorldBossUIRankingRewardsAssigner extends DefaultItemDataAssigner
   {
      
      private var _bg:Coreponent;
      
      private var _placing:Label;
      
      private var _infoBtn:Button;
      
      public function WorldBossUIRankingRewardsAssigner()
      {
         super();
      }
      
      override public function assignChildren() : void
      {
         super.assignChildren();
         this._bg = FuiComponentSelectorUtil.selectComponent("bg",this) as Coreponent;
         this._placing = FuiComponentSelectorUtil.selectComponent("placing",this) as Label;
         this._infoBtn = FuiComponentSelectorUtil.selectComponent("infoBtn",this) as Button;
         this._infoBtn.tooltipTemplateID = "WORLD_BOSS_RANKING_REWARDS_TOOLTIP";
         this._infoBtn.tooltipDataAssigner = new net.bigpoint.darkorbit.mvc.gui.windows.common.view.components.RewardsToolTipAssigner();
         this._infoBtn.addEventListener(MouseEvent.MOUSE_OVER,this.onHoverInfoBtn);
      }
      
      override public function set data(param1:Object) : void
      {
         var _loc2_:WorldBossUIRankingRewardsVO = param1 as WorldBossUIRankingRewardsVO;
         if(!_loc2_)
         {
            visible = false;
            return;
         }
         this.removeListeners();
         super.data = _loc2_;
         this.addListeners();
         this.update();
      }
      
      private function addListeners() : void
      {
         if(!this.VO)
         {
            return;
         }
         this.VO.rewardListChanged.add(this.update);
      }
      
      private function removeListeners() : void
      {
         if(!this.VO)
         {
            return;
         }
         this.VO.rewardListChanged.remove(this.update);
      }
      
      public function get VO() : WorldBossUIRankingRewardsVO
      {
         return data as WorldBossUIRankingRewardsVO;
      }
      
      private function update() : void
      {
         this.updateLabel();
         this.updateTooltip();
      }
      
      private function updateLabel() : void
      {
         if(!this.VO)
         {
            return;
         }
         this._placing.text = this.VO.title;
      }
      
      private function updateTooltip() : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:RewardTitleModule = null;
         var _loc1_:Vector.<Object> = new Vector.<Object>();
         if(Boolean(this.VO) && Boolean(this.VO.rewards) && this.VO.rewards.length > 0)
         {
            _loc2_ = 0;
            while(_loc2_ < this.VO.rewards.length)
            {
               _loc1_.push(this.VO.rewards[_loc2_]);
               _loc2_++;
            }
         }
         if(Boolean(this.VO) && Boolean(this.VO.titleList) && this.VO.titleList.length > 0)
         {
            _loc3_ = 0;
            while(_loc3_ < this.VO.titleList.length)
            {
               _loc4_ = this.VO.titleList[_loc3_];
               if(_loc4_.titleKey != "")
               {
                  _loc1_.push(this.VO.titleList[_loc3_]);
               }
               _loc3_++;
            }
         }
         if(_loc1_.length > 0)
         {
            this._infoBtn.tooltipData = new VectorCollection(_loc1_);
         }
         this._infoBtn.visible = _loc1_.length > 0;
      }
      
      override public function set index(param1:int) : void
      {
         super.index = param1;
         this._bg.visible = param1 % 2 != 0;
      }
      
      private function onHoverInfoBtn(param1:MouseEvent) : void
      {
         if(Boolean(this.VO) && Boolean(this.VO.rewards) && this.VO.rewards.length == 0)
         {
            dispatchEvent(new WorldBossUIRankingRewardsEvent(WorldBossUIRankingRewardsEvent.REQUEST_RANK_REWARD_INFO,this.VO));
         }
      }
   }
}

