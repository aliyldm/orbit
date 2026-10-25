package net.bigpoint.darkorbit.mvc.gui.windows.dispatch.gate.view
{
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemList;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.view.components.ITabItem;
   import net.bigpoint.darkorbit.mvc.gui.windows.dispatch.gate.view.components.DispatchGateListItemAssigner;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class DispatchGateView implements ITabItem
   {
      
      public var onActive:ISignal = new Signal();
      
      private var _cache:FuiComponentSelectorCache;
      
      private var _view:Coreponent;
      
      public function DispatchGateView(param1:Sprite)
      {
         super();
         this._cache = new FuiComponentSelectorCache(param1);
         this._view = this._cache.selectComponent("gate") as Coreponent;
         this.list.itemDataAssigner = DispatchGateListItemAssigner;
      }
      
      public function get title() : String
      {
         return "dispatch_label_gate";
      }
      
      public function get view() : Coreponent
      {
         return this._view;
      }
      
      public function set visible(param1:Boolean) : void
      {
         if(param1 && !this._view.visible)
         {
            this.onActive.dispatch();
         }
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
      
      public function get list() : ItemList
      {
         return this._cache.selectComponent("gate.table_content.table_list") as ItemList;
      }
      
      public function get sideIcon() : Coreponent
      {
         return this._cache.selectComponent("gate.side.icon") as Coreponent;
      }
      
      public function get btnHire() : Button
      {
         return this._cache.selectComponent("gate.side.hire_btn") as Button;
      }
      
      public function get btnGalaxyGate() : Button
      {
         return this._cache.selectComponent("gate.table_top_space.galaxygates_btn") as Button;
      }
   }
}

