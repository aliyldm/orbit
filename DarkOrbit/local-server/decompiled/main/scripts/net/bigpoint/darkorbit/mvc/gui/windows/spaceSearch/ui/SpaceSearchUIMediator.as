package net.bigpoint.darkorbit.mvc.gui.windows.spaceSearch.ui
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.com.module.porting.SpaceSearch.SpaceSearchRequest;
   import net.bigpoint.darkorbit.delete_in_eic.BitmapVO;
   import net.bigpoint.darkorbit.delete_in_eic.BitmapVOLoader;
   import net.bigpoint.darkorbit.delete_in_eic.IconVOLoader;
   import net.bigpoint.darkorbit.delete_in_eic.ItemDataProviderHelper;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Container;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.dropdownbox.DropDownBox;
   import net.bigpoint.darkorbit.fui.components.list.dropdownbox.DropDownBoxEvent;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.components.tooltip.DefaultTooltipDataAssigner;
   import net.bigpoint.darkorbit.fui.components.tooltip.ITooltipDataAssigner;
   import net.bigpoint.darkorbit.fui.system.manager.TipUtil;
   import net.bigpoint.darkorbit.gui.GuiManager;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowCreationVO;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowEvent;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.windows.CreatePopupView;
   import net.bigpoint.darkorbit.mvc.gui.windows.SimpleWindowCreationMap;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.interfaces.IWindow;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.mediator.SimpleWindowMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.spaceSearch.ui.model.SpaceSearchRedDotData;
   import net.bigpoint.darkorbit.mvc.gui.windows.spaceSearch.ui.model.SpaceSearchRedDotProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.spaceSearch.ui.model.SpaceSearchUIData;
   import net.bigpoint.darkorbit.mvc.gui.windows.spaceSearch.ui.model.SpaceSearchUIProxy;
   import net.bigpoint.darkorbit.mvc.hintSystem.view.hintWindow.uistructures.HintWindowViewSetup;
   import net.bigpoint.darkorbit.net.JavascriptProxy;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class SpaceSearchUIMediator extends SimpleWindowMediator
   {
      
      private static const sp2:Sprite = new Sprite();
      
      private var _view:SpaceSearchUIView;
      
      private var topBg:Coreponent;
      
      private var bg:Coreponent;
      
      private var markBg:Coreponent;
      
      private var missionInfo:Coreponent;
      
      private var missionInfoBg:Coreponent;
      
      private var filterBox:DropDownBox;
      
      private var icon:Coreponent;
      
      private var lootAmount:Label;
      
      private var lootName:Label;
      
      private var explore_btn:Button;
      
      private var mapper:Dictionary = new Dictionary();
      
      protected var _showTooltipIntervalID:uint = 0;
      
      private var _currentTooltipContainer:Container;
      
      protected var _tooltipDataAssigner:ITooltipDataAssigner = new DefaultTooltipDataAssigner();
      
      protected var _tooltipData:Object;
      
      private var arr:Array = [1,5,10];
      
      private var loader:BitmapVOLoader = new BitmapVOLoader();
      
      private var data:SpaceSearchUIData;
      
      private const buttonHighlight:Sprite = new Sprite();
      
      private var redDotData:SpaceSearchRedDotData;
      
      private var angle:Number = 0;
      
      public var ids:Dictionary;
      
      private var logCount:int = 0;
      
      private var allPlanetMC:Vector.<MovieClip> = new Vector.<MovieClip>();
      
      private var allBtnMC:Vector.<Button> = new Vector.<Button>();
      
      private var allMaskMC:Vector.<MovieClip> = new Vector.<MovieClip>();
      
      private const sp:Sprite = new Sprite();
      
      public function SpaceSearchUIMediator(param1:String, param2:SimpleWindow)
      {
         super(param1,param2);
         SpaceSearchRedDotData.drawDot(this.buttonHighlight);
      }
      
      private function onCloseHandler(param1:SimpleWindowEvent) : void
      {
         this.clear(this.mediatorName);
      }
      
      override public function onRegister() : void
      {
         super.onRegister();
         var _loc1_:SpaceSearchUIProxy = SpaceSearchUIProxy.getOrCreateProxy(this.facade);
         this.data = _loc1_.viewData;
         this.data.changed.add(this.onDataChanged);
         this.redDotData = SpaceSearchRedDotProxy.getOrCreateProxy(this.facade).viewData;
         this.redDotData.changed.add(this.onRedDotChanged);
         sp2.graphics.clear();
         sp2.graphics.lineStyle(3,65280,0.7);
         sp2.graphics.drawCircle(0,0,30);
         sp2.graphics.moveTo(0,-40);
         sp2.graphics.lineTo(0,-20);
         sp2.graphics.moveTo(0,40);
         sp2.graphics.lineTo(0,20);
         sp2.graphics.moveTo(-40,0);
         sp2.graphics.lineTo(-20,0);
         sp2.graphics.moveTo(40,0);
         sp2.graphics.lineTo(20,0);
         sp2.graphics.endFill();
         sp2.addEventListener(Event.ENTER_FRAME,this.efe);
      }
      
      private function efe(param1:Event) : void
      {
         sp2.rotation += Math.sin(this.angle = this.angle + 0.135) * 2;
      }
      
      protected function mouseOver(param1:MouseEvent) : void
      {
         this._showTooltipIntervalID = setTimeout(this.showTooltip,300);
      }
      
      protected function mouseOut(param1:*) : void
      {
         TipUtil.removeCurrentTooltipContainer(this._currentTooltipContainer);
         clearTimeout(this._showTooltipIntervalID);
      }
      
      protected function showTooltip() : void
      {
         if(this._view.helpBtn)
         {
            if(!this._tooltipData)
            {
               this._tooltipData = BPLocale.getItem("strikeandexit_info");
            }
            if(!this._currentTooltipContainer)
            {
               this._currentTooltipContainer = TipUtil.createTip("SAE_TIP");
            }
            TipUtil.showTip(this._view.helpBtn,this._currentTooltipContainer,this._tooltipDataAssigner,this._tooltipData);
         }
      }
      
      private function missionInfoClick(param1:MouseEvent) : void
      {
         this.tryCreateAndOpen();
      }
      
      private function onEventSelected(param1:DropDownBoxEvent) : void
      {
         this.onDataChanged();
      }
      
      override protected function handleLoadAndBuildContentCallback(param1:Array) : void
      {
         var mediator:* = undefined;
         var callbackParams:Array = param1;
         var cfg2:XML = SpaceSearchXML.xmls["events_space_search"];
         this.ids = SpaceSearchXML.createPlanetIdToResKeyMap(cfg2);
         super.handleLoadAndBuildContentCallback(callbackParams);
         this._view = new SpaceSearchUIView(simpleWindow);
         this._view.helpBtn.addEventListener(MouseEvent.MOUSE_OVER,this.mouseOver);
         this._view.helpBtn.addEventListener(MouseEvent.MOUSE_OUT,this.mouseOut);
         this.icon = this._view.icon;
         this.lootAmount = this._view.lootAmount;
         this.lootName = this._view.lootName;
         this.bg = this._view.bg;
         this.bg.scaleX = this.bg.scaleY = 0.6;
         this.markBg = this._view.markBg;
         this.topBg = this._view.topBg;
         this.missionInfo = this._view.missionInfo;
         this.missionInfo.mouseEnabled = true;
         this.missionInfo.addEventListener(MouseEvent.CLICK,this.missionInfoClick);
         this.missionInfoBg = this._view.mission_info_bg;
         this.filterBox = this._view.filterBox;
         this.filterBox.updateAvailableEntries(new <String>["SS_explore_choose_1","SS_explore_choose_5","SS_explore_choose_10"]);
         this.filterBox.addEventListener(DropDownBoxEvent.SELECTED_ENTRY_CHANGED,this.onEventSelected);
         this.explore_btn = this._view.explore_btn;
         ScreenManager.getInstance().map;
         mediator = this;
         if(!this._view.refreshButton)
         {
            return;
         }
         this.explore_btn.addEventListener(MouseEvent.CLICK,this.explore_btn_click);
         this._view.refreshButton.visible = false;
         this._view.refreshButton.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
         {
            simpleWindow.minimize();
            mediator.clear(GuiConstants.SPACE_SEARCH);
            mediator.clear(GuiConstants.SPACE_SEARCH_REWARD);
         });
         IconVOLoader.getInstance().loadIcon(this.missionInfo,null,"task",AssetsProxy.EVENTS);
         this.updateBg();
      }
      
      private function explore_btn_click(param1:MouseEvent) : void
      {
         var sCom:SpaceSearchRequest = null;
         var sendRequest:Function = null;
         var event:MouseEvent = param1;
         var count:int = int(this.arr[this.filterBox.currentEntry]);
         var cost:Boolean = this.data.cost * count <= this.data.quantity;
         if(cost)
         {
            sCom = new SpaceSearchRequest();
            sCom.action = SpaceSearchRequest.ACTION_ssSearch;
            sCom.count = this.arr[this.filterBox.currentEntry];
            sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,sCom);
         }
         else
         {
            sendRequest = function():void
            {
               JavascriptProxy.referToURL("internalDock&tpl=internalDockSpecials&shopItem=package_event-deal-ftl-s",null);
            };
            CreatePopupView.getInstance().createPopup(sendRequest,BPLocale.getItem("SS_explore_nomaterials_2"));
         }
      }
      
      private function updateBg() : void
      {
         this.loader.addEventListener(BitmapVO.EVENT_COMPLETE,this.mvOk);
         var _loc1_:String = Settings.staticHost + "do_img/global/events/spaceSearch/swf/ss_planet.swf";
         this.loader.getRes(_loc1_);
      }
      
      private function mvOk(param1:BitmapVO) : void
      {
         var _loc4_:String = null;
         var _loc5_:MovieClip = null;
         var _loc6_:Button = null;
         var _loc7_:* = undefined;
         var _loc2_:MovieClip = param1.getMovieClip();
         this.topBg.visible = false;
         this.markBg.visible = false;
         this.bg.addChild(_loc2_);
         this.allPlanetMC.length = 0;
         this.allMaskMC.length = 0;
         var _loc3_:int = 1;
         while(_loc3_ <= 40)
         {
            _loc4_ = _loc3_ < 10 ? "0" + _loc3_ : "" + _loc3_;
            _loc5_ = _loc2_.getChildByName("p_" + _loc4_) as MovieClip;
            _loc5_.visible = false;
            this.allPlanetMC.push(_loc5_);
            _loc6_ = new Button();
            _loc6_.width = 100;
            _loc6_.height = 100;
            _loc6_.graphics.beginFill(26265,0);
            _loc6_.graphics.drawCircle(0,0,40);
            _loc6_.graphics.endFill();
            _loc6_.x = _loc5_.x;
            _loc6_.y = _loc5_.y;
            _loc6_.mouseEnabled = true;
            _loc6_.visible = false;
            this.bg.addChild(_loc6_);
            this.allBtnMC.push(_loc6_);
            _loc3_++;
         }
         _loc3_ = 1;
         while(_loc3_ <= 8)
         {
            _loc7_ = _loc2_.getChildByName("mc0" + _loc3_) as MovieClip;
            _loc7_.visible = false;
            this.allMaskMC.push(_loc7_);
            _loc3_++;
         }
         this.allMaskMC[0].visible = true;
         this.allPlanetMC[0].visible = true;
         this.serverNotification();
      }
      
      protected function onRedDotChanged() : void
      {
         if(!this.redDotData)
         {
            return;
         }
         if(!this.missionInfoBg)
         {
            return;
         }
         this.updateRedDot(this.redDotData.missionHighLight || this.redDotData.rewardHighLight);
      }
      
      public function serverNotification() : void
      {
         var _loc1_:SpaceSearchRequest = new SpaceSearchRequest();
         _loc1_.action = SpaceSearchRequest.ACTION_ssAtlas;
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,_loc1_);
      }
      
      public function onDataChanged() : void
      {
         var _loc8_:String = null;
         var _loc9_:String = null;
         if(this.allMaskMC.length <= 0)
         {
            return;
         }
         var _loc1_:int = this.data.index;
         var _loc2_:int = this.data.prc;
         var _loc3_:ItemVO = ItemDataProviderHelper.getItem(this.data.lootId);
         IconVOLoader.getInstance().loadIcon(this.icon,_loc3_,"100x100",AssetsProxy.ITEMS);
         this.lootName.text = _loc3_.fullname;
         this._view.infoBtn.tooltipData = _loc3_.rawDescription;
         var _loc4_:int = int(this.arr[this.filterBox.currentEntry]);
         var _loc5_:Boolean = this.data.cost * _loc4_ <= this.data.quantity;
         this.lootAmount.text = this.data.quantity + "/" + this.data.cost * _loc4_;
         var _loc6_:int = 0;
         while(_loc6_ < this.allPlanetMC.length)
         {
            this.allPlanetMC[_loc6_].visible = _loc1_ >= _loc6_;
            this.allBtnMC[_loc6_].visible = _loc1_ >= _loc6_;
            _loc8_ = this.ids[_loc6_ + 1];
            _loc8_ = BPLocale.getItem(_loc8_);
            _loc8_ = BPLocale.getItem("SS_tips_name").replace("%PLANETNAME%","") + ": " + _loc8_;
            _loc2_ = this.data.prc;
            if(_loc1_ > _loc6_)
            {
               _loc2_ = 100;
            }
            _loc9_ = BPLocale.getItem("SS_tips_explore_progress").replace("%PERCENT%","") + ": " + _loc2_ + "%";
            this.allBtnMC[_loc6_].tooltipData = _loc8_ + "\n" + _loc9_;
            _loc6_++;
         }
         this.allPlanetMC[0].parent.addChild(this.sp);
         this.allPlanetMC[0].parent.addChild(this.allPlanetMC[0]);
         this.allPlanetMC[0].addChild(sp2);
         this.sp.graphics.clear();
         if(_loc1_ > 0)
         {
            this.sp.graphics.lineStyle(3,26265,0.7);
            this.sp.graphics.moveTo(this.allPlanetMC[0].x,this.allPlanetMC[0].y);
            _loc6_ = 1;
            while(_loc6_ < this.allPlanetMC.length)
            {
               if(!this.allPlanetMC[_loc6_].visible)
               {
                  break;
               }
               this.allPlanetMC[0].parent.addChild(this.allPlanetMC[_loc6_]);
               if(_loc6_ % 5 == 0)
               {
                  this.sp.graphics.moveTo(this.allPlanetMC[_loc6_].x,this.allPlanetMC[_loc6_].y);
               }
               else
               {
                  this.sp.graphics.lineTo(this.allPlanetMC[_loc6_].x,this.allPlanetMC[_loc6_].y);
               }
               this.allPlanetMC[_loc6_].addChild(sp2);
               _loc6_++;
            }
            this.sp.graphics.endFill();
         }
         _loc6_ = 0;
         while(_loc6_ < this.allMaskMC.length)
         {
            this.allMaskMC[_loc6_].visible = false;
            _loc6_++;
         }
         var _loc7_:int = int(_loc1_ / 5);
         sp2.visible = true;
         if(_loc1_ == this.allPlanetMC.length - 1 && _loc2_ >= 100)
         {
            sp2.visible = false;
            return;
         }
         if(_loc7_ < this.allMaskMC.length && Boolean(this.allMaskMC[_loc7_]))
         {
            this.allMaskMC[_loc7_].visible = true;
         }
      }
      
      private function updateRedDot(param1:Boolean) : void
      {
         if(param1)
         {
            this.missionInfoBg.addChild(this.buttonHighlight);
         }
         else if(Boolean(this.buttonHighlight.parent) && this.buttonHighlight.parent == this.missionInfoBg)
         {
            this.missionInfoBg.removeChild(this.buttonHighlight);
         }
      }
      
      private function tryCreateAndOpen() : Boolean
      {
         var windowId:String = null;
         var window:IWindow = null;
         var uiSetup:HintWindowViewSetup = null;
         var creationVO:SimpleWindowCreationVO = null;
         try
         {
            windowId = GuiConstants.SPACE_SEARCH_OBJECTIVES;
            window = GuiManager.instance.getWindow(windowId);
            if(!window)
            {
               uiSetup = new HintWindowViewSetup();
               uiSetup.setUp();
               creationVO = SimpleWindowCreationMap.getById(windowId);
               if(creationVO)
               {
                  facade.sendNotification(GuiNotifications.CREATE_SIMPLE_WINDOW,creationVO);
                  window = guiManager.getWindow(windowId);
               }
               else
               {
                  window = guiManager.createWindow(windowId);
               }
               window.maximize();
               return true;
            }
            if(window.maximized)
            {
               window.minimize();
            }
            else
            {
               window.maximize();
            }
            return true;
         }
         catch(e:Error)
         {
         }
         return false;
      }
   }
}

