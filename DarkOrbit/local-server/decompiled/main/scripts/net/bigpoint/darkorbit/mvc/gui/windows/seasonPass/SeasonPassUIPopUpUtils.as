package net.bigpoint.darkorbit.mvc.gui.windows.seasonPass
{
   import flash.display.Bitmap;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.as3toolbox.filecollection.finish.ImageFinisher;
   import net.bigpoint.darkorbit.fui.UISystem;
   import net.bigpoint.darkorbit.fui.components.core.Container;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.components.window.PopupWindow;
   import net.bigpoint.darkorbit.gui.GuiManager;
   import net.bigpoint.darkorbit.gui.container.SimpleContainer;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowCreationVO;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class SeasonPassUIPopUpUtils
   {
      
      private static var _banner:Coreponent;
      
      public function SeasonPassUIPopUpUtils()
      {
         super();
      }
      
      public static function createPopup(param1:String, param2:Function, param3:Function, param4:String, param5:String = "title_error", param6:Function = null) : *
      {
         var _loc7_:GuiManager = GuiManager.instance;
         var _loc8_:SimpleWindow = (_loc7_.getWindow(param1) ? _loc7_.getWindow(param1) : _loc7_.createWindow(param1,new SimpleWindowCreationVO(param1,ScreenManager.getInstance().getWindowLayer2(),SimpleWindow.OPEN_STRATEGY_LAYER_2))) as SimpleWindow;
         var _loc9_:SimpleContainer = _loc8_.getContainer(0);
         _loc9_.removeAllElements();
         var _loc10_:DisplayObjectContainer = new Sprite();
         _loc9_.addElement(_loc10_);
         UISystem.getInstance().tooltipManager.attemptToRemoveTooltip();
         _loc8_.setTitle(param5);
         UISystem.getInstance().loadAndBuildWithResKey(param1,_loc10_,popupCreated,[_loc8_,_loc10_,param2,param3,BPLocale.getItem(param4),param6]);
      }
      
      private static function popupCreated(param1:SimpleWindow, param2:DisplayObjectContainer, param3:Function, param4:Function, param5:String, param6:Function) : void
      {
         param1.maximize();
         param1.autoSize();
         new PopupWindow(param1,param2,param3,param4,param5,param6);
      }
      
      public static function createPopupBanner(param1:String, param2:Function, param3:String = "", param4:String = "", param5:String = "") : *
      {
         var _loc6_:GuiManager = GuiManager.instance;
         var _loc7_:SimpleWindow = (_loc6_.getWindow(param1) ? _loc6_.getWindow(param1) : _loc6_.createWindow(param1,new SimpleWindowCreationVO(param1,ScreenManager.getInstance().getWindowLayer2(),SimpleWindow.OPEN_STRATEGY_LAYER_2))) as SimpleWindow;
         var _loc8_:SimpleContainer = _loc7_.getContainer(0);
         _loc8_.removeAllElements();
         var _loc9_:DisplayObjectContainer = new Sprite();
         _loc8_.addElement(_loc9_);
         UISystem.getInstance().tooltipManager.attemptToRemoveTooltip();
         UISystem.getInstance().loadAndBuildWithResKey(param1,_loc9_,popupBannerCreated,[_loc7_,_loc9_,param2,param3,param4,param5]);
      }
      
      private static function popupBannerCreated(param1:SimpleWindow, param2:DisplayObjectContainer, param3:Function, param4:String, param5:String, param6:String) : void
      {
         var _loc8_:Label = null;
         var _loc9_:Container = null;
         var _loc10_:Label = null;
         param1.maximize();
         param1.autoSize();
         var _loc7_:DisplayObjectContainer = param2.getChildAt(0) as DisplayObjectContainer;
         if(_loc7_)
         {
            loadBanner(_loc7_,param5);
            _loc8_ = _loc7_.getChildByName("seasonTitle") as Label;
            if((Boolean(_loc8_)) && param6.length > 0)
            {
               _loc8_.text = BPLocale.getItem(param6);
            }
            _loc9_ = _loc7_.getChildByName("description") as Container;
            if(_loc9_)
            {
               _loc10_ = _loc9_.getChildByName("label") as Label;
               if(_loc10_)
               {
                  _loc10_.text = param4.length > 0 ? param4 : BPLocale.getItem("window_reward_sp_tab_error-unclaimed-rewards");
               }
            }
         }
         new PopupWindow(param1,param2,param3,null,param4,null);
      }
      
      private static function loadBanner(param1:DisplayObjectContainer, param2:String) : void
      {
         if(!param1 || param2.length == 0)
         {
            return;
         }
         _banner = param1.getChildByName("banner") as Coreponent;
         if(Boolean(_banner) && param2.length > 0)
         {
            _banner.loadResource(param2,handleBannerLoaded,handleBannerLoadError,AssetsProxy.EVENTS);
         }
      }
      
      private static function handleBannerLoaded(param1:ImageFinisher = null) : void
      {
         MovieClipUtils.cleanupDisplayObjectContainer(_banner);
         var _loc2_:* = new Bitmap(param1.getBitmap().bitmapData);
         _loc2_.width = _banner.width;
         _loc2_.height = _banner.height;
         _banner.addChild(_loc2_);
      }
      
      private static function handleBannerLoadError(param1:*) : void
      {
         MovieClipUtils.cleanupDisplayObjectContainer(_banner);
      }
   }
}

