package net.bigpoint.darkorbit.mvc.gui.windows.spaceSearch.objectives.missions
{
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.core.data.VectorCollection;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemList;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.view.components.ITabItem;
   import net.bigpoint.darkorbit.mvc.gui.windows.spaceSearch.objectives.missions.model.TabSpaceSearchMissionsDataAssigner;
   
   public class TabSpaceSearchMissionsView implements ITabItem
   {
      
      public static const KEY:String = "SS_tab_Missions";
      
      private var _cache:FuiComponentSelectorCache;
      
      public var _view:Coreponent;
      
      public function TabSpaceSearchMissionsView(param1:Sprite)
      {
         super();
         this._cache = new FuiComponentSelectorCache(param1);
         this._view = this._cache.selectComponent("body_missions") as Coreponent;
         this.availableExchangeItemList.itemDataAssigner = TabSpaceSearchMissionsDataAssigner;
      }
      
      public function get title() : String
      {
         return KEY;
      }
      
      public function get view() : Coreponent
      {
         return this._view;
      }
      
      public function set visible(param1:Boolean) : void
      {
         this._view.visible = param1;
      }
      
      public function get visible() : Boolean
      {
         return this._view.visible;
      }
      
      public function set active(param1:Boolean) : void
      {
      }
      
      public function get active() : Boolean
      {
         return true;
      }
      
      public function get availableExchangeItemList() : ItemList
      {
         return this._cache.selectComponent("body_missions.mid.item.list") as ItemList;
      }
      
      public function set availableExchangeItemList(param1:*) : void
      {
         this.availableExchangeItemList.list = new VectorCollection(param1);
      }
   }
}

