package net.bigpoint.darkorbit.mvc.sectorControl.controller
{
   import net.bigpoint.darkorbit.com.module.SectorControlPlayerCountModule;
   import net.bigpoint.darkorbit.mvc.sectorControl.model.proxy.SectorControlProxy;
   import org.puremvc.as3.multicore.interfaces.ICommand;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class UpdateSectorControlPlayersModelCommand extends SimpleCommand implements ICommand
   {
      
      public function UpdateSectorControlPlayersModelCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         (facade.retrieveProxy(SectorControlProxy.NAME) as SectorControlProxy).updatePlayers(param1.getBody() as Vector.<SectorControlPlayerCountModule>);
      }
   }
}

