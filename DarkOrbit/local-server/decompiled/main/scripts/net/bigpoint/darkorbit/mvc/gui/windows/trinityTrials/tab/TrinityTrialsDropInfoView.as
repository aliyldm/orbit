package net.bigpoint.darkorbit.mvc.gui.windows.trinityTrials.tab
{
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemList;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.view.components.ITabItem;
   
   public class TrinityTrialsDropInfoView implements ITabItem
   {
      
      private var _fuiCache:FuiComponentSelectorCache;
      
      public var _view:Coreponent;
      
      public function TrinityTrialsDropInfoView(param1:Sprite)
      {
         super();
         this._fuiCache = new FuiComponentSelectorCache(param1);
         this._view = this._fuiCache.selectComponent("dropInfo") as Coreponent;
      }
      
      public function get title() : String
      {
         return "trinitytrials_tab_difficulty";
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
      
      public function get item_list() : ItemList
      {
         return this._fuiCache.selectComponent("dropInfo.drop_level_info_list") as ItemList;
      }
   }
}

