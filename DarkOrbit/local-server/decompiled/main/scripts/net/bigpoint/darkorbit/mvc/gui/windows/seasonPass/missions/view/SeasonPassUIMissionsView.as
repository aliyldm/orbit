package net.bigpoint.darkorbit.mvc.gui.windows.seasonPass.missions.view
{
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.core.data.VectorCollection;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemList;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.view.components.ITabItem;
   import net.bigpoint.darkorbit.mvc.gui.windows.seasonPass.missions.view.component.SeasonPassMissionItemAssigner;
   
   public class SeasonPassUIMissionsView implements ITabItem
   {
      
      private var _cache:FuiComponentSelectorCache;
      
      private var _view:Coreponent;
      
      public function SeasonPassUIMissionsView(param1:Sprite)
      {
         super();
         this._cache = new FuiComponentSelectorCache(param1);
         this._view = this._cache.selectComponent("missions") as Coreponent;
         this.missionItemList.itemDataAssigner = SeasonPassMissionItemAssigner;
      }
      
      public function get title() : String
      {
         return "window_mission_sp_tab";
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
      
      public function get missionItemList() : ItemList
      {
         return this._cache.selectComponent("missions.active.body.content.list") as ItemList;
      }
      
      public function set missionList(param1:Object) : void
      {
         this.missionItemList.list = new VectorCollection(param1);
      }
      
      public function get missionList() : Object
      {
         return this.missionItemList;
      }
      
      public function get btnDaily() : Button
      {
         return this._cache.selectComponent("missions.active.sidebar.daily") as Button;
      }
      
      public function get btnWeekly() : Button
      {
         return this._cache.selectComponent("missions.active.sidebar.weekly") as Button;
      }
      
      public function get btnSeason() : Button
      {
         return this._cache.selectComponent("missions.active.sidebar.season") as Button;
      }
      
      public function get textRefresh() : Label
      {
         return this._cache.selectComponent("missions.active.body.header.refreshTimes") as Label;
      }
      
      public function get refreshHintLabel() : Label
      {
         return this._cache.selectComponent("missions.active.body.header.refresh") as Label;
      }
   }
}

