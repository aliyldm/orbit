package Infinicast.Client.Impl.ObjectState
{
   import Infinicast.Client.Api.IPath;
   import Infinicast.Client.Impl.IConnector;
   
   public class ObjectStateManager
   {
      
      private var _connector:IConnector;
      
      public function ObjectStateManager(param1:IConnector)
      {
         super();
         this._connector = param1;
      }
      
      public function getOrCreateLocalObject(param1:String) : IPath
      {
         return this._connector.path(param1);
      }
   }
}

