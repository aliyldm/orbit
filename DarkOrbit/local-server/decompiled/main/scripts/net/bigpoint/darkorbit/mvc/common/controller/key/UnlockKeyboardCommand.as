package net.bigpoint.darkorbit.mvc.common.controller.key
{
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class UnlockKeyboardCommand extends DOAbstractSimpleCommand
   {
      
      public function UnlockKeyboardCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         eventManager.unlockKeyboard();
      }
   }
}

