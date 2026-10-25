package net.bigpoint.darkorbit.mvc.gui.windows.spacemap.model.vo
{
   public class AvailableJumpVO
   {
      
      private var _mapID:int;
      
      private var _price:int;
      
      private var _feedBack:int;
      
      private var _jumpVoucherAmount:int;
      
      public function AvailableJumpVO(param1:int, param2:int, param3:int, param4:int)
      {
         super();
         this._mapID = param1;
         this._price = param2;
         this._feedBack = param3;
         this._jumpVoucherAmount = param4;
      }
      
      public function get mapID() : int
      {
         return this._mapID;
      }
      
      public function get price() : int
      {
         return this._price;
      }
      
      public function get feedBack() : int
      {
         return this._feedBack;
      }
      
      public function get jumpVoucherAmount() : int
      {
         return this._jumpVoucherAmount;
      }
   }
}

