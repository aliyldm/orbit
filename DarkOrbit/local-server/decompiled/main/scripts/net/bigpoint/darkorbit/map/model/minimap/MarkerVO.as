package net.bigpoint.darkorbit.map.model.minimap
{
   import flash.display.MovieClip;
   
   public class MarkerVO
   {
      
      private var _id:String;
      
      public var x:int;
      
      public var y:int;
      
      private var _count:int;
      
      private var _colorAppendix:String;
      
      private var _secondsPerMarker:Number;
      
      private var _scale:Number;
      
      private var _inverse:Boolean;
      
      public var mc:MovieClip;
      
      public function MarkerVO(param1:String, param2:int, param3:int, param4:int = -1, param5:String = "", param6:Number = 0.5, param7:Number = 1, param8:Boolean = false)
      {
         super();
         this._inverse = param8;
         this._scale = param7;
         this._secondsPerMarker = param6;
         this._colorAppendix = param5;
         this._count = param4;
         this.y = param3;
         this.x = param2;
         this._id = param1;
      }
      
      public function get id() : String
      {
         return this._id;
      }
      
      public function get count() : int
      {
         return this._count;
      }
      
      public function get colorAppendix() : String
      {
         return this._colorAppendix;
      }
      
      public function get secondsPerMarker() : Number
      {
         return this._secondsPerMarker;
      }
      
      public function get scale() : Number
      {
         return this._scale;
      }
      
      public function get inverse() : Boolean
      {
         return this._inverse;
      }
      
      public function set count(param1:int) : void
      {
         this._count = param1;
      }
   }
}

