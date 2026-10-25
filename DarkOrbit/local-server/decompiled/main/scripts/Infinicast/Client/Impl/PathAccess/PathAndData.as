package Infinicast.Client.Impl.PathAccess
{
   import Infinicast.Client.Api.IPath;
   
   public class PathAndData implements IPathAndData
   {
      
      private var _data:*;
      
      private var _path:IPath;
      
      public function PathAndData()
      {
         super();
      }
      
      public function get data() : *
      {
         return this._data;
      }
      
      public function set data(param1:*) : void
      {
         this._data = param1;
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

