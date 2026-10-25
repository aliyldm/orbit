package net.bigpoint.darkorbit.mvc.gui.windows.spaceSearch.ui.model
{
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class SpaceSearchUIData
   {
      
      private var _upCount:int = 0;
      
      private var _index:int;
      
      private var _prc:int;
      
      private var _lootId:String;
      
      private var _quantity:int;
      
      private var _cost:int;
      
      public const changed:ISignal = new Signal();
      
      public function SpaceSearchUIData()
      {
         super();
      }
      
      public function get count() : int
      {
         return this._upCount;
      }
      
      public function update(param1:int, param2:int, param3:String, param4:int, param5:int) : void
      {
         this._index = param1;
         this._prc = param2;
         this._lootId = param3;
         this._quantity = param4;
         this._cost = param5;
         ++this._upCount;
         this.changed.dispatch();
      }
      
      public function get index() : int
      {
         return this._index;
      }
      
      public function get prc() : int
      {
         return this._prc;
      }
      
      public function get lootId() : String
      {
         return this._lootId;
      }
      
      public function get quantity() : int
      {
         return this._quantity;
      }
      
      public function get cost() : int
      {
         return this._cost;
      }
   }
}

