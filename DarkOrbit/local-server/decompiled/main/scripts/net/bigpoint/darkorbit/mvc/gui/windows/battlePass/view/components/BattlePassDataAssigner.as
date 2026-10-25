package net.bigpoint.darkorbit.mvc.gui.windows.battlePass.view.components
{
   import com.bigpoint.utils.ui.tooltip.TooltipControl;
   import flash.display.InteractiveObject;
   import flash.display.Sprite;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.com.module.QuestAcceptabilityStatusModule;
   import net.bigpoint.darkorbit.delete_in_eic.ItemDataProviderHelper;
   import net.bigpoint.darkorbit.delete_in_eic.ItemFilterTypes;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.core.InvalidationType;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.mvc.gui.windows.ItemLoader;
   import net.bigpoint.darkorbit.mvc.gui.windows.ItemPackageLoader;
   import net.bigpoint.darkorbit.mvc.gui.windows.battlePass.model.vo.BattlePassObjectiveVO;
   import net.bigpoint.darkorbit.mvc.gui.windows.battlePass.model.vo.BattlePassRewardVO;
   import net.bigpoint.darkorbit.questfm.conditions.Condition;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class BattlePassDataAssigner extends DefaultItemDataAssigner
   {
      
      private static const MIN_ROW_HEIGHT:Number = 80;
      
      private static const ROW_BOTTOM_PADDING:Number = 5;
      
      private const PROGRESS_MAX_CHAR:int = 8;
      
      private var _rowColumns:Array;
      
      private var _outline:Coreponent;
      
      private var _lastRowHeight:Number = -1;
      
      private var _rewardImgLeft:Coreponent;
      
      private var _rewardImgRight:Coreponent;
      
      private var _objectiveTitle:Label;
      
      private var _objectiveConditions:Label;
      
      private var _objectiveProgress:Label;
      
      private var _bg:Coreponent;
      
      private var _verticalDivider_1:Coreponent;
      
      private var _verticalDivider_2:Coreponent;
      
      private var _rewardHighlightImg:Coreponent;
      
      private var _lockImg:Coreponent;
      
      private var _objBlockerImg:Coreponent;
      
      private var _rewardLeftBlockerImg:Coreponent;
      
      private var _rewardRightBlockerImg:Coreponent;
      
      public function BattlePassDataAssigner()
      {
         super();
      }
      
      override public function assignChildren() : void
      {
         super.assignChildren();
         this._rewardImgLeft = FuiComponentSelectorUtil.selectComponent("reward_col_1.reward_img",this) as Coreponent;
         this._rewardImgRight = FuiComponentSelectorUtil.selectComponent("reward_col_2.reward_img",this) as Coreponent;
         this._objectiveTitle = FuiComponentSelectorUtil.selectComponent("obj_col.title",this) as Label;
         this._objectiveConditions = FuiComponentSelectorUtil.selectComponent("obj_col.conditions",this) as Label;
         this._bg = FuiComponentSelectorUtil.selectComponent("bg",this) as Coreponent;
         this._verticalDivider_1 = FuiComponentSelectorUtil.selectComponent("vertical_divider_1",this) as Coreponent;
         this._verticalDivider_2 = FuiComponentSelectorUtil.selectComponent("vertical_divider_2",this) as Coreponent;
         this._objectiveProgress = FuiComponentSelectorUtil.selectComponent("obj_col.objective_progress",this) as Label;
         this._rewardHighlightImg = FuiComponentSelectorUtil.selectComponent("reward_col_2.highlight_img",this) as Coreponent;
         this._lockImg = FuiComponentSelectorUtil.selectComponent("reward_col_2.lock_img",this) as Coreponent;
         this._objBlockerImg = FuiComponentSelectorUtil.selectComponent("obj_col.obj_completed_blocker",this) as Coreponent;
         this._rewardLeftBlockerImg = FuiComponentSelectorUtil.selectComponent("reward_col_1.obj_completed_blocker",this) as Coreponent;
         this._rewardRightBlockerImg = FuiComponentSelectorUtil.selectComponent("reward_col_2.obj_completed_blocker",this) as Coreponent;
         this._outline = FuiComponentSelectorUtil.selectComponent("objective_outline",this) as Coreponent;
         this._rowColumns = [getChildByName("obj_col"),getChildByName("reward_col_1"),getChildByName("reward_col_2")];
      }
      
      override public function set data(param1:Object) : void
      {
         var _loc2_:BattlePassObjectiveVO = null;
         var _loc3_:Array = null;
         var _loc4_:net.bigpoint.darkorbit.questfm.conditions.Condition = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:net.bigpoint.darkorbit.questfm.conditions.Condition = null;
         var _loc10_:Sprite = null;
         if(param1 == data)
         {
            super.data = param1;
         }
         else
         {
            this.removeListeners();
            super.data = param1;
            this.addListeners();
            _loc2_ = this.battlePassObjectiveVO;
            if(_loc2_)
            {
               if(_loc2_.questReward)
               {
                  this.addReward(_loc2_.questReward,this._rewardImgLeft);
               }
               if(_loc2_.bpReward)
               {
                  this.addReward(_loc2_.bpReward,this._rewardImgRight);
               }
               this._objectiveTitle.text = _loc2_.objectiveTitle;
               _loc3_ = [];
               if(_loc2_.quest)
               {
                  _loc7_ = 0;
                  while(_loc7_ < _loc2_.quest.getCase().conditions.length)
                  {
                     _loc4_ = net.bigpoint.darkorbit.questfm.conditions.Condition(_loc2_.quest.getCase().conditions[_loc7_]);
                     _loc3_.push("• " + _loc4_.description);
                     if(_loc4_.conditions)
                     {
                        _loc8_ = 0;
                        while(_loc8_ < _loc4_.conditions.length)
                        {
                           _loc9_ = _loc4_.conditions[_loc8_];
                           _loc3_.push("  - " + _loc9_.description);
                           _loc8_++;
                        }
                     }
                     _loc7_++;
                  }
               }
               _loc5_ = _loc3_.join("\n");
               this._objectiveConditions.text = _loc5_;
               _loc6_ = "";
               if(_loc4_)
               {
                  _loc6_ = _loc4_.currentVerbose + _loc4_.targetVerbose;
                  if(_loc6_.length > this.PROGRESS_MAX_CHAR)
                  {
                     _loc6_ = _loc4_.currentVerbose + "\n" + _loc4_.targetVerbose;
                  }
               }
               this._objectiveProgress.text = _loc6_;
               this.updateObjectiveStatus();
               this.updateBattlePassStatus();
            }
            if(this._verticalDivider_1 != null && this._verticalDivider_1.numChildren == 0)
            {
               _loc10_ = new Sprite();
               _loc10_.graphics.lineStyle(1,3631231);
               _loc10_.graphics.lineTo(0,this._verticalDivider_1.height);
               this._verticalDivider_1.addChild(_loc10_);
            }
            if(this._verticalDivider_2 != null && this._verticalDivider_2.numChildren == 0)
            {
               _loc10_ = new Sprite();
               _loc10_.graphics.lineStyle(1,3631231);
               _loc10_.graphics.lineTo(0,this._verticalDivider_2.height);
               this._verticalDivider_2.addChild(_loc10_);
            }
         }
         this.updateRowHeight();
      }
      
      private function updateRowHeight() : void
      {
         var _loc3_:Coreponent = null;
         if(!this._objectiveConditions || !this._rowColumns)
         {
            return;
         }
         this._objectiveTitle.forceRedraw();
         this._objectiveConditions.marginTop = Math.max(26,this._objectiveTitle.marginTop + this._objectiveTitle.height + 5);
         this._objectiveConditions.forceRedraw();
         this._objectiveProgress.forceRedraw();
         var _loc1_:Number = data ? Math.max(MIN_ROW_HEIGHT,this._objectiveConditions.marginTop + this._objectiveConditions.height + ROW_BOTTOM_PADDING,this._objectiveProgress.marginTop + this._objectiveProgress.height + ROW_BOTTOM_PADDING,this._objectiveConditions.getBounds(this).bottom + ROW_BOTTOM_PADDING,this._objectiveProgress.getBounds(this).bottom + ROW_BOTTOM_PADDING) : MIN_ROW_HEIGHT;
         _loc1_ = Math.ceil(_loc1_);
         var _loc2_:BattlePassObjectiveList = Boolean(parent) && parent.parent is BattlePassObjectiveList ? parent.parent as BattlePassObjectiveList : null;
         if(_loc2_)
         {
            _loc2_.requestRowLayout();
         }
         if(this._lastRowHeight == _loc1_)
         {
            return;
         }
         this._lastRowHeight = _loc1_;
         height = _loc1_;
         for each(_loc3_ in this._rowColumns)
         {
            _loc3_.height = height;
            _loc3_.forceRedraw();
            _loc3_.forceRedraw(InvalidationType.SIZE,true);
            _loc3_.forceRedraw(InvalidationType.POSITION,true);
         }
         this._bg.height = height;
         this._bg.forceRedraw();
         if(this._outline)
         {
            this._outline.height = height;
            this._outline.forceRedraw();
         }
         this.redrawDivider(this._verticalDivider_1);
         this.redrawDivider(this._verticalDivider_2);
      }
      
      private function redrawDivider(param1:Coreponent) : void
      {
         if(!param1)
         {
            return;
         }
         param1.height = height;
         var _loc2_:Sprite = param1.numChildren > 0 ? param1.getChildAt(0) as Sprite : null;
         if(!_loc2_)
         {
            _loc2_ = new Sprite();
            param1.addChild(_loc2_);
         }
         _loc2_.graphics.clear();
         _loc2_.graphics.lineStyle(1,3631231);
         _loc2_.graphics.lineTo(0,height);
         param1.forceRedraw();
      }
      
      override public function set index(param1:int) : void
      {
         super.index = param1;
         this._bg.visible = param1 % 2 == 0;
      }
      
      private function get battlePassObjectiveVO() : BattlePassObjectiveVO
      {
         return data as BattlePassObjectiveVO;
      }
      
      private function handleItemLoadError(param1:* = null) : void
      {
         MovieClipUtils.cleanupDisplayObjectContainer(this._rewardImgLeft);
      }
      
      private function addReward(param1:BattlePassRewardVO, param2:Coreponent) : void
      {
         var _loc4_:ItemLoader = null;
         var _loc5_:ItemVO = null;
         var _loc6_:Array = null;
         var _loc7_:ItemPackageLoader = null;
         var _loc3_:String = "";
         while(param2.numChildren > 0)
         {
            TooltipControl.getInstance().removeToolTip(param2.getChildAt(0) as InteractiveObject);
            param2.removeChildAt(0);
         }
         if(param1.lootID)
         {
            _loc4_ = new ItemLoader(param1.lootID);
            _loc5_ = ItemDataProviderHelper.getItem(param1.lootID);
            if(_loc5_.fullname)
            {
               _loc3_ += _loc5_.fullname + "\n";
            }
            if(_loc5_.rawDescription)
            {
               _loc3_ += _loc5_.descriptionName + "\n";
            }
            if(param1.amount > 0)
            {
               _loc3_ += BPLocale.getItem("tdm_result_window_ttip_amount_headline") + ": " + param1.amount + "\n";
            }
            if(_loc5_.typeClass == ItemFilterTypes.PetAIProtocolType)
            {
               _loc3_ = this.ProcessForAIPortocals(_loc3_,_loc5_.typeValue);
            }
            this.addItemToolTip(_loc4_,_loc3_);
            param2.addChild(_loc4_);
         }
         else if(param1.packageID)
         {
            _loc6_ = param1.getPackageItemIDs();
            if(_loc6_)
            {
               if(_loc6_.length > 0)
               {
                  _loc7_ = new ItemPackageLoader();
                  _loc7_.itemShowTimeInSec = param1.itemShowTimeInSec;
                  _loc7_.width = 32;
                  _loc7_.height = 32;
                  _loc7_.list = _loc6_;
                  if(param1.tooltipkey)
                  {
                     TooltipControl.getInstance().addToolTip(_loc7_,BPLocale.getItem(param1.tooltipkey));
                  }
                  param2.addChild(_loc7_);
               }
            }
         }
      }
      
      private function addListeners() : void
      {
         var _loc1_:BattlePassObjectiveVO = data as BattlePassObjectiveVO;
         if(_loc1_)
         {
            _loc1_.questChanged.add(this.updateObjectiveProgress);
            _loc1_.questChanged.add(this.updateObjectiveStatus);
            _loc1_.battlePassChanged.add(this.updateBattlePassStatus);
         }
      }
      
      private function removeListeners() : void
      {
         if(this._objectiveConditions)
         {
            TooltipControl.getInstance().removeToolTip(this._objectiveConditions);
         }
         var _loc1_:BattlePassObjectiveVO = data as BattlePassObjectiveVO;
         if(_loc1_)
         {
            _loc1_.questChanged.remove(this.updateObjectiveProgress);
            _loc1_.questChanged.remove(this.updateObjectiveStatus);
            _loc1_.battlePassChanged.remove(this.updateBattlePassStatus);
         }
      }
      
      override public function dispose() : void
      {
         this.removeListeners();
         super.dispose();
      }
      
      private function updateObjectiveProgress() : void
      {
         var _loc2_:net.bigpoint.darkorbit.questfm.conditions.Condition = null;
         var _loc3_:String = null;
         var _loc1_:BattlePassObjectiveVO = data as BattlePassObjectiveVO;
         if(Boolean(_loc1_) && _loc1_.statusModule.type != QuestAcceptabilityStatusModule.ACCEPTABILITYTYPE_COMPLETED)
         {
            _loc2_ = net.bigpoint.darkorbit.questfm.conditions.Condition(_loc1_.quest.getCase().conditions[0]);
            _loc3_ = _loc2_.currentVerbose + _loc2_.targetVerbose;
            if(_loc3_.length > this.PROGRESS_MAX_CHAR)
            {
               _loc3_ = _loc2_.currentVerbose + "\n" + _loc2_.targetVerbose;
            }
            this._objectiveProgress.text = _loc3_;
         }
      }
      
      private function updateObjectiveStatus() : void
      {
         var _loc1_:BattlePassObjectiveVO = data as BattlePassObjectiveVO;
         if(_loc1_)
         {
            if(Boolean(_loc1_.statusModule) && _loc1_.statusModule.type == QuestAcceptabilityStatusModule.ACCEPTABILITYTYPE_COMPLETED)
            {
               this._objectiveProgress.text = BPLocale.getItem("window_objectives_msg_completed");
               this._objBlockerImg.visible = true;
               this._rewardLeftBlockerImg.visible = true;
               if(_loc1_.hasBattlePass && !_loc1_.toCollect)
               {
                  this._rewardRightBlockerImg.visible = true;
               }
               else
               {
                  this._rewardRightBlockerImg.visible = false;
               }
            }
            else
            {
               this._objBlockerImg.visible = false;
               this._rewardLeftBlockerImg.visible = false;
               this._rewardRightBlockerImg.visible = false;
            }
         }
      }
      
      private function ProcessForAIPortocals(param1:String, param2:String) : String
      {
         if(param2 == "HEAT_GENERATION")
         {
            param1 = param1.replace("%amount%","1");
         }
         return param1;
      }
      
      private function updateBattlePassStatus() : void
      {
         var _loc1_:BattlePassObjectiveVO = data as BattlePassObjectiveVO;
         if(_loc1_)
         {
            if(_loc1_.hasBattlePass)
            {
               this._lockImg.visible = false;
            }
            else
            {
               this._lockImg.visible = true;
            }
         }
      }
      
      protected function addItemToolTip(param1:InteractiveObject, param2:String) : void
      {
         TooltipControl.getInstance().addToolTip(param1,param2,true);
      }
   }
}

