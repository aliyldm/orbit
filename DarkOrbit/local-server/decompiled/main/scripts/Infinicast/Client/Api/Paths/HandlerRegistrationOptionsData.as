package Infinicast.Client.Api.Paths
{
   public class HandlerRegistrationOptionsData
   {
      
      public var sendingEndpointDataContext:Boolean = false;
      
      public var dataContextPaths:Vector.<DataContextRequest> = null;
      
      private var _isOncePerRole:Boolean;
      
      private var _isSticky:Boolean;
      
      private var _listenerType:int;
      
      private var _roleFilter:String;
      
      public function HandlerRegistrationOptionsData()
      {
         super();
      }
      
      public function get isOncePerRole() : Boolean
      {
         return this._isOncePerRole;
      }
      
      public function set isOncePerRole(param1:Boolean) : void
      {
         this._isOncePerRole = param1;
      }
      
      public function get isSticky() : Boolean
      {
         return this._isSticky;
      }
      
      public function set isSticky(param1:Boolean) : void
      {
         this._isSticky = param1;
      }
      
      public function get listenerType() : int
      {
         return this._listenerType;
      }
      
      public function set listenerType(param1:int) : void
      {
         this._listenerType = param1;
      }
      
      public function get roleFilter() : String
      {
         return this._roleFilter;
      }
      
      public function set roleFilter(param1:String) : void
      {
         this._roleFilter = param1;
      }
   }
}

