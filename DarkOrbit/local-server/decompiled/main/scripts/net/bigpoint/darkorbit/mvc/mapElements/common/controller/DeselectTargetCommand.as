package net.bigpoint.darkorbit.mvc.mapElements.common.controller
{
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class DeselectTargetCommand extends DOAbstractSimpleCommand
   {
      
      public function DeselectTargetCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         if(map)
         {
            map.lockManager.target = null;
         }
      }
   }
}

