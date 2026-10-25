package net.bigpoint.darkorbit.mvc.refractionzoneWindow.comhandlers
{
   import net.bigpoint.darkorbit.com.module.RzoneStatusCommand;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.refractionzoneWindow.RZoneNotifications;
   import net.bigpoint.darkorbit.mvc.refractionzoneWindow.model.RZoneStatusProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class RZoneStatusCommandHandler extends DOAbstractSimpleCommand
   {
      
      public function RZoneStatusCommandHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:RzoneStatusCommand = param1.getBody() as RzoneStatusCommand;
         sendNotification(RZoneNotifications.INIT);
         var _loc3_:RZoneStatusProxy = retrieveProxy(RZoneStatusProxy.NAME) as RZoneStatusProxy;
         _loc3_.update(_loc2_);
      }
   }
}

