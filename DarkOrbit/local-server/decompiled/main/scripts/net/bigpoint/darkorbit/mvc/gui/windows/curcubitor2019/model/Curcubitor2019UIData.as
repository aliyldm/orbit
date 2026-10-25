package net.bigpoint.darkorbit.mvc.gui.windows.curcubitor2019.model
{
   import com.bigpoint.utils.bindables.BindableCountDown;
   import flash.events.EventDispatcher;
   import net.bigpoint.darkorbit.com.module.Curcubitor2019Command;
   import net.bigpoint.darkorbit.com.module.Curcubitor2019TimeUpdateCommand;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class Curcubitor2019UIData extends EventDispatcher
   {
      
      public const changed:ISignal = new Signal();
      
      public const timer:BindableCountDown = new BindableCountDown();
      
      private var _leftToKill:Number;
      
      private var _topDescription:String;
      
      private var _middleDescription:String;
      
      private var _hasCurcubitors:Boolean;
      
      public function Curcubitor2019UIData()
      {
         super();
      }
      
      public function updateInfo(param1:Curcubitor2019Command) : void
      {
         this.timer.value = param1.timeToNext;
         this._leftToKill = param1.curcubitorLeftToKill;
         this.updateDescription(param1.bossCount);
         this.changed.dispatch();
      }
      
      public function updateTimer(param1:Curcubitor2019TimeUpdateCommand) : void
      {
         this.timer.value = param1.timeToNext;
      }
      
      private function updateDescription(param1:Number) : void
      {
         if(this.timer.value > 0)
         {
            this._topDescription = "curcubitor_status_next_spawn_time";
            this._middleDescription = "curcubitor_countdown_no_spawn";
            this._leftToKill = 0;
            this._hasCurcubitors = false;
         }
         else if(param1 == 0)
         {
            this._topDescription = "curcubitor_status_spawning";
            if(this._leftToKill > 0)
            {
               this._middleDescription = "curcubitor_countdown_npc";
               this._hasCurcubitors = true;
            }
            else
            {
               this._middleDescription = "curcubitor_countdown_wrong_map";
               this._hasCurcubitors = false;
            }
         }
         else
         {
            this._topDescription = "curcubitor_status_boss_spawn";
            this._middleDescription = "curcubitor_countdown_boss_spawn";
            this._leftToKill = param1;
            this._hasCurcubitors = false;
         }
      }
      
      public function get topDescription() : String
      {
         return this._topDescription;
      }
      
      public function get middleDescription() : String
      {
         return this._middleDescription;
      }
      
      public function get leftToKill() : Number
      {
         return this._leftToKill;
      }
      
      public function get hasCurcubitors() : Boolean
      {
         return this._hasCurcubitors;
      }
   }
}

