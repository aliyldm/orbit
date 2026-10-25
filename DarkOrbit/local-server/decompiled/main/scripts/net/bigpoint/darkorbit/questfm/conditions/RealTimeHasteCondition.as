package net.bigpoint.darkorbit.questfm.conditions
{
   import com.bigpoint.utils.TimeFormatter;
   import net.bigpoint.darkorbit.interfaces.IFrameObserver;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.questWindow.controller.QuestNotification;
   
   public class RealTimeHasteCondition extends Condition implements IFrameObserver
   {
      
      private var summedTpf:int;
      
      private var timeLeft:Number = 0;
      
      private var facade:GameFacade = GameFacade.getInstance();
      
      public function RealTimeHasteCondition()
      {
         super();
      }
      
      override public function set runstate(param1:Boolean) : void
      {
         super.runstate = param1;
      }
      
      override public function set current(param1:Number) : void
      {
         _current = param1;
         this.setTimeLeft();
      }
      
      override protected function parseMatches(param1:Vector.<String>) : void
      {
         super.parseMatches(param1);
         _description = _description.replace(/%TIME%/,TimeFormatter.getSmartFormatedTime(Math.ceil(_target * 0.001)));
         _target_plain = TimeFormatter.getSmartFormatedTime(this.timeLeft);
      }
      
      private function updateRunstateTimer(param1:Boolean) : void
      {
         this.setTimeLeft();
         if(param1)
         {
            ScreenManager.addObserver(this);
         }
         else
         {
            ScreenManager.removeObserver(this);
         }
      }
      
      private function setTimeLeft() : void
      {
         this.timeLeft = Math.ceil(current * 0.001);
      }
      
      public function updateTimer(param1:Number) : void
      {
         this.summedTpf += param1;
         while(this.summedTpf > 1000)
         {
            this.summedTpf -= 1000;
            this.current = current - 1000;
         }
         _target_plain = TimeFormatter.getSmartFormatedTime(this.timeLeft);
         this.facade.forwardNotification(QuestNotification.UPDATE_QUEST_CONDITION_VIEW,this);
      }
      
      override public function set questIsRunning(param1:Boolean) : void
      {
         super.questIsRunning = param1;
         this.updateRunstateTimer(param1);
      }
   }
}

