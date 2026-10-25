package net.bigpoint.darkorbit.mvc.hintSystem.controller.hintWindow
{
   import net.bigpoint.as3toolbox.filecollection.finish.XMLFinisher;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.hintSystem.HintSystemConstants;
   import net.bigpoint.darkorbit.mvc.hintSystem.view.hintOverviewWindow.HintSystemHintOverviewWindowMediator;
   import net.bigpoint.darkorbit.mvc.hintSystem.view.hintWindow.HintSystemHintWindowMediator;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.AsyncCommand;
   
   public class HintSystemLoadUISkinsStructureAsyncCommand extends AsyncCommand
   {
      
      public function HintSystemLoadUISkinsStructureAsyncCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:AssetsProxy = facade.retrieveProxy(AssetsProxy.NAME) as AssetsProxy;
         _loc2_.load(HintSystemConstants.SKIN_DEFINITIONS_NAME,this.handleXMLLoaded,this.handleXMLLoadError);
      }
      
      protected function handleXMLLoaded(param1:XMLFinisher) : void
      {
         var _loc2_:HintSystemHintWindowMediator = facade.retrieveMediator(HintSystemHintWindowMediator.NAME) as HintSystemHintWindowMediator;
         _loc2_.uiSetupModule.skinsStructure = param1.getXML();
         var _loc3_:HintSystemHintOverviewWindowMediator = facade.retrieveMediator(HintSystemHintOverviewWindowMediator.NAME) as HintSystemHintOverviewWindowMediator;
         _loc3_.uiSetupModule.skinsStructure = param1.getXML();
         commandComplete();
      }
      
      protected function handleXMLLoadError(param1:XMLFinisher) : void
      {
      }
   }
}

