package net.bigpoint.darkorbit.mvc.gui.windows.singularityDrive.handler
{
   import net.bigpoint.darkorbit.com.module.porting.voyagers.VoyagersPassCommand;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.gui.windows.singularityDrive.model.SingularityDrivePassProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class SingularityDrivePassCommandHandler extends DOAbstractSimpleCommand
   {
      
      public function SingularityDrivePassCommandHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:VoyagersPassCommand = param1.getBody() as VoyagersPassCommand;
         var _loc3_:SingularityDrivePassProxy = SingularityDrivePassProxy.getProxy();
         _loc3_.rcvRewardPass(_loc2_);
      }
   }
}

