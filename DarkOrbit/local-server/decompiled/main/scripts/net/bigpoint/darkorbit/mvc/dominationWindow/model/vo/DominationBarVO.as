package net.bigpoint.darkorbit.mvc.dominationWindow.model.vo
{
   public class DominationBarVO
   {
      
      private var _faction:String;
      
      private var _score:int;
      
      private var _maxScore:int;
      
      private var _isLeading:Boolean;
      
      public function DominationBarVO(param1:String, param2:Number, param3:Number, param4:Boolean)
      {
         super();
         this._maxScore = param3;
         this._score = param2;
         this._faction = param1;
         this._isLeading = param4;
      }
      
      public function get faction() : String
      {
         return this._faction;
      }
      
      public function set faction(param1:String) : void
      {
         this._faction = param1;
      }
      
      public function get score() : int
      {
         return this._score;
      }
      
      public function set score(param1:int) : void
      {
         this._score = param1;
      }
      
      public function get maxScore() : int
      {
         return this._maxScore;
      }
      
      public function set maxScore(param1:int) : void
      {
         this._maxScore = param1;
      }
      
      public function get isLeading() : Boolean
      {
         return this._isLeading;
      }
      
      public function set isLeading(param1:Boolean) : void
      {
         this._isLeading = param1;
      }
   }
}

