package net.bigpoint.darkorbit.mvc.jackpotBattle.resultWin.model.vo
{
   public class JackpotArenaMatchResultVO
   {
      
      private var _stat:String;
      
      private var _hero:String;
      
      private var _opponent:String;
      
      private var _toolTipStats:String;
      
      private var _toolTipHero:String;
      
      private var _toolTipOpponent:String;
      
      public function JackpotArenaMatchResultVO(param1:String, param2:String, param3:String, param4:String, param5:String, param6:String)
      {
         super();
         this._toolTipOpponent = param6;
         this._toolTipHero = param5;
         this._toolTipStats = param4;
         this._opponent = param3;
         this._hero = param2;
         this._stat = param1;
      }
      
      public function get stat() : String
      {
         return this._stat;
      }
      
      public function get hero() : String
      {
         return this._hero;
      }
      
      public function get opponent() : String
      {
         return this._opponent;
      }
      
      public function get toolTipStats() : String
      {
         return this._toolTipStats;
      }
      
      public function get toolTipHero() : String
      {
         return this._toolTipHero;
      }
      
      public function get toolTipOpponent() : String
      {
         return this._toolTipOpponent;
      }
   }
}

