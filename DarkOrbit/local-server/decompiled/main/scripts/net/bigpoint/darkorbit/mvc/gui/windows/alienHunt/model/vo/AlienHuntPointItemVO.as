package net.bigpoint.darkorbit.mvc.gui.windows.alienHunt.model.vo
{
   public class AlienHuntPointItemVO
   {
      
      private var _points:uint;
      
      private var _npcID:int;
      
      public function AlienHuntPointItemVO()
      {
         super();
      }
      
      public static function sort(param1:AlienHuntPointItemVO, param2:AlienHuntPointItemVO) : int
      {
         return param2.points - param1.points;
      }
      
      public function get points() : uint
      {
         return this._points;
      }
      
      public function set points(param1:uint) : void
      {
         this._points = param1;
      }
      
      public function get npcID() : int
      {
         return this._npcID;
      }
      
      public function set npcID(param1:int) : void
      {
         this._npcID = param1;
      }
   }
}

