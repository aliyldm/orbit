package net.bigpoint.darkorbit.pattern
{
   public class FireworkDescriptorPattern
   {
      
      private var _id:String;
      
      private var _order:Array;
      
      public function FireworkDescriptorPattern(param1:String, param2:Array)
      {
         super();
         this._order = param2;
         this._id = param1;
      }
      
      public function get order() : Array
      {
         return this._order;
      }
      
      public function get id() : String
      {
         return this._id;
      }
   }
}

