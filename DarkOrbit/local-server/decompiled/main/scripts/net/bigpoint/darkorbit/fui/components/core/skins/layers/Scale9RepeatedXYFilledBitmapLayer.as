package net.bigpoint.darkorbit.fui.components.core.skins.layers
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import net.bigpoint.darkorbit.utils.BitmapUtils;
   
   public class Scale9RepeatedXYFilledBitmapLayer extends Scale9BitmapLayer implements ISkinLayer
   {
      
      public static const REPEAT_XY:String = "repeatXY";
      
      public static const REPEAT_X:String = "repeatX";
      
      public static const REPEAT_Y:String = "repeatY";
      
      protected var c_fill:Shape;
      
      private var _fillMode:String;
      
      public function Scale9RepeatedXYFilledBitmapLayer(param1:BitmapData, param2:Number, param3:Number, param4:Number, param5:Number, param6:String = "repeatXY", param7:Number = 10, param8:Number = 10)
      {
         this._fillMode = param6;
         super(param1,param2,param3,param4,param5,param7,param8);
      }
      
      override protected function createSegments() : void
      {
         var _loc7_:BitmapData = null;
         var _loc1_:Number = _unscaledBitmapData.width;
         var _loc2_:Number = _x2 - _x1;
         var _loc3_:Number = _unscaledBitmapData.width - _x2;
         var _loc4_:Number = _unscaledBitmapData.height;
         var _loc5_:Number = _y2 - _y1;
         var _loc6_:Number = _unscaledBitmapData.height - _y2;
         var _loc8_:Point = new Point(0,0);
         if(_x1 > 0 && _y1 > 0)
         {
            _loc7_ = new BitmapData(_x1,_y1,true,0);
            _loc7_.copyPixels(_unscaledBitmapData,new Rectangle(0,0,_x1,_y1),_loc8_);
            tl = new Bitmap(_loc7_);
            this.addChild(tl);
         }
         if(_loc2_ > 0 && _y1 > 0)
         {
            _loc7_ = new BitmapData(_loc2_,_y1,true,0);
            _loc7_.copyPixels(_unscaledBitmapData,new Rectangle(_x1,0,_x2,_y1),_loc8_);
            tc = new Bitmap(_loc7_);
            this.addChild(tc);
         }
         if(_loc3_ > 0 && _y1 > 0)
         {
            _loc7_ = new BitmapData(_loc3_,_y1,true,0);
            _loc7_.copyPixels(_unscaledBitmapData,new Rectangle(_x2,0,_loc1_,_y1),_loc8_);
            tr = new Bitmap(_loc7_);
            this.addChild(tr);
         }
         if(_x1 > 0 && _loc5_ > 0)
         {
            _loc7_ = new BitmapData(_x1,_loc5_,true,0);
            _loc7_.copyPixels(_unscaledBitmapData,new Rectangle(0,_y1,_x1,_y2),_loc8_);
            cl = new Bitmap(_loc7_);
         }
         if(_loc2_ > 0 && _loc5_ > 0)
         {
            _loc7_ = new BitmapData(_loc2_,_loc5_,true,0);
            _loc7_.copyPixels(_unscaledBitmapData,new Rectangle(_x1,_y1,_x2,_y2),_loc8_);
            cc = new Bitmap(_loc7_);
         }
         if(_loc3_ > 0 && _loc5_ > 0)
         {
            _loc7_ = new BitmapData(_loc3_,_loc5_,true,0);
            _loc7_.copyPixels(_unscaledBitmapData,new Rectangle(_x2,_y1,_loc1_,_y2),_loc8_);
            cr = new Bitmap(_loc7_);
         }
         this.c_fill = new Shape();
         addChild(this.c_fill);
         if(_x1 > 0 && _loc6_ > 0)
         {
            _loc7_ = new BitmapData(_x1,_loc6_,true,0);
            _loc7_.copyPixels(_unscaledBitmapData,new Rectangle(0,_y2,_x1,_loc4_),_loc8_);
            bl = new Bitmap(_loc7_);
            this.addChild(bl);
         }
         if(_loc2_ > 0 && _loc6_ > 0)
         {
            _loc7_ = new BitmapData(_loc2_,_loc6_,true,0);
            _loc7_.copyPixels(_unscaledBitmapData,new Rectangle(_x1,_y2,_x2,_loc4_),_loc8_);
            bc = new Bitmap(_loc7_);
            this.addChild(bc);
         }
         if(_loc3_ > 0 && _loc6_ > 0)
         {
            _loc7_ = new BitmapData(_loc3_,_loc6_,true,0);
            _loc7_.copyPixels(_unscaledBitmapData,new Rectangle(_x2,_y2,_loc1_,_loc4_),_loc8_);
            br = new Bitmap(_loc7_);
            this.addChild(br);
         }
      }
      
      override public function redraw() : void
      {
         var _loc8_:Matrix = null;
         var _loc9_:int = 0;
         var _loc1_:Number = _unscaledBitmapData.width - _x2;
         var _loc2_:Number = _unscaledBitmapData.height - _y2;
         var _loc3_:Number = _width - (_x1 + _loc1_);
         var _loc4_:Number = _height - (_y1 + _loc2_);
         var _loc5_:Number = _x1 + _loc3_;
         var _loc6_:Number = _y1 + _loc4_;
         if(tl)
         {
            tl.x = 0;
            tl.y = 0;
         }
         if(tc)
         {
            tc.x = _x1;
            tc.width = _loc3_;
         }
         if(tr)
         {
            tr.x = _loc5_;
         }
         var _loc7_:Graphics = this.c_fill.graphics;
         _loc7_.clear();
         if(this.c_fill)
         {
            this.c_fill.x = 0;
            this.c_fill.y = 0;
         }
         if(cl)
         {
            _loc7_.beginBitmapFill(cl.bitmapData);
            _loc7_.drawRect(0,_y1,cl.width,_loc4_);
            _loc7_.endFill();
         }
         if(cc)
         {
            _loc7_.beginBitmapFill(this.createCenterBD(_loc3_,_loc4_));
            _loc7_.drawRect(_x1,_y1,_loc3_,_loc4_);
            _loc7_.endFill();
         }
         if(cr)
         {
            _loc8_ = new Matrix();
            _loc9_ = _loc5_ % cr.width;
            _loc8_.translate(_loc9_,0);
            _loc7_.beginBitmapFill(cr.bitmapData,_loc8_,true);
            _loc7_.drawRect(_loc5_,_y1,cr.width,_loc4_);
            _loc7_.endFill();
         }
         if(bl)
         {
            bl.x = 0;
            bl.y = _loc6_;
         }
         if(bc)
         {
            bc.x = _x1;
            bc.y = _loc6_;
            bc.width = _loc3_;
         }
         if(br)
         {
            br.x = _loc5_;
            br.y = _loc6_;
         }
      }
      
      private function createCenterBD(param1:int, param2:int) : BitmapData
      {
         if(this._fillMode == REPEAT_X)
         {
            return BitmapUtils.scaleBitmapData(cc.bitmapData,1,param2 / cc.bitmapData.height);
         }
         if(this._fillMode == REPEAT_Y)
         {
            return BitmapUtils.scaleBitmapData(cc.bitmapData,param1 / cc.bitmapData.width,1);
         }
         return cc.bitmapData;
      }
      
      override public function clone() : DisplayObject
      {
         return new Scale9RepeatedXYFilledBitmapLayer(this._unscaledBitmapData,_x1,_y1,_x2,_y2,this._fillMode,_width,_height);
      }
   }
}

