package net.bigpoint.darkorbit.mvc.gui.windows.dispatch.rewardlist.view.components
{
   import flash.display.Bitmap;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.as3toolbox.filecollection.finish.ImageFinisher;
   import net.bigpoint.darkorbit.delete_in_eic.ItemDataProviderHelper;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.dispatch.rewardlist.model.DispatchRewardVO;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class DispatchRewardListItemAssigner extends DefaultItemDataAssigner
   {
      
      private var _icon:Coreponent;
      
      private var _name:Label;
      
      private var _iconAmount:Coreponent;
      
      private var _chance:Label;
      
      public function DispatchRewardListItemAssigner()
      {
         super();
      }
      
      override public function assignChildren() : void
      {
         super.assignChildren();
         this._icon = FuiComponentSelectorUtil.selectComponent("icon",this) as Coreponent;
         this._name = FuiComponentSelectorUtil.selectComponent("name",this) as Label;
         this._iconAmount = FuiComponentSelectorUtil.selectComponent("amountIcon",this) as Coreponent;
         this._chance = FuiComponentSelectorUtil.selectComponent("chance",this) as Label;
      }
      
      override public function set data(param1:Object) : void
      {
         if(param1 == data)
         {
            super.data = param1;
         }
         else
         {
            this.removeListeners();
            super.data = param1;
            this.addListeners();
            this.updateRewardItem();
         }
      }
      
      private function addListeners() : void
      {
      }
      
      private function removeListeners() : void
      {
      }
      
      private function updateRewardItem() : void
      {
         var _loc1_:DispatchRewardVO = data as DispatchRewardVO;
         if(!_loc1_)
         {
            return;
         }
         var _loc2_:ItemVO = ItemDataProviderHelper.getItem(_loc1_.rewardModule.lootId);
         if(!_loc2_)
         {
            return;
         }
         this._icon.loadResource(_loc2_.getLoot30x30(),this.handleIconLoaded,this.handleIconLoadError,AssetsProxy.ITEMS);
         this._name.text = _loc2_.fullname;
         var _loc3_:String = "dispatch_amount_" + _loc1_.rewardModule.amount + "_30x30";
         this._iconAmount.loadResource(_loc3_,this.handleIconAmountLoaded,this.handleIconAmountLoadError,AssetsProxy.ITEMS);
         var _loc4_:* = "dispatch_tooltip_description_dropChance-" + _loc1_.rewardModule.chance;
         this._chance.text = BPLocale.getItemInCategory("base",_loc4_);
      }
      
      private function handleIconLoaded(param1:ImageFinisher = null) : void
      {
         this.setImageIcon(this._icon,new Bitmap(param1.getBitmap().bitmapData));
      }
      
      private function handleIconLoadError(param1:*) : void
      {
         this.setImageIcon(this._icon);
      }
      
      private function handleIconAmountLoaded(param1:ImageFinisher = null) : void
      {
         this.setImageIcon(this._iconAmount,new Bitmap(param1.getBitmap().bitmapData));
      }
      
      private function handleIconAmountLoadError(param1:*) : void
      {
         this.setImageIcon(this._iconAmount);
      }
      
      private function setImageIcon(param1:Coreponent, param2:Bitmap = null) : void
      {
         MovieClipUtils.cleanupDisplayObjectContainer(param1);
         if(param2 != null)
         {
            param2.width = param1.width;
            param2.height = param1.height;
            param1.addChild(param2);
         }
      }
   }
}

