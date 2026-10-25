package net.bigpoint.darkorbit.net.netty.handlers
{
   import net.bigpoint.darkorbit.com.module.UnstableModulesListCommand;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.crafting.reroll.model.RerollProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class UnstableModulesListCommandHandler extends DOAbstractSimpleCommand
   {
      
      public function UnstableModulesListCommandHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:UnstableModulesListCommand = param1.getBody() as UnstableModulesListCommand;
         var _loc3_:RerollProxy = facade.retrieveProxy(RerollProxy.NAME) as RerollProxy;
         if(!_loc3_)
         {
            registerProxy(_loc3_ = new RerollProxy());
         }
         _loc3_.updateInfo(_loc2_);
      }
   }
}

