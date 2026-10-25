package net.bigpoint.darkorbit.mvc.gui.windows.armoryUnlock.handler
{
   import net.bigpoint.darkorbit.com.module.porting.armoryunlock.ArmoryUnlockInfoCommand;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class ArmoryUnlockInfoCommandHandler extends DOAbstractSimpleCommand
   {
      
      public function ArmoryUnlockInfoCommandHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:ArmoryUnlockInfoCommand = param1.getBody() as ArmoryUnlockInfoCommand;
         var _loc3_:ArmoryUnlockInfoProxy = facade.retrieveProxy(GuiConstants.ARMORY_UNLOCK) as ArmoryUnlockInfoProxy;
         _loc3_.updateViewData(_loc2_);
      }
   }
}

