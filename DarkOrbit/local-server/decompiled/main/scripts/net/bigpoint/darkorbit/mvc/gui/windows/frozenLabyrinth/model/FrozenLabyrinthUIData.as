package net.bigpoint.darkorbit.mvc.gui.windows.frozenLabyrinth.model
{
   import com.bigpoint.utils.bindables.BindableCountDown;
   import com.bigpoint.utils.bindables.BindableInt;
   import flash.events.EventDispatcher;
   import net.bigpoint.darkorbit.com.module.FrozenLabyrinthInfoCommand;
   import net.bigpoint.darkorbit.com.module.FrozenLabyrinthKeyInfoCommand;
   import net.bigpoint.darkorbit.com.module.FrozenLabyrinthRankInfoCommand;
   import net.bigpoint.darkorbit.com.module.FrozenLabyrinthRankModule;
   import net.bigpoint.darkorbit.com.module.FrozenLabyrinthSynkInfoCommand;
   import net.bigpoint.darkorbit.com.module.FrozenLabyrinthTimeInfoCommand;
   import net.bigpoint.darkorbit.com.module.FrozenLabyrinthTopRankerInfoCommand;
   import net.bigpoint.darkorbit.mvc.gui.windows.frozenLabyrinth.model.vo.FrozenLabyrinthSynkVO;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class FrozenLabyrinthUIData extends EventDispatcher
   {
      
      public const changed:ISignal = new Signal();
      
      public const synkChanged:ISignal = new Signal();
      
      public const timer:BindableCountDown = new BindableCountDown();
      
      private var _labyrinthActive:Boolean;
      
      private var _topDescription:String;
      
      public const labyrinthKeys:BindableInt = new BindableInt();
      
      public var _synkLocation:FrozenLabyrinthSynkVO = new FrozenLabyrinthSynkVO();
      
      private var _topTenRank:Vector.<FrozenLabyrinthRankModule> = new Vector.<FrozenLabyrinthRankModule>(0);
      
      private var _myRank:FrozenLabyrinthRankModule = new FrozenLabyrinthRankModule();
      
      public function FrozenLabyrinthUIData()
      {
         super();
      }
      
      public function updateInfo(param1:FrozenLabyrinthInfoCommand) : void
      {
         this.setLabyrinthActive(param1.timeInfo.timeToEndLabyrinth,param1.timeInfo.timeToNextLabyrinth);
         this.updateTopDescription();
         this.updateKeyAmount(param1.labyrinthKeys);
         this.updateRanks(param1.rankInfo);
         this.changed.dispatch();
      }
      
      public function updateTimer(param1:FrozenLabyrinthTimeInfoCommand) : void
      {
         this.setLabyrinthActive(param1.timeToEndLabyrinth,param1.timeToNextLabyrinth);
         this.updateTopDescription();
         this.changed.dispatch();
      }
      
      public function updateRanking(param1:FrozenLabyrinthRankInfoCommand) : void
      {
         this.updateRanks(param1);
         this.changed.dispatch();
      }
      
      public function updateTopRankers(param1:FrozenLabyrinthTopRankerInfoCommand) : void
      {
         this._topTenRank = param1.topRankers;
         this.changed.dispatch();
      }
      
      private function setLabyrinthActive(param1:Number, param2:Number) : void
      {
         if(param1)
         {
            this._labyrinthActive = true;
            this.updateLabyrinthTimer(param1);
         }
         else
         {
            this._labyrinthActive = false;
            this.updateLabyrinthTimer(param2);
         }
      }
      
      private function updateRanks(param1:FrozenLabyrinthRankInfoCommand) : void
      {
         this._topTenRank = param1.topRankers;
         this._myRank = param1.myRank;
      }
      
      private function updateLabyrinthTimer(param1:Number) : void
      {
         this.timer.value = param1;
      }
      
      public function updateKeys(param1:FrozenLabyrinthKeyInfoCommand) : void
      {
         this.updateKeyAmount(param1.labyrinthKeys);
      }
      
      public function updateKeyAmount(param1:int) : void
      {
         this.labyrinthKeys.value = param1;
      }
      
      public function updateSynkLocation(param1:FrozenLabyrinthSynkInfoCommand) : void
      {
         this._synkLocation.mapName = param1.mapName;
         this._synkLocation.zone = param1.zone;
         this._synkLocation.respawnInSeconds.value = param1.respawnInSeconds;
         this._synkLocation.isGateActive.value = param1.isGateActive;
         this.synkChanged.dispatch();
      }
      
      private function updateTopDescription() : void
      {
         if(this._labyrinthActive)
         {
            this._topDescription = "frozen_labyrinth_status_open";
         }
         else if(this.timer.value)
         {
            this._topDescription = "frozen_labyrinth_status_closed";
         }
         else
         {
            this._topDescription = "frozen_labyrinth_status_ended";
         }
      }
      
      public function get topDescription() : String
      {
         return this._topDescription;
      }
      
      public function get topRankers() : Vector.<FrozenLabyrinthRankModule>
      {
         return this._topTenRank;
      }
      
      public function get ownRank() : FrozenLabyrinthRankModule
      {
         return this._myRank;
      }
   }
}

