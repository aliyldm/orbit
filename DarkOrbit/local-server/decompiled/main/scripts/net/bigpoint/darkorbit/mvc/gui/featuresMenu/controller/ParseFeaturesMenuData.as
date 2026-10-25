package net.bigpoint.darkorbit.mvc.gui.featuresMenu.controller
{
   import com.bigpoint.utils.PointLite;
   import net.bigpoint.darkorbit.com.module.ItemCommand;
   import net.bigpoint.darkorbit.com.module.UIFeatureBarCommand;
   import net.bigpoint.darkorbit.com.module.UILayoutCommand;
   import net.bigpoint.darkorbit.com.module.WindowItemCommand;
   import net.bigpoint.darkorbit.gui.GuiManager;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.common.utils.ParserUtility;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.common.abstract.model.vo.AbstractMenuBarVO;
   import net.bigpoint.darkorbit.mvc.gui.featuresMenu.FeaturesMenuConstants;
   import net.bigpoint.darkorbit.mvc.gui.featuresMenu.FeaturesMenuNotifications;
   import net.bigpoint.darkorbit.mvc.gui.featuresMenu.model.FeaturesMenuProxy;
   import net.bigpoint.darkorbit.mvc.gui.featuresMenu.model.vo.FeatureBarVO;
   import net.bigpoint.darkorbit.mvc.gui.featuresMenu.model.vo.FeatureItemVO;
   import net.bigpoint.darkorbit.mvc.gui.featuresMenu.model.vo.FeatureWindowVO;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.interfaces.IWindow;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class ParseFeaturesMenuData extends DOAbstractSimpleCommand
   {
      
      private static var UNITY_CLIENT_EVENT_UNITY_CLIENT_REWARD:String = "unity_client_reward";
      
      private static var UNITY_CLIENT_EVENT_A_NEW_HOPE:String = "a_new_hope";
      
      private static var UNITY_CLIENT_EVENT_RETURN_OF_HERO:String = "return_of_hero";
      
      private static var UNITY_CLIENT_EVENT_EXPEDITION:String = "expedition";
      
      private static var UNITY_CLIENT_ASSISTANT:String = "assistant";
      
      private static var UNITY_STELLAR_PATH_FINDER:String = "stellar_pathfinder";
      
      private static const UNSUPPORTED_FEATURE:Array = [UNITY_CLIENT_EVENT_UNITY_CLIENT_REWARD,UNITY_CLIENT_EVENT_A_NEW_HOPE,UNITY_CLIENT_EVENT_RETURN_OF_HERO,UNITY_CLIENT_ASSISTANT,UNITY_STELLAR_PATH_FINDER];
      
      public function ParseFeaturesMenuData()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         this.parseData(param1.getBody() as UILayoutCommand);
      }
      
      private function parseData(param1:UILayoutCommand) : void
      {
         var _loc2_:UIFeatureBarCommand = null;
         this.menuProxy.menuBars = new Vector.<AbstractMenuBarVO>();
         for each(_loc2_ in param1.featureBars)
         {
            this.menuProxy.menuBars.push(this.parseFeatureBar(_loc2_));
         }
         sendNotification(FeaturesMenuNotifications.DATA_READY);
         sendNotification(FeaturesMenuNotifications.CHECK_BOUNDS_AND_SAVE_POS);
      }
      
      private function parseFeatureBar(param1:UIFeatureBarCommand) : FeatureBarVO
      {
         var _loc7_:ItemCommand = null;
         var _loc8_:FeatureWindowVO = null;
         var _loc9_:FeatureItemVO = null;
         var _loc2_:Vector.<FeatureItemVO> = new Vector.<FeatureItemVO>();
         var _loc3_:int = int(param1.featureBarItems.length);
         var _loc4_:String = FeaturesMenuConstants.MENUS_ID_MAP[param1.featureBarType];
         var _loc5_:int = 0;
         while(_loc5_ != _loc3_)
         {
            _loc7_ = param1.featureBarItems[_loc5_] as ItemCommand;
            if(UNSUPPORTED_FEATURE.indexOf(_loc7_.itemId) < 0)
            {
               _loc8_ = this.getFeatureWindow(_loc7_);
               _loc9_ = new FeatureItemVO(_loc7_.itemId,_loc4_,_loc7_.visible,_loc7_.toolTip,_loc8_);
               _loc2_.push(_loc9_);
               if(Boolean(_loc9_.id) && _loc7_.visible)
               {
                  sendNotification(GuiNotifications.FEATURE_INIT,_loc9_.id);
               }
               this.updateWindowVisibility(_loc9_);
               if(_loc8_)
               {
                  if(_loc9_.visible && _loc8_.maximized)
                  {
                     guiProxy.addVisibleWindow(_loc8_);
                  }
                  else if(!_loc9_.visible || !_loc8_.maximized)
                  {
                     guiProxy.removeVisibleWindow(_loc8_);
                  }
               }
            }
            _loc5_++;
         }
         var _loc6_:PointLite = ParserUtility.parseStringCords(param1.featureBarPosition)[0];
         return new FeatureBarVO(_loc4_,GuiConstants.LAYOUTS_MAP[int(param1.featureBarOrder)],_loc6_,_loc2_);
      }
      
      private function getFeatureWindow(param1:ItemCommand) : FeatureWindowVO
      {
         var _loc4_:SimpleWindow = null;
         var _loc2_:FeatureWindowVO = guiProxy.getFeatureWindowById(param1.itemId);
         var _loc3_:WindowItemCommand = param1 as WindowItemCommand;
         if(Boolean(_loc3_) && Boolean(_loc2_))
         {
            _loc2_.update(new PointLite(_loc3_.posX,_loc3_.posY),new PointLite(_loc3_.width,_loc3_.height),_loc3_.maximized,_loc3_.windowTitle,_loc3_.helpText,_loc3_.toolTip);
            _loc4_ = GuiManager.instance.getWindow(_loc3_.itemId);
            if(_loc4_)
            {
               _loc4_.assignValuesFromFeatureWindowVO(_loc2_);
            }
            _loc2_.saveSettingsOnServer = true;
         }
         return _loc2_;
      }
      
      private function updateWindowVisibility(param1:FeatureItemVO) : void
      {
         var _loc4_:Boolean = false;
         var _loc2_:IWindow = guiManager.windows[param1.id] as IWindow;
         var _loc3_:FeatureWindowVO = param1.featureWindowVO;
         if(_loc3_)
         {
            if(_loc2_)
            {
               _loc4_ = (!param1.visible || !param1.featureWindowVO.maximized) && _loc2_.maximized;
               if(_loc4_)
               {
                  _loc2_.minimize(false,true);
               }
               else if(param1.visible && param1.featureWindowVO.maximized && !_loc2_.maximized)
               {
                  _loc2_.maximize(false);
               }
            }
         }
      }
      
      private function get menuProxy() : FeaturesMenuProxy
      {
         return facade.retrieveProxy(FeaturesMenuProxy.NAME) as FeaturesMenuProxy;
      }
   }
}

