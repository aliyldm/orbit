package net.bigpoint.darkorbit.mvc.crafting.upgrade.view.components.listAssigners
{
   import flash.display.Bitmap;
   import flash.display.Shape;
   import flash.display.Sprite;
   import net.bigpoint.as3toolbox.filecollection.finish.ImageFinisher;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.com.module.AssemblyRecipeBuildStatusModule;
   import net.bigpoint.darkorbit.com.module.AssemblyRecipeReadyToCollectStatusModule;
   import net.bigpoint.darkorbit.delete_in_eic.ItemFilterTypes;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.delete_in_eic.ItemsDataUtility;
   import net.bigpoint.darkorbit.fui.components.bars.ProgressBar;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Container;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.items.item.attributes.RecipeCosts;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.model.TargetItemRecipeModel;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.model.states.AssemblyTimerState;
   import net.bigpoint.darkorbit.mvc.crafting.upgrade.model.UpgradeRecipeItemPair;
   import net.bigpoint.darkorbit.mvc.gui.windows.synthesis.ui.items.SelectItemTipAssigner;
   import net.bigpoint.darkorbit.mvc.gui.windows.synthesis.ui.items.StarLevelDisplayHelper;
   import net.bigpoint.darkorbit.mvc.gui.windows.warpControls.mode.WarpControlsProxy;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class UpgradeTargetGridAssigner extends DefaultItemDataAssigner
   {
      
      private var _img:Coreponent;
      
      private var _imgFinsihed:Coreponent;
      
      private var _itemUpgradeLevel:Label;
      
      private var _xpLevel:Label;
      
      private var _hover:Button;
      
      private var _progress:ProgressBar;
      
      private var _craftableItemContainer:Container;
      
      private var _currentRecipe:TargetItemRecipeModel;
      
      private var _equipped:Coreponent;
      
      private var _starLayer:Sprite;
      
      private var _delegates:Object = {};
      
      private var _skipCostHelper:RecipeCosts;
      
      public function UpgradeTargetGridAssigner()
      {
         super();
      }
      
      override public function set data(param1:Object) : void
      {
         var _loc2_:UpgradeRecipeItemPair = null;
         if(param1 == data)
         {
            super.data = param1;
            _loc2_ = param1 as UpgradeRecipeItemPair;
            StarLevelDisplayHelper.render(this._starLayer,_loc2_ ? _loc2_.item : null);
         }
         else
         {
            this.removeCallbacks();
            this.removeSignalListeners();
            super.data = param1;
            if(param1)
            {
               this.update(param1 as UpgradeRecipeItemPair);
            }
            else
            {
               StarLevelDisplayHelper.render(this._starLayer,null);
            }
         }
      }
      
      private function get upgradeRecipeItemPair() : UpgradeRecipeItemPair
      {
         return data as UpgradeRecipeItemPair;
      }
      
      override public function assignChildren() : void
      {
         super.assignChildren();
         this._img = FuiComponentSelectorUtil.selectComponent("pic",this) as Coreponent;
         this._imgFinsihed = FuiComponentSelectorUtil.selectComponent("pic_finished",this) as Coreponent;
         this._itemUpgradeLevel = FuiComponentSelectorUtil.selectComponent("itemUpgradeLevel",this) as Label;
         this._xpLevel = FuiComponentSelectorUtil.selectComponent("xpLevel",this) as Label;
         this._hover = FuiComponentSelectorUtil.selectComponent("hover",this) as Button;
         this._progress = FuiComponentSelectorUtil.selectComponent("progress",this) as ProgressBar;
         this._craftableItemContainer = FuiComponentSelectorUtil.selectComponent("craftableItemContainer",this) as Container;
         this._equipped = FuiComponentSelectorUtil.selectComponent("equipped",this) as Coreponent;
         this._starLayer = new Sprite();
         this._starLayer.name = "starLayer";
         this._starLayer.mouseEnabled = false;
         this._starLayer.mouseChildren = false;
         this._starLayer.x = this._img.x;
         this._starLayer.y = this._img.y;
         this._starLayer.graphics.beginFill(0,0);
         this._starLayer.graphics.drawRect(0,0,this._img.width,this._img.height);
         this._starLayer.graphics.endFill();
         addChild(this._starLayer);
         this._delegates[AssemblyRecipeBuildStatusModule.instance.getLibcomModuleId()] = this.upgradeTimerStateHandler;
         this._delegates[AssemblyRecipeReadyToCollectStatusModule.instance.getLibcomModuleId()] = this.upgradeReadyToCollectHandler;
         this.tooltipDataAssigner = new SelectItemTipAssigner();
      }
      
      override protected function drawSelection() : void
      {
         super.drawSelection();
         this._hover.enabled = !_selected;
      }
      
      override public function dispose() : void
      {
         this.removeSignalListeners();
         super.dispose();
      }
      
      private function removeCallbacks() : void
      {
         var _loc1_:ItemVO = data as ItemVO;
         if(!_loc1_)
         {
            return;
         }
         removeLoadResourceCallback(_loc1_.getLoot30x30(Hero.factionName),this.handleItemLoaded,AssetsProxy.ITEMS);
      }
      
      private function update(param1:UpgradeRecipeItemPair) : void
      {
         var _loc3_:* = undefined;
         StarLevelDisplayHelper.render(this._starLayer,param1 ? param1.item : null);
         if(param1.item.typeClass == ItemFilterTypes.Weapon__CannonType || param1.item.typeClass == ItemFilterTypes.Weapon__CannonShieldType)
         {
            _loc3_ = WarpControlsProxy.getProxy(GameFacade.getInstance()).getInventoryItemByItemId(param1.id);
            if(_loc3_)
            {
               tooltipData = _loc3_;
            }
            else
            {
               tooltipData = param1.item.fullname;
            }
         }
         else
         {
            tooltipData = param1.item.fullname;
         }
         var _loc2_:String = param1.item.getLoot30x30(Hero.factionName);
         loadResource(_loc2_,this.handleItemLoaded,this.handleItemLoadError,AssetsProxy.ITEMS);
         this.drawItemData();
         this._progress.currentValue = 1;
         this.addSignalListeners();
         this.updateStates();
      }
      
      private function drawItemData() : void
      {
         var _loc1_:UpgradeRecipeItemPair = null;
         _loc1_ = this.upgradeRecipeItemPair;
         if(!_loc1_)
         {
            return;
         }
         StarLevelDisplayHelper.render(this._starLayer,_loc1_.item);
         this._itemUpgradeLevel.text = ItemsDataUtility.getDisplayUpgradeLevel(_loc1_.item).toString();
         var _loc2_:int = _loc1_.item.xpLevel;
         this._xpLevel.text = _loc2_.toString();
         this._xpLevel.visible = _loc2_ > 0;
         this._equipped.visible = _loc1_.item.isEquipped;
      }
      
      private function addSignalListeners() : void
      {
         var _loc1_:UpgradeRecipeItemPair = this.upgradeRecipeItemPair;
         if(!_loc1_)
         {
            return;
         }
         if(_loc1_.item != null)
         {
            _loc1_.item.itemVOChanged.add(this.drawItemData);
         }
         _loc1_.changed.add(this.updateStates);
      }
      
      private function removeSignalListeners() : void
      {
         var _loc1_:UpgradeRecipeItemPair = this.upgradeRecipeItemPair;
         if(!_loc1_)
         {
            return;
         }
         if(_loc1_.item != null)
         {
            _loc1_.item.itemVOChanged.remove(this.drawItemData);
         }
         _loc1_.changed.remove(this.updateStates);
         if(_loc1_.recipe != null)
         {
            this.timerStateCleanUp();
         }
      }
      
      private function updateStates() : void
      {
         this._progress.visible = false;
         this._imgFinsihed.visible = false;
         if(this.upgradeRecipeItemPair == null || this.upgradeRecipeItemPair.recipe == null)
         {
            return;
         }
         this._currentRecipe = this.upgradeRecipeItemPair.recipe;
         this.timerStateCleanUp();
         var _loc1_:int = this._currentRecipe.state.status.getLibcomModuleId();
         var _loc2_:Function = this._delegates[_loc1_];
         if(_loc2_ != null)
         {
            _loc2_();
         }
      }
      
      private function upgradeTimerStateHandler() : void
      {
         var _loc1_:AssemblyTimerState = this._currentRecipe.state as AssemblyTimerState;
         this._skipCostHelper = this._currentRecipe.collectSteps(this.upgradeRecipeItemPair.item.upgradeLevel,_loc1_.buildAmount);
         this.upgradeTimerStateChanged();
         this._progress.visible = true;
         _loc1_.timer.changed.add(this.upgradeTimerStateChanged);
         _loc1_.timer.complete.add(this.timerStateCleanUp);
      }
      
      private function upgradeTimerStateChanged() : void
      {
         var _loc1_:AssemblyTimerState = this._currentRecipe.state as AssemblyTimerState;
         if(_loc1_ == null)
         {
            this.timerStateCleanUp();
            return;
         }
         this._progress.currentValue = _loc1_.timer.value / this._skipCostHelper.buildTimeSec;
      }
      
      private function timerStateCleanUp() : void
      {
         var _loc1_:AssemblyTimerState = this._currentRecipe.state as AssemblyTimerState;
         if(_loc1_ != null)
         {
            _loc1_.timer.changed.remove(this.upgradeTimerStateChanged);
            _loc1_.timer.complete.remove(this.timerStateCleanUp);
         }
         this._progress.visible = false;
      }
      
      private function upgradeReadyToCollectHandler() : void
      {
         this._imgFinsihed.visible = true;
      }
      
      private function handleItemLoadError(param1:*) : void
      {
         MovieClipUtils.cleanupDisplayObjectContainer(this._img);
      }
      
      private function handleItemLoaded(param1:ImageFinisher = null) : void
      {
         MovieClipUtils.cleanupDisplayObjectContainer(this._img);
         var _loc2_:Bitmap = new Bitmap(param1.getBitmap().bitmapData);
         this._img.addChild(_loc2_);
      }
      
      private function markItemFinished() : void
      {
         var _loc1_:Shape = new Shape();
         _loc1_.graphics.beginFill(16711680,1);
         _loc1_.graphics.lineStyle(1,16777215);
         _loc1_.graphics.drawCircle(6,6,4);
         _loc1_.graphics.endFill();
         this._img.addChild(_loc1_);
      }
   }
}

