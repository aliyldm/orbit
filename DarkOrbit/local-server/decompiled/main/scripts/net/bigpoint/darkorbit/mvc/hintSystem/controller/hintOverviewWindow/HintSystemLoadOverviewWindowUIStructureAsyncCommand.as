package net.bigpoint.darkorbit.mvc.hintSystem.controller.hintOverviewWindow
{
   import net.bigpoint.as3toolbox.filecollection.finish.XMLFinisher;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.hintSystem.HintSystemConstants;
   import net.bigpoint.darkorbit.mvc.hintSystem.view.hintOverviewWindow.HintSystemHintOverviewWindowMediator;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.AsyncCommand;
   
   public class HintSystemLoadOverviewWindowUIStructureAsyncCommand extends AsyncCommand
   {
      
      public function HintSystemLoadOverviewWindowUIStructureAsyncCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:AssetsProxy = facade.retrieveProxy(AssetsProxy.NAME) as AssetsProxy;
         _loc2_.load(HintSystemConstants.OVERVIEW_WINDOW_NAME,this.handleContentXMLLoaded,this.handleContentXMLLoadError);
      }
      
      protected function handleContentXMLLoaded(param1:XMLFinisher) : void
      {
         var _loc2_:XML = param1.getXML();
         var _loc3_:HintSystemHintOverviewWindowMediator = facade.retrieveMediator(HintSystemHintOverviewWindowMediator.NAME) as HintSystemHintOverviewWindowMediator;
         _loc3_.uiSetupModule.uiStructure = _loc2_;
         commandComplete();
      }
      
      protected function handleContentXMLLoadError(param1:XMLFinisher) : void
      {
      }
   }
}

