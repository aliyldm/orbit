package net.bigpoint.darkorbit.mvc.influenceWindow.model
{
   public class InfluenceBarVo
   {
      
      private var _faction:String;
      
      private var _score:Number = 0;
      
      private var _maxScore:Number = 0;
      
      private var _isLeading:Boolean;
      
      public function InfluenceBarVo(param1:String, param2:Number, param3:Number, param4:Boolean)
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
      
      public function get score() : Number
      {
         return this._score;
      }
      
      public function get maxScore() : Number
      {
         return this._maxScore;
      }
      
      public function get isLeading() : Boolean
      {
         return this._isLeading;
      }
      
      public function set faction(param1:String) : void
      {
         this._faction = param1;
      }
      
      public function set score(param1:Number) : void
      {
         this._score = param1;
      }
      
      public function set maxScore(param1:Number) : void
      {
         this._maxScore = param1;
      }
      
      public function set isLeading(param1:Boolean) : void
      {
         this._isLeading = param1;
      }
   }
}

