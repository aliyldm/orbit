package net.bigpoint.darkorbit.mvc.application.controller.init
{
   import net.bigpoint.darkorbit.mvc.spaceMap.SpaceMapDataProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.AsyncCommand;
   
   public class InitSpaceMapModelCommand extends AsyncCommand
   {
      
      public function InitSpaceMapModelCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:SpaceMapDataProxy = facade.retrieveProxy(SpaceMapDataProxy.NAME) as SpaceMapDataProxy;
         _loc2_.loadConfig(commandComplete);
      }
   }
}

