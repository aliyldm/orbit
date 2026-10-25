package Infinicast.Client.Impl.Query
{
   import Infinicast.Client.Api.Errors.ICError;
   import Infinicast.Client.Api.IPath;
   import Infinicast.Client.Api.Paths.IListenerQuery;
   import Infinicast.Client.Api.Paths.IListeningChangedContext;
   import Infinicast.Client.Api.Paths.IListeningEndedContext;
   import Infinicast.Client.Api.Paths.IListeningStartedContext;
   import Infinicast.Client.Api.Paths.ListeningHandlerRegistrationOptions;
   
   public class ListenerQuery implements IListenerQuery
   {
      
      private var _path:IPath = null;
      
      private var _executor:ListenerQueryExecutor = null;
      
      private var _roleFilter:String = "";
      
      private var _listeningType:int;
      
      public function ListenerQuery(param1:IPath, param2:ListenerQueryExecutor)
      {
         super();
         this._path = param1;
         this._executor = param2;
         this._listeningType = 0;
      }
      
      public function filterRole(param1:String) : IListenerQuery
      {
         this._roleFilter = param1;
         return this;
      }
      
      public function filterType(param1:int) : IListenerQuery
      {
         this._listeningType = param1;
         return this;
      }
      
      public function getListeningType() : int
      {
         return this._listeningType;
      }
      
      public function toList(param1:Function) : void
      {
         this._executor.getListenerList(param1,this._roleFilter,this._listeningType);
      }
      
      public function getFilteredRole() : String
      {
         return this._roleFilter;
      }
      
      public function onStart(param1:Function, param2:Function = null) : void
      {
         var self:ListenerQuery = null;
         var handler:Function = param1;
         var registrationCompleteCallback:Function = param2;
         self = this;
         this._executor.onListeningStarted(function(param1:IListeningStartedContext):void
         {
            handler(param1);
         },this.getHandlerRegistrationOptions(),function(param1:ICError):void
         {
            if(registrationCompleteCallback != null)
            {
               registrationCompleteCallback(param1);
            }
            else if(param1 != null)
            {
               self._executor.unhandeledError(param1);
            }
         });
      }
      
      public function onDataChange(param1:Function, param2:Function = null) : void
      {
         var self:ListenerQuery = null;
         var handler:Function = param1;
         var registrationCompleteCallback:Function = param2;
         self = this;
         this._executor.onListeningChanged(function(param1:IListeningChangedContext):void
         {
            handler(param1);
         },this.getHandlerRegistrationOptions(),function(param1:ICError):void
         {
            if(registrationCompleteCallback != null)
            {
               registrationCompleteCallback(param1);
            }
            else if(param1 != null)
            {
               self._executor.unhandeledError(param1);
            }
         });
      }
      
      public function onEnd(param1:Function, param2:Function = null) : void
      {
         var self:ListenerQuery = null;
         var handler:Function = param1;
         var registrationCompleteCallback:Function = param2;
         self = this;
         this._executor.onListeningEnded(function(param1:IListeningEndedContext):void
         {
            handler(param1);
         },this.getHandlerRegistrationOptions(),function(param1:ICError):void
         {
            if(registrationCompleteCallback != null)
            {
               registrationCompleteCallback(param1);
            }
            else if(param1 != null)
            {
               self._executor.unhandeledError(param1);
            }
         });
      }
      
      private function getHandlerRegistrationOptions() : ListeningHandlerRegistrationOptions
      {
         var _loc1_:ListeningHandlerRegistrationOptions = new ListeningHandlerRegistrationOptions();
         _loc1_.withRole(this.getFilteredRole());
         _loc1_.listenerType = this.getListeningType();
         return _loc1_;
      }
      
      public function live(param1:Function, param2:Function, param3:Function = null, param4:Function = null) : void
      {
         var self:ListenerQuery = null;
         var onStart:Function = param1;
         var onEnd:Function = param2;
         var onChange:Function = param3;
         var registrationCompleteCallback:Function = param4;
         self = this;
         this._executor.getAndListenOnListeners(onStart,onChange,onEnd,this.getHandlerRegistrationOptions(),function(param1:ICError):void
         {
            if(registrationCompleteCallback != null)
            {
               registrationCompleteCallback(param1);
            }
            else if(param1 != null)
            {
               self._executor.unhandeledError(param1);
            }
         });
      }
   }
}

