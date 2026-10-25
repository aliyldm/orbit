package net.bigpoint.darkorbit.mvc.gui.windows.battlePass.view.components
{
   import flash.display.DisplayObjectContainer;
   import net.bigpoint.darkorbit.delete_in_eic.ItemFilterSettingsVO;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemList;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   import net.bigpoint.darkorbit.items.utils.ItemFilter;
   
   public class BattlePassKeyExchangeView
   {
      
      private var _cache:FuiComponentSelectorCache;
      
      private var _battlepassFilter:BattlePassFilterViewController;
      
      public function BattlePassKeyExchangeView(param1:DisplayObjectContainer)
      {
         super();
         this._cache = new FuiComponentSelectorCache(param1);
         this._battlepassFilter = new BattlePassFilterViewController(this._cache.selectComponent("root.key_exchange_parent.top.filterComboboxContainer"));
         this.itemFilterSettings = new ItemFilterSettingsVO(ItemFilter.getFilterByType(ItemFilter.FILTER_TYPE_BATTLEPASS),"BATTLEPASS");
         this.list.itemDataAssigner = BattlePassExchangeDataAssigner;
      }
      
      public function get list() : ItemList
      {
         return this._cache.selectComponent("root.key_exchange_parent.body.battlepass_exchangelist") as ItemList;
      }
      
      public function set itemFilterSettings(param1:ItemFilterSettingsVO) : void
      {
         this._battlepassFilter.itemFilterSettings = param1;
      }
      
      public function get itemFilterSettings() : ItemFilterSettingsVO
      {
         return this._battlepassFilter.itemFilterSettings;
      }
      
      public function get tab() : Coreponent
      {
         return this._cache.selectComponent("root.key_exchange_parent") as Coreponent;
      }
      
      public function get keyAmount() : Label
      {
         return this._cache.selectComponent("root.key_exchange_parent.top.overall_keys") as Label;
      }
      
      public function get filterController() : BattlePassFilterViewController
      {
         return this._battlepassFilter;
      }
   }
}

