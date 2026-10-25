package net.bigpoint.darkorbit.mvc.traininggrounds.model
{
   public class TraininggroundsResultsDataVO
   {
      
      public static const LOSER:uint = 0;
      
      public static const DRAW:uint = 1;
      
      public static const WINNER:uint = 2;
      
      private var _heroResult:uint;
      
      private var _opponentName:String;
      
      private var _heroRoundsWon:int;
      
      private var _opponentRoundsWon:int;
      
      private var _heroTAScore:String;
      
      private var _opponentTAScore:String;
      
      private var _rewards:Vector.<Vector.<String>>;
      
      public function TraininggroundsResultsDataVO(param1:uint, param2:String, param3:int, param4:int, param5:String, param6:String, param7:Vector.<Vector.<String>>)
      {
         super();
         this._heroResult = param1;
         this._opponentName = param2;
         this._heroRoundsWon = param3;
         this._opponentRoundsWon = param4;
         this._heroTAScore = param5;
         this._opponentTAScore = param6;
         this._rewards = param7;
      }
      
      public function get heroResult() : uint
      {
         return this._heroResult;
      }
      
      public function get opponentName() : String
      {
         return this._opponentName;
      }
      
      public function get heroRoundsWon() : int
      {
         return this._heroRoundsWon;
      }
      
      public function get opponentRoundsWon() : int
      {
         return this._opponentRoundsWon;
      }
      
      public function get heroTAScore() : String
      {
         return this._heroTAScore;
      }
      
      public function get opponentTAScore() : String
      {
         return this._opponentTAScore;
      }
      
      public function get rewards() : Vector.<Vector.<String>>
      {
         return this._rewards;
      }
   }
}

