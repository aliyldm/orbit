package net.bigpoint.darkorbit.mvc.gui.windows.singularityDrive.handler
{
   import net.bigpoint.darkorbit.com.module.porting.voyagers.VoyagersGateWindowCommand;
   import net.bigpoint.darkorbit.gui.GuiManager;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.windows.singularityDrive.model.SingularityDrivePassProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class SingularityDriveGateWindowCommandHandler extends DOAbstractSimpleCommand
   {
      
      public function SingularityDriveGateWindowCommandHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         GuiManager.instance.tryCreateAndOpen(GuiConstants.SINGULARITYDRIVE_DIFFICULTY_SELECT);
         var _loc2_:VoyagersGateWindowCommand = param1.getBody() as VoyagersGateWindowCommand;
         var _loc3_:SingularityDrivePassProxy = SingularityDrivePassProxy.getProxy();
         _loc3_.viewData.updateGateData(_loc2_);
      }
   }
}

