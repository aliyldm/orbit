package net.bigpoint.darkorbit.mvc.crafting.hyperforge.view.assigners
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
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class HyperforgeTypeAssigner extends DefaultItemDataAssigner
   {
      
      private var _img:Coreponent;
      
      private var _hover:Button;
      
      private var _loadedLootId:String;
      
      public function HyperforgeTypeAssigner()
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
               this.update(param1 as String);
            }
         }
      }
      
      override public function assignChildren() : void
      {
         super.assignChildren();
         this._img = FuiComponentSelectorUtil.selectComponent("pic",this) as Coreponent;
         this._hover = FuiComponentSelectorUtil.selectComponent("hover",this) as Button;
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
      
      private function update(param1:String) : void
      {
         var _loc2_:ItemVO = ItemDataProviderHelper.getItem(param1);
         this.tooltipData = _loc2_.fullname;
         this._loadedLootId = _loc2_.getLoot30x30(Hero.factionName);
         loadResource(this._loadedLootId,this.handleItemLoaded,null,AssetsProxy.ITEMS);
         buttonMode = true;
      }
      
      private function handleItemLoaded(param1:ImageFinisher = null) : void
      {
         MovieClipUtils.cleanupDisplayObjectContainer(this._img);
         this._img.addChild(new Bitmap(param1.getBitmap().bitmapData));
      }
   }
}

