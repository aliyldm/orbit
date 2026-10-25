package Infinicast.Client.Impl.PathAccess
{
   import Infinicast.Client.Api.IPath;
   
   public interface IPathAndData
   {
      
      function get data() : *;
      
      function set data(param1:*) : void;
      
      function get path() : IPath;
      
      function set path(param1:IPath) : void;
   }
}

