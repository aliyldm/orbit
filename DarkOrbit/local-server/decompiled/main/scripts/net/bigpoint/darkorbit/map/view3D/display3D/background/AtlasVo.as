package net.bigpoint.darkorbit.map.view3D.display3D.background
{
   import flash.geom.Rectangle;
   
   public class AtlasVo
   {
      
      private var _atlasXML:XML;
      
      private var _numImages:Number;
      
      private var _rectangles:Vector.<Rectangle> = new Vector.<Rectangle>();
      
      public function AtlasVo(param1:XML)
      {
         super();
         this._atlasXML = param1;
         this.parseXml();
      }
      
      private function parseXml() : void
      {
         var _loc1_:XML = null;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Rectangle = null;
         this._numImages = this._atlasXML.children().length();
         for each(_loc1_ in this._atlasXML.SubTexture)
         {
            _loc2_ = parseFloat(_loc1_.attribute("x"));
            _loc3_ = parseFloat(_loc1_.attribute("y"));
            _loc4_ = parseFloat(_loc1_.attribute("width"));
            _loc5_ = parseFloat(_loc1_.attribute("height"));
            _loc6_ = new Rectangle(_loc2_,_loc3_,_loc4_,_loc5_);
            this._rectangles.push(_loc6_);
         }
      }
      
      public function get numImages() : Number
      {
         return this._numImages;
      }
      
      public function get rectangles() : Vector.<Rectangle>
      {
         return this._rectangles;
      }
   }
}

