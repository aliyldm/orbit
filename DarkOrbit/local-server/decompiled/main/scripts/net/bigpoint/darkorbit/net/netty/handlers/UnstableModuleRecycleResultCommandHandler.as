package net.bigpoint.darkorbit.net.netty.handlers
{
   import net.bigpoint.darkorbit.com.module.UnstableModuleRecycleResultCommand;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.crafting.reroll.model.RerollProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class UnstableModuleRecycleResultCommandHandler extends DOAbstractSimpleCommand
   {
      
      public function UnstableModuleRecycleResultCommandHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:UnstableModuleRecycleResultCommand = param1.getBody() as UnstableModuleRecycleResultCommand;
         var _loc3_:RerollProxy = facade.retrieveProxy(RerollProxy.NAME) as RerollProxy;
         if(!_loc3_)
         {
            registerProxy(_loc3_ = new RerollProxy());
         }
         _loc3_.updateRecycleResult(_loc2_);
      }
   }
}

