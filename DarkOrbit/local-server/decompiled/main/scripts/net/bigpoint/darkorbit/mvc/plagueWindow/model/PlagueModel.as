package net.bigpoint.darkorbit.mvc.plagueWindow.model
{
   import com.bigpoint.utils.bindables.BindableCountDown;
   import com.bigpoint.utils.bindables.BindableObject;
   import net.bigpoint.darkorbit.com.module.SpacePlagueBossSummoningProgressCommand;
   import net.bigpoint.darkorbit.com.module.SpacePlagueInfectionStatusCommand;
   import net.bigpoint.darkorbit.com.module.SpacePlagueRatingStatusCommand;
   
   public class PlagueModel
   {
      
      public const timeLeft:BindableCountDown = new BindableCountDown(0);
      
      public const currentState:BindableObject = new BindableObject();
      
      private var _waveGroups:Object = {};
      
      private var _states:Object = {};
      
      private var _infectedPoints:int;
      
      private var _notInfectedPoints:int;
      
      private var _infected:Boolean;
      
      private var _mapID:int;
      
      public function PlagueModel()
      {
         super();
         this._waveGroups[SpacePlagueBossSummoningProgressCommand.SPACEPLAGUEBOSSSUMMONINGWAVEGROUPTYPE_WAVE_3] = new WaveMapGroup(new <int>[3,4,7,8,11,12]);
         this._waveGroups[SpacePlagueBossSummoningProgressCommand.SPACEPLAGUEBOSSSUMMONINGWAVEGROUPTYPE_WAVE_2] = new WaveMapGroup(new <int>[17,18,19,21,22,23,25,26,27]);
         this._waveGroups[SpacePlagueBossSummoningProgressCommand.SPACEPLAGUEBOSSSUMMONINGWAVEGROUPTYPE_WAVE_1] = new WaveMapGroup(new <int>[13,14,15,16,29]);
         this._states[BossSummonState] = new BossSummonState();
         this._states[MinionsSummonState] = new MinionsSummonState();
         this._states[NothingSummonState] = new NothingSummonState();
         this._states[OnOtherMapSummonState] = new OnOtherMapSummonState();
         this.setState(OnOtherMapSummonState);
      }
      
      public function get infected() : Boolean
      {
         return this._infected;
      }
      
      public function get infectedPoints() : int
      {
         return this._infectedPoints;
      }
      
      public function get notInfectedPoints() : int
      {
         return this._notInfectedPoints;
      }
      
      private function get minionsState() : MinionsSummonState
      {
         return this._states[MinionsSummonState] as MinionsSummonState;
      }
      
      private function get otherMapStateState() : OnOtherMapSummonState
      {
         return this._states[OnOtherMapSummonState] as OnOtherMapSummonState;
      }
      
      public function setCurrentMapId(param1:int) : void
      {
         this._mapID = param1;
         this.checkCurrentState();
      }
      
      public function setBossSummoningInfos(param1:Vector.<SpacePlagueBossSummoningProgressCommand>) : void
      {
         var _loc4_:SpacePlagueBossSummoningProgressCommand = null;
         var _loc5_:WaveMapGroup = null;
         var _loc2_:int = int(param1.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = param1[_loc3_];
            _loc5_ = this._waveGroups[_loc4_.waveGroup] as WaveMapGroup;
            if(_loc4_.bossCounter.active)
            {
               _loc5_.bossActive = _loc4_.bossCounter.active;
               _loc5_.counter = _loc4_.bossCounter.currentValue;
               _loc5_.counterMax = _loc4_.bossCounter.maxValue;
               _loc5_.active = _loc4_.bossCounter.active;
            }
            else
            {
               _loc5_.bossActive = false;
               _loc5_.active = _loc4_.minionsCounter.active;
               _loc5_.counter = _loc4_.minionsCounter.currentValue;
               _loc5_.counterMax = _loc4_.minionsCounter.maxValue;
            }
            _loc3_++;
         }
         this.checkCurrentState();
      }
      
      public function setInfection(param1:SpacePlagueInfectionStatusCommand) : void
      {
         this._infected = param1.infected;
         this.timeLeft.value = param1.remainingTime;
      }
      
      public function setRating(param1:SpacePlagueRatingStatusCommand) : void
      {
         this._infectedPoints = param1.infectedPoints;
         this._notInfectedPoints = param1.healthyPoints;
      }
      
      private function checkCurrentState() : void
      {
         var _loc2_:WaveMapGroup = null;
         var _loc3_:Vector.<int> = null;
         var _loc4_:* = undefined;
         var _loc1_:WaveMapGroup = this.getGroupForMap();
         if(_loc1_)
         {
            this.minionsState.currentWave = _loc1_;
            this.setState(MinionsSummonState);
         }
         else
         {
            _loc3_ = new Vector.<int>(0);
            for(_loc4_ in this._waveGroups)
            {
               _loc2_ = this._waveGroups[_loc4_] as WaveMapGroup;
               if(_loc2_.active)
               {
                  _loc3_ = _loc3_.concat(_loc2_.mapIDs);
               }
            }
            if(_loc3_.length > 0)
            {
               this.otherMapStateState.maps = _loc3_;
               this.setState(OnOtherMapSummonState);
            }
            else
            {
               this.setState(NothingSummonState);
            }
         }
      }
      
      private function getGroupForMap() : WaveMapGroup
      {
         var _loc1_:* = undefined;
         var _loc2_:WaveMapGroup = null;
         for(_loc1_ in this._waveGroups)
         {
            _loc2_ = this._waveGroups[_loc1_] as WaveMapGroup;
            if(_loc2_.active && _loc2_.hasMap(this._mapID))
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      private function setState(param1:Class) : void
      {
         this.currentState.value = this._states[param1];
      }
   }
}

