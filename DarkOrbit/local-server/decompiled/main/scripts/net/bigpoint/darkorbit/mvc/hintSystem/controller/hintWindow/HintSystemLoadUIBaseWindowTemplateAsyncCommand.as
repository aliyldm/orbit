package net.bigpoint.darkorbit.mvc.hintSystem.controller.hintWindow
{
   import net.bigpoint.as3toolbox.filecollection.finish.XMLFinisher;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.hintSystem.HintSystemConstants;
   import net.bigpoint.darkorbit.mvc.hintSystem.view.hintWindow.HintSystemHintWindowMediator;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.AsyncCommand;
   
   public class HintSystemLoadUIBaseWindowTemplateAsyncCommand extends AsyncCommand
   {
      
      public function HintSystemLoadUIBaseWindowTemplateAsyncCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:AssetsProxy = facade.retrieveProxy(AssetsProxy.NAME) as AssetsProxy;
         _loc2_.load(HintSystemConstants.BASE_WINDOW_TEMPLATE_NAME,this.handleBaseWindowXMLLoaded,this.handlebaseWindowXMLLoadError);
      }
      
      protected function handleBaseWindowXMLLoaded(param1:XMLFinisher) : void
      {
         var _loc2_:HintSystemHintWindowMediator = facade.retrieveMediator(HintSystemHintWindowMediator.NAME) as HintSystemHintWindowMediator;
         _loc2_.uiSetupModule.templatesStructure = param1.getXML();
         commandComplete();
      }
      
      protected function handlebaseWindowXMLLoadError(param1:XMLFinisher) : void
      {
      }
   }
}

