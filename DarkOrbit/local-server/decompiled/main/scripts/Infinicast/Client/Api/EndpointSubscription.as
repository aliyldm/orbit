package Infinicast.Client.Api
{
   public class EndpointSubscription
   {
      
      private var _path:String;
      
      private var _roles:Vector.<String>;
      
      public function EndpointSubscription()
      {
         super();
      }
      
      public function get path() : String
      {
         return this._path;
      }
      
      public function set path(param1:String) : void
      {
         this._path = param1;
      }
      
      public function get roles() : Vector.<String>
      {
         return this._roles;
      }
      
      public function set roles(param1:Vector.<String>) : void
      {
         this._roles = param1;
      }
   }
}

