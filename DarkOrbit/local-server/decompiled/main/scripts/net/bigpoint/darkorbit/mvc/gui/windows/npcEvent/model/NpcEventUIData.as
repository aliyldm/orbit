package net.bigpoint.darkorbit.mvc.gui.windows.npcEvent.model
{
   import com.bigpoint.utils.bindables.BindableCountDown;
   import flash.events.EventDispatcher;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.com.module.NpcEventBossInfoCommand;
   import net.bigpoint.darkorbit.com.module.NpcEventInfoCommand;
   import net.bigpoint.darkorbit.com.module.NpcEventTimeInfoCommand;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class NpcEventUIData extends EventDispatcher
   {
      
      private static const TITLE:String = "_title";
      
      private static const DESCRIPTION:String = "_event_description";
      
      private static const BOSS:String = "_boss_spawn";
      
      public const changed:ISignal = new Signal();
      
      public const timer:BindableCountDown = new BindableCountDown();
      
      private var _windowTitle:String;
      
      private var _topDescription:String;
      
      private var _middleDescription:String;
      
      private var _eventDescriptionTextKey:String;
      
      private var _hasBoss:Boolean = false;
      
      private var _leftToKill:Number = 0;
      
      private var _bossCount:Number = 0;
      
      private var _eventActive:Boolean = false;
      
      private var _textKey:String;
      
      private var _npcName:String;
      
      public function NpcEventUIData()
      {
         super();
      }
      
      public function updateInfo(param1:NpcEventInfoCommand) : void
      {
         this._hasBoss = param1.type == NpcEventInfoCommand.WINDOWTYPE_STANDARD;
         this._textKey = param1.textKey;
         this._windowTitle = this._textKey + TITLE;
         this._eventDescriptionTextKey = this._textKey + DESCRIPTION;
         this._npcName = InGameCatalog.instance.getNpcName(param1.npcID);
         this.updateTimer(param1.timeInfoCommand);
         if(this._hasBoss)
         {
            this.updateBossInfo(param1.bossInfoCommand);
         }
         this.changed.dispatch();
      }
      
      public function updateTimer(param1:NpcEventTimeInfoCommand) : void
      {
         this.setEventActive(param1.timeToEndSpawn,param1.timeToNextSpawn);
         this.updateDescriptions();
         this.changed.dispatch();
      }
      
      public function updateBossInfo(param1:NpcEventBossInfoCommand) : void
      {
         this._leftToKill = param1.leftToKill;
         this._bossCount = param1.bossCount;
         this.updateDescriptions();
         this.changed.dispatch();
      }
      
      private function setEventActive(param1:Number, param2:Number) : void
      {
         if(param1)
         {
            this._eventActive = true;
            this.updateEventTimer(param1);
         }
         else
         {
            this._eventActive = false;
            this.updateEventTimer(param2);
         }
      }
      
      private function updateEventTimer(param1:Number) : void
      {
         this.timer.value = param1;
      }
      
      private function updateDescriptions() : void
      {
         this.updateTopDescription();
         if(this._hasBoss)
         {
            this.updateMiddleDescription();
         }
         this.insertNpcName();
      }
      
      private function updateTopDescription() : void
      {
         if(!this._hasBoss || this._bossCount <= 0)
         {
            if(this._eventActive)
            {
               this._topDescription = "npc_event_status_spawning";
            }
            else if(!this.timer.value)
            {
               this._topDescription = "npc_event_status_ended";
            }
            else
            {
               this._topDescription = "npc_event_next_spawn_time";
            }
         }
         else
         {
            this._topDescription = this._textKey + BOSS;
         }
      }
      
      private function updateMiddleDescription() : void
      {
         if(!this._eventActive)
         {
            this._middleDescription = "npc_event_no_spawn";
            this._leftToKill = 0;
         }
         else if(this._bossCount == 0)
         {
            if(this.leftToKill > 0)
            {
               this._middleDescription = "npc_event_countdown_npc";
            }
            else
            {
               this._middleDescription = "npc_event_wrong_map";
            }
         }
         else
         {
            this._leftToKill = this._bossCount;
            this._middleDescription = "npc_event_countdown_multi_boss";
         }
      }
      
      private function insertNpcName() : void
      {
         this._topDescription = BPLocale.getItem(this._topDescription).replace("%NPC%",this._npcName);
         if(this._hasBoss)
         {
            this._middleDescription = BPLocale.getItem(this._middleDescription).replace("%NPC%",this._npcName);
         }
      }
      
      public function get windowTitle() : String
      {
         return this._windowTitle;
      }
      
      public function get topDescription() : String
      {
         return this._topDescription;
      }
      
      public function get middleDescription() : String
      {
         return this._middleDescription;
      }
      
      public function get eventDescriptionTextkey() : String
      {
         return this._eventDescriptionTextKey;
      }
      
      public function get leftToKill() : Number
      {
         return this._leftToKill;
      }
      
      public function get hasBoss() : Boolean
      {
         return this._hasBoss;
      }
   }
}

