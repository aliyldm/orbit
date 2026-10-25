package net.bigpoint.darkorbit.mvc.chatclient.view.report
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   
   public class ReasonVO
   {
      
      private var _key:String;
      
      public function ReasonVO(param1:String)
      {
         super();
         this._key = param1;
      }
      
      public function get key() : String
      {
         return this._key;
      }
      
      public function toString() : String
      {
         return BPLocale.getItemInCategory("chat",this._key);
      }
   }
}

