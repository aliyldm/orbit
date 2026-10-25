package net.bigpoint.darkorbit.mvc.application.controller.bootup
{
   import net.bigpoint.darkorbit.mvc.application.model.ProfileProxy;
   import net.bigpoint.darkorbit.mvc.application.model.vo.StartupVO;
   import net.bigpoint.darkorbit.settings.Profiler;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.AsyncCommand;
   
   public class CreateProfilerCommand extends AsyncCommand
   {
      
      public function CreateProfilerCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:StartupVO = param1.getBody() as StartupVO;
         var _loc3_:ProfileProxy = facade.retrieveProxy(ProfileProxy.NAME) as ProfileProxy;
         _loc3_.setProfiler(new Profiler(_loc2_.main));
         commandComplete();
      }
   }
}

