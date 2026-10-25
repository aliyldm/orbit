package net.bigpoint.darkorbit.mvc.sectorControl.controller
{
   import net.bigpoint.darkorbit.mvc.sectorControl.model.proxy.SectorControlProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class CleanupSectorControlCommand extends SimpleCommand
   {
      
      public function CleanupSectorControlCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:SectorControlProxy = facade.retrieveProxy(SectorControlProxy.NAME) as SectorControlProxy;
         _loc2_.resetControlPointMapping();
      }
   }
}

