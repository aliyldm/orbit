package net.bigpoint.darkorbit.map.model.ship.factory.vos
{
   public class MinionVo
   {
      
      private var _posIndex:int;
      
      private var _motherShipID:int;
      
      public function MinionVo(param1:int, param2:int)
      {
         super();
         this._posIndex = param2;
         this._motherShipID = param1;
      }
      
      public function get posIndex() : int
      {
         return this._posIndex;
      }
      
      public function get motherShipID() : int
      {
         return this._motherShipID;
      }
   }
}

