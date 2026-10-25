package Infinicast.Client.Api.Query
{
   public class SortCriteria
   {
      
      private var _field:String;
      
      private var _isAscending:Boolean;
      
      public function SortCriteria()
      {
         super();
      }
      
      public static function byField(param1:String, param2:Boolean = true) : SortCriteria
      {
         var _loc3_:SortCriteria = new SortCriteria();
         _loc3_.field = param1;
         _loc3_.isAscending = param2;
         return _loc3_;
      }
      
      public function get field() : String
      {
         return this._field;
      }
      
      public function set field(param1:String) : void
      {
         this._field = param1;
      }
      
      public function get isAscending() : Boolean
      {
         return this._isAscending;
      }
      
      public function set isAscending(param1:Boolean) : void
      {
         this._isAscending = param1;
      }
   }
}

