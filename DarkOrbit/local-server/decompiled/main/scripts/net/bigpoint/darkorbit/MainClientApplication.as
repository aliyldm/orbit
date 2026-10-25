package net.bigpoint.darkorbit
{
   import flash.accessibility.*;
   import flash.debugger.*;
   import flash.display.*;
   import flash.errors.*;
   import flash.events.*;
   import flash.external.*;
   import flash.geom.*;
   import flash.media.*;
   import flash.net.*;
   import flash.printing.*;
   import flash.profiler.*;
   import flash.system.*;
   import flash.text.*;
   import flash.ui.*;
   import flash.utils.*;
   import flash.xml.*;
   import mx.binding.*;
   import mx.core.DeferredInstanceFromFunction;
   import mx.core.IFlexModuleFactory;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.filters.*;
   import mx.styles.*;
   import net.bigpoint.as3toolbox.guicomponents.skins.Scale9GridImageButtonSkin;
   import net.bigpoint.as3toolbox.guicomponents.skins.Scale9GridImageSkin;
   import net.bigpoint.darkorbit.mvc.common.view.skins.DOButtonSkinWithColoredText;
   import net.bigpoint.darkorbit.mvc.common.view.skins.DOCustomImageBgContainerSkin;
   import net.bigpoint.darkorbit.mvc.common.view.skins.DOCustomScaleBgContainerSkin;
   import net.bigpoint.darkorbit.mvc.common.view.skins.DODownGradListSkin;
   import net.bigpoint.darkorbit.mvc.common.view.skins.DODownGradWindowSkin;
   import net.bigpoint.darkorbit.mvc.common.view.skins.DOListSkin;
   import net.bigpoint.darkorbit.mvc.common.view.skins.DOSkinnable9ScaleContainerSkin;
   import net.bigpoint.darkorbit.mvc.common.view.skins.DOToolTipBorderSkin;
   import net.bigpoint.darkorbit.mvc.common.view.skins.DOWindowSkin;
   import net.bigpoint.darkorbit.mvc.common.view.skins.scroller.DOScrollerSkin;
   import net.bigpoint.darkorbit.mvc.common.view.skins.scroller.DOScrollerSkinWithoutBorder;
   import net.bigpoint.darkorbit.mvc.common.view.skins.scroller.hScroll.DOHScrollBarSkin;
   import net.bigpoint.darkorbit.mvc.common.view.skins.scroller.hScroll.DOHScrollBarThumbSkin;
   import net.bigpoint.darkorbit.mvc.common.view.skins.scroller.hScroll.DOHScrollBarTrackSkin;
   import net.bigpoint.darkorbit.mvc.common.view.skins.scroller.hScroll.DOHScrollDownButtonSkin;
   import net.bigpoint.darkorbit.mvc.common.view.skins.scroller.hScroll.DOHScrollUpButtonSkin;
   import net.bigpoint.darkorbit.mvc.common.view.skins.scroller.vScroll.DOVScrollBarSkin;
   import net.bigpoint.darkorbit.mvc.common.view.skins.scroller.vScroll.DOVScrollBarThumbSkin;
   import net.bigpoint.darkorbit.mvc.common.view.skins.scroller.vScroll.DOVScrollBarTrackSkin;
   import net.bigpoint.darkorbit.mvc.common.view.skins.scroller.vScroll.DOVScrollDownButtonSkin;
   import net.bigpoint.darkorbit.mvc.common.view.skins.scroller.vScroll.DOVScrollUpButtonSkin;
   import net.bigpoint.darkorbit.mvc.jackpotBattle.resultWin.view.skin.JackpotWindowItemListSkin;
   import net.bigpoint.darkorbit.mvc.questWindow.view.challengesSection.skins.HighscoreTableSkin;
   import net.bigpoint.darkorbit.mvc.tdm.lobbyWindow.view.skins.TeamDeathMatchLobbyWindowMatchoverviewSkin;
   import net.bigpoint.darkorbit.mvc.tdm.matchresultWindow.view.window.components.TDMRewardIconSkin;
   import net.bigpoint.darkorbit.mvc.tdm.matchresultWindow.view.window.components.TDMSkinnableContainerOuterSkin;
   import net.bigpoint.darkorbit.mvc.tdm.matchresultWindow.view.window.components.tooltip.DOToolTipListSkinTDM;
   import net.bigpoint.darkorbit.settings.Settings;
   import spark.components.Application;
   import spark.components.SkinnableContainer;
   
   use namespace mx_internal;
   
   public class MainClientApplication extends Application
   {
      
      private static var _skinParts:Object = {
         "controlBarGroup":false,
         "contentGroup":false
      };
      
      private var _3343801main:Main;
      
      private var _1659371121windowContainer:SkinnableContainer;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      mx_internal var _MainClientApplication_StylesInit_done:Boolean = false;
      
      private var _embed__font_EurostileT_medium_normal_1074410548:Class = MainClientApplication__embed__font_EurostileT_medium_normal_1074410548;
      
      private var _embed__font_EurostileTHea_medium_normal_1991873928:Class = MainClientApplication__embed__font_EurostileTHea_medium_normal_1991873928;
      
      private var _embed__font_EurostileTHeaNoneCFF_medium_normal_1671520351:Class = MainClientApplication__embed__font_EurostileTHeaNoneCFF_medium_normal_1671520351;
      
      private var _embed__font_EurostileTNoneCFF_medium_normal_688355214:Class = MainClientApplication__embed__font_EurostileTNoneCFF_medium_normal_688355214;
      
      public function MainClientApplication()
      {
         super();
         mx_internal::_document = this;
         this.width = 1280;
         this.height = 900;
         this.mxmlContentFactory = new DeferredInstanceFromFunction(this._MainClientApplication_Array1_c);
         this.addEventListener("creationComplete",this.___MainClientApplication_Application1_creationComplete);
         this.addEventListener("addedToStage",this.___MainClientApplication_Application1_addedToStage);
      }
      
      override public function set moduleFactory(param1:IFlexModuleFactory) : void
      {
         var factory:IFlexModuleFactory = param1;
         super.moduleFactory = factory;
         if(this.__moduleFactoryInitialized)
         {
            return;
         }
         this.__moduleFactoryInitialized = true;
         if(!this.styleDeclaration)
         {
            this.styleDeclaration = new CSSStyleDeclaration(null,styleManager);
         }
         this.styleDeclaration.defaultFactory = function():void
         {
            this.backgroundAlpha = 0;
            this.backgroundColor = 0;
         };
         mx_internal::_MainClientApplication_StylesInit();
      }
      
      override public function initialize() : void
      {
         super.initialize();
      }
      
      private function handleInit() : void
      {
         try
         {
            Security.allowDomain("*");
         }
         catch(e:Error)
         {
         }
      }
      
      private function handleAddedToStage() : void
      {
         this.main.init(this,this.windowContainer);
      }
      
      [SecureSWF(rename="off")]
      public function startGame() : void
      {
         this.main.initApplication();
      }
      
      [SecureSWF(rename="off")]
      public function get autoStartEnabled() : Boolean
      {
         return Settings.singleSessionAutoStartEnabled;
      }
      
      [SecureSWF(rename="off")]
      public function launchClientButtonClicked() : void
      {
         this.main.initApplication();
      }
      
      [SecureSWF(rename="off")]
      public function forwardEventDispatch(param1:Event) : void
      {
         systemManager.dispatchEvent(param1);
      }
      
      private function _MainClientApplication_Array1_c() : Array
      {
         return [this._MainClientApplication_Main1_i(),this._MainClientApplication_SkinnableContainer1_i()];
      }
      
      private function _MainClientApplication_Main1_i() : Main
      {
         var _loc1_:Main = new Main();
         _loc1_.initialized(this,"main");
         this.main = _loc1_;
         BindingManager.executeBindings(this,"main",this.main);
         return _loc1_;
      }
      
      private function _MainClientApplication_SkinnableContainer1_i() : SkinnableContainer
      {
         var _loc1_:SkinnableContainer = new SkinnableContainer();
         _loc1_.id = "windowContainer";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.windowContainer = _loc1_;
         BindingManager.executeBindings(this,"windowContainer",this.windowContainer);
         return _loc1_;
      }
      
      public function ___MainClientApplication_Application1_creationComplete(param1:FlexEvent) : void
      {
         this.handleInit();
      }
      
      public function ___MainClientApplication_Application1_addedToStage(param1:Event) : void
      {
         this.handleAddedToStage();
      }
      
      mx_internal function _MainClientApplication_StylesInit() : void
      {
         var style:CSSStyleDeclaration = null;
         var effects:Array = null;
         var conditions:Array = null;
         var condition:CSSCondition = null;
         var selector:CSSSelector = null;
         if(mx_internal::_MainClientApplication_StylesInit_done)
         {
            return;
         }
         mx_internal::_MainClientApplication_StylesInit_done = true;
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","questWindow");
         conditions.push(condition);
         selector = new CSSSelector("net.bigpoint.darkorbit.mvc.common.view.components.DOWindow",conditions,selector);
         style = styleManager.getStyleDeclaration("net.bigpoint.darkorbit.mvc.common.view.components.DOWindow.questWindow");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.titleColor = 15262143;
               this.resizable = "false";
               this.background = "placeholders";
               this.skinClass = DOWindowSkin;
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","jackpotWindow");
         conditions.push(condition);
         selector = new CSSSelector("net.bigpoint.darkorbit.mvc.common.view.components.DOWindow",conditions,selector);
         style = styleManager.getStyleDeclaration("net.bigpoint.darkorbit.mvc.common.view.components.DOWindow.jackpotWindow");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.titleColor = 15262143;
               this.resizable = "false";
               this.background = "placeholders";
               this.skinClass = DOWindowSkin;
               this.headerHeight = 37;
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","tdmResultWindow");
         conditions.push(condition);
         selector = new CSSSelector("net.bigpoint.darkorbit.mvc.common.view.components.DOWindow",conditions,selector);
         style = styleManager.getStyleDeclaration("net.bigpoint.darkorbit.mvc.common.view.components.DOWindow.tdmResultWindow");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.titleColor = 15262143;
               this.resizable = "false";
               this.background = "placeholders";
               this.skinClass = DOWindowSkin;
               this.headerHeight = 37;
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","battleStationPopup");
         conditions.push(condition);
         selector = new CSSSelector("net.bigpoint.darkorbit.mvc.common.view.components.DOWindow",conditions,selector);
         style = styleManager.getStyleDeclaration("net.bigpoint.darkorbit.mvc.common.view.components.DOWindow.battleStationPopup");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.titleColor = 15262143;
               this.resizable = "false";
               this.background = "placeholders";
               this.skinClass = DOWindowSkin;
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","battleStationBuildWindow");
         conditions.push(condition);
         selector = new CSSSelector("net.bigpoint.darkorbit.mvc.common.view.components.DOWindow",conditions,selector);
         style = styleManager.getStyleDeclaration("net.bigpoint.darkorbit.mvc.common.view.components.DOWindow.battleStationBuildWindow");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.titleColor = 15262143;
               this.resizable = "true";
               this.background = "placeholders";
               this.skinClass = DOWindowSkin;
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","companyHierarchyWindow");
         conditions.push(condition);
         selector = new CSSSelector("net.bigpoint.darkorbit.mvc.common.view.components.DOWindow",conditions,selector);
         style = styleManager.getStyleDeclaration("net.bigpoint.darkorbit.mvc.common.view.components.DOWindow.companyHierarchyWindow");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.titleColor = 15262143;
               this.resizable = "false";
               this.background = "placeholders";
               this.skinClass = DOWindowSkin;
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","wordPuzzleWindow");
         conditions.push(condition);
         selector = new CSSSelector("net.bigpoint.darkorbit.mvc.common.view.components.DOWindow",conditions,selector);
         style = styleManager.getStyleDeclaration("net.bigpoint.darkorbit.mvc.common.view.components.DOWindow.wordPuzzleWindow");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.titleColor = 15262143;
               this.resizable = "false";
               this.background = "placeholders";
               this.skinClass = DODownGradWindowSkin;
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","countDownStatusWindow");
         conditions.push(condition);
         selector = new CSSSelector("net.bigpoint.darkorbit.mvc.common.view.components.DOWindow",conditions,selector);
         style = styleManager.getStyleDeclaration("net.bigpoint.darkorbit.mvc.common.view.components.DOWindow.countDownStatusWindow");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.titleColor = 15262143;
               this.resizable = "false";
               this.background = "placeholders";
               this.skinClass = DODownGradWindowSkin;
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","settingsWindow");
         conditions.push(condition);
         selector = new CSSSelector("net.bigpoint.darkorbit.mvc.common.view.components.DOWindow",conditions,selector);
         style = styleManager.getStyleDeclaration("net.bigpoint.darkorbit.mvc.common.view.components.DOWindow.settingsWindow");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.titleColor = 15262143;
               this.resizable = "true";
               this.background = "placeholders";
               this.width = "420";
               this.skinClass = DOWindowSkin;
               this.height = "480";
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","questWindowOuter");
         conditions.push(condition);
         selector = new CSSSelector("net.bigpoint.darkorbit.mvc.common.view.components.DOViewContainerBase",conditions,selector);
         style = styleManager.getStyleDeclaration("net.bigpoint.darkorbit.mvc.common.view.components.DOViewContainerBase.questWindowOuter");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderColour = 3423815;
               this.borderWeight = 1;
               this.borderAlpha = 1;
               this.backgroundAlpha = 1;
               this.backgroundColour = 0;
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","questWindowInvisible");
         conditions.push(condition);
         selector = new CSSSelector("net.bigpoint.darkorbit.mvc.common.view.components.DOViewContainerBase",conditions,selector);
         style = styleManager.getStyleDeclaration("net.bigpoint.darkorbit.mvc.common.view.components.DOViewContainerBase.questWindowInvisible");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderColour = 3423815;
               this.borderWeight = 1;
               this.borderAlpha = 0;
               this.backgroundAlpha = 0;
               this.backgroundColour = 2239282;
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","questWindowAcceptQuest");
         conditions.push(condition);
         selector = new CSSSelector("net.bigpoint.darkorbit.mvc.common.view.components.DOButtonBase",conditions,selector);
         style = styleManager.getStyleDeclaration("net.bigpoint.darkorbit.mvc.common.view.components.DOButtonBase.questWindowAcceptQuest");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.scalable = false;
               this.overState = "button_green_over";
               this.libID = "questWin";
               this.scale9rect = "10,14,1,1";
               this.disabledState = "button_inactive";
               this.normalState = "button_green_normal";
               this.downState = "button_green_down";
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","greenButtonWithColoredText");
         conditions.push(condition);
         selector = new CSSSelector("net.bigpoint.darkorbit.mvc.common.view.components.DOButtonBase",conditions,selector);
         style = styleManager.getStyleDeclaration("net.bigpoint.darkorbit.mvc.common.view.components.DOButtonBase.greenButtonWithColoredText");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.scalable = false;
               this.overState = "button_green_over";
               this.libID = "questWin";
               this.color = 15658734;
               this.scale9rect = "10,14,1,1";
               this.skinClass = DOButtonSkinWithColoredText;
               this.disabledState = "button_inactive";
               this.normalState = "button_green_normal";
               this.downState = "button_green_down";
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","greenButtonWithColoredText");
         conditions.push(condition);
         condition = new CSSCondition("pseudo","over");
         conditions.push(condition);
         selector = new CSSSelector("net.bigpoint.darkorbit.mvc.common.view.components.DOButtonBase",conditions,selector);
         style = styleManager.getStyleDeclaration("net.bigpoint.darkorbit.mvc.common.view.components.DOButtonBase.greenButtonWithColoredText:over");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","greenButtonWithColoredText");
         conditions.push(condition);
         condition = new CSSCondition("pseudo","up");
         conditions.push(condition);
         selector = new CSSSelector("net.bigpoint.darkorbit.mvc.common.view.components.DOButtonBase",conditions,selector);
         style = styleManager.getStyleDeclaration("net.bigpoint.darkorbit.mvc.common.view.components.DOButtonBase.greenButtonWithColoredText:up");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 15658734;
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","greenButtonWithColoredText");
         conditions.push(condition);
         condition = new CSSCondition("pseudo","down");
         conditions.push(condition);
         selector = new CSSSelector("net.bigpoint.darkorbit.mvc.common.view.components.DOButtonBase",conditions,selector);
         style = styleManager.getStyleDeclaration("net.bigpoint.darkorbit.mvc.common.view.components.DOButtonBase.greenButtonWithColoredText:down");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 14737632;
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","greenButtonWithColoredText");
         conditions.push(condition);
         condition = new CSSCondition("pseudo","disabled");
         conditions.push(condition);
         selector = new CSSSelector("net.bigpoint.darkorbit.mvc.common.view.components.DOButtonBase",conditions,selector);
         style = styleManager.getStyleDeclaration("net.bigpoint.darkorbit.mvc.common.view.components.DOButtonBase.greenButtonWithColoredText:disabled");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 5592405;
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","questWindowAbortQuest");
         conditions.push(condition);
         selector = new CSSSelector("net.bigpoint.darkorbit.mvc.common.view.components.DOButtonBase",conditions,selector);
         style = styleManager.getStyleDeclaration("net.bigpoint.darkorbit.mvc.common.view.components.DOButtonBase.questWindowAbortQuest");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.scalable = false;
               this.overState = "button_blue_over";
               this.libID = "questWin";
               this.scale9rect = "10,14,1,1";
               this.disabledState = "button_inactive";
               this.normalState = "button_blue_normal";
               this.downState = "button_blue_down";
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","scalableGreenConfirmButton");
         conditions.push(condition);
         selector = new CSSSelector("net.bigpoint.darkorbit.mvc.common.view.components.DOButtonBase",conditions,selector);
         style = styleManager.getStyleDeclaration("net.bigpoint.darkorbit.mvc.common.view.components.DOButtonBase.scalableGreenConfirmButton");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.scalable = true;
               this.overState = "button_green_over";
               this.libID = "questWin";
               this.scale9rect = "10,14,1,1";
               this.disabledState = "button_inactive";
               this.normalState = "button_green_normal";
               this.downState = "button_green_down";
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","scalableBlueCancelButton");
         conditions.push(condition);
         selector = new CSSSelector("net.bigpoint.darkorbit.mvc.common.view.components.DOButtonBase",conditions,selector);
         style = styleManager.getStyleDeclaration("net.bigpoint.darkorbit.mvc.common.view.components.DOButtonBase.scalableBlueCancelButton");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.scalable = true;
               this.overState = "button_blue_over";
               this.libID = "questWin";
               this.scale9rect = "10,14,1,1";
               this.disabledState = "button_inactive";
               this.normalState = "button_blue_normal";
               this.downState = "button_blue_down";
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","generalWindowCloseButton");
         conditions.push(condition);
         selector = new CSSSelector("net.bigpoint.darkorbit.mvc.common.view.components.DOButtonBase",conditions,selector);
         style = styleManager.getStyleDeclaration("net.bigpoint.darkorbit.mvc.common.view.components.DOButtonBase.generalWindowCloseButton");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.scalable = false;
               this.overState = "winCloseBtn_over";
               this.libID = "ui";
               this.scale9rect = "10,14,1,1";
               this.disabledState = "winCloseBtn_normal";
               this.normalState = "winCloseBtn_normal";
               this.downState = "winCloseBtn_down";
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","windowResizeHandle");
         conditions.push(condition);
         selector = new CSSSelector("net.bigpoint.darkorbit.mvc.common.view.components.DOButtonBase",conditions,selector);
         style = styleManager.getStyleDeclaration("net.bigpoint.darkorbit.mvc.common.view.components.DOButtonBase.windowResizeHandle");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.scalable = false;
               this.overState = "resize_handle_over";
               this.libID = "questWin";
               this.scale9rect = "10,14,1,1";
               this.disabledState = "resize_handle_normal";
               this.normalState = "resize_handle_normal";
               this.downState = "resize_handle_normal";
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","sliderArrow");
         conditions.push(condition);
         selector = new CSSSelector("net.bigpoint.darkorbit.mvc.common.view.components.DOButtonBase",conditions,selector);
         style = styleManager.getStyleDeclaration("net.bigpoint.darkorbit.mvc.common.view.components.DOButtonBase.sliderArrow");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.scalable = false;
               this.overState = "slider_button_hover";
               this.libID = "battleStationsUI";
               this.disabledState = "slider_button_normal";
               this.normalState = "slider_button_normal";
               this.downState = "slider_button_hover";
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","downArrowButtonNormal");
         conditions.push(condition);
         selector = new CSSSelector("net.bigpoint.darkorbit.mvc.common.view.components.DOButtonBase",conditions,selector);
         style = styleManager.getStyleDeclaration("net.bigpoint.darkorbit.mvc.common.view.components.DOButtonBase.downArrowButtonNormal");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.scalable = false;
               this.overState = "btn_filter_normal_hover";
               this.libID = "battleStationsUI";
               this.disabledState = "btn_filter_normal_normal";
               this.normalState = "btn_filter_normal_normal";
               this.downState = "btn_filter_normal_click";
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","downArrowButtonActive");
         conditions.push(condition);
         selector = new CSSSelector("net.bigpoint.darkorbit.mvc.common.view.components.DOButtonBase",conditions,selector);
         style = styleManager.getStyleDeclaration("net.bigpoint.darkorbit.mvc.common.view.components.DOButtonBase.downArrowButtonActive");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.scalable = false;
               this.overState = "btn_filter_active_hover";
               this.libID = "battleStationsUI";
               this.disabledState = "btn_filter_active_normal";
               this.normalState = "btn_filter_active_normal";
               this.downState = "btn_filter_active_click";
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","questWindowTabs");
         conditions.push(condition);
         selector = new CSSSelector("net.bigpoint.darkorbit.mvc.common.view.components.DOTabButtonBase",conditions,selector);
         style = styleManager.getStyleDeclaration("net.bigpoint.darkorbit.mvc.common.view.components.DOTabButtonBase.questWindowTabs");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.overAndSelectedState = "tabSelected";
               this.overState = "tabRollover";
               this.downAndSelectedState = "tabSelected";
               this.upAndSelectedState = "tabSelected";
               this.libID = "questWin";
               this.upState = "tabDisabled";
               this.disabledState = "tabDisabled";
               this.downState = "tabSelected";
               this.disabledAndSelectedState = "tabDisabled";
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","tdmResultWinTabs");
         conditions.push(condition);
         selector = new CSSSelector("net.bigpoint.darkorbit.mvc.common.view.components.DOTabButtonBase",conditions,selector);
         style = styleManager.getStyleDeclaration("net.bigpoint.darkorbit.mvc.common.view.components.DOTabButtonBase.tdmResultWinTabs");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.overAndSelectedState = "tabSelected";
               this.overState = "tabDisabled";
               this.downAndSelectedState = "tabSelected";
               this.upAndSelectedState = "tabSelected";
               this.libID = "tdmResultWin";
               this.upState = "tabDisabled";
               this.disabledState = "tabDisabled";
               this.downState = "tabSelected";
               this.disabledAndSelectedState = "tabDisabled";
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","questWindowTabBar");
         conditions.push(condition);
         selector = new CSSSelector("net.bigpoint.darkorbit.mvc.common.view.components.DOScalableDivider",conditions,selector);
         style = styleManager.getStyleDeclaration("net.bigpoint.darkorbit.mvc.common.view.components.DOScalableDivider.questWindowTabBar");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.libID = "questWin";
               this.linkageID = "tabDivider_x7y8";
               this.scale9rect = "7,8,1,1";
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","skinnedScroller");
         conditions.push(condition);
         selector = new CSSSelector("",conditions,selector);
         style = styleManager.getStyleDeclaration(".skinnedScroller");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.skinClass = DOScrollerSkin;
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","skinnedScrollerWithoutBorder");
         conditions.push(condition);
         selector = new CSSSelector("",conditions,selector);
         style = styleManager.getStyleDeclaration(".skinnedScrollerWithoutBorder");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.skinClass = DOScrollerSkinWithoutBorder;
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","skinnedVScrollBar");
         conditions.push(condition);
         selector = new CSSSelector("",conditions,selector);
         style = styleManager.getStyleDeclaration(".skinnedVScrollBar");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.skinClass = DOVScrollBarSkin;
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","skinnedVScrollBarTrack");
         conditions.push(condition);
         selector = new CSSSelector("",conditions,selector);
         style = styleManager.getStyleDeclaration(".skinnedVScrollBarTrack");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.libID = "questWin";
               this.skinClass = DOVScrollBarTrackSkin;
               this.track = "track_bg";
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","skinnedVScrollBarThumb");
         conditions.push(condition);
         selector = new CSSSelector("",conditions,selector);
         style = styleManager.getStyleDeclaration(".skinnedVScrollBarThumb");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.libID = "questWin";
               this.thumb = "scroll_thumb";
               this.skinClass = DOVScrollBarThumbSkin;
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","skinnedVScrollBarDownButton");
         conditions.push(condition);
         selector = new CSSSelector("",conditions,selector);
         style = styleManager.getStyleDeclaration(".skinnedVScrollBarDownButton");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.overState = "arrow_down_active";
               this.libID = "questWin";
               this.upState = "arrow_down";
               this.skinClass = DOVScrollDownButtonSkin;
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","skinnedVScrollBarUpButton");
         conditions.push(condition);
         selector = new CSSSelector("",conditions,selector);
         style = styleManager.getStyleDeclaration(".skinnedVScrollBarUpButton");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.overState = "arrow_up_active";
               this.libID = "questWin";
               this.upState = "arrow_up";
               this.skinClass = DOVScrollUpButtonSkin;
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","skinnedHScrollBar");
         conditions.push(condition);
         selector = new CSSSelector("",conditions,selector);
         style = styleManager.getStyleDeclaration(".skinnedHScrollBar");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.skinClass = DOHScrollBarSkin;
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","skinnedHScrollBarTrack");
         conditions.push(condition);
         selector = new CSSSelector("",conditions,selector);
         style = styleManager.getStyleDeclaration(".skinnedHScrollBarTrack");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.libID = "questWin";
               this.skinClass = DOHScrollBarTrackSkin;
               this.track = "track_bg";
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","skinnedHScrollBarThumb");
         conditions.push(condition);
         selector = new CSSSelector("",conditions,selector);
         style = styleManager.getStyleDeclaration(".skinnedHScrollBarThumb");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.libID = "questWin";
               this.thumb = "scroll_thumb";
               this.skinClass = DOHScrollBarThumbSkin;
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","skinnedHScrollBarLeftButton");
         conditions.push(condition);
         selector = new CSSSelector("",conditions,selector);
         style = styleManager.getStyleDeclaration(".skinnedHScrollBarLeftButton");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.overState = "arrow_up_active";
               this.libID = "questWin";
               this.upState = "arrow_up";
               this.skinClass = DOHScrollDownButtonSkin;
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","skinnedHScrollBarRightButton");
         conditions.push(condition);
         selector = new CSSSelector("",conditions,selector);
         style = styleManager.getStyleDeclaration(".skinnedHScrollBarRightButton");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.overState = "arrow_up_active";
               this.libID = "questWin";
               this.upState = "arrow_up";
               this.skinClass = DOHScrollUpButtonSkin;
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","skinnedList");
         conditions.push(condition);
         selector = new CSSSelector("",conditions,selector);
         style = styleManager.getStyleDeclaration(".skinnedList");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.skinClass = DOListSkin;
               this.borderAlpha = 0;
               this.contentBackgroundAlpha = 0;
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","skinnedListDownGrade");
         conditions.push(condition);
         selector = new CSSSelector("",conditions,selector);
         style = styleManager.getStyleDeclaration(".skinnedListDownGrade");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.skinClass = DODownGradListSkin;
               this.borderAlpha = 0;
               this.contentBackgroundAlpha = 0;
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","skinnedDataGrid");
         conditions.push(condition);
         selector = new CSSSelector("",conditions,selector);
         style = styleManager.getStyleDeclaration(".skinnedDataGrid");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderVisible = false;
               this.skinClass = HighscoreTableSkin;
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","skinnedDataGridHeader");
         conditions.push(condition);
         selector = new CSSSelector("",conditions,selector);
         style = styleManager.getStyleDeclaration(".skinnedDataGridHeader");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.paddingBottom = 1;
               this.paddingRight = 5;
               this.column1align = "center";
               this.paddingTop = 2;
               this.paddingLeft = 4;
               this.fontColor = "#424a50";
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","skinnedDataGridRow");
         conditions.push(condition);
         selector = new CSSSelector("",conditions,selector);
         style = styleManager.getStyleDeclaration(".skinnedDataGridRow");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.column2align = "left";
               this.paddingBottom = 0;
               this.column3align = "left";
               this.column4align = "left";
               this.fontColorHover = "#00FFFF";
               this.paddingRight = 5;
               this.column1align = "center";
               this.fontColorActive = "#a59a61";
               this.paddingTop = 6;
               this.paddingLeft = 5;
               this.fontColor = "#6b6b6b";
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","doCheckBox");
         conditions.push(condition);
         selector = new CSSSelector("",conditions,selector);
         style = styleManager.getStyleDeclaration(".doCheckBox");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.checkedState = "check_box_checked";
               this.libID = "questWin";
               this.uncheckedState = "check_box_unchecked";
               this.checkedHoveredState = "check_box_checked_hovered";
               this.uncheckedHoveredState = "check_box_unchecked_hovered";
               this.skinClass = DOCustomScaleBgContainerSkin;
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","doCheckBoxFilterAvailable");
         conditions.push(condition);
         selector = new CSSSelector("",conditions,selector);
         style = styleManager.getStyleDeclaration(".doCheckBoxFilterAvailable");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.checkedState = "quests_available_active";
               this.libID = "questWin";
               this.uncheckedState = "quests_available_inactive";
               this.checkedHoveredState = "quests_available_active_hovered";
               this.uncheckedHoveredState = "quests_available_inactive_hovered";
               this.skinClass = DOCustomScaleBgContainerSkin;
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","doCheckBoxFilterUnavailable");
         conditions.push(condition);
         selector = new CSSSelector("",conditions,selector);
         style = styleManager.getStyleDeclaration(".doCheckBoxFilterUnavailable");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.checkedState = "quests_unavailable_active";
               this.libID = "questWin";
               this.uncheckedState = "quests_unavailable_inactive";
               this.checkedHoveredState = "quests_unavailable_active_hovered";
               this.uncheckedHoveredState = "quests_unavailable_inactive_hovered";
               this.skinClass = DOCustomScaleBgContainerSkin;
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","doCheckBoxFilterCompleted");
         conditions.push(condition);
         selector = new CSSSelector("",conditions,selector);
         style = styleManager.getStyleDeclaration(".doCheckBoxFilterCompleted");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.checkedState = "quests_completed_active";
               this.libID = "questWin";
               this.uncheckedState = "quests_completed_inactive";
               this.checkedHoveredState = "quests_completed_active_hovered";
               this.uncheckedHoveredState = "quests_completed_inactive_hovered";
               this.skinClass = DOCustomScaleBgContainerSkin;
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","doCheckBoxLevelOrder");
         conditions.push(condition);
         selector = new CSSSelector("",conditions,selector);
         style = styleManager.getStyleDeclaration(".doCheckBoxLevelOrder");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.checkedState = "quests_mission_sort_DOWN_active";
               this.libID = "questWin";
               this.uncheckedState = "quests_mission_sort_UP_active";
               this.checkedHoveredState = "quests_mission_sort_DOWN_active_hovered";
               this.uncheckedHoveredState = "quests_mission_sort_UP_active_hovered";
               this.skinClass = DOCustomScaleBgContainerSkin;
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","doCheckBoxFilterAttempted");
         conditions.push(condition);
         selector = new CSSSelector("",conditions,selector);
         style = styleManager.getStyleDeclaration(".doCheckBoxFilterAttempted");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.checkedState = "challenge_attempted_active";
               this.libID = "questWin";
               this.uncheckedState = "challenge_attempted_inactive";
               this.checkedHoveredState = "challenge_attempted_active_hovered";
               this.uncheckedHoveredState = "challenge_attempted_inactive_hovered";
               this.skinClass = DOCustomScaleBgContainerSkin;
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","doCheckBoxFilterUnattempted");
         conditions.push(condition);
         selector = new CSSSelector("",conditions,selector);
         style = styleManager.getStyleDeclaration(".doCheckBoxFilterUnattempted");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.checkedState = "challenge_unattempted_active";
               this.libID = "questWin";
               this.uncheckedState = "challenge_unattempted_inactive";
               this.checkedHoveredState = "challenge_unattempted_active_hovered";
               this.uncheckedHoveredState = "challenge_unattempted_inactive_hovered";
               this.skinClass = DOCustomScaleBgContainerSkin;
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","questListItemRendererContentStyle");
         conditions.push(condition);
         selector = new CSSSelector("",conditions,selector);
         style = styleManager.getStyleDeclaration(".questListItemRendererContentStyle");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("spark.components.SkinnableContainer",conditions,selector);
         conditions = [];
         condition = new CSSCondition("class","instalationBackground");
         conditions.push(condition);
         selector = new CSSSelector("",conditions,selector);
         style = styleManager.getStyleDeclaration("spark.components.SkinnableContainer .instalationBackground");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.libID = "battleStationsUI";
               this.skinClass = DOCustomImageBgContainerSkin;
               this.backgroundBitmap = "instalation_bg_with_holsters";
            };
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("spark.components.SkinnableContainer",conditions,selector);
         conditions = [];
         condition = new CSSCondition("class","moduleSingleHolsterBackground");
         conditions.push(condition);
         selector = new CSSSelector("",conditions,selector);
         style = styleManager.getStyleDeclaration("spark.components.SkinnableContainer .moduleSingleHolsterBackground");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.libID = "battleStationsUI";
               this.skinClass = DOCustomScaleBgContainerSkin;
               this.backgroundBitmap = "single_holster_background";
            };
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("spark.components.SkinnableContainer",conditions,selector);
         conditions = [];
         condition = new CSSCondition("class","moduleDoubleHolsterBackground");
         conditions.push(condition);
         selector = new CSSSelector("",conditions,selector);
         style = styleManager.getStyleDeclaration("spark.components.SkinnableContainer .moduleDoubleHolsterBackground");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.libID = "battleStationsUI";
               this.skinClass = DOCustomScaleBgContainerSkin;
               this.backgroundBitmap = "double_holster_background";
            };
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("spark.components.SkinnableContainer",conditions,selector);
         conditions = [];
         condition = new CSSCondition("class","ratingsBackground");
         conditions.push(condition);
         selector = new CSSSelector("",conditions,selector);
         style = styleManager.getStyleDeclaration("spark.components.SkinnableContainer .ratingsBackground");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.libID = "battleStationsUI";
               this.skinClass = DOCustomScaleBgContainerSkin;
               this.backgroundBitmap = "ratings_background_gradient";
            };
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("spark.components.SkinnableContainer",conditions,selector);
         conditions = [];
         condition = new CSSCondition("class","selectionSliderPopupBg");
         conditions.push(condition);
         selector = new CSSSelector("",conditions,selector);
         style = styleManager.getStyleDeclaration("spark.components.SkinnableContainer .selectionSliderPopupBg");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.libID = "battleStationsUI";
               this.skinClass = DOCustomImageBgContainerSkin;
               this.backgroundBitmap = "slider_background";
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","TeamDeathMatchLobbyWindowMatchoverviewCSS");
         conditions.push(condition);
         selector = new CSSSelector("",conditions,selector);
         style = styleManager.getStyleDeclaration(".TeamDeathMatchLobbyWindowMatchoverviewCSS");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.libID = "tdmLobbyWindow";
               this.scale9Grid = "7,7,1,1";
               this.skinID = "innerFrameTop_15x9";
               this.skinClass = TeamDeathMatchLobbyWindowMatchoverviewSkin;
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","TeamDeathMatchLobbyWindowMatchdetailCSS");
         conditions.push(condition);
         selector = new CSSSelector("",conditions,selector);
         style = styleManager.getStyleDeclaration(".TeamDeathMatchLobbyWindowMatchdetailCSS");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.libID = "tdmLobbyWindow";
               this.scale9Grid = "7,1,1,1";
               this.skinID = "innerFrameBottom_15x9";
               this.skinClass = DOSkinnable9ScaleContainerSkin;
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","jackpotGrid");
         conditions.push(condition);
         selector = new CSSSelector("spark.components.DataGrid",conditions,selector);
         style = styleManager.getStyleDeclaration("spark.components.DataGrid.jackpotGrid");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.libID = "jackpotResultWin";
               this.scale9Grid = "9,9,1,1";
               this.skinID = "innerFrame";
               this.skinClass = JackpotWindowItemListSkin;
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","skinnedListTDM");
         conditions.push(condition);
         selector = new CSSSelector("spark.components.DataGrid",conditions,selector);
         style = styleManager.getStyleDeclaration("spark.components.DataGrid.skinnedListTDM");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.libID = "tdmResultWin";
               this.scale9Grid = "7,7,1,1";
               this.skinClass = DOToolTipListSkinTDM;
               this.borderAlpha = 1;
               this.skinID = "tooltipFrame";
               this.contentBackgroundAlpha = 0;
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","jackpot");
         conditions.push(condition);
         selector = new CSSSelector("spark.components.SkinnableContainer",conditions,selector);
         style = styleManager.getStyleDeclaration("spark.components.SkinnableContainer.jackpot");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.libID = "jackpotResultWin";
               this.scale9Grid = "9,9,1,1";
               this.skinID = "frameSprite";
               this.skinClass = DOSkinnable9ScaleContainerSkin;
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","tdmResult");
         conditions.push(condition);
         selector = new CSSSelector("spark.components.SkinnableContainer",conditions,selector);
         style = styleManager.getStyleDeclaration("spark.components.SkinnableContainer.tdmResult");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.libID = "tdmResultWin";
               this.scale9Grid = "7,7,1,1";
               this.skinID = "innerFrame";
               this.skinClass = TDMSkinnableContainerOuterSkin;
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","tdmResultBorder");
         conditions.push(condition);
         selector = new CSSSelector("spark.components.SkinnableContainer",conditions,selector);
         style = styleManager.getStyleDeclaration("spark.components.SkinnableContainer.tdmResultBorder");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.libID = "tdmResultWin";
               this.scale9Grid = "9,9,1,1";
               this.skinID = "frameSprite";
               this.skinClass = DOSkinnable9ScaleContainerSkin;
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","tdmAccordion");
         conditions.push(condition);
         selector = new CSSSelector("spark.components.SkinnableContainer",conditions,selector);
         style = styleManager.getStyleDeclaration("spark.components.SkinnableContainer.tdmAccordion");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.libID = "tdmResultWin";
               this.scale9Grid = "7,7,1,1";
               this.skinID = "accordionFrame";
               this.skinClass = DOSkinnable9ScaleContainerSkin;
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","emergencyRepairBackground");
         conditions.push(condition);
         selector = new CSSSelector("spark.components.SkinnableContainer",conditions,selector);
         style = styleManager.getStyleDeclaration("spark.components.SkinnableContainer.emergencyRepairBackground");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.libID = "battleStationsUI";
               this.skinClass = DOCustomScaleBgContainerSkin;
               this.backgroundBitmap = "emergency_repair_background";
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","constructionProgressBackground");
         conditions.push(condition);
         selector = new CSSSelector("spark.components.SkinnableContainer",conditions,selector);
         style = styleManager.getStyleDeclaration("spark.components.SkinnableContainer.constructionProgressBackground");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.libID = "battleStationsUI";
               this.skinClass = DOCustomScaleBgContainerSkin;
               this.backgroundBitmap = "progress_background";
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","factionLogoEIC");
         conditions.push(condition);
         selector = new CSSSelector("spark.components.SkinnableContainer",conditions,selector);
         style = styleManager.getStyleDeclaration("spark.components.SkinnableContainer.factionLogoEIC");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.libID = "battleStationsUI";
               this.skinClass = DOCustomScaleBgContainerSkin;
               this.backgroundBitmap = "faction_eic_logo";
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","factionLogoMMO");
         conditions.push(condition);
         selector = new CSSSelector("spark.components.SkinnableContainer",conditions,selector);
         style = styleManager.getStyleDeclaration("spark.components.SkinnableContainer.factionLogoMMO");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.libID = "battleStationsUI";
               this.skinClass = DOCustomScaleBgContainerSkin;
               this.backgroundBitmap = "faction_mmo_logo";
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","factionLogoVRU");
         conditions.push(condition);
         selector = new CSSSelector("spark.components.SkinnableContainer",conditions,selector);
         style = styleManager.getStyleDeclaration("spark.components.SkinnableContainer.factionLogoVRU");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.libID = "battleStationsUI";
               this.skinClass = DOCustomScaleBgContainerSkin;
               this.backgroundBitmap = "faction_vru_logo";
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","factionLogoNeutral");
         conditions.push(condition);
         selector = new CSSSelector("spark.components.SkinnableContainer",conditions,selector);
         style = styleManager.getStyleDeclaration("spark.components.SkinnableContainer.factionLogoNeutral");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.libID = "battleStationsUI";
               this.skinClass = DOCustomScaleBgContainerSkin;
               this.backgroundBitmap = "faction_neutral_logo";
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","tdmToolTip");
         conditions.push(condition);
         selector = new CSSSelector("spark.components.SkinnableContainer",conditions,selector);
         style = styleManager.getStyleDeclaration("spark.components.SkinnableContainer.tdmToolTip");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.normalKey = "icon_std";
               this.libID = "tdmResultWin";
               this.skinClass = TDMRewardIconSkin;
               this.hoverKey = "icon_hover";
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("id","rewardsList");
         conditions.push(condition);
         selector = new CSSSelector("*",conditions,selector);
         conditions = null;
         selector = new CSSSelector("spark.components.SkinnableContainer",conditions,selector);
         style = styleManager.getStyleDeclaration("*#rewardsList spark.components.SkinnableContainer");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.labelsPaddingBottom = 0;
               this.amountFontColor = "#ffffff";
               this.labelsPaddingTop = 4;
               this.rewardNameFontColor = "#99e7fd";
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("id","components");
         conditions.push(condition);
         selector = new CSSSelector("*",conditions,selector);
         conditions = null;
         selector = new CSSSelector("spark.components.SkinnableContainer",conditions,selector);
         style = styleManager.getStyleDeclaration("*#components spark.components.SkinnableContainer");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.labelsPaddingBottom = 0;
               this.amountFontColor = "#ffffff";
               this.labelsPaddingTop = 4;
               this.rewardNameFontColor = "#99e7fd";
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","teamDeathMatchLobbywindow");
         conditions.push(condition);
         selector = new CSSSelector("spark.components.SkinnableContainer",conditions,selector);
         style = styleManager.getStyleDeclaration("spark.components.SkinnableContainer.teamDeathMatchLobbywindow");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.libID = "tdmLobbyWindow";
               this.scale9Grid = "9,9,1,1";
               this.skinID = "frameSprite";
               this.skinClass = DOSkinnable9ScaleContainerSkin;
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","teamDeathMatchFactionLogoEIC");
         conditions.push(condition);
         selector = new CSSSelector("spark.components.SkinnableContainer",conditions,selector);
         style = styleManager.getStyleDeclaration("spark.components.SkinnableContainer.teamDeathMatchFactionLogoEIC");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.libID = "tdmLobbyWindow";
               this.skinClass = DOCustomScaleBgContainerSkin;
               this.backgroundBitmap = "logoLobbyEIC";
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","teamDeathMatchFactionLogoMMO");
         conditions.push(condition);
         selector = new CSSSelector("spark.components.SkinnableContainer",conditions,selector);
         style = styleManager.getStyleDeclaration("spark.components.SkinnableContainer.teamDeathMatchFactionLogoMMO");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.libID = "tdmLobbyWindow";
               this.skinClass = DOCustomScaleBgContainerSkin;
               this.backgroundBitmap = "logoLobbyMMO";
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","teamDeathMatchFactionLogoVRU");
         conditions.push(condition);
         selector = new CSSSelector("spark.components.SkinnableContainer",conditions,selector);
         style = styleManager.getStyleDeclaration("spark.components.SkinnableContainer.teamDeathMatchFactionLogoVRU");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.libID = "tdmLobbyWindow";
               this.skinClass = DOCustomScaleBgContainerSkin;
               this.backgroundBitmap = "logoLobbyVRU";
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","teamDeathMatchFactionLogoPanel");
         conditions.push(condition);
         selector = new CSSSelector("spark.components.SkinnableContainer",conditions,selector);
         style = styleManager.getStyleDeclaration("spark.components.SkinnableContainer.teamDeathMatchFactionLogoPanel");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.libID = "tdmLobbyWindow";
               this.skinClass = DOCustomScaleBgContainerSkin;
               this.backgroundBitmap = "panel_133x55";
            };
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("mx.controls.ToolTip",conditions,selector);
         style = styleManager.getStyleDeclaration("mx.controls.ToolTip");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.border = 1;
               this.backgroundColor = 0;
               this.borderColor = 1873341;
               this.color = 13421772;
               this.fontSize = 12;
               this.borderSkin = DOToolTipBorderSkin;
               this.borderStyle = "solid";
               this.cornerRadius = 0;
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","filterOptionButton");
         conditions.push(condition);
         selector = new CSSSelector("spark.components.Button",conditions,selector);
         style = styleManager.getStyleDeclaration("spark.components.Button.filterOptionButton");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.separatorColor = 1186592;
               this.unactiveFontColor = 9211010;
               this.darkBackgroundColor = 1843495;
               this.brightBackgroundColor = 2238767;
               this.overStateBackgroundColor = 3555401;
               this.activeFontColor = 15459011;
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","clanBattleStationPopupHSlider");
         conditions.push(condition);
         selector = new CSSSelector("spark.components.HSlider",conditions,selector);
         style = styleManager.getStyleDeclaration("spark.components.HSlider.clanBattleStationPopupHSlider");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.arrowButtonStyleName = "sliderArrow";
            };
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("net.bigpoint.as3toolbox.guicomponents.components.Scale9GridImage",conditions,selector);
         style = styleManager.getStyleDeclaration("net.bigpoint.as3toolbox.guicomponents.components.Scale9GridImage");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.skinClass = Scale9GridImageSkin;
            };
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("net.bigpoint.as3toolbox.guicomponents.components.Scale9GridImageButton",conditions,selector);
         style = styleManager.getStyleDeclaration("net.bigpoint.as3toolbox.guicomponents.components.Scale9GridImageButton");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.skinClass = Scale9GridImageButtonSkin;
            };
         }
         styleManager.initProtoChainRoots();
      }
      
      [Bindable(event="propertyChange")]
      public function get main() : Main
      {
         return this._3343801main;
      }
      
      public function set main(param1:Main) : void
      {
         var _loc2_:Object = null;
         _loc2_ = this._3343801main;
         if(_loc2_ !== param1)
         {
            this._3343801main = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"main",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get windowContainer() : SkinnableContainer
      {
         return this._1659371121windowContainer;
      }
      
      public function set windowContainer(param1:SkinnableContainer) : void
      {
         var _loc2_:Object = null;
         _loc2_ = this._1659371121windowContainer;
         if(_loc2_ !== param1)
         {
            this._1659371121windowContainer = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"windowContainer",_loc2_,param1));
            }
         }
      }
   }
}

