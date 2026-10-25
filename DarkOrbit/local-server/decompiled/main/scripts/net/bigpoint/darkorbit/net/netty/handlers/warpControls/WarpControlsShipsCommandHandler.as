package net.bigpoint.darkorbit.net.netty.handlers.warpControls
{
   import net.bigpoint.darkorbit.com.module.porting.hangar.HangarShipsCommand;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.gui.windows.warpControls.mode.WarpControlsProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class WarpControlsShipsCommandHandler extends DOAbstractSimpleCommand
   {
      
      public function WarpControlsShipsCommandHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:HangarShipsCommand = param1.getBody() as HangarShipsCommand;
         WarpControlsProxy.getProxy(this.facade).rcvAllData(_loc2_);
      }
   }
}

