package net.bigpoint.darkorbit.loadingscreen.mvc.assets.controller
{
   import net.bigpoint.darkorbit.loadingscreen.mvc.assets.model.AssetsProxy;
   import org.puremvc.as3.interfaces.ICommand;
   import org.puremvc.as3.interfaces.INotification;
   import org.puremvc.as3.patterns.command.SimpleCommand;
   
   public class InitAssetsCommand extends SimpleCommand implements ICommand
   {
      
      public function InitAssetsCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:AssetsProxy = facade.retrieveProxy(AssetsProxy.PROXY_NAME) as AssetsProxy;
         _loc2_.init();
      }
   }
}

