package net.bigpoint.darkorbit.managers.keyboardManager
{
   public class KeyValuePair
   {
      
      public var name:String;
      
      public var args:Vector.<String>;
      
      public var keys:Vector.<int>;
      
      public function KeyValuePair()
      {
         super();
      }
      
      public function toString() : String
      {
         return "KeyValuePair name: " + this.name + " args: " + this.args + " keys: " + this.keys;
      }
   }
}

