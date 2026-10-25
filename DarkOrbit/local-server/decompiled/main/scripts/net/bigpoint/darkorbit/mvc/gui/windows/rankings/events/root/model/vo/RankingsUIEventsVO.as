package net.bigpoint.darkorbit.mvc.gui.windows.rankings.events.root.model.vo
{
   public class RankingsUIEventsVO
   {
      
      private var _rankings:Vector.<Vector.<String>>;
      
      private var _nextRank:Vector.<String>;
      
      private var _myRank:Vector.<String>;
      
      private var _prevRank:Vector.<String>;
      
      public function RankingsUIEventsVO(param1:Vector.<Vector.<String>>, param2:Vector.<String>, param3:Vector.<String>, param4:Vector.<String>)
      {
         super();
         this._rankings = param1;
         this._nextRank = param2;
         this._myRank = param3;
         this._prevRank = param4;
      }
      
      public function get rankings() : Vector.<Vector.<String>>
      {
         return this._rankings;
      }
      
      public function get nextRank() : Vector.<String>
      {
         return this._nextRank;
      }
      
      public function get myRank() : Vector.<String>
      {
         return this._myRank;
      }
      
      public function get prevRank() : Vector.<String>
      {
         return this._prevRank;
      }
   }
}

