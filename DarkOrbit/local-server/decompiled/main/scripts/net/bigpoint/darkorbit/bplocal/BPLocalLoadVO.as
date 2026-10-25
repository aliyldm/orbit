package net.bigpoint.darkorbit.bplocal
{
   public class BPLocalLoadVO
   {
      
      private var _url:String;
      
      private var _category:String;
      
      public function BPLocalLoadVO(param1:String, param2:String)
      {
         super();
         this._category = param2;
         this._url = param1;
      }
      
      public function get url() : String
      {
         return this._url;
      }
      
      public function get category() : String
      {
         return this._category;
      }
   }
}

