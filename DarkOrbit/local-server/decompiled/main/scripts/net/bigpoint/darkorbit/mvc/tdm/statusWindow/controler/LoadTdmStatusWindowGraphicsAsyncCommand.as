package net.bigpoint.darkorbit.mvc.tdm.statusWindow.controler
{
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.AsyncCommand;
   
   public class LoadTdmStatusWindowGraphicsAsyncCommand extends AsyncCommand
   {
      
      public function LoadTdmStatusWindowGraphicsAsyncCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         commandComplete();
      }
   }
}

