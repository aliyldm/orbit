package net.bigpoint.darkorbit.mvc.gui.windows.diminishingQuest.view
{
   import net.bigpoint.darkorbit.com.module.QuestAcceptabilityStatusModule;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.mediator.SimpleWindowMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.diminishingQuest.controller.DiminishingQuestUpdateConditionCommand;
   import net.bigpoint.darkorbit.mvc.gui.windows.diminishingQuest.model.DiminishingQuestUIData;
   import net.bigpoint.darkorbit.mvc.gui.windows.diminishingQuest.model.DiminishingQuestUIWindowProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.diminishingQuest.view.components.DiminishingQuestRootView;
   import net.bigpoint.darkorbit.mvc.questWindow.controller.QuestNotification;
   
   public class DiminishingQuestUIWindowMediator extends SimpleWindowMediator
   {
      
      private var _data:DiminishingQuestUIData;
      
      private var _view:DiminishingQuestRootView;
      
      public function DiminishingQuestUIWindowMediator(param1:String, param2:SimpleWindow)
      {
         super(param1,param2);
         param2.setSize(250,175);
         this._view = new DiminishingQuestRootView(guiManager,param2);
         this._view.onQuestAccepted.add(this.onQuestAccepted);
      }
      
      override public function onRegister() : void
      {
         super.onRegister();
      }
      
      override protected function handleLoadAndBuildContentCallback(param1:Array) : void
      {
         super.handleLoadAndBuildContentCallback(param1);
         var _loc2_:DiminishingQuestUIWindowProxy = retrieveProxy(GuiConstants.DIMINISH_RETURN_QUEST) as DiminishingQuestUIWindowProxy;
         this.data = _loc2_.getData() as DiminishingQuestUIData;
         facade.registerCommand(QuestNotification.UPDATE_QUEST_CONDITION_VIEW,DiminishingQuestUpdateConditionCommand);
      }
      
      public function get data() : DiminishingQuestUIData
      {
         return this._data;
      }
      
      public function set data(param1:DiminishingQuestUIData) : void
      {
         if(this._data != null)
         {
            this._data.changed.remove(this.onDataChange);
            this._data.acceptTimer.changed.remove(this.onTimerUpdate);
         }
         this._data = param1;
         if(this._data != null)
         {
            this._data.changed.add(this.onDataChange);
            this._data.acceptTimer.changed.add(this.onTimerUpdate);
            this.onDataChange();
            this.onTimerUpdate();
         }
      }
      
      public function updateViewCondition(param1:int, param2:Boolean) : void
      {
         this._view.updateCondition(param1,param2);
      }
      
      private function onDataChange() : void
      {
         var _loc1_:Boolean = false;
         if(this._data.quest == null)
         {
            window.minimize(false,true);
         }
         else
         {
            _loc1_ = !(this._data.status == QuestAcceptabilityStatusModule.ACCEPTABILITYTYPE_NOT_STARTED || this._data.status == QuestAcceptabilityStatusModule.ACCEPTABILITYTYPE_NOT_ACCEPTABLE);
            this._view.quest = this._data.quest;
            this._view.isQuestRunning = _loc1_;
            this._view.toggleShowAcceptBtn(!_loc1_);
            this._view.refresh();
         }
      }
      
      private function onTimerUpdate() : void
      {
         this._view.updateTimer(this._data.acceptTimer.value);
      }
      
      private function onQuestAccepted() : void
      {
         this._data.questAccepted.dispatch();
      }
   }
}

