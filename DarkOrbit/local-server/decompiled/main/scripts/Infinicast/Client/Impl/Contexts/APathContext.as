package Infinicast.Client.Impl.Contexts
{
   import Infinicast.Client.Api.IPath;
   import Infinicast.Client.Api.Paths.IAPathContext;
   
   public class APathContext implements IAPathContext
   {
      
      private var _path:IPath;
      
      public function APathContext()
      {
         super();
      }
      
      public function get path() : IPath
      {
         return this._path;
      }
      
      public function set path(param1:IPath) : void
      {
         this._path = param1;
      }
   }
}

