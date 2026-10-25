package net.bigpoint.darkorbit.fui.system.utils
{
   import flash.display.Bitmap;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import net.bigpoint.as3toolbox.filecollection.finish.ImageFinisher;
   import net.bigpoint.darkorbit.fui.UISystem;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.components.text.label.LabelSkin;
   import net.bigpoint.darkorbit.fui.components.window.PopupWindow;
   import net.bigpoint.darkorbit.gui.GuiManager;
   import net.bigpoint.darkorbit.gui.container.SimpleContainer;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowCreationVO;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class FuiPopUpUtils
   {
      
      private static var _icon:Coreponent;
      
      private static const guiManager2:GuiManager = GuiManager.instance;
      
      public static const POPUP_ICON_SKIN_SUCCESS:String = "popup_generic_icon_success";
      
      public static const POPUP_ICON_SKIN_ERROR:String = "popup_generic_icon_error";
      
      public static const POPUP_ICON_SKIN_QUESTION:String = "popup_generic_icon_question";
      
      public static const POPUP_FOOTER_OFFSET:int = 24;
      
      public function FuiPopUpUtils()
      {
         super();
      }
      
      public static function createPopupOkCancel(param1:Function, param2:Function, param3:String, param4:Function = null, param5:String = "confirmationPopup") : void
      {
         var _loc6_:SimpleWindow = (guiManager2.getWindow(GuiConstants.CONFIRMATION_POPUP) ? guiManager2.getWindow(GuiConstants.CONFIRMATION_POPUP) : guiManager2.createWindow(GuiConstants.CONFIRMATION_POPUP,new SimpleWindowCreationVO(GuiConstants.CONFIRMATION_POPUP,ScreenManager.getInstance().getWindowLayer2(),SimpleWindow.OPEN_STRATEGY_LAYER_2))) as SimpleWindow;
         var _loc7_:SimpleContainer = _loc6_.getContainer(0);
         var _loc8_:DisplayObjectContainer = new Sprite();
         _loc7_.removeAllElements();
         _loc7_.addElement(_loc8_);
         UISystem.getInstance().loadAndBuildWithResKey(param5,_loc8_,popupCreated,[_loc6_,_loc8_,param1,param2,param3,param4]);
      }
      
      public static function createPopupOk(param1:Function, param2:Function, param3:String) : void
      {
         var _loc4_:SimpleWindow = (guiManager2.getWindow(GuiConstants.CONFIRMATION_POPUP) ? guiManager2.getWindow(GuiConstants.CONFIRMATION_POPUP) : guiManager2.createWindow(GuiConstants.CONFIRMATION_POPUP,new SimpleWindowCreationVO(GuiConstants.CONFIRMATION_POPUP,ScreenManager.getInstance().getWindowLayer2(),SimpleWindow.OPEN_STRATEGY_LAYER_2))) as SimpleWindow;
         var _loc5_:SimpleContainer = _loc4_.getContainer(0);
         var _loc6_:DisplayObjectContainer = new Sprite();
         _loc5_.removeAllElements();
         _loc5_.addElement(_loc6_);
         UISystem.getInstance().loadAndBuildWithResKey("confirmationPopup_ok",_loc6_,popupCreated,[_loc4_,_loc6_,param1,param2,param3]);
      }
      
      public static function createPopup(param1:String, param2:Function, param3:Function, param4:String, param5:String = "title_alert") : *
      {
         var _loc6_:SimpleWindow = (guiManager2.getWindow(param1) ? guiManager2.getWindow(param1) : guiManager2.createWindow(param1,new SimpleWindowCreationVO(param1,ScreenManager.getInstance().getWindowLayer2(),SimpleWindow.OPEN_STRATEGY_LAYER_2))) as SimpleWindow;
         if(_loc6_ == null)
         {
            return;
         }
         var _loc7_:SimpleContainer = _loc6_.getContainer(0);
         if(_loc7_ == null)
         {
            return;
         }
         _loc7_.removeAllElements();
         var _loc8_:DisplayObjectContainer = new Sprite();
         _loc7_.addElement(_loc8_);
         UISystem.getInstance().tooltipManager.attemptToRemoveTooltip();
         _loc6_.setTitle(param5);
         UISystem.getInstance().loadAndBuildWithResKey(param1,_loc8_,popupCreated,[_loc6_,_loc8_,param2,param3,param4]);
      }
      
      private static function popupCreated(param1:SimpleWindow, param2:DisplayObjectContainer, param3:Function, param4:Function, param5:String, param6:Function = null) : void
      {
         param1.maximize();
         param1.autoSize();
         new PopupWindow(param1,param2,param3,param4,param5,param6);
      }
      
      public static function createPopupLoadIcon(param1:String, param2:Function, param3:Function, param4:String, param5:String, param6:String = "ITEMS", param7:String = "title_alert") : *
      {
         var _loc8_:SimpleWindow = (guiManager2.getWindow(param1) ? guiManager2.getWindow(param1) : guiManager2.createWindow(param1,new SimpleWindowCreationVO(param1,ScreenManager.getInstance().getWindowLayer2(),SimpleWindow.OPEN_STRATEGY_LAYER_2))) as SimpleWindow;
         if(_loc8_ == null)
         {
            return;
         }
         var _loc9_:SimpleContainer = _loc8_.getContainer(0);
         if(_loc9_ == null)
         {
            return;
         }
         _loc9_.removeAllElements();
         var _loc10_:DisplayObjectContainer = new Sprite();
         _loc9_.addElement(_loc10_);
         UISystem.getInstance().tooltipManager.attemptToRemoveTooltip();
         _loc8_.setTitle(param7);
         UISystem.getInstance().loadAndBuildWithResKey(param1,_loc10_,popupLoadIconCreated,[_loc8_,_loc10_,param2,param3,param4,param5,param6]);
      }
      
      private static function popupLoadIconCreated(param1:SimpleWindow, param2:DisplayObjectContainer, param3:Function, param4:Function, param5:String, param6:String, param7:String) : void
      {
         param1.maximize();
         param1.autoSize();
         var _loc8_:DisplayObjectContainer = param2.getChildAt(0) as DisplayObjectContainer;
         if(_loc8_ == null || param6 == "" || param7 == "")
         {
            return;
         }
         _icon = _loc8_.getChildByName("icon") as Coreponent;
         if(_icon)
         {
            _icon.loadResource(param6,handleIconLoaded,handleIconLoadError,param7);
         }
         new PopupWindow(param1,param2,param3,param4,param5,null);
      }
      
      private static function handleIconLoaded(param1:ImageFinisher = null) : void
      {
         MovieClipUtils.cleanupDisplayObjectContainer(_icon);
         var _loc2_:* = new Bitmap(param1.getBitmap().bitmapData);
         _loc2_.width = _icon.width;
         _loc2_.height = _icon.height;
         _icon.addChild(_loc2_);
      }
      
      private static function handleIconLoadError(param1:*) : void
      {
         MovieClipUtils.cleanupDisplayObjectContainer(_icon);
      }
      
      public static function createPopupLoadSkin(param1:String, param2:Function, param3:Function, param4:String, param5:String = "", param6:String = "title_alert") : *
      {
         var _loc7_:SimpleWindow = (guiManager2.getWindow(param1) ? guiManager2.getWindow(param1) : guiManager2.createWindow(param1,new SimpleWindowCreationVO(param1,ScreenManager.getInstance().getWindowLayer2(),SimpleWindow.OPEN_STRATEGY_LAYER_2))) as SimpleWindow;
         if(!_loc7_)
         {
            return;
         }
         var _loc8_:SimpleContainer = _loc7_.getContainer(0);
         if(!_loc8_)
         {
            _loc8_ = new SimpleContainer(GuiManager.instance,0);
            _loc8_.x = SimpleWindow.UICONTAINER_X;
            _loc8_.y = SimpleWindow.UICONTAINER_Y;
            _loc7_.addContainer(_loc8_);
         }
         _loc8_.removeAllElements();
         var _loc9_:DisplayObjectContainer = new Sprite();
         _loc8_.addElement(_loc9_);
         UISystem.getInstance().tooltipManager.attemptToRemoveTooltip();
         _loc7_.setTitle(param6);
         UISystem.getInstance().loadAndBuildWithResKey(param1,_loc9_,popupLoadSkinCreated,[_loc7_,_loc9_,param2,param3,param4,param5]);
      }
      
      private static function popupLoadSkinCreated(param1:SimpleWindow, param2:DisplayObjectContainer, param3:Function, param4:Function, param5:String, param6:String) : void
      {
         var handleTextDrawn:Function;
         var contentContainer:DisplayObjectContainer = null;
         var container:DisplayObjectContainer = null;
         var iconHeight:int = 0;
         var label:Label = null;
         var window:SimpleWindow = param1;
         var root:DisplayObjectContainer = param2;
         var handleRestartClientOk:Function = param3;
         var handleRestartClientCancel:Function = param4;
         var text:String = param5;
         var skinName:String = param6;
         window.maximize();
         window.autoSize();
         contentContainer = root.getChildAt(0) as DisplayObjectContainer;
         if(!contentContainer)
         {
            return;
         }
         container = contentContainer.getChildAt(0) as DisplayObjectContainer;
         if(!container)
         {
            return;
         }
         iconHeight = 0;
         _icon = container.getChildByName("icon") as Coreponent;
         if(_icon)
         {
            _icon.registeredSkinName = skinName;
            iconHeight = _icon.height;
         }
         label = container.getChildByName("label") as Label;
         handleTextDrawn = function():void
         {
            var _loc1_:* = 0;
            var _loc2_:LabelSkin = label.skin as LabelSkin;
            if(_loc2_)
            {
               _loc1_ = _loc2_.textField.height;
            }
            var _loc3_:int = iconHeight + _loc1_ + 40;
            var _loc4_:int = 0;
            var _loc5_:Button = container.getChildByName("okButton") as Button;
            if(_loc5_)
            {
               _loc5_.marginTop = _loc3_;
               _loc4_ = _loc5_.height;
            }
            var _loc6_:Button = container.getChildByName("cancelButton") as Button;
            if(_loc6_)
            {
               _loc6_.marginTop = _loc3_;
            }
            _loc3_ += _loc4_;
            window.setHeight(_loc3_ + POPUP_FOOTER_OFFSET);
            contentContainer.height = _loc3_;
            container.height = _loc3_;
         };
         label.addEventListener(Coreponent.EVENT_DRAWN,handleTextDrawn);
         new PopupWindow(window,contentContainer,handleRestartClientOk,handleRestartClientCancel,text,null);
      }
   }
}

