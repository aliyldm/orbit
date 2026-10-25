package net.bigpoint.darkorbit.mvc.gui.windows.mileageMarket.view
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   
   public class MileageMarketPackItemAssigner extends DefaultItemDataAssigner
   {
      
      private static const PACK_PREFIX:String = "items_package_";
      
      private var _pack:Label;
      
      public function MileageMarketPackItemAssigner()
      {
         super();
      }
      
      override public function assignChildren() : void
      {
         super.assignChildren();
         this._pack = FuiComponentSelectorUtil.selectComponent("pack",this) as Label;
      }
      
      override public function set data(param1:Object) : void
      {
         var _loc2_:String = param1 as String;
         if(!_loc2_)
         {
            visible = false;
            return;
         }
         super.data = _loc2_;
         this._pack.text = BPLocale.getItemInCategory("items",PACK_PREFIX + _loc2_ + "_fullname");
      }
   }
}

