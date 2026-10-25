package net.bigpoint.darkorbit.pattern
{
   public class FullResourcePattern
   {
      
      private var _id:int;
      
      private var _srcKey:String;
      
      private var _resKey:String;
      
      private var _starlingResKey:String;
      
      public function FullResourcePattern(param1:int, param2:String, param3:String, param4:String = null)
      {
         super();
         this._id = param1;
         this._srcKey = param2;
         this._resKey = param3;
         this._starlingResKey = param4;
      }
      
      public function get id() : int
      {
         return this._id;
      }
      
      public function get srcKey() : String
      {
         return this._srcKey;
      }
      
      public function get resKey() : String
      {
         return this._resKey;
      }
      
      public function toString() : String
      {
         return "FullResourcePattern" + ["id",this._id,"scr",this._srcKey,"res",this._resKey];
      }
      
      public function get starlingResKey() : String
      {
         return this._starlingResKey;
      }
   }
}

