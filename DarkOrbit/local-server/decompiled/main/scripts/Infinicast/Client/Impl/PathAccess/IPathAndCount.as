package Infinicast.Client.Impl.PathAccess
{
   import Infinicast.Client.Api.IPath;
   
   public interface IPathAndCount
   {
      
      function get count() : int;
      
      function set count(param1:int) : void;
      
      function get path() : IPath;
      
      function set path(param1:IPath) : void;
   }
}

