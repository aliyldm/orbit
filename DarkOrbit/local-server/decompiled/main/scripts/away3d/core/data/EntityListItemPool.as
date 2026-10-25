package away3d.core.data
{
   public class EntityListItemPool
   {
      
      private var _pool:Vector.<EntityListItem>;
      
      private var _index:int;
      
      private var _poolSize:int;
      
      public function EntityListItemPool()
      {
         super();
         this._pool = new Vector.<EntityListItem>();
      }
      
      public function getItem() : EntityListItem
      {
         var _loc1_:EntityListItem = null;
         if(this._index == this._poolSize)
         {
            _loc1_ = new EntityListItem();
            this._pool[this._index++] = _loc1_;
            ++this._poolSize;
         }
         else
         {
            _loc1_ = this._pool[this._index++];
         }
         return _loc1_;
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

