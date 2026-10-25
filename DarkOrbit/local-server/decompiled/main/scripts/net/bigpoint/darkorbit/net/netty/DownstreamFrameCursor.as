package net.bigpoint.darkorbit.net.netty
{
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public final class DownstreamFrameCursor
   {
      
      private var _bytes:ByteArray;
      
      private var _bounds:Vector.<int>;
      
      private var _index:uint;
      
      private var _view:BoundedDataInput = new BoundedDataInput();
      
      public function DownstreamFrameCursor(param1:ByteArray, param2:Vector.<int>)
      {
         super();
         this._bytes = param1;
         this._bounds = param2;
      }
      
      public function get frameCount() : uint
      {
         return this._bounds.length >> 1;
      }
      
      public function get hasMore() : Boolean
      {
         return this._index < this._bounds.length;
      }
      
      public function nextFrame() : IDataInput
      {
         if(!this.hasMore)
         {
            throw new RangeError("No downstream frame remains");
         }
         var _loc1_:uint = uint(this._bounds[this._index++]);
         var _loc2_:uint = uint(this._bounds[this._index++]);
         this._view.reset(this._bytes,_loc1_,_loc1_ + _loc2_);
         return this._view;
      }
   }
}

