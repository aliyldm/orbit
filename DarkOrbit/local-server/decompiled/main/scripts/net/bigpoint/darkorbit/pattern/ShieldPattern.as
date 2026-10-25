package net.bigpoint.darkorbit.pattern
{
   public class ShieldPattern
   {
      
      private var _resKey:String;
      
      private var _resKeySkilled:String = null;
      
      private var _scale:Number = 1;
      
      public function ShieldPattern(param1:String, param2:String = null, param3:Number = 1)
      {
         super();
         this._resKey = param1;
         this._resKeySkilled = param2;
         this._scale = param3;
      }
      
      public function get resKey() : String
      {
         return this._resKey;
      }
      
      public function set resKey(param1:String) : void
      {
         this._resKey = param1;
      }
      
      public function get resKeySkilled() : String
      {
         return this._resKeySkilled ? this._resKeySkilled : this._resKey;
      }
      
      public function set resKeySkilled(param1:String) : void
      {
         this._resKeySkilled = param1;
      }
      
      public function get scale() : Number
      {
         return this._scale;
      }
      
      public function set scale(param1:Number) : void
      {
         this._scale = param1;
      }
   }
}

