package net.bigpoint.darkorbit.mvc.gui.windows.miniClientReward.view
{
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.fui.UISystem;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.core.InvalidationType;
   import net.bigpoint.darkorbit.fui.components.scroll.ScrollContainer;
   import net.bigpoint.darkorbit.fui.components.scroll.Scrollbar;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   import net.bigpoint.darkorbit.mvc.gui.windows.miniClientReward.model.MiniClientRewardVO;
   
   public class MiniClientRewardView
   {
      
      private static const CONTENT_WIDTH:int = 570;
      
      private static const DEFAULT_VIEW_HEIGHT:int = 360;
      
      private static const BOTTOM_HEIGHT:int = 111;
      
      private static const ITEMS_PER_ROW:int = 7;
      
      private static const NORMAL_ITEM_WIDTH:int = 80;
      
      private static const LAST_ITEM_WIDTH:int = 170;
      
      private static const REWARD_ITEM_HEIGHT:int = 120;
      
      private static const NORMAL_REWARD_TEMPLATE:XML = <container width="80" autoSizeWidth="false" height="120" mouseEnabled="true" mouseChildren="true">
				<label name="day" registeredSkinName="commonui_default_label" registeredTextStyleName="rewards_day_text_default" alightX="left" marginTop="10" width="66" autoSizeTextHeight="true"/>

				<button name="bg" registeredSkinName="reward_bg" width="80" height="120" alignX="center" alignY="center"/>

				<button name="pic" width="50" height="50"/>

				<coreponent name="checkmark" width="42" height="38" marginLeft="15" alignY="center" visible="false" registeredSkinName="reward_checkmark"/>

				<label name="amount" registeredSkinName="commonui_default_label" registeredTextStyleName="rewards_amount_text_default" alightX="center" marginBottom="18" width="80" autoSizeTextHeight="true" alignY="bottom"/>
			</container>;
      
      private static const LAST_REWARD_TEMPLATE:XML = <container width="170" autoSizeWidth="false" height="120" mouseEnabled="true" mouseChildren="true">
				<label name="day" registeredSkinName="commonui_default_label" registeredTextStyleName="rewards_day_text_default" alightX="left" marginTop="10" width="160" autoSizeTextHeight="true"/>

				<button name="bg" registeredSkinName="reward_last_bg" width="170" height="120" alignX="center" alignY="center"/>

				<button name="pic" width="198" height="98"/>

				<coreponent name="checkmark" width="42" height="38" marginLeft="64" alignY="center" visible="false" registeredSkinName="reward_checkmark"/>

				<label name="amount" registeredSkinName="commonui_default_label" registeredTextStyleName="rewards_amount_text_default" alightX="center" marginBottom="18" width="160" autoSizeTextHeight="true" alignY="bottom"/>
			</container>;
      
      private var _uiContainer:Sprite;
      
      private var _fuiCache:FuiComponentSelectorCache;
      
      private var _rewardItems:Vector.<MiniClientRewardItemAssigner> = new Vector.<MiniClientRewardItemAssigner>(0);
      
      public function MiniClientRewardView(param1:Sprite)
      {
         super();
         this._uiContainer = param1;
         this._fuiCache = new FuiComponentSelectorCache(this._uiContainer);
      }
      
      public function get list_scroll_bar() : Scrollbar
      {
         return this._fuiCache.selectComponent("root.rewards.body.reward_list_scroll_bar") as Scrollbar;
      }
      
      public function get rewardScrollContainer() : ScrollContainer
      {
         return this._fuiCache.selectComponent("root.rewards.body.reward_scroll_container") as ScrollContainer;
      }
      
      public function get rewardContent() : Coreponent
      {
         return this._fuiCache.selectComponent("root.rewards.body.reward_scroll_container.content") as Coreponent;
      }
      
      public function get overlayBg() : Coreponent
      {
         return this._fuiCache.selectComponent("root.rewards.body.overlay.overlay_bg") as Coreponent;
      }
      
      public function get overlayText() : Label
      {
         return this._fuiCache.selectComponent("root.rewards.body.overlay.overlay_text") as Label;
      }
      
      public function get claimBtn() : Button
      {
         return this._fuiCache.selectComponent("root.rewards.bottom.claim_btn") as Button;
      }
      
      public function get downloadBtn() : Button
      {
         return this._fuiCache.selectComponent("root.rewards.bottom.download_btn") as Button;
      }
      
      public function get timer() : Label
      {
         return this._fuiCache.selectComponent("root.rewards.bottom.countdown_timer") as Label;
      }
      
      public function get timerText() : Label
      {
         return this._fuiCache.selectComponent("root.rewards.bottom.countdown_text") as Label;
      }
      
      private function get root() : Coreponent
      {
         return this._fuiCache.selectComponent("root") as Coreponent;
      }
      
      private function get rewardsContainer() : Coreponent
      {
         return this._fuiCache.selectComponent("root.rewards") as Coreponent;
      }
      
      private function get body() : Coreponent
      {
         return this._fuiCache.selectComponent("root.rewards.body") as Coreponent;
      }
      
      public function renderRewards(param1:Vector.<MiniClientRewardVO>) : int
      {
         var _loc3_:MiniClientRewardVO = null;
         var _loc4_:MiniClientRewardVO = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         this.clearRewardItems();
         if(!param1 || param1.length <= 0)
         {
            return this.applyViewHeight(REWARD_ITEM_HEIGHT);
         }
         var _loc2_:Vector.<MiniClientRewardVO> = new Vector.<MiniClientRewardVO>(0);
         for each(_loc4_ in param1)
         {
            if(_loc4_.isLast)
            {
               _loc3_ = _loc4_;
            }
            else
            {
               _loc2_.push(_loc4_);
            }
         }
         _loc6_ = _loc2_.length > 0 ? int(Math.ceil(_loc2_.length / ITEMS_PER_ROW)) : 0;
         _loc5_ = 0;
         while(_loc5_ < _loc2_.length)
         {
            this.addRewardItem(_loc2_[_loc5_],false,this.getNormalRewardX(_loc5_),Math.floor(_loc5_ / ITEMS_PER_ROW) * REWARD_ITEM_HEIGHT);
            _loc5_++;
         }
         if(_loc3_)
         {
            this.addRewardItem(_loc3_,true,int((CONTENT_WIDTH - LAST_ITEM_WIDTH) / 2),_loc6_ * REWARD_ITEM_HEIGHT);
         }
         return this.applyViewHeight((_loc6_ + (_loc3_ ? 1 : 0)) * REWARD_ITEM_HEIGHT);
      }
      
      private function applyViewHeight(param1:int) : int
      {
         var _loc2_:int = 0;
         _loc2_ = Math.max(DEFAULT_VIEW_HEIGHT,param1 + BOTTOM_HEIGHT);
         var _loc3_:int = Math.max(DEFAULT_VIEW_HEIGHT - BOTTOM_HEIGHT,param1);
         this.rewardContent.height = param1;
         this.rewardScrollContainer.setSize(CONTENT_WIDTH,_loc3_);
         this.rewardContent.forceRedraw(InvalidationType.SIZE);
         this.rewardScrollContainer.forceRedraws([InvalidationType.SIZE,InvalidationType.LAYOUT],true);
         this.rewardScrollContainer.setScrollPositionInPercent(0);
         this.body.setSize(CONTENT_WIDTH,_loc3_);
         this.body.forceRedraws([InvalidationType.SIZE,InvalidationType.LAYOUT],true);
         this.rewardsContainer.setSize(CONTENT_WIDTH,_loc2_);
         this.rewardsContainer.forceRedraws([InvalidationType.SIZE,InvalidationType.LAYOUT],true);
         this.root.setSize(580,_loc2_);
         this.root.forceRedraws([InvalidationType.SIZE,InvalidationType.LAYOUT],true);
         this.list_scroll_bar.visible = false;
         return _loc2_;
      }
      
      private function addRewardItem(param1:MiniClientRewardVO, param2:Boolean, param3:int, param4:int) : void
      {
         var _loc5_:MiniClientRewardItemAssigner = new MiniClientRewardItemAssigner();
         UISystem.getInstance().build(param2 ? LAST_REWARD_TEMPLATE : NORMAL_REWARD_TEMPLATE,_loc5_,true);
         this.rewardContent.addChild(_loc5_);
         param4 = param4 > 10 ? int(param4 - 10) : param4;
         _loc5_.x = param3;
         _loc5_.y = param4;
         _loc5_.data = param1;
         _loc5_.forceRedraws([InvalidationType.SIZE,InvalidationType.POSITION,InvalidationType.LAYOUT],true);
         this._rewardItems.push(_loc5_);
      }
      
      private function clearRewardItems() : void
      {
         var _loc1_:MiniClientRewardItemAssigner = null;
         for each(_loc1_ in this._rewardItems)
         {
            _loc1_.data = null;
            _loc1_.dispose();
         }
         this._rewardItems.length = 0;
         while(this.rewardContent.numChildren > 0)
         {
            this.rewardContent.removeChildAt(0);
         }
      }
      
      private function getNormalRewardX(param1:int) : int
      {
         var _loc2_:Number = (CONTENT_WIDTH - ITEMS_PER_ROW * NORMAL_ITEM_WIDTH) / (ITEMS_PER_ROW - 1);
         return int(param1 % ITEMS_PER_ROW * (NORMAL_ITEM_WIDTH + _loc2_));
      }
   }
}

