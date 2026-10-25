package net.bigpoint.darkorbit.mvc.common.controller.key
{
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class LockKeyboardCommand extends DOAbstractSimpleCommand
   {
      
      public function LockKeyboardCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         eventManager.lockKeyboard();
      }
   }
}

