package net.bigpoint.darkorbit.mvc.gui.windows.worldBoss.progress.model
{
   import flash.events.EventDispatcher;
   import net.bigpoint.darkorbit.com.module.porting.publicWorldBoss.PublicWorldBossRaidIntensity;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class WorldBossUIProgressData extends EventDispatcher
   {
      
      public const changed:ISignal = new Signal();
      
      public const tierChanged:ISignal = new Signal();
      
      private var _raidList:Vector.<WorldBossUIProgressVO> = new Vector.<WorldBossUIProgressVO>();
      
      public function WorldBossUIProgressData()
      {
         super();
      }
      
      public function updateInfo(param1:Vector.<PublicWorldBossRaidIntensity>) : void
      {
         this.setRaidList(param1);
         this.changed.dispatch();
      }
      
      public function get raidList() : Vector.<WorldBossUIProgressVO>
      {
         return this._raidList;
      }
      
      public function setRaidList(param1:Vector.<PublicWorldBossRaidIntensity>) : void
      {
         var _loc2_:PublicWorldBossRaidIntensity = null;
         this._raidList = new Vector.<WorldBossUIProgressVO>();
         for each(_loc2_ in param1)
         {
            this._raidList.push(new WorldBossUIProgressVO(_loc2_));
         }
      }
   }
}

