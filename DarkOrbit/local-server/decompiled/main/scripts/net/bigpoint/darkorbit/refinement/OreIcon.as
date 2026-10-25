package net.bigpoint.darkorbit.refinement
{
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   
   public class OreIcon extends MovieClip
   {
      
      private var _id:int;
      
      private var _bitmap:Bitmap;
      
      private var _tooltipKey:String;
      
      public function OreIcon(param1:int, param2:Bitmap, param3:String)
      {
         super();
         this._id = param1;
         this._bitmap = param2;
         this._tooltipKey = param3;
         this.addChild(param2);
         this.mouseChildren = false;
         this.mouseEnabled = false;
      }
      
      public function get id() : int
      {
         return this._id;
      }
      
      public function get tooltipKey() : String
      {
         return this._tooltipKey;
      }
   }
}

