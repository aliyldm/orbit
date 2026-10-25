package net.bigpoint.darkorbit.gui.killscreen.vos
{
   public class KillScreenOptionDetailVo
   {
      
      private var _wildcard:String;
      
      private var _replacement:String;
      
      private var _baseKey:String;
      
      private var _currency:String;
      
      public function KillScreenOptionDetailVo()
      {
         super();
      }
      
      public function set wildcard(param1:String) : void
      {
         this._wildcard = param1;
      }
      
      public function set replacement(param1:String) : void
      {
         this._replacement = param1;
      }
      
      public function set baseKey(param1:String) : void
      {
         this._baseKey = param1;
      }
      
      public function get baseKey() : String
      {
         return this._baseKey;
      }
      
      public function get wildcard() : String
      {
         return this._wildcard;
      }
      
      public function get replacement() : String
      {
         return this._replacement;
      }
      
      public function get currency() : String
      {
         return this._currency;
      }
      
      public function set currency(param1:String) : void
      {
         this._currency = param1;
      }
   }
}

