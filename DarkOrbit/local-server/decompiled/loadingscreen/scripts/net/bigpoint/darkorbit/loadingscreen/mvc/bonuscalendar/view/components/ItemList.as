package net.bigpoint.darkorbit.loadingscreen.mvc.bonuscalendar.view.components
{
   import flash.display.Sprite;
   import flash.events.Event;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.loadingscreen.mvc.bonuscalendar.model.vo.ItemVO;
   
   public class ItemList extends Sprite
   {
      
      public static var EVENT_ALL_IMAGES_LOADED:String = "EVENT_ALL_IMAGES_LOADED";
      
      private static const ITEMS_PER_ROW:uint = 8;
      
      public static const ITEM_GAP_X:uint = 5;
      
      public static const ITEM_GAP_Y:uint = 4;
      
      private var _uiLibrary:SWFFinisher;
      
      private var _list:Vector.<ItemVO>;
      
      private var __loaded__:uint = 0;
      
      public function ItemList(param1:SWFFinisher)
      {
         super();
         this._uiLibrary = param1;
      }
      
      public function set list(param1:Vector.<ItemVO>) : void
      {
         var _loc3_:ItemRenderer = null;
         var _loc5_:ItemVO = null;
         this.__loaded__ = 0;
         this._list = param1;
         this.cleanUp();
         var _loc2_:uint = 24;
         var _loc4_:uint = 0;
         while(_loc4_ < _loc2_)
         {
            _loc5_ = this._list[_loc4_];
            _loc3_ = this.createItem(_loc5_);
            _loc3_.addEventListener(ItemRenderer.EVENT_IMAGE_LOADED,this.handleImageLoaded);
            _loc3_.data = _loc5_;
            _loc3_.x = _loc4_ % ITEMS_PER_ROW * (ItemRenderer.WIDTH + ITEM_GAP_X);
            _loc3_.y = Math.floor(_loc4_ / ITEMS_PER_ROW) * (ItemRenderer.HEIGHT + ITEM_GAP_Y);
            _loc4_++;
         }
      }
      
      private function createItem(param1:ItemVO) : ItemRenderer
      {
         var _loc2_:ItemRenderer = new ItemRenderer(param1,this._uiLibrary);
         addChild(_loc2_);
         return _loc2_;
      }
      
      private function handleImageLoaded(param1:Event) : void
      {
         ++this.__loaded__;
         var _loc2_:uint = this._list.length - 1;
         if(this.__loaded__ == _loc2_)
         {
            dispatchEvent(new Event(ItemList.EVENT_ALL_IMAGES_LOADED));
         }
      }
      
      public function showEm() : void
      {
         var _loc3_:ItemRenderer = null;
         var _loc1_:uint = this._list.length - 1;
         var _loc2_:uint = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this.getChildAt(_loc2_) as ItemRenderer;
            _loc3_.showIt();
            _loc2_++;
         }
      }
      
      private function cleanUp() : void
      {
         var _loc1_:uint = 0;
         while(this.numChildren > 0)
         {
            getChildAt(_loc1_).removeEventListener(ItemRenderer.EVENT_IMAGE_LOADED,this.handleImageLoaded);
            this.removeChildAt(0);
         }
      }
   }
}

