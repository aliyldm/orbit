package net.bigpoint.darkorbit.mvc.crafting.reroll.view.components.listAssigners
{
   import flash.display.Bitmap;
   import net.bigpoint.as3toolbox.filecollection.finish.ImageFinisher;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.delete_in_eic.ItemDataProviderHelper;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class RerollShipListAssigner extends DefaultItemDataAssigner
   {
      
      private var _img:Coreponent;
      
      public function RerollShipListAssigner()
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
               this.update();
            }
         }
      }
      
      private function get dataVO() : String
      {
         return data as String;
      }
      
      override public function assignChildren() : void
      {
         super.assignChildren();
         this._img = FuiComponentSelectorUtil.selectComponent("pic",this) as Coreponent;
      }
      
      private function removeCallbacks() : void
      {
         if(!this.dataVO)
         {
            return;
         }
         removeLoadResourceCallback(ItemDataProviderHelper.getItem(this.dataVO).getLoot30x30(Hero.factionName),this.handleItemLoaded,AssetsProxy.ITEMS);
      }
      
      private function update() : void
      {
         if(!this.dataVO)
         {
            return;
         }
         var _loc1_:ItemVO = ItemDataProviderHelper.getItem(this.dataVO);
         tooltipData = _loc1_.fullname;
         loadResource(_loc1_.getLoot30x30(Hero.factionName),this.handleItemLoaded,this.handleItemLoadError,AssetsProxy.ITEMS);
      }
      
      private function handleItemLoadError(param1:*) : void
      {
         MovieClipUtils.cleanupDisplayObjectContainer(this._img);
      }
      
      private function handleItemLoaded(param1:ImageFinisher = null) : void
      {
         MovieClipUtils.cleanupDisplayObjectContainer(this._img);
         this._img.addChild(new Bitmap(param1.getBitmap().bitmapData));
      }
   }
}

