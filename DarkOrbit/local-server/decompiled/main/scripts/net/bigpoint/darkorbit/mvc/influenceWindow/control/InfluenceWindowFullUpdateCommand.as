package net.bigpoint.darkorbit.mvc.influenceWindow.control
{
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.influenceWindow.model.InfluenceWindowProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class InfluenceWindowFullUpdateCommand extends DOAbstractSimpleCommand
   {
      
      public function InfluenceWindowFullUpdateCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:InfluenceWindowProxy = retrieveProxy(InfluenceWindowProxy.NAME) as InfluenceWindowProxy;
         _loc2_.updateView();
      }
   }
}

