package net.bigpoint.darkorbit.equipment.view.components.items
{
   import com.bigpoint.filecollection.finish.FileCollectionFinisher;
   import com.greensock.TweenMax;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.equipment.events.ItemEvent;
   import net.bigpoint.darkorbit.equipment.model.AssetProxy;
   
   public class InventoryLargeItemComponent extends InventoryItemComponent
   {
      
      private var lowerCaseName:String;
      
      private var currentGraphicBitmap:Bitmap = new Bitmap();
      
      public var optionalFinishedLoadingCallback:Function;
      
      private var usingBorder:Boolean;
      
      private var _imageSize:Number;
      
      public function InventoryLargeItemComponent()
      {
         super();
         isLargeIcon = true;
      }
      
      public function useBackgroundBorder() : void
      {
         itemBorder = this.createBorder();
         addChild(itemBorder);
         setChildIndex(itemBorder,0);
         this.usingBorder = true;
         itemSprite.x = itemSprite.y = 1.5;
      }
      
      private function createBorder() : MovieClip
      {
         var _loc1_:MovieClip = new MovieClip();
         var _loc2_:Graphics = _loc1_.graphics;
         _loc2_.lineStyle(2,16777215);
         _loc2_.drawRect(0,0,66,66);
         _loc2_.endFill();
         return _loc1_;
      }
      
      public function changeLargeGraphic(param1:String, param2:String = "100x100", param3:String = null) : void
      {
         if(param1 == null || param1.indexOf(ItemFilter.EMPTY_SPACE_FILTER) >= 0)
         {
            this.removeItemSprite();
            if(param1.indexOf(ItemFilter.EMPTY_SHIP_POSFTFIX) >= 0)
            {
               itemSprite = AssetProxy.getMovieClip("scrollComponents","empty_ship");
            }
            else if(param1.indexOf(ItemFilter.EMPTY_SHIP_POSFTFIX) >= 0)
            {
               itemSprite = AssetProxy.getMovieClip("scrollComponents","empty_pet");
            }
            else
            {
               itemSprite = new Sprite();
            }
            addChild(itemSprite);
            if(this.optionalFinishedLoadingCallback != null)
            {
               this.optionalFinishedLoadingCallback(this);
            }
            return;
         }
         itemName = param1;
         if(param3 == null || param3 == "")
         {
            this.lowerCaseName = param1.toLowerCase() + param2;
         }
         else
         {
            this.lowerCaseName = param1.toLowerCase() + "-" + param3 + param2;
         }
         if(param1 != "empty")
         {
            AssetProxy.lazyGetAsset(this.lowerCaseName,this.handleIconLoaded,this.handleIconLoadError);
         }
      }
      
      public function removeItemSprite() : void
      {
         if(contains(itemSprite))
         {
            removeChild(itemSprite);
         }
      }
      
      private function handleIconLoaded(param1:FileCollectionFinisher = null) : void
      {
         var _loc3_:Bitmap = null;
         var _loc4_:BitmapData = null;
         var _loc5_:BitmapData = null;
         if(itemSprite.contains(this.currentGraphicBitmap))
         {
            itemSprite.removeChild(this.currentGraphicBitmap);
         }
         var _loc2_:DisplayObject = AssetProxy.getImage(this.lowerCaseName);
         if(_loc2_ != null)
         {
            _loc3_ = Bitmap(_loc2_);
            _loc4_ = _loc3_.bitmapData;
            _loc5_ = _loc4_.clone();
            this.currentGraphicBitmap = new Bitmap(_loc5_);
            itemSprite.graphics.clear();
            if(!isNaN(this._imageSize))
            {
               this.currentGraphicBitmap.width = this.currentGraphicBitmap.height = this._imageSize;
            }
            itemSprite.addChild(this.currentGraphicBitmap);
            addChild(itemSprite);
            if(this.optionalFinishedLoadingCallback != null)
            {
               this.optionalFinishedLoadingCallback(this);
            }
         }
      }
      
      override public function setSelected() : void
      {
         dispatchEvent(new ItemEvent(ItemEvent.ITEM_SELECTED,itemID,itemName));
         TweenMax.to(itemBorder,0.5,{"colorTransform":{
            "tint":16766515,
            "tintAmount":1
         }});
      }
      
      override public function setDeselected() : void
      {
         TweenMax.to(itemBorder,0.5,{"colorTransform":{
            "tint":16766515,
            "tintAmount":0
         }});
      }
      
      private function handleIconLoadError() : void
      {
      }
      
      public function set imageSize(param1:Number) : void
      {
         this._imageSize = param1;
      }
   }
}

