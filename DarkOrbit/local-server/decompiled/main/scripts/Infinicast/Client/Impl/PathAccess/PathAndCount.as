package Infinicast.Client.Impl.PathAccess
{
   import Infinicast.Client.Api.IPath;
   
   public class PathAndCount implements IPathAndCount
   {
      
      private var _count:int;
      
      private var _path:IPath;
      
      public function PathAndCount()
      {
         super();
      }
      
      public function get count() : int
      {
         return this._count;
      }
      
      public function set count(param1:int) : void
      {
         this._count = param1;
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

