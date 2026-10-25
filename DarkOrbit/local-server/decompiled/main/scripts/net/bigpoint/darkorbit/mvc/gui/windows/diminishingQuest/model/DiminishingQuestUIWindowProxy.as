package net.bigpoint.darkorbit.mvc.gui.windows.diminishingQuest.model
{
   import net.bigpoint.darkorbit.com.module.DiminishingQuestAcceptQuestRequest;
   import net.bigpoint.darkorbit.com.module.QuestAcceptabilityStatusModule;
   import net.bigpoint.darkorbit.com.module.QuestDefinitionModule;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.model.SimpleWindowProxy;
   import net.bigpoint.darkorbit.questfm.ICondition;
   
   public class DiminishingQuestUIWindowProxy extends SimpleWindowProxy
   {
      
      private var _questData:DiminishingQuestUIData;
      
      private var _waitAcceptQuestRequest:Boolean = false;
      
      public function DiminishingQuestUIWindowProxy(param1:String)
      {
         super(param1,this._questData = new DiminishingQuestUIData());
         this._questData.questAccepted.add(this.requestAcceptQuest);
      }
      
      public function updateQuestObjectives(param1:int, param2:Number, param3:Boolean, param4:Boolean) : void
      {
         var _loc6_:int = 0;
         var _loc7_:ICondition = null;
         if(this._questData.quest == null)
         {
            return;
         }
         var _loc5_:ICondition = this._questData.quest.flatConditions[param1];
         if(_loc5_ == null)
         {
            return;
         }
         _loc5_.current = param2;
         _loc5_.runstate = param3;
         _loc5_.completed = param4;
         if(_loc5_.children.length > 0)
         {
            _loc6_ = 0;
            while(_loc6_ < _loc5_.children.length)
            {
               _loc7_ = _loc5_.children[_loc6_] as ICondition;
               _loc7_.runstate = param3;
               _loc7_.completed = param4;
               _loc6_++;
            }
         }
         this._questData.changed.dispatch();
      }
      
      public function setQuest(param1:QuestDefinitionModule, param2:QuestAcceptabilityStatusModule, param3:Number) : void
      {
         this._questData.setQuestNetty(param1);
         this._questData.acceptabilityStatus = param2;
         this._questData.timeToQuestEnd = param3;
         this._questData.changed.dispatch();
      }
      
      public function acceptQuestResponse(param1:QuestAcceptabilityStatusModule, param2:Number) : void
      {
         this._waitAcceptQuestRequest = false;
         this._questData.acceptabilityStatus = param1;
         this._questData.timeToQuestEnd = param2;
         this._questData.changed.dispatch();
      }
      
      public function removeQuest(param1:QuestAcceptabilityStatusModule) : void
      {
         this._questData.quest = null;
         this._questData.acceptabilityStatus = param1;
         this._questData.changed.dispatch();
      }
      
      public function requestAcceptQuest() : void
      {
         if(this._waitAcceptQuestRequest)
         {
            return;
         }
         facade.sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new DiminishingQuestAcceptQuestRequest(this._questData.quest.id));
         this._waitAcceptQuestRequest = true;
      }
   }
}

