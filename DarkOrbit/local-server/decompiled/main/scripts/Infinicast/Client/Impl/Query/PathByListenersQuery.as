package Infinicast.Client.Impl.Query
{
   import Infinicast.Client.Api.IPath;
   import Infinicast.Client.Api.Paths.IPathByListenersQuery;
   
   public class PathByListenersQuery implements IPathByListenersQuery
   {
      
      private var _path:IPath = null;
      
      private var _executor:ChildrenWithListenersQueryExecutor = null;
      
      private var startPosition:int = -1;
      
      private var limitPosition:int = -1;
      
      public function PathByListenersQuery(param1:IPath, param2:ChildrenWithListenersQueryExecutor)
      {
         super();
         this._path = param1;
         this._executor = param2;
      }
      
      public function start(param1:int) : IPathByListenersQuery
      {
         this.startPosition = param1;
         return this;
      }
      
      public function limit(param1:int) : IPathByListenersQuery
      {
         this.limitPosition = param1;
         return this;
      }
      
      public function toList(param1:Function) : void
      {
         this._executor.getChildrenWithListeners(param1,this.startPosition,this.limitPosition);
      }
   }
}

