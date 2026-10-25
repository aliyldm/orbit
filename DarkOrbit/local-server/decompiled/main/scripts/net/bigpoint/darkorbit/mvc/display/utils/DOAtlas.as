package net.bigpoint.darkorbit.mvc.display.utils
{
   import flash.display.BitmapData;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   
   public class DOAtlas
   {
      
      private var mTextureRegions:Dictionary;
      
      private var mTextureFrames:Dictionary;
      
      private var mAtlasXml:XML;
      
      public function DOAtlas(param1:XML = null)
      {
         super();
         this.mTextureRegions = new Dictionary();
         this.mTextureFrames = new Dictionary();
         if(param1)
         {
            this.parseAtlasXml(param1);
         }
      }
      
      protected function parseAtlasXml(param1:XML) : void
      {
         var _loc3_:XML = null;
         var _loc4_:String = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Rectangle = null;
         var _loc14_:Rectangle = null;
         this.mAtlasXml = param1;
         var _loc2_:Number = 1;
         for each(_loc3_ in param1.SubTexture)
         {
            _loc4_ = _loc3_.attribute("name");
            _loc5_ = parseFloat(_loc3_.attribute("x")) / _loc2_;
            _loc6_ = parseFloat(_loc3_.attribute("y")) / _loc2_;
            _loc7_ = parseFloat(_loc3_.attribute("width")) / _loc2_;
            _loc8_ = parseFloat(_loc3_.attribute("height")) / _loc2_;
            _loc9_ = parseFloat(_loc3_.attribute("frameX")) / _loc2_;
            _loc10_ = parseFloat(_loc3_.attribute("frameY")) / _loc2_;
            _loc11_ = parseFloat(_loc3_.attribute("frameWidth")) / _loc2_;
            _loc12_ = parseFloat(_loc3_.attribute("frameHeight")) / _loc2_;
            _loc13_ = new Rectangle(_loc5_,_loc6_,_loc7_,_loc8_);
            _loc14_ = _loc11_ > 0 && _loc12_ > 0 ? new Rectangle(_loc9_,_loc10_,_loc11_,_loc12_) : null;
            this.addRegion(_loc4_,_loc13_,_loc14_);
         }
      }
      
      public function getTexture(param1:BitmapData, param2:String) : BitmapData
      {
         var _loc4_:BitmapData = null;
         var _loc3_:Rectangle = this.mTextureRegions[param2];
         if(_loc3_ == null)
         {
            return null;
         }
         _loc4_ = new BitmapData(_loc3_.width,_loc3_.height);
         _loc4_.copyPixels(param1,_loc3_,new Point(0,0));
         return _loc4_;
      }
      
      public function getTextures(param1:BitmapData, param2:String = "") : Vector.<BitmapData>
      {
         var _loc5_:String = null;
         param2 ||= "";
         var _loc3_:Vector.<BitmapData> = new Vector.<BitmapData>(0);
         var _loc4_:Vector.<String> = new Vector.<String>(0);
         for(_loc5_ in this.mTextureRegions)
         {
            if(_loc5_.indexOf(param2) == 0)
            {
               _loc4_.push(_loc5_);
            }
         }
         _loc4_.sort(Array.CASEINSENSITIVE);
         for each(_loc5_ in _loc4_)
         {
            _loc3_.push(this.getTexture(param1,_loc5_));
         }
         return _loc3_;
      }
      
      public function getRegion(param1:String) : Rectangle
      {
         return this.mTextureRegions[param1];
      }
      
      public function getFrame(param1:String) : Rectangle
      {
         return this.mTextureFrames[param1];
      }
      
      public function addRegion(param1:String, param2:Rectangle, param3:Rectangle = null) : void
      {
         this.mTextureRegions[param1] = param2;
         this.mTextureFrames[param1] = param3;
      }
      
      public function removeRegion(param1:String) : void
      {
         delete this.mTextureRegions[param1];
         delete this.mTextureFrames[param1];
      }
      
      public function getTexturesCount(param1:String) : int
      {
         var _loc3_:String = null;
         param1 ||= "";
         var _loc2_:int = 0;
         for(_loc3_ in this.mTextureRegions)
         {
            if(_loc3_.indexOf(param1) == 0)
            {
               _loc2_++;
            }
         }
         return _loc2_;
      }
      
      public function get source() : XML
      {
         return this.mAtlasXml;
      }
   }
}

