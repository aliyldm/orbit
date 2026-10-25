package net.bigpoint.as3toolbox.guicomponents.components
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.geom.Rectangle;
   import spark.components.supportClasses.SkinnableComponent;
   import spark.primitives.BitmapImage;
   
   public class Scale9GridImage extends SkinnableComponent
   {
      
      private static var _skinParts:Object = {
         "upperRightImage":true,
         "lowerLeftImage":true,
         "lowerRightImage":true,
         "upperLeftImage":true,
         "middleLeftImage":true,
         "middleCenterImage":true,
         "lowerCenterImage":true,
         "upperCenterImage":true,
         "middleRightImage":true
      };
      
      [SkinPart(type="spark.primitives.BitmapImage",required="true")]
      public var upperLeftImage:BitmapImage;
      
      [SkinPart(type="spark.primitives.BitmapImage",required="true")]
      public var upperCenterImage:BitmapImage;
      
      [SkinPart(type="spark.primitives.BitmapImage",required="true")]
      public var upperRightImage:BitmapImage;
      
      [SkinPart(type="spark.primitives.BitmapImage",required="true")]
      public var middleLeftImage:BitmapImage;
      
      [SkinPart(type="spark.primitives.BitmapImage",required="true")]
      public var middleCenterImage:BitmapImage;
      
      [SkinPart(type="spark.primitives.BitmapImage",required="true")]
      public var middleRightImage:BitmapImage;
      
      [SkinPart(type="spark.primitives.BitmapImage",required="true")]
      public var lowerLeftImage:BitmapImage;
      
      [SkinPart(type="spark.primitives.BitmapImage",required="true")]
      public var lowerCenterImage:BitmapImage;
      
      [SkinPart(type="spark.primitives.BitmapImage",required="true")]
      public var lowerRightImage:BitmapImage;
      
      private var _updateSlices:Boolean = true;
      
      private var _source:BitmapData;
      
      private var _scale9Grid:Rectangle;
      
      public function Scale9GridImage()
      {
         super();
      }
      
      public function get updateSlices() : Boolean
      {
         return this._updateSlices;
      }
      
      public function set updateSlices(param1:Boolean) : void
      {
         this._updateSlices = param1;
      }
      
      public function get source() : BitmapData
      {
         return this._source;
      }
      
      public function set source(param1:*) : void
      {
         if(this._source != param1)
         {
            if(param1 is Class)
            {
               this.setSourceFromClass(param1 as Class);
            }
            else if(param1 is Bitmap)
            {
               this._source = (param1 as Bitmap).bitmapData;
            }
            else
            {
               if(!(param1 is BitmapData))
               {
                  return;
               }
               this._source = param1;
            }
            this._scale9Grid = new Rectangle(0,0,this._source.width,this._source.height);
            this._updateSlices = true;
            if(skin != null)
            {
               skin.invalidateDisplayList();
            }
         }
      }
      
      override public function get scale9Grid() : Rectangle
      {
         return this._scale9Grid;
      }
      
      override public function set scale9Grid(param1:Rectangle) : void
      {
         if(this._scale9Grid != param1)
         {
            this._scale9Grid = param1;
            this._scale9Grid.x = isNaN(this._scale9Grid.x) ? 0 : this._scale9Grid.x;
            this._scale9Grid.y = isNaN(this._scale9Grid.y) ? 0 : this._scale9Grid.y;
            this._scale9Grid.width = isNaN(this._scale9Grid.width) ? (this._source != null ? this._source.width : 0) : this._scale9Grid.width;
            this._scale9Grid.height = isNaN(this._scale9Grid.height) ? (this._source != null ? this._source.height : 0) : this._scale9Grid.height;
            this._updateSlices = true;
            if(skin != null)
            {
               skin.invalidateDisplayList();
            }
         }
      }
      
      private function setSourceFromClass(param1:Class) : void
      {
         var _loc2_:Object = new param1();
         if(_loc2_ is Bitmap)
         {
            this._source = (_loc2_ as Bitmap).bitmapData;
            return;
         }
         if(_loc2_ is BitmapData)
         {
            this._source = _loc2_ as BitmapData;
            return;
         }
      }
   }
}

