package net.bigpoint.darkorbit.mvc.gui.windows.trinityTrials.tab
{
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemList;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.view.components.ITabItem;
   import net.bigpoint.darkorbit.mvc.gui.windows.trinityTrials.items.TrinityTrialsUpLevelCostGroup;
   import net.bigpoint.darkorbit.mvc.gui.windows.trinityTrials.items.TrinityTrialsUpLevelSkipGroup;
   
   public class TrinityTrialsUpLevelView implements ITabItem
   {
      
      private var _fuiCache:FuiComponentSelectorCache;
      
      public var _view:Coreponent;
      
      private var _costItemGroup:TrinityTrialsUpLevelCostGroup;
      
      private var _skipItemGroup:TrinityTrialsUpLevelSkipGroup;
      
      public function TrinityTrialsUpLevelView(param1:Sprite)
      {
         super();
         this._fuiCache = new FuiComponentSelectorCache(param1);
         this._view = this._fuiCache.selectComponent("upDropLevel") as Coreponent;
         this._costItemGroup = new TrinityTrialsUpLevelCostGroup(param1);
         this._skipItemGroup = new TrinityTrialsUpLevelSkipGroup(param1);
      }
      
      public function get title() : String
      {
         return "trinitytrials_tab_upgrade";
      }
      
      public function get costItemGroup() : TrinityTrialsUpLevelCostGroup
      {
         return this._costItemGroup;
      }
      
      public function get skipItemGroup() : TrinityTrialsUpLevelSkipGroup
      {
         return this._skipItemGroup;
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
      
      public function get current_level_label() : Label
      {
         return this._fuiCache.selectComponent("upDropLevel.list_group.current_level") as Label;
      }
      
      public function get up_arrow() : Coreponent
      {
         return this._fuiCache.selectComponent("upDropLevel.list_group.up_arrow") as Coreponent;
      }
      
      public function get next_level_label() : Label
      {
         return this._fuiCache.selectComponent("upDropLevel.list_group.next_level") as Label;
      }
      
      public function get current_level_info_list() : ItemList
      {
         return this._fuiCache.selectComponent("upDropLevel.list_group.current_level_info_list") as ItemList;
      }
      
      public function get next_level_info_list() : ItemList
      {
         return this._fuiCache.selectComponent("upDropLevel.list_group.next_level_info_list") as ItemList;
      }
      
      public function get listGroup() : Coreponent
      {
         return this._fuiCache.selectComponent("upDropLevel.list_group") as Coreponent;
      }
      
      public function get upLevelCostGroup() : Coreponent
      {
         return this._fuiCache.selectComponent("upDropLevel.upLevelCostGroup") as Coreponent;
      }
      
      public function get skipUpLevelCostGroup() : Coreponent
      {
         return this._fuiCache.selectComponent("upDropLevel.skipUpLevelCostGroup") as Coreponent;
      }
      
      public function get item_list_bg() : Coreponent
      {
         return this._fuiCache.selectComponent("upDropLevel.list_group.item_list_bg") as Coreponent;
      }
      
      public function get item_list_bg_max() : Coreponent
      {
         return this._fuiCache.selectComponent("upDropLevel.list_group.item_list_bg_max") as Coreponent;
      }
   }
}

