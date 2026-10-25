package net.bigpoint.darkorbit.mvc.crafting.hyperforge.view.assigners
{
   import flash.display.Bitmap;
   import net.bigpoint.as3toolbox.filecollection.finish.ImageFinisher;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.com.module.QuantumFluidCoreData;
   import net.bigpoint.darkorbit.delete_in_eic.InventoryProxy;
   import net.bigpoint.darkorbit.delete_in_eic.ItemDataProviderHelper;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class HyperforgeModuleAssigner extends DefaultItemDataAssigner
   {
      
      private var _img:Coreponent;
      
      private var _hover:Button;
      
      private var _name:Label;
      
      private var _itemUpgradeLevel:Label;
      
      private var _equipped:Coreponent;
      
      public function HyperforgeModuleAssigner()
      {
         super();
      }
      
      override public function set data(param1:Object) : void
      {
         if(param1 == data)
         {
            super.data = param1;
         }
         else
         {
            this.removeCallbacks();
            super.data = param1;
            if(param1)
            {
               this.update(param1 as QuantumFluidCoreData);
            }
         }
      }
      
      private function get dataVO() : QuantumFluidCoreData
      {
         return data as QuantumFluidCoreData;
      }
      
      override public function assignChildren() : void
      {
         super.assignChildren();
         this._img = FuiComponentSelectorUtil.selectComponent("pic",this) as Coreponent;
         this._name = FuiComponentSelectorUtil.selectComponent("itemName",this) as Label;
         this._hover = FuiComponentSelectorUtil.selectComponent("hover",this) as Button;
         this._itemUpgradeLevel = FuiComponentSelectorUtil.selectComponent("itemUpgradeLevel",this) as Label;
         this._equipped = FuiComponentSelectorUtil.selectComponent("equipped",this) as Coreponent;
         this.buttonMode = true;
      }
      
      override protected function drawSelection() : void
      {
         super.drawSelection();
         this._hover.enabled = !_selected;
      }
      
      override public function dispose() : void
      {
         super.dispose();
      }
      
      private function removeCallbacks() : void
      {
         if(!this.dataVO)
         {
            return;
         }
         var _loc1_:ItemVO = ItemDataProviderHelper.getItem(this.dataVO.lootId);
         if(_loc1_)
         {
            removeLoadResourceCallback(_loc1_.getLoot30x30(Hero.factionName),this.handleItemLoaded,AssetsProxy.ITEMS);
         }
      }
      
      private function update(param1:QuantumFluidCoreData) : void
      {
         var _loc2_:ItemVO = null;
         if(!this.dataVO)
         {
            return;
         }
         _loc2_ = ItemDataProviderHelper.getItem(this.dataVO.lootId);
         if(!_loc2_)
         {
            return;
         }
         tooltipData = _loc2_.fullname;
         var _loc3_:String = _loc2_.getLoot30x30(Hero.factionName);
         loadResource(_loc3_,this.handleItemLoaded,this.handleItemLoadError,AssetsProxy.ITEMS);
         this._name.text = _loc2_.fullname;
         this._itemUpgradeLevel.text = "" + param1.lv;
         var _loc4_:InventoryProxy = GameFacade.getInstance().retrieveProxy(InventoryProxy.NAME) as InventoryProxy;
         var _loc5_:ItemVO = _loc4_.inventory.getByItemId(this.dataVO.itemId);
         if(this._equipped)
         {
            this._equipped.visible = Boolean(_loc5_) && _loc5_.isEquipped;
         }
      }
      
      private function handleItemLoadError(param1:*) : void
      {
         MovieClipUtils.cleanupDisplayObjectContainer(this._img);
      }
      
      private function handleItemLoaded(param1:ImageFinisher = null) : void
      {
         MovieClipUtils.cleanupDisplayObjectContainer(this._img);
         var _loc2_:Bitmap = new Bitmap(param1.getBitmap().bitmapData);
         this._img.addChild(_loc2_);
      }
   }
}

