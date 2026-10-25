package Infinicast.Client.Api.Paths
{
   public class AfinityNamedJsonDataQuery
   {
      
      private var _query:ICDataQuery;
      
      private var _name:String;
      
      public function AfinityNamedJsonDataQuery()
      {
         super();
      }
      
      public function get query() : ICDataQuery
      {
         return this._query;
      }
      
      public function set query(param1:ICDataQuery) : void
      {
         this._query = param1;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function set name(param1:String) : void
      {
         this._name = param1;
      }
   }
}

