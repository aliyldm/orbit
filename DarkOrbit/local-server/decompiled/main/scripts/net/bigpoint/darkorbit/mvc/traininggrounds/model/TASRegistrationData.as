package net.bigpoint.darkorbit.mvc.traininggrounds.model
{
   import com.bigpoint.utils.bindables.BindableCountDown;
   import net.bigpoint.darkorbit.com.module.TrainingArenaPerformanceEntryCommand;
   import net.bigpoint.darkorbit.com.module.TrainingArenaSeasonRewardEntryCommand;
   
   public class TASRegistrationData
   {
      
      private var _rank:int;
      
      private var _season:String;
      
      private var _seasonDuration:BindableCountDown = new BindableCountDown(0,1000,0,1000);
      
      private var _performance:Vector.<TrainingArenaPerformanceEntryCommand>;
      
      private var _battles:int;
      
      private var _victories:int;
      
      private var _rewards:Vector.<TrainingArenaSeasonRewardEntryCommand>;
      
      private var _taScore:Number = -1;
      
      private var _rankDelta:int = -1;
      
      public function TASRegistrationData()
      {
         super();
      }
      
      public function get rewards() : Vector.<TrainingArenaSeasonRewardEntryCommand>
      {
         return this._rewards;
      }
      
      public function set rewards(param1:Vector.<TrainingArenaSeasonRewardEntryCommand>) : void
      {
         this._rewards = param1;
      }
      
      public function get rank() : int
      {
         return this._rank;
      }
      
      public function set rank(param1:int) : void
      {
         if(this._rankDelta != -1)
         {
            this._rankDelta = param1 - this._rank;
         }
         else
         {
            this._rankDelta = 0;
         }
         this._rank = param1;
      }
      
      public function get season() : String
      {
         return this._season;
      }
      
      public function set season(param1:String) : void
      {
         this._season = param1;
      }
      
      public function get seasonDurationTimer() : BindableCountDown
      {
         return this._seasonDuration;
      }
      
      public function get performance() : Vector.<TrainingArenaPerformanceEntryCommand>
      {
         return this._performance;
      }
      
      public function set performance(param1:Vector.<TrainingArenaPerformanceEntryCommand>) : void
      {
         this._performance = param1;
      }
      
      public function get battles() : int
      {
         return this._battles;
      }
      
      public function set battles(param1:int) : void
      {
         this._battles = param1;
      }
      
      public function get victories() : int
      {
         return this._victories;
      }
      
      public function set victories(param1:int) : void
      {
         this._victories = param1;
      }
      
      public function set taScore(param1:Number) : void
      {
         this._taScore = param1;
      }
      
      public function get taScore() : Number
      {
         return this._taScore;
      }
      
      public function get rankDelta() : int
      {
         return this._rankDelta;
      }
   }
}

