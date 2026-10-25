package net.bigpoint.darkorbit.mvc.gui.windows.anniv19.view
{
   import net.bigpoint.darkorbit.delete_in_eic.IconVOLoader;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   
   public class DifficultySelectionItemAssigner extends DefaultItemDataAssigner
   {
      
      private var _icon:Coreponent;
      
      private var _itemNum:Label;
      
      public function DifficultySelectionItemAssigner()
      {
         super();
      }
      
      override public function assignChildren() : void
      {
         super.assignChildren();
         var _loc1_:Coreponent = FuiComponentSelectorUtil.selectComponent("reward_icon_bg",this) as Coreponent;
         this._icon = FuiComponentSelectorUtil.selectComponent("reward_item_icon",this) as Coreponent;
         this._itemNum = FuiComponentSelectorUtil.selectComponent("reward_item_num_label",this) as Label;
      }
      
      override public function set data(param1:Object) : void
      {
         var _loc2_:ItemVO = param1 as ItemVO;
         if(_loc2_)
         {
            IconVOLoader.getInstance().loadIcon(this._icon,_loc2_,"100x100",AssetsProxy.ITEMS);
            this._itemNum.text = "" + _loc2_.amount;
            this.tooltipData = "" + _loc2_.fullname + "\n" + _loc2_.rawDescription;
         }
      }
   }
}

