package net.bigpoint.darkorbit.mvc.gui.windows.singularityDrive.view.assigners
{
   import flash.display.Bitmap;
   import net.bigpoint.as3toolbox.filecollection.finish.ImageFinisher;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.delete_in_eic.ItemDataProviderHelper;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.crafting.upgrade.model.UpgradeTypeModel;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class SingularityDriveTypeAssigner extends DefaultItemDataAssigner
   {
      
      private var _img:Coreponent;
      
      private var _hover:Button;
      
      private var _loadedLootId:String;
      
      private var _collectable:Coreponent;
      
      public function SingularityDriveTypeAssigner()
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
               this.update(param1 as UpgradeTypeModel);
            }
         }
      }
      
      override public function assignChildren() : void
      {
         super.assignChildren();
         this._img = FuiComponentSelectorUtil.selectComponent("pic",this) as Coreponent;
         this._hover = FuiComponentSelectorUtil.selectComponent("hover",this) as Button;
         this._collectable = FuiComponentSelectorUtil.selectComponent("craftableTypeItemContainer",this) as Coreponent;
      }
      
      override protected function drawSelection() : void
      {
         super.drawSelection();
         this._hover.enabled = !_selected;
      }
      
      private function removeCallbacks() : void
      {
         removeLoadResourceCallback(this._loadedLootId,this.handleItemLoaded,AssetsProxy.ITEMS);
      }
      
      private function resourceLoadErrorCallback(param1:*) : void
      {
         MovieClipUtils.cleanupDisplayObjectContainer(this._img);
      }
      
      private function update(param1:UpgradeTypeModel) : void
      {
         var _loc2_:ItemVO = null;
         _loc2_ = ItemDataProviderHelper.getItem(param1.targetItemType.lootID);
         this.tooltipData = _loc2_.fullname;
         this._loadedLootId = _loc2_.getLoot30x30(Hero.factionName);
         loadResource(this._loadedLootId,this.handleItemLoaded,this.resourceLoadErrorCallback,AssetsProxy.ITEMS);
         buttonMode = true;
         if(param1.hasCollectibleRecipe.value)
         {
            this._collectable.visible = true;
         }
         else
         {
            this._collectable.visible = false;
         }
      }
      
      private function handleItemLoaded(param1:ImageFinisher = null) : void
      {
         MovieClipUtils.cleanupDisplayObjectContainer(this._img);
         this._img.addChild(new Bitmap(param1.getBitmap().bitmapData));
      }
   }
}

