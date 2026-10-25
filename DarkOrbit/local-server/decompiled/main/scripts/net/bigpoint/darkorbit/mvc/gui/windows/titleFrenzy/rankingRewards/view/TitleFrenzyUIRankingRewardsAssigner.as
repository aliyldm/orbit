package net.bigpoint.darkorbit.mvc.gui.windows.titleFrenzy.rankingRewards.view
{
   import com.bealearts.collection.VectorCollection;
   import com.bigpoint.utils.TextFormatter;
   import flash.events.MouseEvent;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.view.components.RewardsToolTipAssigner;
   import net.bigpoint.darkorbit.mvc.gui.windows.titleFrenzy.rankingRewards.model.TitleFrenzyUIRankingRewardsVO;
   
   public class TitleFrenzyUIRankingRewardsAssigner extends DefaultItemDataAssigner
   {
      
      private var _bg:Coreponent;
      
      private var _placing:Label;
      
      private var _infoBtn:Button;
      
      public function TitleFrenzyUIRankingRewardsAssigner()
      {
         super();
      }
      
      override public function assignChildren() : void
      {
         super.assignChildren();
         this._bg = FuiComponentSelectorUtil.selectComponent("bg",this) as Coreponent;
         this._placing = FuiComponentSelectorUtil.selectComponent("placing",this) as Label;
         this._infoBtn = FuiComponentSelectorUtil.selectComponent("infoBtn",this) as Button;
         this._infoBtn.tooltipTemplateID = "TITLE_FRENZY_RANKING_REWARDS_TOOLTIP";
         this._infoBtn.tooltipDataAssigner = new RewardsToolTipAssigner();
         this._infoBtn.addEventListener(MouseEvent.MOUSE_OVER,this.onHoverInfoBtn);
      }
      
      override public function set data(param1:Object) : void
      {
         var _loc2_:TitleFrenzyUIRankingRewardsVO = param1 as TitleFrenzyUIRankingRewardsVO;
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
      
      public function get VO() : TitleFrenzyUIRankingRewardsVO
      {
         return data as TitleFrenzyUIRankingRewardsVO;
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
         var _loc1_:String = TextFormatter.roundInteger(this.VO.min);
         if(this.VO.max >= int.MAX_VALUE)
         {
            _loc1_ += "+";
         }
         else if(this.VO.min != this.VO.max)
         {
            _loc1_ += " - " + TextFormatter.roundInteger(this.VO.max);
         }
         this._placing.text = _loc1_;
      }
      
      private function updateTooltip() : void
      {
         if(Boolean(this.VO) && Boolean(this.VO.rewards) && this.VO.rewards.length > 0)
         {
            this._infoBtn.tooltipData = new VectorCollection(this.VO.rewards);
         }
         this._infoBtn.visible = this.VO.rewards != null;
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
            dispatchEvent(new TitleFrenzyUIRankingRewardsEvent(TitleFrenzyUIRankingRewardsEvent.REQUEST_RANK_REWARD_INFO,this.VO));
         }
      }
   }
}

