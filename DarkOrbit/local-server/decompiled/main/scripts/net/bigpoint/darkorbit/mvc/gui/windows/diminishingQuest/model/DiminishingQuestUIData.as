package net.bigpoint.darkorbit.mvc.gui.windows.diminishingQuest.model
{
   import com.bigpoint.utils.bindables.BindableCountDown;
   import flash.events.EventDispatcher;
   import net.bigpoint.darkorbit.com.module.QuestAcceptabilityStatusModule;
   import net.bigpoint.darkorbit.com.module.QuestDefinitionModule;
   import net.bigpoint.darkorbit.questfm.Quest;
   import net.bigpoint.darkorbit.questfm.QuestParser;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class DiminishingQuestUIData extends EventDispatcher
   {
      
      public var changed:ISignal = new Signal();
      
      public var questAccepted:ISignal = new Signal();
      
      public const acceptTimer:BindableCountDown = new BindableCountDown();
      
      private var _quest:Quest;
      
      private var _timeToQuestEnd:Number;
      
      private var _status:int;
      
      public function DiminishingQuestUIData()
      {
         super();
      }
      
      public function get quest() : Quest
      {
         return this._quest;
      }
      
      public function set quest(param1:Quest) : void
      {
         this._quest = param1;
         this.changed.dispatch();
      }
      
      public function get status() : int
      {
         return this._status;
      }
      
      public function setQuestNetty(param1:QuestDefinitionModule) : void
      {
         this._quest = QuestParser.instance.parseDefinition(param1);
      }
      
      public function set acceptabilityStatus(param1:QuestAcceptabilityStatusModule) : void
      {
         this._status = param1.type;
      }
      
      public function set timeToQuestEnd(param1:Number) : void
      {
         this._timeToQuestEnd = param1;
         this.acceptTimer.value = param1;
      }
   }
}

