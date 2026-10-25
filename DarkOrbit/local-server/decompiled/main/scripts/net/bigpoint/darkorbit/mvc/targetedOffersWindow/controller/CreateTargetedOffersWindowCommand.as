package net.bigpoint.darkorbit.mvc.targetedOffersWindow.controller
{
   import net.bigpoint.as3toolbox.filecollection.finish.XMLFinisher;
   import net.bigpoint.darkorbit.com.module.DisplayOfferCommand;
   import net.bigpoint.darkorbit.fui.UISystem;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.common.AssetNotifications;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.targetedOffersWindow.TargetedOfferNotifications;
   import net.bigpoint.darkorbit.mvc.targetedOffersWindow.model.TargetedOfferProxy;
   import net.bigpoint.darkorbit.mvc.targetedOffersWindow.view.TargetedOffer;
   import net.bigpoint.darkorbit.mvc.targetedOffersWindow.view.TargetedOfferWindow;
   import net.bigpoint.darkorbit.mvc.targetedOffersWindow.view.TargetedOfferWindowMediator;
   import net.bigpoint.darkorbit.settings.Settings;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class CreateTargetedOffersWindowCommand extends DOAbstractSimpleCommand
   {
      
      private static const XML_NAME:String = "targetedOffersWindow";
      
      private var _offerCmd:DisplayOfferCommand;
      
      public function CreateTargetedOffersWindowCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         this._offerCmd = param1.getBody() as DisplayOfferCommand;
         if(retrieveProxy(TargetedOfferProxy.NAME))
         {
            return;
         }
         registerProxy(new TargetedOfferProxy(this._offerCmd.packageName,Settings.dynamicHost + this._offerCmd.link,this._offerCmd.lootIds));
         this.loadAndBuildOffer();
      }
      
      private function loadAndBuildOffer() : void
      {
         sendNotification(AssetNotifications.LOAD_ASSET,[XML_NAME,this.handleContentXMLLoaded]);
      }
      
      private function handleContentXMLLoaded(param1:XMLFinisher) : void
      {
         var _loc2_:XML = param1.getXML();
         var _loc3_:TargetedOffer = new TargetedOffer(this._offerCmd.key,this._offerCmd.percentage,this._offerCmd.price);
         UISystem.getInstance().loadAndBuild(_loc2_,_loc3_,this.handleContentCreated,[_loc3_]);
      }
      
      private function handleContentCreated(param1:TargetedOffer) : void
      {
         var _loc2_:uint = uint(this._offerCmd.alignment.alignmentValue);
         var _loc3_:TargetedOfferWindow = new TargetedOfferWindow(guiManager,guiProxy.getFeatureWindowById(this.windowID),param1,_loc2_);
         registerMediator(new TargetedOfferWindowMediator(_loc3_));
         registerCommand(TargetedOfferNotifications.CLEANUP,CleanupTargetedOfferWindow);
         param1.handleWindowContentCreated();
      }
      
      private function get windowID() : String
      {
         return GuiConstants.TARGETED_OFFERS_WINDOW;
      }
   }
}

