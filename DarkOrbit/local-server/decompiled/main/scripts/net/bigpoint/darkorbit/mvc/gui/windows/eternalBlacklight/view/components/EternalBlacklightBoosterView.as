package net.bigpoint.darkorbit.mvc.gui.windows.eternalBlacklight.view.components
{
   import flash.display.DisplayObjectContainer;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemList;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   
   public class EternalBlacklightBoosterView
   {
      
      private var _cache:FuiComponentSelectorCache;
      
      public function EternalBlacklightBoosterView(param1:DisplayObjectContainer)
      {
         super();
         this._cache = new FuiComponentSelectorCache(param1);
         this.activeBoostersList.itemDataAssigner = EternalBlacklightActiveBoosterAssigner;
         this.boosterSelectionList.itemDataAssigner = EternalBlacklightBoosterChoiceAssigner;
      }
      
      public function get tabRoot() : Coreponent
      {
         return this._cache.selectComponent("root.boosters") as Coreponent;
      }
      
      public function get activeBoostersList() : ItemList
      {
         return this._cache.selectComponent("root.boosters.top.active_boosters") as ItemList;
      }
      
      public function get bottomInSession() : Coreponent
      {
         return this._cache.selectComponent("root.boosters.bottom_in_session") as Coreponent;
      }
      
      public function get boosterSelectionList() : ItemList
      {
         return this._cache.selectComponent("root.boosters.bottom_in_session.boosters_selection") as ItemList;
      }
      
      public function get bottomOutOfSession() : Coreponent
      {
         return this._cache.selectComponent("root.boosters.bottom_out_of_session") as Coreponent;
      }
      
      public function get boosterPoints() : Label
      {
         return this._cache.selectComponent("root.boosters.bottom_in_session.booster_points") as Label;
      }
   }
}

