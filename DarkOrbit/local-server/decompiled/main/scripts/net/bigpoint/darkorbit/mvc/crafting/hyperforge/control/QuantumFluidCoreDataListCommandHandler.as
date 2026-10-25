package net.bigpoint.darkorbit.mvc.crafting.hyperforge.control
{
   import net.bigpoint.darkorbit.com.module.QuantumFluidCoreDataListCommand;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.crafting.hyperforge.model.HyperforgeProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class QuantumFluidCoreDataListCommandHandler extends DOAbstractSimpleCommand
   {
      
      public function QuantumFluidCoreDataListCommandHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:QuantumFluidCoreDataListCommand = param1.getBody() as QuantumFluidCoreDataListCommand;
         var _loc3_:HyperforgeProxy = GameFacade.getInstance().retrieveProxy(HyperforgeProxy.NAME) as HyperforgeProxy;
         if(!_loc3_)
         {
            registerProxy(new HyperforgeProxy());
            _loc3_ = GameFacade.getInstance().retrieveProxy(HyperforgeProxy.NAME) as HyperforgeProxy;
         }
         _loc3_.setHyperforgeData(_loc2_);
      }
   }
}

