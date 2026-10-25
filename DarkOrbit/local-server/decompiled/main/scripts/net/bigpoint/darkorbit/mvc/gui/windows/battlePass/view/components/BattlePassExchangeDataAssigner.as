package net.bigpoint.darkorbit.mvc.gui.windows.battlePass.view.components
{
   import com.bigpoint.utils.ui.tooltip.TooltipControl;
   import flash.display.InteractiveObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.com.module.BattlePassKeyExchangeLootModule;
   import net.bigpoint.darkorbit.delete_in_eic.Constants;
   import net.bigpoint.darkorbit.delete_in_eic.ItemDataProviderHelper;
   import net.bigpoint.darkorbit.delete_in_eic.ItemFilterTypes;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.mvc.gui.windows.ItemLoader;
   import net.bigpoint.darkorbit.mvc.gui.windows.ItemPackageLoader;
   import net.bigpoint.darkorbit.mvc.gui.windows.battlePass.model.vo.BattlePassExchangeVO;
   
   public class BattlePassExchangeDataAssigner extends DefaultItemDataAssigner
   {
      
      private var _rewardImg:Coreponent;
      
      private var _rewardTitle:Label;
      
      private var _rewardDesc:Label;
      
      private var _rewardLimit:Label;
      
      private var _bg:Coreponent;
      
      private var _bgSpecial:Coreponent;
      
      private var _verticalDivider_1:Coreponent;
      
      private var _verticalDivider_2:Coreponent;
      
      private var _keyRequiredAmount:Label;
      
      private var _claimButton:Button;
      
      private var _blocker:Coreponent;
      
      private var _bgRewardStandard:Coreponent;
      
      private var _bgRewardSpecial:Coreponent;
      
      private var _bgDescStandard:Coreponent;
      
      private var _bgDescSpecial:Coreponent;
      
      public function BattlePassExchangeDataAssigner()
      {
         super();
      }
      
      override public function assignChildren() : void
      {
         super.assignChildren();
         this._rewardImg = FuiComponentSelectorUtil.selectComponent("reward.reward_img",this) as Coreponent;
         this._rewardTitle = FuiComponentSelectorUtil.selectComponent("description.title",this) as Label;
         this._rewardDesc = FuiComponentSelectorUtil.selectComponent("description.body",this) as Label;
         this._rewardLimit = FuiComponentSelectorUtil.selectComponent("description.limit",this) as Label;
         this._bg = FuiComponentSelectorUtil.selectComponent("bg",this) as Coreponent;
         this._bgSpecial = FuiComponentSelectorUtil.selectComponent("special_bg",this) as Coreponent;
         this._verticalDivider_1 = FuiComponentSelectorUtil.selectComponent("vertical_divider_1",this) as Coreponent;
         this._verticalDivider_2 = FuiComponentSelectorUtil.selectComponent("vertical_divider_2",this) as Coreponent;
         this._keyRequiredAmount = FuiComponentSelectorUtil.selectComponent("claim.require_keys",this) as Label;
         this._claimButton = FuiComponentSelectorUtil.selectComponent("claim.claim_btn",this) as Button;
         this._blocker = FuiComponentSelectorUtil.selectComponent("blocker",this) as Coreponent;
         this._bgRewardStandard = FuiComponentSelectorUtil.selectComponent("reward.bg",this) as Coreponent;
         this._bgRewardSpecial = FuiComponentSelectorUtil.selectComponent("reward.bg_special",this) as Coreponent;
         this._bgDescStandard = FuiComponentSelectorUtil.selectComponent("description.bg",this) as Coreponent;
         this._bgDescSpecial = FuiComponentSelectorUtil.selectComponent("description.bg_special",this) as Coreponent;
      }
      
      override public function set data(param1:Object) : void
      {
         var _loc2_:BattlePassExchangeVO = null;
         var _loc3_:Boolean = false;
         var _loc4_:Sprite = null;
         if(param1 == data)
         {
            super.data = param1;
         }
         else
         {
            this.removeListeners();
            super.data = param1;
            this.addListeners();
            _loc2_ = this.battlePassExchangeVO;
            if(_loc2_)
            {
               _loc3_ = _loc2_.isSpecial;
               this._rewardTitle.text = BPLocale.getItemInCategory(Constants.BPLOCAL_CATEGORY__ITEMS,"items_bpk_" + _loc2_.rewardName + "_fullname");
               if(_loc2_.loots.length > 1)
               {
                  this._rewardDesc.text = BPLocale.getItemInCategory(Constants.BPLOCAL_CATEGORY__ITEMS,"items_bpk_" + _loc2_.rewardName + "_description");
                  this.loadMultipleRewardImage(_loc2_);
               }
               else if(_loc2_.loots.length == 1)
               {
                  this.createDescriptionForSingleItem(_loc2_.loots[0]);
                  this.loadSingleRewardImage(_loc2_);
               }
               this._keyRequiredAmount.text = _loc2_.cost.toString();
               this._bg.visible = !_loc3_;
               this._bgSpecial.visible = _loc3_;
               this._claimButton.enabled = !_loc2_.isCompleted() && _loc2_.isEnoughKey();
               this._bgRewardStandard.visible = !_loc3_;
               this._bgRewardSpecial.visible = _loc3_;
               this._bgDescStandard.visible = !_loc3_;
               this._bgDescSpecial.visible = _loc3_;
               this.updateClaimCount();
               if(this._verticalDivider_1 != null)
               {
                  if(this._verticalDivider_1.numChildren > 0)
                  {
                     this._verticalDivider_1.removeChildAt(0);
                  }
                  _loc4_ = new Sprite();
                  _loc4_.graphics.lineStyle(1,_loc3_ ? 16776960 : 3631231);
                  _loc4_.graphics.lineTo(0,this._verticalDivider_1.height);
                  this._verticalDivider_1.addChild(_loc4_);
               }
               if(this._verticalDivider_2 != null)
               {
                  if(this._verticalDivider_2.numChildren > 0)
                  {
                     this._verticalDivider_2.removeChildAt(0);
                  }
                  _loc4_ = new Sprite();
                  _loc4_.graphics.lineStyle(1,_loc3_ ? 16776960 : 3631231);
                  _loc4_.graphics.lineTo(0,this._verticalDivider_2.height);
                  this._verticalDivider_2.addChild(_loc4_);
               }
            }
         }
      }
      
      private function loadSingleRewardImage(param1:BattlePassExchangeVO) : void
      {
         var _loc3_:ItemLoader = null;
         var _loc2_:String = "";
         var _loc4_:* = param1.loots[0].lootId;
         _loc3_ = new ItemLoader(_loc4_);
         var _loc5_:ItemVO = ItemDataProviderHelper.getItem(_loc4_);
         if(_loc5_.fullname)
         {
            _loc2_ += _loc5_.fullname + "\n";
         }
         if(_loc5_.rawDescription)
         {
            _loc2_ += _loc5_.descriptionName + "\n";
         }
         if(_loc5_.typeClass == ItemFilterTypes.PetAIProtocolType)
         {
            _loc2_ = this.ProcessForAIProtocols(_loc2_,_loc5_.typeValue);
         }
         this.addItemToolTip(_loc3_,_loc2_);
         this._rewardImg.addChild(_loc3_);
      }
      
      private function loadMultipleRewardImage(param1:BattlePassExchangeVO) : void
      {
         var _loc5_:ItemPackageLoader = null;
         var _loc2_:Array = new Array();
         var _loc3_:int = int(param1.loots.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_.push(param1.loots[_loc4_].lootId);
            _loc4_++;
         }
         if(_loc2_.length > 0)
         {
            _loc5_ = new ItemPackageLoader();
            _loc5_.width = 32;
            _loc5_.height = 32;
            _loc5_.list = _loc2_;
            this._rewardImg.addChild(_loc5_);
         }
      }
      
      private function get battlePassExchangeVO() : BattlePassExchangeVO
      {
         return data as BattlePassExchangeVO;
      }
      
      private function addListeners() : void
      {
         var _loc1_:BattlePassExchangeVO = this.battlePassExchangeVO;
         if(_loc1_)
         {
            _loc1_.claimCountChanged.add(this.updateClaimCount);
            this._claimButton.addEventListener(MouseEvent.CLICK,this.sendClaimRequest);
         }
      }
      
      private function removeListeners() : void
      {
         var _loc1_:BattlePassExchangeVO = this.battlePassExchangeVO;
         if(_loc1_)
         {
            _loc1_.claimCountChanged.remove(this.updateClaimCount);
            this._claimButton.removeEventListener(MouseEvent.CLICK,this.sendClaimRequest);
         }
      }
      
      private function updateClaimCount() : void
      {
         var _loc1_:BattlePassExchangeVO = this.battlePassExchangeVO;
         this._rewardLimit.visible = _loc1_.limit > 0;
         this._rewardLimit.text = BPLocale.getItem("window_objectives_keyexchange_limit") + ":      " + _loc1_.claimCount + "/" + _loc1_.limit;
         this._blocker.visible = _loc1_.isCompleted();
         this._claimButton.enabled = !_loc1_.isCompleted() && _loc1_.isEnoughKey();
      }
      
      private function ProcessForAIProtocols(param1:String, param2:String) : String
      {
         if(param2 == "HEAT_GENERATION")
         {
            param1 = param1.replace("%amount%","1");
         }
         return param1;
      }
      
      private function createDescriptionForSingleItem(param1:BattlePassKeyExchangeLootModule) : void
      {
         var _loc3_:String = null;
         var _loc2_:ItemVO = ItemDataProviderHelper.getItem(param1.lootId);
         if(_loc2_ == null)
         {
            return;
         }
         if(_loc2_.isItemValue(ItemFilterTypes.BoosterValue))
         {
            _loc3_ = BPLocale.getItemInCategory(Constants.BPLOCAL_CATEGORY__ITEMS,"items_bpk_reward-booster_description");
         }
         else
         {
            _loc3_ = BPLocale.getItemInCategory(Constants.BPLOCAL_CATEGORY__ITEMS,"items_bpk_reward_description");
         }
         _loc3_ = _loc3_.replace("%AMOUNT%",param1.amount);
         _loc3_ = _loc3_.replace("%ITEMNAME%",_loc2_.fullname);
         this._rewardDesc.text = _loc3_;
      }
      
      protected function addItemToolTip(param1:InteractiveObject, param2:String) : void
      {
         TooltipControl.getInstance().addToolTip(param1,param2,true);
      }
      
      private function sendClaimRequest(param1:MouseEvent) : void
      {
         this.battlePassExchangeVO.sendClaimRequest();
      }
   }
}

