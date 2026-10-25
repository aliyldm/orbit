package away3d.core.data
{
   public class RenderableListItemPool
   {
      
      private var _pool:Vector.<RenderableListItem>;
      
      private var _index:int;
      
      private var _poolSize:int;
      
      public function RenderableListItemPool()
      {
         super();
         this._pool = new Vector.<RenderableListItem>();
      }
      
      public function getItem() : RenderableListItem
      {
         var _loc1_:RenderableListItem = null;
         if(this._index == this._poolSize)
         {
            _loc1_ = new RenderableListItem();
            this._pool[this._index++] = _loc1_;
            ++this._poolSize;
            return _loc1_;
         }
         return this._pool[this._index++];
      }
      
      public function freeAll() : void
      {
         this._index = 0;
      }
      
      public function dispose() : void
      {
         this._pool.length = 0;
      }
   }
}

