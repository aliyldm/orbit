package net.bigpoint.darkorbit.loadingscreen.mvc.translation.controller
{
   import net.bigpoint.darkorbit.loadingscreen.mvc.translation.model.TranslationProxy;
   import org.puremvc.as3.interfaces.ICommand;
   import org.puremvc.as3.interfaces.INotification;
   import org.puremvc.as3.patterns.command.SimpleCommand;
   
   public class LoadTranslationCommand extends SimpleCommand implements ICommand
   {
      
      public function LoadTranslationCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:TranslationProxy = facade.retrieveProxy(TranslationProxy.PROXY_NAME) as TranslationProxy;
         _loc2_.loadTranslation();
      }
   }
}

