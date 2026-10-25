package net.bigpoint.darkorbit.mvc.gui.windows.trinityTrials.items
{
   import com.bigpoint.utils.TextFormatter;
   import com.bigpoint.utils.TimeFormatter;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.delete_in_eic.IconVOLoader;
   import net.bigpoint.darkorbit.delete_in_eic.ItemDataProviderHelper;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.fui.components.bars.ProgressBar;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   import net.bigpoint.darkorbit.mvc.gui.windows.synthesis.model.SynthesisConst;
   import net.bigpoint.darkorbit.mvc.gui.windows.trinityTrials.model.TrinityTrialsMainProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.warpControls.golbalEvent.EventCenter;
   import net.bigpoint.darkorbit.mvc.gui.windows.warpControls.golbalEvent.GameEvent;
   import net.bigpoint.darkorbit.mvc.gui.windows.warpControls.golbalEvent.GameEventConst;
   import net.bigpoint.darkorbit.utils.HtmlTextUtils;
   
   public class TrinityTrialsUpLevelSkipGroup extends DefaultItemDataAssigner
   {
      
      private var uiCache:FuiComponentSelectorCache;
      
      private var _view:Sprite;
      
      private var _icon:Coreponent;
      
      private var _item_name:Label;
      
      private var _item_num:Label;
      
      private var _tip_info:Button;
      
      private var _skip_button:Button;
      
      private var _proxy:TrinityTrialsMainProxy;
      
      private var _progress_bar:ProgressBar;
      
      private var _progress_bar_text:Label;
      
      private var _intervalUnit:uint = 0;
      
      private var _isEnough:Boolean = false;
      
      private var _buildTime:int = 0;
      
      public function TrinityTrialsUpLevelSkipGroup(param1:Sprite)
      {
         super();
         this._view = param1;
         this.uiCache = new FuiComponentSelectorCache(param1);
         this._progress_bar = this.uiCache.selectComponent("upDropLevel.skipUpLevelCostGroup.progress.progress_bar.bar") as ProgressBar;
         this._progress_bar_text = this.uiCache.selectComponent("upDropLevel.skipUpLevelCostGroup.progress.progress_bar.label_current") as Label;
         this._icon = this.uiCache.selectComponent("upDropLevel.skipUpLevelCostGroup.item_group.icon") as Coreponent;
         this._item_name = this.uiCache.selectComponent("upDropLevel.skipUpLevelCostGroup.item_group.cost_item_name") as Label;
         this._item_num = this.uiCache.selectComponent("upDropLevel.skipUpLevelCostGroup.item_group.cost_num_label") as Label;
         this._tip_info = this.uiCache.selectComponent("upDropLevel.skipUpLevelCostGroup.item_group.tip_info") as Button;
         this._skip_button = this.uiCache.selectComponent("upDropLevel.skipUpLevelCostGroup.skip_button") as Button;
         this._skip_button.addEventListener(MouseEvent.CLICK,this.sendSkip);
         this._proxy = TrinityTrialsMainProxy.getProxy();
         this.mouseEnabled = true;
         this.mouseChildren = true;
      }
      
      public function update() : void
      {
         var _loc1_:String = null;
         var _loc2_:ItemVO = null;
         if(this._intervalUnit != 0)
         {
            clearInterval(this._intervalUnit);
         }
         if(this._proxy.viewData.upLevelData)
         {
            this._buildTime = this._proxy.viewData.upLevelData.buildSeconds;
            _loc1_ = this._proxy.viewData.upLevelData.costLootId;
            _loc2_ = ItemDataProviderHelper.getItem(_loc1_);
            IconVOLoader.getInstance().loadIcon(this._icon,_loc2_,"30x30");
            this._item_name.text = _loc2_.fullname;
            this._icon.tooltipData = _loc2_.fullname;
            this._tip_info.tooltipData = _loc2_.sourceName;
            this.setCostAmount();
            if(this._buildTime > 0)
            {
               this._progress_bar_text.text = TimeFormatter.getSmartFormatedTimeSmall(this._buildTime);
               this._progress_bar.minValue = 0;
               this._progress_bar.maxValue = this._proxy.viewData.upLevelData.totalBuildSeconds;
               this._progress_bar.setCurrentValueNoTween(this._buildTime);
               this._intervalUnit = setInterval(this.updateTime,1000);
            }
         }
      }
      
      private function setCostAmount() : *
      {
         var _loc4_:String = null;
         var _loc1_:String = this._proxy.viewData.upLevelData.costLootId;
         var _loc2_:int = this._proxy.viewData.upLevelData.lootAmount;
         if(_loc1_ == SynthesisConst.LOOTID_URIDIUM)
         {
            _loc2_ = Hero.uridiumAmount;
         }
         var _loc3_:int = this._proxy.viewData.upLevelData.costLootAmount;
         if(_loc2_ >= _loc3_)
         {
            this._isEnough = true;
         }
         else
         {
            this._isEnough = false;
         }
         if(this._isEnough)
         {
            this._skip_button.enabled = true;
            _loc4_ = HtmlTextUtils.coloriseText(15592941,TextFormatter.roundInteger(_loc2_));
         }
         else
         {
            this._skip_button.enabled = false;
            _loc4_ = HtmlTextUtils.coloriseText(16711680,TextFormatter.roundInteger(_loc2_));
         }
         this._item_num.useHTML = true;
         this._item_num.text = _loc3_ + "/" + _loc4_;
      }
      
      private function updateTime() : void
      {
         --this._buildTime;
         this._progress_bar.currentValue = this._buildTime;
         this._progress_bar_text.text = TimeFormatter.getSmartFormatedTimeSmall(this._buildTime);
         if(this._buildTime <= 0)
         {
            clearInterval(this._intervalUnit);
            EventCenter.instance.dispatchEvent(new GameEvent(GameEventConst.UP_DROP_LEVEL_COMPLETE));
         }
      }
      
      private function sendSkip(param1:MouseEvent) : void
      {
         var _loc2_:int = this._proxy.viewData.upLevelData.costLootAmount;
         this._proxy.sendUpLevelRequest(this._proxy.viewData.upLevelData.costLootId,_loc2_);
      }
      
      public function stop() : void
      {
         clearInterval(this._intervalUnit);
      }
   }
}

