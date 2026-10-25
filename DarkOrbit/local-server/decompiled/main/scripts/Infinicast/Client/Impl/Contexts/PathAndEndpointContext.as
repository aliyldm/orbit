package Infinicast.Client.Impl.Contexts
{
   import Infinicast.Client.Api.IEndpoint;
   import Infinicast.Client.Api.IPath;
   import Infinicast.Client.Api.Paths.IPathAndEndpointContext;
   
   public class PathAndEndpointContext implements IPathAndEndpointContext
   {
      
      private var _path:IPath;
      
      private var _endpoint:IEndpoint;
      
      private var _endpointData:*;
      
      public function PathAndEndpointContext(param1:IPath, param2:IEndpoint, param3:*)
      {
         super();
         this.path = param1;
         this.endpoint = param2;
         this.endpointData = param3;
      }
      
      public function get path() : IPath
      {
         return this._path;
      }
      
      public function set path(param1:IPath) : void
      {
         this._path = param1;
      }
      
      public function get endpoint() : IEndpoint
      {
         return this._endpoint;
      }
      
      public function set endpoint(param1:IEndpoint) : void
      {
         this._endpoint = param1;
      }
      
      public function get endpointData() : *
      {
         return this._endpointData;
      }
      
      public function set endpointData(param1:*) : void
      {
         this._endpointData = param1;
      }
   }
}

