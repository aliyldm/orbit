package net.bigpoint.darkorbit.mvc.gui.common.model
{
   import net.bigpoint.darkorbit.gui.BarState;
   import net.bigpoint.darkorbit.gui.BarStatesCollection;
   import net.bigpoint.darkorbit.gui.GuiManager;
   import net.bigpoint.darkorbit.gui.container.SimpleContainer;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.common.abstract.model.DOAbstractProxy;
   import net.bigpoint.darkorbit.mvc.gui.featuresMenu.FeaturesMenuNotifications;
   import net.bigpoint.darkorbit.mvc.gui.featuresMenu.model.vo.FeatureWindowVO;
   
   public class GuiProxy extends DOAbstractProxy
   {
      
      public static const NAME:String = "GuiProxy";
      
      private var _guiManager:GuiManager;
      
      private var _featureWindows:Vector.<FeatureWindowVO>;
      
      private var _visibleWindows:Vector.<FeatureWindowVO>;
      
      private const _openWindows:Vector.<String> = new Vector.<String>(0);
      
      public function GuiProxy()
      {
         super(NAME);
      }
      
      override public function onRegister() : void
      {
         this._featureWindows = new Vector.<FeatureWindowVO>();
         this._visibleWindows = new Vector.<FeatureWindowVO>();
         sendNotification(GuiNotifications.PARSE_WINDOWS_XML_DATA);
      }
      
      public function getWindowById(param1:String) : SimpleWindow
      {
         return this._guiManager.getWindow(param1);
      }
      
      public function set guiManager(param1:GuiManager) : void
      {
         this._guiManager = param1;
      }
      
      public function getFeatureWindowById(param1:String) : FeatureWindowVO
      {
         var _loc2_:int = int(this._featureWindows.length);
         var _loc3_:int = 0;
         while(_loc3_ != _loc2_)
         {
            if(this._featureWindows[_loc3_].id == param1)
            {
               return this._featureWindows[_loc3_];
            }
            _loc3_++;
         }
         return null;
      }
      
      public function getVisibleFeatureWindowById(param1:String) : FeatureWindowVO
      {
         var _loc2_:int = int(this._visibleWindows.length);
         var _loc3_:int = 0;
         while(_loc3_ != _loc2_)
         {
            if(this._visibleWindows[_loc3_].id == param1)
            {
               return this._visibleWindows[_loc3_];
            }
            _loc3_++;
         }
         return null;
      }
      
      public function addVisibleWindow(param1:FeatureWindowVO) : void
      {
         if(this.visibleWindows.indexOf(param1) == -1)
         {
            this.visibleWindows.push(param1);
         }
      }
      
      public function removeVisibleWindow(param1:FeatureWindowVO) : void
      {
         var _loc2_:int = this.visibleWindows.indexOf(param1);
         if(_loc2_ != -1)
         {
            this.visibleWindows.splice(_loc2_,1);
         }
      }
      
      public function toggleVisibilityWindows() : void
      {
         var _loc1_:Vector.<FeatureWindowVO> = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:FeatureWindowVO = null;
         var _loc5_:String = null;
         if(this.visibleWindows.length != 0)
         {
            this._openWindows.length = 0;
            _loc1_ = this.visibleWindows;
            _loc2_ = int(_loc1_.length);
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               _loc4_ = _loc1_[_loc3_];
               this._openWindows.push(_loc4_.id);
               sendNotification(GuiNotifications.MINIMIZE_WINDOW_BY_ID,_loc4_.id);
               _loc3_++;
            }
         }
         else
         {
            _loc2_ = int(this._openWindows.length);
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               _loc5_ = this._openWindows[_loc3_];
               GuiManager.instance.getWindow(_loc5_).maximize();
               _loc3_++;
            }
            this._openWindows.length = 0;
         }
         sendNotification(FeaturesMenuNotifications.UPDATE_BTNS_SELECTIONS);
      }
      
      public function get featureWindows() : Vector.<FeatureWindowVO>
      {
         return this._featureWindows;
      }
      
      public function set featureWindows(param1:Vector.<FeatureWindowVO>) : void
      {
         this._featureWindows = param1;
      }
      
      public function get visibleWindows() : Vector.<FeatureWindowVO>
      {
         return this._visibleWindows;
      }
      
      public function set visibleWindows(param1:Vector.<FeatureWindowVO>) : void
      {
         this._visibleWindows = param1;
      }
      
      public function getBarStatesAsString() : String
      {
         return BarStatesCollection.getBarStatesAsString();
      }
      
      public function setBarStatesFromString(param1:String) : void
      {
         var _loc2_:String = null;
         var _loc3_:Array = null;
         var _loc4_:BarState = null;
         var _loc5_:BarState = null;
         while(param1.indexOf("|") != -1)
         {
            _loc2_ = param1.substring(0,param1.indexOf("|"));
            param1 = param1.substring(param1.indexOf("|") + 1);
            _loc3_ = _loc2_.split(",");
            if(_loc3_.length >= 2)
            {
               _loc4_ = BarStatesCollection.getBarState(_loc3_[0]);
               if(_loc4_ != null)
               {
                  _loc4_.stateID = _loc3_[1];
               }
               else
               {
                  _loc5_ = new BarState(_loc3_[0],_loc3_[1]);
                  BarStatesCollection.addBarState(_loc5_);
               }
               this._guiManager.updateInfoField(GuiConstants.SHIP_WINDOW,SimpleContainer.CONTAINER_CLASS_HERO_INFO_0,_loc3_[0]);
               this._guiManager.updateInfoField(GuiConstants.SHIP_WINDOW,SimpleContainer.CONTAINER_CLASS_HERO_INFO_1,_loc3_[0]);
            }
         }
      }
   }
}

