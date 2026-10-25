package net.bigpoint.darkorbit.mvc.tdm.statusWindow.model.vo
{
   public class FactionScoreVO
   {
      
      private var _faction:int;
      
      private var _score:int;
      
      private var _scoreMax:int;
      
      public function FactionScoreVO(param1:uint, param2:int, param3:int)
      {
         super();
         this._faction = param1;
         this._score = param2;
         this._scoreMax = param3;
      }
      
      public function get faction() : int
      {
         return this._faction;
      }
      
      public function get score() : int
      {
         return this._score;
      }
      
      public function get scoreMax() : int
      {
         return this._scoreMax;
      }
   }
}

