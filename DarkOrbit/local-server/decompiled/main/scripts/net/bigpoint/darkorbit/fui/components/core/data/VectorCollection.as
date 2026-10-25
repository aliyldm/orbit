package net.bigpoint.darkorbit.fui.components.core.data
{
   public class VectorCollection implements ICollection
   {
      
      public static const empty:ICollection = new VectorCollection(null);
      
      private var _collection:Object;
      
      public function VectorCollection(param1:Object)
      {
         super();
         if(param1)
         {
            this._collection = param1;
         }
         else
         {
            this._collection = new Vector.<Object>();
         }
      }
      
      public function getItemAt(param1:uint) : Object
      {
         if(param1 >= 0 && param1 < this.length)
         {
            return this._collection[param1];
         }
         return null;
      }
      
      public function get length() : uint
      {
         return this._collection ? uint(this._collection.length) : 0;
      }
      
      public function set collection(param1:Object) : void
      {
         this._collection = param1 ? param1 : this._collection;
      }
      
      public function get collection() : Object
      {
         return this._collection;
      }
      
      public function indexOf(param1:Object) : int
      {
         return this._collection ? int(this._collection.indexOf(param1)) : -1;
      }
   }
}

