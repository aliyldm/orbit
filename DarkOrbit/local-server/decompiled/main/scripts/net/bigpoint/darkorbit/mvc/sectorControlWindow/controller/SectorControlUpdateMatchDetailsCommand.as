package net.bigpoint.darkorbit.mvc.sectorControlWindow.controller
{
   import net.bigpoint.darkorbit.com.module.SectorControlMatchDetailCommand;
   import net.bigpoint.darkorbit.mvc.sectorControl.model.proxy.SectorControlProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class SectorControlUpdateMatchDetailsCommand extends SimpleCommand
   {
      
      public function SectorControlUpdateMatchDetailsCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:SectorControlMatchDetailCommand = param1.getBody() as SectorControlMatchDetailCommand;
         var _loc3_:SectorControlProxy = facade.retrieveProxy(SectorControlProxy.NAME) as SectorControlProxy;
         _loc3_.updateMatchDetails(_loc2_);
      }
   }
}

