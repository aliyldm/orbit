package net.bigpoint.darkorbit.mvc.gui.windows.roguelite.view.components
{
   import net.bigpoint.darkorbit.fui.components.buttons.radio.RadioButton;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   
   public class RogueLiteShipTabAssigner extends DefaultItemDataAssigner
   {
      
      private var _tab:RadioButton;
      
      public function RogueLiteShipTabAssigner()
      {
         super();
      }
      
      override public function set data(param1:Object) : void
      {
         super.data = param1;
         this._tab.text = String(param1);
         drawSelection();
      }
      
      override public function assignChildren() : void
      {
         super.assignChildren();
         this._tab = FuiComponentSelectorUtil.selectComponent("tab",this) as RadioButton;
      }
   }
}

