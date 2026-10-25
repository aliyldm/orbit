package net.bigpoint.darkorbit.net
{
   import flash.display.StageDisplayState;
   import flash.external.ExternalInterface;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.common.JavaScriptCallNotification;
   import net.bigpoint.darkorbit.mvc.common.view.ScreenNotifications;
   
   public class JavascriptProxy
   {
      
      public static const FUNCTION_SHOP_EXTRA:String = "redirectToExtra";
      
      public static const FUNCTION_CLIENT_ERROR:String = "clientError";
      
      public static const FUNCTION_CLIENT_EVENT:String = "clientEvent";
      
      public static const FUNCTION_SHOW_PET_FUEL:String = "showPetFuel";
      
      public static const FUNCTION_REFER_TO_URL:String = "InternalMapRevolution.referToURL";
      
      public static const FUNCTION_REFER_OPENER_TO_URL:String = "InternalMapRevolution.referOpenerToUrl";
      
      public static const FUNCTION_BP_CLOSE_WINDOW:String = "bpCloseWindow";
      
      public static const FUNCTION_ON_TECH_EXPIRED:String = "onTechExpired";
      
      public static const FUNCTION_CLIENT_RESOLUTION_CHANGE:String = "clientResolutionChanged";
      
      public static const FUNCTION_CLOSE_CHILD_WINDOW:String = "InternalMapRevolution.closeChildWindow";
      
      public static const FUNCTION_SHOW_HANGAR:String = "showHangar";
      
      public static const FUNCTION_PAYMENT:String = "openPayment";
      
      public static const FUNCTION_DO_REDIRECT:String = "do_redirect";
      
      public static const FUNCTION_RELOAD:String = "document.location.reload";
      
      public static const FUNCTION_REFER_TO_EXTERNAL_URL_IN_NEW_WINDOW:String = "referToExternalURLInNewWindow";
      
      public static const FUNCTION_OPEN_PAYMENT_POPUP:String = "openPaymentFromExternal";
      
      public static const FUNCTION_OPEN_PAYMENT_POPUP_WITH_LINK:String = "openPaymentLinkFromExternal";
      
      public static const FUNCTION_IS_PEPPER_PLAYER:String = "InternalMapRevolution.detectPepper";
      
      public static const TRADE_POSSIBLE:String = "tradePossible";
      
      public static const TRADE_NOT_POSSIBLE:String = "tradeNotPossible";
      
      public static const QUEST_ACCOMPLISHED:String = "questCompleteFinished";
      
      public static const JUMP_POSSIBLE:String = "jumpPossible";
      
      public static const JUMP_NOT_POSSIBLE:String = "jumpNotPossible";
      
      public static const USER_LOW_HP:String = "userLowHP";
      
      public static const USER_LEVEL_UP:String = "userLevelUp";
      
      public static const CARGO_FULL:String = "cargoFull";
      
      public static const LASER_AMMO_EMPTY:String = "laserAmmoEmpty";
      
      public static const ROCKETS_EMPTY:String = "rocketsEmpty";
      
      public static const ACHIEVEMENT:String = "ACHIEVEMENT";
      
      public static const SPECIALOFFER:String = "SPECIALOFFER";
      
      public static const INTERNAL_DOCK:String = "internalDock";
      
      public static const DATA_LAYER_PUSH:String = "dataLayer.push";
      
      public static const INTERNAL_DOCK_TEMPLATE__EQUIPMENT:String = "internalDockEquipment";
      
      public function JavascriptProxy()
      {
         super();
      }
      
      public static function call(param1:String, param2:Array, param3:Function = null, param4:Array = null) : void
      {
         if(!ExternalInterface.available)
         {
            if(param3 != null)
            {
               param3(param4[0]);
            }
            return;
         }
         switch(param1)
         {
            case FUNCTION_REFER_TO_URL:
            case FUNCTION_PAYMENT:
            case FUNCTION_REFER_OPENER_TO_URL:
               GameFacade.getInstance().sendNotification(JavaScriptCallNotification.ADD_DELAYED_CALLBACK,param2,param1);
               GameFacade.getInstance().sendNotification(ScreenNotifications.FULLSCREEN_CHANGE);
               break;
            default:
               switch(param2.length)
               {
                  case 0:
                     ExternalInterface.call(param1);
                     break;
                  case 1:
                     ExternalInterface.call(param1,param2[0]);
                     break;
                  case 2:
                     ExternalInterface.call(param1,param2[0],param2[1]);
                     break;
                  case 3:
                     ExternalInterface.call(param1,param2[0],param2[1],param2[2]);
               }
         }
      }
      
      public static function referToURL(param1:String, param2:String, param3:String = null, param4:Boolean = true, param5:String = null, param6:Function = null, param7:Array = null, param8:Boolean = true, param9:String = "") : void
      {
         var _loc10_:ScreenManager = ScreenManager.getInstance();
         if(Boolean(param4) && Boolean(_loc10_.stage) && _loc10_.stage.displayState == StageDisplayState.FULL_SCREEN_INTERACTIVE)
         {
            _loc10_.fullscreenToggle();
         }
         if(!ExternalInterface.available)
         {
            if(param6 != null)
            {
               param6(param7[0]);
            }
            return;
         }
         ExternalInterface.call(FUNCTION_REFER_TO_URL,param1,param2,param3,param4,param5,param9,param8);
      }
      
      public static function referToURLviaVO(param1:JavascriptCallVO) : void
      {
         referToURL(param1.action,param1.textKey,param1.template,param1.focus,param1.category,param1.jsUnavailableCallback,param1.jsUnavailableCallBackParams,param1.openPage,param1.lootID);
      }
   }
}

