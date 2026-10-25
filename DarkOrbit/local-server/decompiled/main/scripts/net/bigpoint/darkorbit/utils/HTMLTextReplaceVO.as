package net.bigpoint.darkorbit.utils
{
   public class HTMLTextReplaceVO
   {
      
      private var _regExp:RegExp;
      
      private var _string:String;
      
      public function HTMLTextReplaceVO(param1:RegExp, param2:String)
      {
         super();
         this._string = param2;
         this._regExp = param1;
      }
      
      public function get string() : String
      {
         return this._string;
      }
      
      public function get regExp() : RegExp
      {
         return this._regExp;
      }
   }
}

