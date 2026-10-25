package net.bigpoint.darkorbit.mvc.gui.windows.common.view.components
{
   import net.bigpoint.darkorbit.fui.components.core.data.VectorCollection;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemList;
   import net.bigpoint.darkorbit.fui.components.tooltip.DefaultTooltipDataAssigner;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.mvc.crafting.reroll.view.components.listAssigners.RerollResultRetainCostGridAssigner;
   
   public class SalvageToolTipAssigner extends DefaultTooltipDataAssigner
   {
      
      private var _list:ItemList;
      
      public function SalvageToolTipAssigner()
      {
         super();
      }
      
      override public function assign() : void
      {
         this._list = FuiComponentSelectorUtil.selectComponent("wrapper.list",target) as ItemList;
         this._list.itemDataAssigner = RerollResultRetainCostGridAssigner;
         this._list.list = new VectorCollection(data);
         super.assign();
      }
      
      override public function set data(param1:Object) : void
      {
         var _loc2_:VectorCollection = null;
         super.data = param1;
         if(this._list)
         {
            _loc2_ = new VectorCollection(data);
            if(_loc2_.length > 0)
            {
               this._list.list = _loc2_;
            }
         }
      }
   }
}

