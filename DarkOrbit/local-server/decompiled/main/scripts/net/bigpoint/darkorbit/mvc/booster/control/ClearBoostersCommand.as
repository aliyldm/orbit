package net.bigpoint.darkorbit.mvc.booster.control
{
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.booster.model.BoosterProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class ClearBoostersCommand extends DOAbstractSimpleCommand
   {
      
      public function ClearBoostersCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:BoosterProxy = retrieveProxy(BoosterProxy.NAME) as BoosterProxy;
         if(_loc2_)
         {
            _loc2_.cleanup();
         }
      }
   }
}

