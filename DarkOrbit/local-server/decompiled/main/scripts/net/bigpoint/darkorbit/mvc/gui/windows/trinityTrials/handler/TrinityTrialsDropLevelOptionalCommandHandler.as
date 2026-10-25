package net.bigpoint.darkorbit.mvc.gui.windows.trinityTrials.handler
{
   import net.bigpoint.darkorbit.com.module.porting.trinitytrials.TrinityTrialsDropLevelOptionalCommand;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class TrinityTrialsDropLevelOptionalCommandHandler extends DOAbstractSimpleCommand
   {
      
      public function TrinityTrialsDropLevelOptionalCommandHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:TrinityTrialsDropLevelOptionalCommand = param1.getBody() as TrinityTrialsDropLevelOptionalCommand;
      }
   }
}

