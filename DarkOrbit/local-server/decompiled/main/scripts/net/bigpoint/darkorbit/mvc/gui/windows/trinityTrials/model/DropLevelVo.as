package net.bigpoint.darkorbit.mvc.gui.windows.trinityTrials.model
{
   public class DropLevelVo
   {
      
      private var _level:int;
      
      private var _desc:String;
      
      private var _value:String;
      
      public function DropLevelVo()
      {
         super();
      }
      
      public function get level() : int
      {
         return this._level;
      }
      
      public function set level(param1:int) : void
      {
         this._level = param1;
      }
      
      public function get desc() : String
      {
         return this._desc;
      }
      
      public function set desc(param1:String) : void
      {
         this._desc = param1;
      }
      
      public function get value() : String
      {
         return this._value;
      }
      
      public function set value(param1:String) : void
      {
         this._value = param1;
      }
   }
}

