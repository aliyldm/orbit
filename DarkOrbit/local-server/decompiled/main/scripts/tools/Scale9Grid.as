package tools
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class Scale9Grid extends Sprite
   {
      
      private var _rectInner:Rectangle;
      
      private var _rectLeftTop:Rectangle;
      
      private var _rectRightTop:Rectangle;
      
      private var _rectLeftDown:Rectangle;
      
      private var _rectRightDown:Rectangle;
      
      private var _width:Number = 0;
      
      private var _height:Number = 0;
      
      private var _sourceBD:BitmapData;
      
      private var bitmap:Bitmap;
      
      private var leftTop:Bitmap;
      
      private var leftDown:Bitmap;
      
      private var rightTop:Bitmap;
      
      private var rightDown:Bitmap;
      
      private var topB:Bitmap;
      
      private var bottomB:Bitmap;
      
      private var leftB:Bitmap;
      
      private var rightB:Bitmap;
      
      private var top:BitmapData;
      
      private var bottom:BitmapData;
      
      private var left:BitmapData;
      
      private var right:BitmapData;
      
      private var _stretchable:Boolean;
      
      public function Scale9Grid(param1:Rectangle, param2:Number, param3:Number, param4:BitmapData, param5:Boolean = false)
      {
         super();
         this._rectInner = param1;
         this._width = param2;
         this._height = param3;
         this._sourceBD = param4;
         this._stretchable = param5;
         this._rectLeftTop = new Rectangle(0,0,this._rectInner.x,this._rectInner.y);
         this._rectRightTop = new Rectangle(this._rectInner.x + this._rectInner.width,0,this._sourceBD.width - this._rectInner.x - this._rectInner.width,this._rectInner.y);
         this._rectLeftDown = new Rectangle(0,this._rectInner.y + this._rectInner.height,this._rectInner.x,this._sourceBD.height - this._rectInner.y - this._rectInner.height);
         this._rectRightDown = new Rectangle(this._rectInner.x + this._rectInner.width,this._rectInner.y + this._rectInner.height,this._sourceBD.width - this._rectInner.x - this._rectInner.width,this._sourceBD.height - this._rectInner.y - this._rectInner.height);
         this.init();
      }
      
      private function init() : void
      {
         var _loc2_:BitmapData = null;
         var _loc3_:BitmapData = null;
         var _loc4_:BitmapData = null;
         var _loc5_:BitmapData = null;
         var _loc6_:BitmapData = null;
         var _loc7_:BitmapData = null;
         var _loc1_:Point = new Point(0,0);
         if(this._rectInner.height >= this._sourceBD.width << 1)
         {
            this.left = new BitmapData(this._rectInner.x,this._sourceBD.height);
            this.left.copyPixels(this._sourceBD,new Rectangle(0,0,this.left.width,this.left.height),_loc1_);
            this.right = new BitmapData(this._sourceBD.width - this._rectInner.x - this._rectInner.width,this._sourceBD.height);
            this.right.copyPixels(this._sourceBD,new Rectangle(this._rectInner.x + this._rectInner.width,0,this.right.width,this.right.height),_loc1_);
            this.leftB = new Bitmap(this.left);
            this.rightB = new Bitmap(this.right);
            addChild(this.leftB);
            addChild(this.rightB);
            this.leftB.x = this.leftB.y = 0;
            this.rightB.x = this._width - this.right.width;
            this.rightB.y = 0;
            this._rectInner.height = this._sourceBD.height;
            _loc2_ = this.sliceVertical(this._width - this.left.width - this.right.width,this._rectInner.height,this._rectInner.x,this._rectInner.y);
            this.bitmap = new Bitmap(_loc2_);
            this.bitmap.x = this.left.width;
            this.bitmap.y = 0;
            addChild(this.bitmap);
         }
         else if(this._rectInner.width >= this._sourceBD.height << 1)
         {
            this.top = new BitmapData(this._sourceBD.width,this._rectInner.y);
            this.top.copyPixels(this._sourceBD,new Rectangle(0,0,this._sourceBD.width,this.top.height),_loc1_);
            this.bottom = new BitmapData(this._sourceBD.width,this._sourceBD.height - this._rectInner.y - this._rectInner.height);
            this.bottom.copyPixels(this._sourceBD,new Rectangle(0,this._rectInner.y + this._rectInner.height,this._sourceBD.width,this.bottom.height),_loc1_);
            this.topB = new Bitmap(this.top);
            this.bottomB = new Bitmap(this.bottom);
            addChild(this.topB);
            addChild(this.bottomB);
            this.topB.x = this.topB.y = 0;
            this.bottomB.x = 0;
            this.bottomB.y = this._height - this.bottom.height;
            this._rectInner.width = this._sourceBD.width;
            _loc3_ = this.sliceHorizontal(this._rectInner.width,this._height - this.top.height - this.bottom.height,this._rectInner.x,this._rectInner.y);
            this.bitmap = new Bitmap(_loc3_);
            this.bitmap.x = 0;
            this.bitmap.y = this.top.height;
            addChild(this.bitmap);
         }
         else
         {
            _loc4_ = new BitmapData(this._rectLeftTop.width,this._rectLeftTop.height);
            _loc4_.copyPixels(this._sourceBD,this._rectLeftTop,_loc1_);
            this.leftTop = new Bitmap(_loc4_);
            addChild(this.leftTop);
            _loc5_ = new BitmapData(this._rectRightTop.width,this._rectRightTop.height);
            _loc5_.copyPixels(this._sourceBD,new Rectangle(this._sourceBD.width - this._rectRightTop.width,0,this._rectRightTop.width,this._rectRightTop.height),_loc1_);
            this.rightTop = new Bitmap(_loc5_);
            addChild(this.rightTop);
            _loc6_ = new BitmapData(this._rectLeftDown.width,this._rectLeftDown.height);
            _loc6_.copyPixels(this._sourceBD,new Rectangle(0,this._sourceBD.height - this._rectLeftDown.height,this._rectLeftDown.width,this._rectLeftDown.height),_loc1_);
            this.leftDown = new Bitmap(_loc6_);
            addChild(this.leftDown);
            _loc7_ = new BitmapData(this._rectRightDown.width,this._rectRightDown.height);
            _loc7_.copyPixels(this._sourceBD,new Rectangle(this._sourceBD.width - this._rectRightDown.width,this._sourceBD.height - this._rectRightDown.height,this._rectRightDown.width,this._rectRightDown.height),_loc1_);
            this.rightDown = new Bitmap(_loc7_);
            addChild(this.rightDown);
            this.slice();
            this.leftTop.x = this.leftTop.y = 0;
            this.leftDown.x = 0;
            this.leftDown.y = this._height - this._rectLeftDown.height;
            this.rightTop.x = this._width - this._rectRightTop.width;
            this.rightTop.y = 0;
            this.rightDown.x = this._width - this._rectRightDown.width;
            this.rightDown.y = this._height - this._rectRightDown.height;
         }
      }
      
      private function sliceHorizontal(param1:Number, param2:Number, param3:Number, param4:Number) : BitmapData
      {
         var _loc5_:BitmapData = new BitmapData(param1,param2);
         var _loc6_:Rectangle = new Rectangle(param3,param4,param1,this._rectInner.height);
         var _loc7_:int = 0;
         while(_loc7_ < param2)
         {
            _loc5_.copyPixels(this._sourceBD,_loc6_,new Point(0,_loc7_));
            _loc7_ += this._rectInner.height;
         }
         return _loc5_;
      }
      
      private function sliceVertical(param1:Number, param2:Number, param3:Number, param4:Number) : BitmapData
      {
         var _loc5_:BitmapData = new BitmapData(param1,param2);
         var _loc6_:Rectangle = new Rectangle(param3,param4,this._rectInner.width,param2);
         var _loc7_:int = 0;
         while(_loc7_ < param1)
         {
            _loc5_.copyPixels(this._sourceBD,_loc6_,new Point(_loc7_,0));
            _loc7_ += this._rectInner.width;
         }
         return _loc5_;
      }
      
      private function slice() : void
      {
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Matrix = null;
         var _loc12_:BitmapData = null;
         var _loc13_:BitmapData = null;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         if(Boolean(this.bitmap) && this.contains(this.bitmap))
         {
            removeChild(this.bitmap);
         }
         var _loc1_:Number = this._height - this._rectRightTop.height - this._rectRightDown.height;
         var _loc2_:Number = this._height - this._rectLeftTop.height - this._rectLeftDown.height;
         var _loc3_:Number = _loc2_ >= _loc1_ ? _loc2_ : _loc1_;
         var _loc4_:Number = this._width - this._rectLeftTop.width - this._rectRightTop.width;
         var _loc5_:Number = this._width - this._rectLeftDown.width - this._rectRightDown.width;
         var _loc6_:Number = _loc4_ >= _loc5_ ? _loc4_ : _loc5_;
         var _loc7_:Number = 0;
         if(this._rectInner.width <= this._sourceBD.width << 1)
         {
            this.top = this.sliceVertical(_loc6_,this._rectLeftTop.height,this._rectInner.x,0);
            this.bottom = this.sliceVertical(_loc6_,this._rectLeftDown.height,this._rectInner.x,this._sourceBD.height - this._rectLeftDown.height);
         }
         if(this._rectInner.height <= this._sourceBD.height << 1)
         {
            this.left = this.sliceHorizontal(this._rectLeftTop.width,_loc3_,0,this._rectInner.y);
            this.right = this.sliceHorizontal(this._rectRightTop.width,_loc3_,this._sourceBD.width - this._rectRightTop.width,this._rectInner.y);
         }
         var _loc8_:BitmapData = new BitmapData(this._width,this._height);
         if(this.top)
         {
            _loc8_.copyPixels(this.top,new Rectangle(0,0,this.top.width,this.top.height),new Point(this._rectLeftTop.width,0));
            _loc7_ = this.top.width;
         }
         if(this.bottom)
         {
            _loc8_.copyPixels(this.bottom,new Rectangle(0,0,this.bottom.width,this.bottom.height),new Point(this._rectLeftDown.width,this._height - this._rectLeftDown.height));
         }
         if(this.left)
         {
            _loc8_.copyPixels(this.left,new Rectangle(0,0,this.left.width,this.left.height),new Point(0,this._rectLeftTop.height));
         }
         if(this.right)
         {
            _loc8_.copyPixels(this.right,new Rectangle(0,0,this.right.width,this.right.height),new Point(this._width - this._rectRightTop.width,this._rectRightTop.height));
         }
         if(this._stretchable)
         {
            _loc9_ = _loc6_ / this._rectInner.width;
            _loc10_ = _loc3_ / this._rectInner.height;
            _loc11_ = new Matrix();
            _loc11_.scale(_loc9_,_loc10_);
            _loc12_ = new BitmapData(this._rectInner.width,this._rectInner.height);
            _loc12_.copyPixels(this._sourceBD,new Rectangle(this._rectInner.x,this._rectInner.y,this._rectInner.width,this._rectInner.height),new Point(0,0));
            _loc13_ = new BitmapData(_loc6_,_loc3_);
            _loc13_.draw(_loc12_,_loc11_);
            _loc8_.copyPixels(_loc13_,new Rectangle(0,0,_loc13_.width,_loc13_.height),new Point(this._rectLeftTop.width,this._rectLeftTop.height));
         }
         else
         {
            _loc14_ = 0;
            while(_loc14_ < _loc6_)
            {
               _loc15_ = 0;
               while(_loc15_ < _loc3_)
               {
                  _loc8_.copyPixels(this._sourceBD,this._rectInner,new Point(this._rectLeftTop.width + _loc14_,this._rectLeftTop.height + _loc15_));
                  _loc15_ += this._rectInner.height;
               }
               _loc14_ += this._rectInner.width;
            }
         }
         this.bitmap = new Bitmap(_loc8_);
         addChild(this.bitmap);
         this.setChildIndex(this.bitmap,0);
      }
      
      public function updateSize(param1:Number, param2:Number) : void
      {
         var _loc3_:BitmapData = null;
         var _loc4_:BitmapData = null;
         this._width = Math.max(param1,this._sourceBD.width);
         this._height = Math.max(param2,this._sourceBD.height);
         if(this._rectInner.height == this._sourceBD.height)
         {
            if(Boolean(this.bitmap) && this.contains(this.bitmap))
            {
               removeChild(this.bitmap);
            }
            this.rightB.x = this._width - this.right.width;
            this.rightB.y = 0;
            _loc3_ = this.sliceVertical(this._width - this.left.width - this.right.width,this._rectInner.height,this._rectInner.x,this._rectInner.y);
            this.bitmap = new Bitmap(_loc3_);
            this.bitmap.x = this.left.width;
            this.bitmap.y = 0;
            addChild(this.bitmap);
         }
         else if(this._rectInner.width == this._sourceBD.width)
         {
            if(Boolean(this.bitmap) && this.contains(this.bitmap))
            {
               removeChild(this.bitmap);
            }
            this.bottomB.x = 0;
            this.bottomB.y = this._height - this.bottom.height;
            _loc4_ = this.sliceHorizontal(this._rectInner.width,this._height - this.top.height - this.bottom.height,this._rectInner.x,this._rectInner.y);
            this.bitmap = new Bitmap(_loc4_);
            this.bitmap.x = 0;
            this.bitmap.y = this.top.height;
            addChild(this.bitmap);
         }
         else
         {
            this.leftTop.x = this.leftTop.y = 0;
            this.leftDown.x = 0;
            this.leftDown.y = this._height - this._rectLeftDown.height;
            this.rightTop.x = this._width - this._rectRightTop.width;
            this.rightTop.y = 0;
            this.rightDown.x = this._width - this._rectRightDown.width;
            this.rightDown.y = this._height - this._rectRightDown.height;
            this.slice();
         }
      }
   }
}

