package net.bigpoint.darkorbit.mvc.gui.windows.dispatch.rewardlist.view
{
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemList;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.mvc.gui.windows.dispatch.rewardlist.view.components.DispatchRewardListItemAssigner;
   
   public class DispatchRewardListView
   {
      
      private var _fuiCache:FuiComponentSelectorCache;
      
      private var _uiContainer:Sprite;
      
      private var _view:Coreponent;
      
      public function DispatchRewardListView(param1:SimpleWindow)
      {
         super();
         this._uiContainer = param1.getUIContainer();
         this._fuiCache = new FuiComponentSelectorCache(this._uiContainer);
         this._view = this._fuiCache.selectComponent("root") as Coreponent;
         this.list.itemDataAssigner = DispatchRewardListItemAssigner;
      }
      
      public function get title() : String
      {
         return "dispatch_tooltip_header_dropChance";
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
      
      public function get labelTitle() : Label
      {
         return this._fuiCache.selectComponent("root.contentContainer.title") as Label;
      }
      
      public function get list() : ItemList
      {
         return this._fuiCache.selectComponent("root.contentContainer.table_content.table_list") as ItemList;
      }
   }
}

