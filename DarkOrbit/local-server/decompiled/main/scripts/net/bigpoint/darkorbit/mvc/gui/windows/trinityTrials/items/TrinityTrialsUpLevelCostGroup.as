package net.bigpoint.darkorbit.mvc.gui.windows.trinityTrials.items
{
   import com.bigpoint.utils.TextFormatter;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.delete_in_eic.IconVOLoader;
   import net.bigpoint.darkorbit.delete_in_eic.ItemDataProviderHelper;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   import net.bigpoint.darkorbit.mvc.gui.windows.synthesis.model.SynthesisConst;
   import net.bigpoint.darkorbit.mvc.gui.windows.trinityTrials.model.TrinityTrialsMainProxy;
   import net.bigpoint.darkorbit.utils.HtmlTextUtils;
   
   public class TrinityTrialsUpLevelCostGroup extends DefaultItemDataAssigner
   {
      
      private var uiCache:FuiComponentSelectorCache;
      
      private var _view:Sprite;
      
      private var _icon:Coreponent;
      
      private var _item_name:Label;
      
      private var _item_num:Label;
      
      private var _tip_info:Button;
      
      private var _build_button:Button;
      
      private var _proxy:TrinityTrialsMainProxy;
      
      private var _isEnough:Boolean;
      
      public function TrinityTrialsUpLevelCostGroup(param1:Sprite)
      {
         super();
         this._view = param1;
         this.uiCache = new FuiComponentSelectorCache(param1);
         this._icon = this.uiCache.selectComponent("upDropLevel.upLevelCostGroup.item_group.icon") as Coreponent;
         this._item_name = this.uiCache.selectComponent("upDropLevel.upLevelCostGroup.item_group.cost_item_name") as Label;
         this._item_num = this.uiCache.selectComponent("upDropLevel.upLevelCostGroup.item_group.cost_num_label") as Label;
         this._tip_info = this.uiCache.selectComponent("upDropLevel.upLevelCostGroup.item_group.tip_info") as Button;
         this._build_button = this.uiCache.selectComponent("upDropLevel.upLevelCostGroup.build_button") as Button;
         this._proxy = TrinityTrialsMainProxy.getProxy();
         this._build_button.addEventListener(MouseEvent.CLICK,this.sendBuild);
         this.mouseEnabled = true;
         this.mouseChildren = true;
      }
      
      public function update() : void
      {
         var _loc1_:String = null;
         var _loc2_:ItemVO = null;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         if(this._proxy.viewData.upLevelData)
         {
            _loc1_ = this._proxy.viewData.upLevelData.costLootId;
            _loc2_ = ItemDataProviderHelper.getItem(_loc1_);
            IconVOLoader.getInstance().loadIcon(this._icon,_loc2_,"30x30");
            this._item_name.text = _loc2_.fullname;
            this._icon.tooltipData = _loc2_.fullname;
            this._tip_info.tooltipData = _loc2_.sourceName;
            _loc3_ = this._proxy.viewData.upLevelData.lootAmount;
            if(_loc1_ == SynthesisConst.LOOTID_URIDIUM)
            {
               _loc3_ = Hero.uridiumAmount;
            }
            if(_loc3_ >= this._proxy.viewData.upLevelData.costLootAmount)
            {
               this._isEnough = true;
            }
            else
            {
               this._isEnough = false;
            }
            if(this._isEnough)
            {
               this._build_button.enabled = true;
               _loc4_ = HtmlTextUtils.coloriseText(15592941,TextFormatter.roundInteger(_loc3_));
            }
            else
            {
               this._build_button.enabled = false;
               _loc4_ = HtmlTextUtils.coloriseText(16711680,TextFormatter.roundInteger(_loc3_));
            }
            this._item_num.useHTML = true;
            this._item_num.text = this._proxy.viewData.upLevelData.costLootAmount + "/" + _loc4_;
         }
      }
      
      private function sendBuild(param1:MouseEvent) : void
      {
         this._proxy.sendUpLevelRequest(this._proxy.viewData.upLevelData.costLootId,this._proxy.viewData.upLevelData.costLootAmount);
      }
   }
}

