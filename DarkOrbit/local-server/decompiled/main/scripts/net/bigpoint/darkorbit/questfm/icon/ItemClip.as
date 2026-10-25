package net.bigpoint.darkorbit.questfm.icon
{
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.filters.GlowFilter;
   import net.bigpoint.as3toolbox.filecollection.finish.ImageFinisher;
   import net.bigpoint.darkorbit.delete_in_eic.ItemDataProviderHelper;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   
   public class ItemClip extends Sprite
   {
      
      private static const size:int = 30;
      
      private const FILTERS:Array = [new GlowFilter(8289918,1,4,4,2,1,true)];
      
      public function ItemClip(param1:String)
      {
         super();
         var _loc2_:ItemVO = ItemDataProviderHelper.getItem(param1);
         (GameFacade.getInstance().retrieveProxy(AssetsProxy.NAME) as AssetsProxy).load(_loc2_.getLoot100x100(),this.handleLoaded,this.handleError,AssetsProxy.ITEMS);
      }
      
      private function handleError(... rest) : void
      {
      }
      
      private function handleLoaded(param1:ImageFinisher) : void
      {
         var _loc2_:Bitmap = new Bitmap(param1.getBitmap().bitmapData);
         _loc2_.width = _loc2_.height = size;
         addChild(_loc2_);
      }
      
      private function get overlay() : DisplayObject
      {
         var _loc1_:Sprite = new Sprite();
         _loc1_.graphics.lineStyle(1,8289918);
         _loc1_.graphics.drawRect(0,0,size,size);
         return _loc1_;
      }
      
      override public function get width() : Number
      {
         return size;
      }
      
      override public function get height() : Number
      {
         return size;
      }
   }
}

