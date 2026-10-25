package net.bigpoint.darkorbit.mvc.gui.windows.dispatch.retriever.view
{
   import flash.display.Sprite;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Container;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemList;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.view.components.ITabItem;
   import net.bigpoint.darkorbit.mvc.gui.windows.dispatch.retriever.view.components.DispatchRetrieverListItemAssigner;
   
   public class DispatchRetrieverView implements ITabItem
   {
      
      private var _cache:FuiComponentSelectorCache;
      
      private var _view:Coreponent;
      
      private var _headerType:Label;
      
      private var _headerTime:Label;
      
      private var _headerCost:Label;
      
      private var _headerAvailableLocale:String;
      
      private var _headerInProgressLocale:String;
      
      public function DispatchRetrieverView(param1:Sprite)
      {
         super();
         this._cache = new FuiComponentSelectorCache(param1);
         this._view = this._cache.selectComponent("retriever") as Coreponent;
         this._headerType = this._cache.selectComponent("retriever.table_header.type") as Label;
         this._headerTime = this._cache.selectComponent("retriever.table_header.time") as Label;
         this._headerCost = this._cache.selectComponent("retriever.table_header.cost") as Label;
         this._headerAvailableLocale = BPLocale.getItemInCategory("base","dispatch_label_type_retriever");
         this._headerInProgressLocale = BPLocale.getItemInCategory("base","dispatch_label_name_remaining");
         this.list.itemDataAssigner = DispatchRetrieverListItemAssigner;
      }
      
      public function get title() : String
      {
         return "dispatch_label_retriever";
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
      
      public function showAvailableTableHeaders(param1:Boolean) : void
      {
         this._headerType.text = param1 ? this._headerAvailableLocale : this._headerInProgressLocale;
         this._headerTime.visible = param1;
         this._headerCost.visible = param1;
      }
      
      public function get tabBtnAvailable() : Button
      {
         return this._cache.selectComponent("retriever.table_top_space.available_tab_btn") as Button;
      }
      
      public function get tabBtnInProgress() : Button
      {
         return this._cache.selectComponent("retriever.table_top_space.inprogress_tab_btn") as Button;
      }
      
      public function get btnAddSlot() : Button
      {
         return this._cache.selectComponent("retriever.table_top_space.addslot_btn") as Button;
      }
      
      public function get labelSlotInfo() : Label
      {
         return this._cache.selectComponent("retriever.table_top_space.available_slots") as Label;
      }
      
      public function get list() : ItemList
      {
         return this._cache.selectComponent("retriever.table_content.table_list") as ItemList;
      }
      
      public function get sideIcon() : Coreponent
      {
         return this._cache.selectComponent("retriever.side.icon") as Coreponent;
      }
      
      public function get sideDescription() : Label
      {
         return this._cache.selectComponent("retriever.side.description") as Label;
      }
      
      public function get quickDeliveryContainer() : Container
      {
         return this._cache.selectComponent("retriever.side.quick_delivery") as Container;
      }
      
      public function get iconQuickDelivery() : Coreponent
      {
         return this._cache.selectComponent("retriever.side.quick_delivery.icon") as Coreponent;
      }
      
      public function get btnQuickDelivery() : Button
      {
         return this._cache.selectComponent("retriever.side.quick_delivery.btn") as Button;
      }
      
      public function get btnHire() : Button
      {
         return this._cache.selectComponent("retriever.side.hire_btn") as Button;
      }
   }
}

