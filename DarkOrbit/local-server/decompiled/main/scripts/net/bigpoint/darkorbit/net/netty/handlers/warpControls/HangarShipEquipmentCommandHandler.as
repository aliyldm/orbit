package net.bigpoint.darkorbit.net.netty.handlers.warpControls
{
   import net.bigpoint.darkorbit.com.module.porting.hangar.HangarShipEquipmentCommand;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.gui.windows.warpControls.mode.WarpControlsProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class HangarShipEquipmentCommandHandler extends DOAbstractSimpleCommand
   {
      
      public function HangarShipEquipmentCommandHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:HangarShipEquipmentCommand = param1.getBody() as HangarShipEquipmentCommand;
         WarpControlsProxy.getProxy(this.facade).rcvHangarShipEquipmentCommand(_loc2_);
      }
   }
}

