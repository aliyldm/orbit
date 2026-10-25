package net.bigpoint.darkorbit.mvc.gui.windows.expedition.view.tab.itemRenderer
{
   import net.bigpoint.darkorbit.delete_in_eic.IconVOLoader;
   import net.bigpoint.darkorbit.delete_in_eic.ItemDataProviderHelper;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   
   public class Tab1ItemAssigner extends DefaultItemDataAssigner
   {
      
      private var _iconBG:Coreponent;
      
      private var _icon:Coreponent;
      
      private var _itemNumLabel:Label;
      
      private var _checkMark:Coreponent;
      
      private var _firstLabel:Label;
      
      public function Tab1ItemAssigner()
      {
         super();
      }
      
      override public function assignChildren() : void
      {
         super.assignChildren();
         this._iconBG = FuiComponentSelectorUtil.selectComponent("reward_icon_bg",this) as Coreponent;
         this._icon = FuiComponentSelectorUtil.selectComponent("reward_item_icon",this) as Coreponent;
         this._itemNumLabel = FuiComponentSelectorUtil.selectComponent("reward_item_num",this) as Label;
         this._checkMark = FuiComponentSelectorUtil.selectComponent("checkmark",this) as Coreponent;
         this._firstLabel = FuiComponentSelectorUtil.selectComponent("reward_first_clear",this) as Label;
      }
      
      override public function set data(param1:Object) : void
      {
         var _loc2_:ItemVO = null;
         if(param1 != null)
         {
            this.visible = true;
            _loc2_ = ItemDataProviderHelper.getItem(param1.lootId);
            if(_loc2_)
            {
               IconVOLoader.getInstance().loadIcon(this._icon,_loc2_,"100x100",AssetsProxy.ITEMS);
            }
            this._itemNumLabel.text = "" + param1.amount + "x" + _loc2_.codeName;
            this._checkMark.visible = param1.isReceived;
            this._firstLabel.visible = param1.isFirst;
            this._icon.tooltipData = _loc2_.fullname;
         }
         else
         {
            this.visible = false;
         }
      }
   }
}

