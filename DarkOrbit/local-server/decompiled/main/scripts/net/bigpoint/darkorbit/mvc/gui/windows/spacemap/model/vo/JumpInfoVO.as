package net.bigpoint.darkorbit.mvc.gui.windows.spacemap.model.vo
{
   public class JumpInfoVO
   {
      
      private var _duration:int;
      
      private var _mapID:int;
      
      public function JumpInfoVO(param1:int, param2:int)
      {
         super();
         this._duration = param1;
         this._mapID = param2;
      }
      
      public function get duration() : int
      {
         return this._duration;
      }
      
      public function get mapID() : int
      {
         return this._mapID;
      }
   }
}

