package net.bigpoint.darkorbit.mvc.gui.featuresMenu.controller.logic
{
   import flash.geom.Point;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.com.module.UIButtonTriggerRequest;
   import net.bigpoint.darkorbit.com.module.porting.trinitytrials.TrinityTrialsUIRequest;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowCreationVO;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.commandCenter.constants.CommandCenterNotifications;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.featuresMenu.FeaturesMenuConstants;
   import net.bigpoint.darkorbit.mvc.gui.featuresMenu.FeaturesMenuNotifications;
   import net.bigpoint.darkorbit.mvc.gui.featuresMenu.model.FeaturesMenuProxy;
   import net.bigpoint.darkorbit.mvc.gui.featuresMenu.model.vo.FeatureItemVO;
   import net.bigpoint.darkorbit.mvc.gui.featuresMenu.view.components.FeatureBtn;
   import net.bigpoint.darkorbit.mvc.gui.windows.SimpleWindowCreationMap;
   import net.bigpoint.darkorbit.mvc.gui.windows.birthdaygate2025.model.BirthdayGate2025Constants;
   import net.bigpoint.darkorbit.mvc.gui.windows.birthdaygate2025.model.BirthdayGate2025Proxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.interfaces.IWindow;
   import net.bigpoint.darkorbit.mvc.gui.windows.expedition.model.ExpeditionInfoProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.singularityDrive.model.SingularityDrivePassProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.synthesis.model.CannonSynthesisProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.synthesis.model.SynthesisConst;
   import net.bigpoint.darkorbit.mvc.gui.windows.trinityTrials.model.TrinityTrialsConst;
   import net.bigpoint.darkorbit.mvc.gui.windows.trinityTrials.model.TrinityTrialsMainProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.warpControls.mode.WarpControlsProxy;
   import net.bigpoint.darkorbit.net.JavascriptProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class FeatureMenuActionCommand extends DOAbstractSimpleCommand
   {
      
      public function FeatureMenuActionCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc7_:SimpleWindowCreationVO = null;
         var _loc8_:Boolean = false;
         var _loc2_:FeatureBtn = param1.getBody() as FeatureBtn;
         var _loc3_:String = param1.getType();
         var _loc4_:FeatureItemVO = this.featuresMenuProxy.getFeatureItemVOById(_loc3_);
         var _loc5_:IWindow = guiManager.getWindow(_loc4_.id);
         if(!_loc5_)
         {
            _loc7_ = SimpleWindowCreationMap.getById(_loc4_.id);
            if(_loc7_)
            {
               facade.sendNotification(GuiNotifications.CREATE_SIMPLE_WINDOW,_loc7_);
               _loc5_ = guiManager.getWindow(_loc4_.id);
            }
            else
            {
               _loc5_ = guiManager.createWindow(_loc4_.id);
            }
            _loc8_ = true;
         }
         var _loc6_:Point = _loc2_.localToGlobal(new Point(0,0));
         this.actionRequest(_loc3_);
         if(_loc4_.barId == FeaturesMenuConstants.GAME_FEATURE_BAR)
         {
            if(Boolean(_loc5_) && Boolean(_loc4_.featureWindowVO))
            {
               sendNotification(GuiNotifications.TOGGLE_WINDOW_BY_ID,new ToggleWindowVO(_loc6_,_loc3_,_loc8_));
            }
            else
            {
               sendNotification(GuiNotifications.CREATE_SIMPLE_WINDOW,_loc7_);
               sendNotification(GuiNotifications.TOGGLE_WINDOW_BY_ID,new ToggleWindowVO(_loc6_,_loc3_,_loc8_));
            }
            this.sendButtonTriggerRequest(_loc4_.id);
         }
         else if(_loc4_.barId == FeaturesMenuConstants.GENERIC_FEATURE_BAR)
         {
            this.runGenericAction(_loc4_,_loc5_,_loc6_,_loc2_,_loc8_);
            this.actionRequest(_loc3_);
         }
         else if(_loc4_.barId == FeaturesMenuConstants.GAME_NEW_FEATURE_BAR)
         {
            this.runGenericActionNewGame(_loc4_,_loc5_,_loc6_,_loc2_,_loc8_);
            this.actionRequest(_loc3_);
         }
         sendNotification(FeaturesMenuNotifications.UPDATE_BTNS_SELECTIONS);
      }
      
      private function runGenericAction(param1:FeatureItemVO, param2:IWindow, param3:Point, param4:FeatureBtn, param5:Boolean = false) : void
      {
         switch(param1.id)
         {
            case FeaturesMenuConstants.LOGOUT:
               if(param2.maximized)
               {
                  guiManager.cancelLogout();
               }
               else
               {
                  screenManager.eventManager.stopHero();
                  this.sendButtonTriggerRequest(param1.id);
               }
               sendNotification(GuiNotifications.TOGGLE_WINDOW_BY_ID,new ToggleWindowVO(param3,param1.id,false));
               break;
            case FeaturesMenuConstants.FULLSCREEN:
               screenManager.fullscreenToggle();
               break;
            case FeaturesMenuConstants.SHOP:
               this.sendButtonTriggerRequest(param1.id);
               sendNotification(CommandCenterNotifications.TRIGGER_SHOP_ACTION);
               break;
            case BirthdayGate2025Constants.BIRTHDAY_2025:
               sendNotification(GuiNotifications.TOGGLE_WINDOW_BY_ID,new ToggleWindowVO(param3,param1.id,param5));
               break;
            default:
               sendNotification(GuiNotifications.TOGGLE_WINDOW_BY_ID,new ToggleWindowVO(param3,param1.id,false));
         }
      }
      
      private function runGenericActionNewGame(param1:FeatureItemVO, param2:IWindow, param3:Point, param4:FeatureBtn, param5:Boolean = false) : void
      {
         this.sendButtonTriggerRequest(param1.id);
         switch(param1.id)
         {
            case FeaturesMenuConstants.NEWSHOP:
               sendNotification(CommandCenterNotifications.TRIGGER_SHOP_ACTION);
               break;
            case FeaturesMenuConstants.HANGAR:
               JavascriptProxy.referToURL("internalDock",null);
               break;
            case FeaturesMenuConstants.CLAN:
               if(Hero.isInClan)
               {
                  JavascriptProxy.referToURL("internalClan",null);
               }
               else
               {
                  JavascriptProxy.referToURL("internalNewClan",null);
               }
               break;
            case FeaturesMenuConstants.VOUCHERS:
               JavascriptProxy.referToURL("internalEvoucher",null);
               break;
            case FeaturesMenuConstants.SKYLAB:
               JavascriptProxy.referToURL("internalSkylab",null);
               break;
            case FeaturesMenuConstants.PILOTSHEET:
               JavascriptProxy.referToURL("internalPilotSheet",null);
               break;
            case FeaturesMenuConstants.AUCTION:
               JavascriptProxy.referToURL("internalAuction",null);
               break;
            case FeaturesMenuConstants.NOVA:
               JavascriptProxy.referToURL("internalCaptain",null);
               break;
            case FeaturesMenuConstants.MESSAGE:
               JavascriptProxy.referToURL("internalMessaging",null);
               break;
            case FeaturesMenuConstants.LOGBOOK:
               JavascriptProxy.referToURL("internalHistory",null);
               break;
            default:
               sendNotification(GuiNotifications.TOGGLE_WINDOW_BY_ID,new ToggleWindowVO(param3,param1.id,param5));
         }
      }
      
      private function sendButtonTriggerRequest(param1:String) : void
      {
         var _loc2_:UIButtonTriggerRequest = new UIButtonTriggerRequest(param1);
         connectionProxy.connectionManager.sendRequest(_loc2_);
      }
      
      private function get featuresMenuProxy() : FeaturesMenuProxy
      {
         return retrieveProxy(FeaturesMenuProxy.NAME) as FeaturesMenuProxy;
      }
      
      private function actionRequest(param1:String) : void
      {
         switch(param1)
         {
            case GuiConstants.WARP_CONTROLS:
               WarpControlsProxy.getProxy(this.facade).sendListRequest();
               break;
            case BirthdayGate2025Constants.BIRTHDAY_2025:
               BirthdayGate2025Proxy.getProxy(this.facade).sendViewInitRequest();
               break;
            case SynthesisConst.SYNTHESIS:
               CannonSynthesisProxy.getProxy(GameFacade.getInstance()).sendInitInventoryRequest();
               break;
            case GuiConstants.EXPEDITION_REWARD:
               ExpeditionInfoProxy.getProxy(this.facade).sendExpeditionInfoRequest();
               break;
            case TrinityTrialsConst.MAIN_VIEW:
               TrinityTrialsMainProxy.getProxy().sendUIRequest(TrinityTrialsUIRequest.OPTIONALTYPE_INIT);
               break;
            case GuiConstants.SINGULARITYDRIVE_PASS:
               SingularityDrivePassProxy.getProxy().sendUIRequest();
         }
      }
   }
}

