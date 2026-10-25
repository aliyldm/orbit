package net.bigpoint.darkorbit.mvc.application.controller.init
{
   import net.bigpoint.darkorbit.Main;
   import net.bigpoint.darkorbit.utils.version.Version;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.AsyncCommand;
   
   public class InitVersionCommand extends AsyncCommand
   {
      
      public function InitVersionCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:Version = new Version();
         Main.VERSION = _loc2_.getVersion();
         commandComplete();
      }
   }
}

