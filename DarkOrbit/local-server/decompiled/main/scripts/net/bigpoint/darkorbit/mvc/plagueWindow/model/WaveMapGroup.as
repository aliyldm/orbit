package net.bigpoint.darkorbit.mvc.plagueWindow.model
{
   public class WaveMapGroup
   {
      
      private var _mapIDs:Vector.<int>;
      
      private var _counter:int;
      
      private var _counterMax:int;
      
      private var _bossActive:Boolean;
      
      private var _active:Boolean;
      
      public function WaveMapGroup(param1:Vector.<int>)
      {
         super();
         this._mapIDs = param1;
      }
      
      public function get counter() : int
      {
         return this._counter;
      }
      
      public function set counter(param1:int) : void
      {
         this._counter = param1;
      }
      
      public function get counterMax() : int
      {
         return this._counterMax;
      }
      
      public function set counterMax(param1:int) : void
      {
         this._counterMax = param1;
      }
      
      public function get bossActive() : Boolean
      {
         return this._bossActive;
      }
      
      public function set bossActive(param1:Boolean) : void
      {
         this._bossActive = param1;
      }
      
      public function hasMap(param1:int) : Boolean
      {
         var _loc2_:int = int(this._mapIDs.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(this._mapIDs[_loc3_] == param1)
            {
               return true;
            }
            _loc3_++;
         }
         return false;
      }
      
      public function get mapIDs() : Vector.<int>
      {
         return this._mapIDs;
      }
      
      public function set active(param1:Boolean) : void
      {
         this._active = param1;
      }
      
      public function get active() : Boolean
      {
         return this._active;
      }
   }
}

