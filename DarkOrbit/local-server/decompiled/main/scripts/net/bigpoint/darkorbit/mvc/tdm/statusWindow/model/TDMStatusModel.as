package net.bigpoint.darkorbit.mvc.tdm.statusWindow.model
{
   import net.bigpoint.darkorbit.com.module.FactionScoreModule;
   import net.bigpoint.darkorbit.mvc.tdm.statusWindow.model.vo.FactionScoreVO;
   
   public class TDMStatusModel
   {
      
      private static const OVERALL_FACTION_COUNT:int = 3;
      
      private static const CURRENT_FACTION_COUNT:int = 2;
      
      private var _maxScore:int = -2147483648;
      
      private var _remainingLifes:int = -2147483648;
      
      private var _overallEventScores:Vector.<FactionScoreModule> = new Vector.<FactionScoreModule>();
      
      private var _remainingSeconds:int = -2147483648;
      
      private var _initSeconds:int = -2147483648;
      
      private var _currentFactionScores:Vector.<FactionScoreVO> = new Vector.<FactionScoreVO>();
      
      public function TDMStatusModel()
      {
         super();
      }
      
      public function get maxScore() : int
      {
         return this._maxScore;
      }
      
      public function get remainingLifes() : int
      {
         return this._remainingLifes;
      }
      
      public function get overallEventScores() : Vector.<FactionScoreModule>
      {
         return this._overallEventScores;
      }
      
      public function get remainingSeconds() : int
      {
         return this._remainingSeconds;
      }
      
      public function get currentFactionScores() : Vector.<FactionScoreVO>
      {
         return this._currentFactionScores;
      }
      
      public function set maxScore(param1:int) : void
      {
         this._maxScore = param1;
      }
      
      public function set remainingLifes(param1:int) : void
      {
         this._remainingLifes = param1;
      }
      
      public function set overallEventScores(param1:Vector.<FactionScoreModule>) : void
      {
         this._overallEventScores = param1;
      }
      
      public function set remainingSeconds(param1:int) : void
      {
         this._remainingSeconds = param1;
      }
      
      public function set initSeconds(param1:int) : void
      {
         this._initSeconds = param1;
      }
      
      public function get initSeconds() : int
      {
         return this._initSeconds;
      }
      
      public function setCurrentFactionScores(param1:Vector.<FactionScoreModule>, param2:int) : void
      {
         var _loc4_:FactionScoreModule = null;
         var _loc3_:Vector.<FactionScoreVO> = new Vector.<FactionScoreVO>();
         var _loc5_:int = 0;
         while(_loc5_ < param1.length)
         {
            _loc4_ = param1[_loc5_];
            _loc3_.push(new FactionScoreVO(_loc4_.faction.faction,_loc4_.score,param2));
            _loc5_++;
         }
         this._currentFactionScores = _loc3_;
      }
      
      public function compareOverallEventScores(param1:Vector.<FactionScoreModule>) : Boolean
      {
         var _loc2_:Boolean = false;
         var _loc3_:uint = 0;
         var _loc4_:int = 0;
         var _loc5_:FactionScoreModule = null;
         var _loc6_:FactionScoreModule = null;
         if(param1.length != this._overallEventScores.length)
         {
            _loc2_ = true;
         }
         else
         {
            _loc3_ = param1.length;
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               _loc5_ = this._overallEventScores[_loc4_];
               _loc6_ = param1[_loc4_];
               if(_loc5_.score != _loc6_.score || _loc5_.faction.faction != _loc6_.faction.faction)
               {
                  _loc2_ = true;
                  break;
               }
               _loc4_++;
            }
         }
         return _loc2_;
      }
      
      public function compareCurrentFactionScores(param1:Vector.<FactionScoreModule>) : Boolean
      {
         var _loc2_:Boolean = false;
         var _loc3_:uint = 0;
         var _loc4_:int = 0;
         var _loc5_:FactionScoreVO = null;
         var _loc6_:FactionScoreModule = null;
         if(param1.length != this._currentFactionScores.length)
         {
            _loc2_ = true;
         }
         else
         {
            _loc3_ = param1.length;
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               _loc5_ = this._currentFactionScores[_loc4_];
               _loc6_ = param1[_loc4_];
               if(_loc5_.score != _loc6_.score || _loc5_.faction != _loc6_.faction.faction)
               {
                  _loc2_ = true;
                  break;
               }
               _loc4_++;
            }
         }
         return _loc2_;
      }
   }
}

