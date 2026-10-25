package net.bigpoint.darkorbit.mvc.dominationWindow.model.vo
{
   public class DominationPointsVO
   {
      
      private var _mmo:int;
      
      private var _eic:int;
      
      private var _vru:int;
      
      public function DominationPointsVO()
      {
         super();
      }
      
      public function get mmo() : int
      {
         return this._mmo;
      }
      
      public function set mmo(param1:int) : void
      {
         this._mmo = param1;
      }
      
      public function get eic() : int
      {
         return this._eic;
      }
      
      public function set eic(param1:int) : void
      {
         this._eic = param1;
      }
      
      public function get vru() : int
      {
         return this._vru;
      }
      
      public function set vru(param1:int) : void
      {
         this._vru = param1;
      }
   }
}

