package net.bigpoint.darkorbit.mvc.common.controller.assets.init
{
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractAsyncCommand;
   import net.bigpoint.darkorbit.mvc.common.model.assets.UberAssetsLib;
   import org.puremvc.as3.multicore.interfaces.ICommand;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class InitUberLibraryCommand extends DOAbstractAsyncCommand implements ICommand
   {
      
      public function InitUberLibraryCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         UberAssetsLib.instance.init(commandComplete);
      }
   }
}

