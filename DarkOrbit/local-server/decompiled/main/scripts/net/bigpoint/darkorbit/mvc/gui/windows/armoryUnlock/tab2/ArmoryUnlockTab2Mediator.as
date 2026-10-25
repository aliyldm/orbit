package net.bigpoint.darkorbit.mvc.gui.windows.armoryUnlock.tab2
{
   import com.bigpoint.utils.BitmapAtlas;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.events.MouseEvent;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.as3toolbox.filecollection.finish.ImageFinisher;
   import net.bigpoint.as3toolbox.filecollection.finish.XMLFinisher;
   import net.bigpoint.darkorbit.com.module.porting.armoryunlock.ArmoryUnlockDrawRequest;
   import net.bigpoint.darkorbit.com.module.porting.armoryunlock.ArmoryUnlockLootShowListCommand;
   import net.bigpoint.darkorbit.com.module.porting.armoryunlock.ArmoryUnlockSelectGroupRequest;
   import net.bigpoint.darkorbit.com.module.porting.events.LootProbabilityModule;
   import net.bigpoint.darkorbit.delete_in_eic.IconVOLoader;
   import net.bigpoint.darkorbit.delete_in_eic.ItemDataProviderHelper;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.components.video.VideoPlayer;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.map.model.ship.patterns.ShipPattern;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.messages.controller.MessageCommandParams;
   import net.bigpoint.darkorbit.mvc.gui.windows.CreatePopupView;
   import net.bigpoint.darkorbit.mvc.gui.windows.armoryUnlock.ArmoryUnlockTab;
   import net.bigpoint.darkorbit.mvc.gui.windows.armoryUnlock.handler.ArmoryUnlockInfoData;
   import net.bigpoint.darkorbit.mvc.gui.windows.armoryUnlock.handler.ArmoryUnlockShipData;
   import net.bigpoint.darkorbit.net.JavascriptProxy;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   import net.bigpoint.darkorbit.utils.math.FastMath;
   
   public class ArmoryUnlockTab2Mediator extends ArmoryUnlockTab
   {
      
      private static const SHIP_COUNT:int = 3;
      
      private static const LOCK_ICON_TEXTURE_RESOURCE_ID:String = "lock_icon_texture";
      
      private static const LOCK_ICON_ATLAS_XML_RESOURCE_ID:String = "lock_icon_atlasXml";
      
      private static const LOCK_ICON_ID:String = "lock_img";
      
      protected var tips:String = "";
      
      protected var lootAmount:int;
      
      protected var lootId:String;
      
      private var tab2:ArmoryUnlockTab2View;
      
      private var shipSelectButtons:Vector.<Button>;
      
      private var lockButton:Button;
      
      private var explore01Button:Button;
      
      private var explore10Button:Button;
      
      private var drawOnceCost:Coreponent;
      
      private var drawTenCost:Coreponent;
      
      private var description:Label;
      
      private var infoBtn001:Button;
      
      private var infoBtn002:Button;
      
      private var icon001:Coreponent;
      
      private var icon003:Coreponent;
      
      private var icon004:Coreponent;
      
      private var label001:Label;
      
      private var itemVideoPlayers:Vector.<VideoPlayer>;
      
      private var _viewData:ArmoryUnlockInfoData;
      
      private var lockIconTextureFinisher:ImageFinisher;
      
      private var lockIconAtlasXmlFinisher:XMLFinisher;
      
      private var lockIconBitmapData:BitmapData;
      
      public function ArmoryUnlockTab2Mediator(param1:String, param2:SimpleWindow)
      {
         super(param1,param2);
      }
      
      public function setView(param1:ArmoryUnlockTab2View) : void
      {
         var _loc3_:Button = null;
         this.tab2 = param1;
         this.tab2.body.visible = false;
         this.cardsContainer = this.tab2.cardsContainer;
         this.icon001 = this.tab2.icon001;
         this.icon003 = this.tab2.icon003;
         this.icon004 = this.tab2.icon004;
         this.label001 = this.tab2.label001;
         this.description = this.tab2.description;
         this.infoBtn001 = this.tab2.infoBtn001;
         this.infoBtn002 = this.tab2.infoBtn002;
         this.explore01Button = this.tab2.explore01Btn;
         this.explore10Button = this.tab2.explore10Btn;
         this.drawOnceCost = this.tab2.drawOnceCost;
         this.drawTenCost = this.tab2.drawTenCost;
         this.lockButton = this.tab2.lockBtn;
         this.explore01Button.addEventListener(MouseEvent.MOUSE_DOWN,this.onExplore01BtnClick);
         this.explore10Button.addEventListener(MouseEvent.MOUSE_DOWN,this.onExplore10BtnClick);
         this.lockButton.addEventListener(MouseEvent.CLICK,this.onLockShipClick);
         this.setDrawButtons(false);
         this.lockButton.enabled = false;
         this.loadLockIconResources();
         this.shipSelectButtons = new Vector.<Button>();
         this.itemVideoPlayers = new Vector.<VideoPlayer>();
         var _loc2_:int = 0;
         while(_loc2_ < SHIP_COUNT)
         {
            _loc3_ = this.tab2.getShipSelectButton(_loc2_);
            _loc3_.addEventListener(MouseEvent.CLICK,this.onShipSelected);
            this.shipSelectButtons.push(_loc3_);
            this.itemVideoPlayers.push(this.tab2.getVideoPlayer(_loc2_));
            _loc2_++;
         }
      }
      
      public function updateData(param1:ArmoryUnlockInfoData) : void
      {
         var _loc2_:ArmoryUnlockShipData = null;
         var _loc4_:Boolean = false;
         this._viewData = param1;
         if(!param1 || !param1.shipList || param1.shipList.length == 0)
         {
            this.tab2.body.visible = false;
            this.lockButton.visible = false;
            this.lockButton.enabled = false;
            this.setDrawButtons(false);
            return;
         }
         if(param1.selectedShipIndex < 0 || param1.selectedShipIndex >= param1.shipList.length)
         {
            param1.selectedShipIndex = 0;
         }
         if(param1.lockedShipIndex >= param1.shipList.length)
         {
            param1.lockedShipIndex = -1;
         }
         if(param1.selectionLocked && param1.lockedShipIndex >= 0)
         {
            param1.selectedShipIndex = param1.lockedShipIndex;
         }
         this.updateShipSelection(param1.shipList,param1.selectedShipIndex,param1.selectionLocked,param1.lockedShipIndex);
         _loc2_ = param1.shipList[param1.selectedShipIndex];
         if(!_loc2_ || !_loc2_.lootShowList)
         {
            return;
         }
         var _loc3_:ArmoryUnlockLootShowListCommand = _loc2_.lootShowList;
         this.lootAmount = _loc3_.resourceAmount;
         this.lootId = _loc3_.resourceLootId;
         this.tab2.body.visible = true;
         super.updateData0(_loc3_);
         this.updateResource(_loc3_);
         this.updateDescription(_loc2_.shipLootId);
         this.updateProbabilityTooltip(_loc3_);
         _loc4_ = param1.selectionLocked && param1.selectedGroup > 0;
         this.lockButton.visible = !_loc4_;
         this.lockButton.enabled = !_loc4_;
         this.setDrawButtons(_loc4_);
      }
      
      protected function goHtmlShop() : void
      {
         var sendRequest:Function = function():void
         {
            JavascriptProxy.referToURL("internalDock&tpl=internalDockSpecials&shopItem=package_event-deal-ftl-s",null);
         };
         CreatePopupView.getInstance().createPopup(sendRequest,BPLocale.getItem("SS_explore_nomaterials_2"));
      }
      
      private function updateShipSelection(param1:Vector.<ArmoryUnlockShipData>, param2:int, param3:Boolean, param4:int) : void
      {
         var _loc6_:ArmoryUnlockShipData = null;
         var _loc7_:Coreponent = null;
         var _loc8_:Coreponent = null;
         var _loc9_:Coreponent = null;
         var _loc10_:Boolean = false;
         var _loc5_:int = 0;
         while(_loc5_ < SHIP_COUNT)
         {
            _loc6_ = _loc5_ < param1.length ? param1[_loc5_] : null;
            _loc7_ = this.tab2.getShipContainer(_loc5_);
            _loc8_ = this.tab2.getShipSelectedOverlay(_loc5_);
            _loc9_ = this.tab2.getShipLockedOverlay(_loc5_);
            _loc10_ = _loc6_ != null && param4 >= 0 && _loc5_ != param4;
            _loc7_.visible = _loc6_ != null;
            _loc8_.visible = _loc6_ != null && _loc5_ == param2;
            _loc9_.visible = _loc10_;
            this.updateLockIcon(_loc5_,_loc10_);
            this.shipSelectButtons[_loc5_].enabled = _loc6_ != null && !param3;
            this.shipSelectButtons[_loc5_].mouseEnabled = _loc6_ != null && !param3;
            this.shipSelectButtons[_loc5_].visible = _loc6_ != null;
            if(_loc6_)
            {
               this.updateShip(_loc5_,_loc6_);
            }
            _loc7_.mouseEnabled = _loc6_ != null && !_loc10_;
            _loc5_++;
         }
      }
      
      private function loadLockIconResources() : void
      {
         var _loc1_:AssetsProxy = GameFacade.getInstance().retrieveProxy(AssetsProxy.NAME) as AssetsProxy;
         if(Boolean(_loc1_) && Boolean(_loc1_.getBitmapAtlasById(LOCK_ICON_ATLAS_XML_RESOURCE_ID)))
         {
            this.lockIconBitmapData = _loc1_.getBitmapDataFromAtlas(LOCK_ICON_ID,LOCK_ICON_ATLAS_XML_RESOURCE_ID);
            return;
         }
         ResourceManager.fileCollection.load(LOCK_ICON_TEXTURE_RESOURCE_ID,this.handleLockIconTextureLoaded);
         ResourceManager.fileCollection.load(LOCK_ICON_ATLAS_XML_RESOURCE_ID,this.handleLockIconAtlasLoaded);
      }
      
      private function handleLockIconTextureLoaded(param1:ImageFinisher) : void
      {
         this.lockIconTextureFinisher = param1;
         this.initializeLockIconAtlas();
      }
      
      private function handleLockIconAtlasLoaded(param1:XMLFinisher) : void
      {
         this.lockIconAtlasXmlFinisher = param1;
         this.initializeLockIconAtlas();
      }
      
      private function initializeLockIconAtlas() : void
      {
         if(Boolean(this.lockIconBitmapData) || Boolean(!this.lockIconTextureFinisher) || !this.lockIconAtlasXmlFinisher)
         {
            return;
         }
         var _loc1_:BitmapAtlas = new BitmapAtlas(this.lockIconTextureFinisher.getBitmap(),this.lockIconAtlasXmlFinisher.getXML());
         var _loc2_:AssetsProxy = GameFacade.getInstance().retrieveProxy(AssetsProxy.NAME) as AssetsProxy;
         if(_loc2_)
         {
            _loc2_.addBitmapAtlas(LOCK_ICON_ATLAS_XML_RESOURCE_ID,_loc1_);
            this.lockIconBitmapData = _loc2_.getBitmapDataFromAtlas(LOCK_ICON_ID,LOCK_ICON_ATLAS_XML_RESOURCE_ID);
         }
         this.refreshLockIcons();
      }
      
      private function refreshLockIcons() : void
      {
         if(!this._viewData || !this._viewData.shipList)
         {
            return;
         }
         var _loc1_:int = this._viewData.lockedShipIndex;
         var _loc2_:int = 0;
         while(_loc2_ < SHIP_COUNT)
         {
            this.updateLockIcon(_loc2_,_loc2_ < this._viewData.shipList.length && _loc1_ >= 0 && _loc2_ != _loc1_);
            _loc2_++;
         }
      }
      
      private function updateLockIcon(param1:int, param2:Boolean) : void
      {
         var _loc3_:Coreponent = this.tab2.getShipLockIcon(param1);
         if(!_loc3_)
         {
            return;
         }
         _loc3_.visible = param2;
         if(!param2 || !this.lockIconBitmapData || _loc3_.numChildren > 0)
         {
            return;
         }
         var _loc4_:Bitmap = new Bitmap(this.lockIconBitmapData);
         _loc4_.x = (_loc3_.width - _loc4_.width) * 0.5;
         _loc4_.y = (_loc3_.height - _loc4_.height) * 0.5;
         _loc3_.addChild(_loc4_);
      }
      
      private function updateShip(param1:int, param2:ArmoryUnlockShipData) : void
      {
         var _loc3_:Label = this.tab2.getShipName(param1);
         var _loc4_:Coreponent = this.tab2.getShipContainer(param1);
         var _loc5_:ItemVO = Boolean(param2.shipLootId) && param2.shipLootId.length > 0 ? ItemDataProviderHelper.getItem(param2.shipLootId) : null;
         var _loc6_:ShipPattern = Boolean(param2.shipLootId) && param2.shipLootId.length > 0 ? PatternManager.shipPatterns[param2.shipLootId] as ShipPattern : null;
         var _loc7_:String = _loc6_ ? _loc6_.name : (_loc5_ ? _loc5_.fullname : param2.shipLootId);
         _loc3_.text = Boolean(_loc7_) && _loc7_.length > 0 ? _loc7_ : "Ship " + (param1 + 1);
         _loc4_.mouseEnabled = true;
         _loc4_.tooltipData = _loc5_ ? _loc5_.fullname + "\n" + _loc5_.rawDescription : _loc3_.text;
         if(_loc5_)
         {
            IconVOLoader.getInstance().loadIcon(this.tab2.getShipIcon(param1),_loc5_,"100x100",AssetsProxy.ITEMS);
         }
      }
      
      private function updateResource(param1:ArmoryUnlockLootShowListCommand) : void
      {
         var _loc2_:ItemVO = Boolean(param1.resourceLootId) && param1.resourceLootId.length > 0 ? ItemDataProviderHelper.getItem(param1.resourceLootId) : null;
         if(_loc2_)
         {
            this.infoBtn001.tooltipData = _loc2_.fullname + "\n" + _loc2_.sourceName;
            IconVOLoader.getInstance().loadIcon(this.icon001,_loc2_,"100x100",AssetsProxy.ITEMS);
            IconVOLoader.getInstance().loadIcon(this.icon003,_loc2_,"100x100",AssetsProxy.ITEMS);
            IconVOLoader.getInstance().loadIcon(this.icon004,_loc2_,"100x100",AssetsProxy.ITEMS);
         }
         this.label001.text = " " + param1.resourceAmount;
      }
      
      private function updateDescription(param1:String) : void
      {
         var _loc2_:ShipPattern = Boolean(param1) && param1.length > 0 ? PatternManager.shipPatterns[param1] as ShipPattern : null;
         var _loc3_:ItemVO = Boolean(param1) && param1.length > 0 ? ItemDataProviderHelper.getItem(param1) : null;
         var _loc4_:String = _loc2_ ? _loc2_.name : (_loc3_ ? _loc3_.fullname : param1);
         if(!_loc4_ || _loc4_.length == 0)
         {
            _loc4_ = "selected";
         }
         var _loc5_:String = BPLocale.getItem("armoryunlock_draw_mega_draw_info");
         if(!_loc5_ || _loc5_ == "armoryunlock_draw_mega_draw_info")
         {
            _loc5_ = "There is a chance to obtain the %SHIPS% ship\'s exclusive railgun!";
         }
         this.description.text = _loc5_.replace("%SHIPS%",_loc4_);
      }
      
      private function updateProbabilityTooltip(param1:ArmoryUnlockLootShowListCommand) : void
      {
         var _loc2_:int = 0;
         var _loc3_:LootProbabilityModule = null;
         var _loc4_:ItemVO = null;
         this.tips = "";
         if(param1.probabilityModuleList)
         {
            _loc2_ = 0;
            while(_loc2_ < param1.probabilityModuleList.length)
            {
               _loc3_ = param1.probabilityModuleList[_loc2_];
               if(_loc3_)
               {
                  _loc4_ = ItemDataProviderHelper.getItem(_loc3_.lootId);
                  if(_loc4_)
                  {
                     if(_loc3_.minLootAmount == _loc3_.maxLootAmount)
                     {
                        this.tips += _loc4_.fullname + " x" + _loc3_.minLootAmount + " " + FastMath.smartFormat(_loc3_.probabilityPercentage) + "%\n";
                     }
                     else
                     {
                        this.tips += _loc4_.fullname + " x " + _loc3_.minLootAmount + "-" + _loc3_.maxLootAmount + " " + FastMath.smartFormat(_loc3_.probabilityPercentage) + "%\n";
                     }
                  }
               }
               _loc2_++;
            }
         }
         this.infoBtn002.tooltipData = this.tips;
      }
      
      private function setDrawButtons(param1:Boolean) : void
      {
         this.explore01Button.visible = param1;
         this.explore10Button.visible = param1;
         this.explore01Button.enabled = param1;
         this.explore10Button.enabled = param1;
         this.drawOnceCost.visible = param1;
         this.drawTenCost.visible = param1;
      }
      
      private function showDrawPrompt() : void
      {
         GameFacade.getInstance().sendNotification(GuiNotifications.SHOW_MESSAGE_SCREEN,new MessageCommandParams().setMessage(BPLocale.getItem("armoryunlock_draw_prompt")));
      }
      
      private function lockSelectedShip(param1:int) : void
      {
         if(!this._viewData || this._viewData.selectionLocked || param1 < 0 || param1 >= this._viewData.shipList.length)
         {
            return;
         }
         var _loc2_:ArmoryUnlockShipData = this._viewData.shipList[param1];
         if(!_loc2_ || _loc2_.group <= 0)
         {
            return;
         }
         var _loc3_:ArmoryUnlockSelectGroupRequest = new ArmoryUnlockSelectGroupRequest();
         _loc3_.group = _loc2_.group;
         this.lockButton.enabled = false;
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,_loc3_);
      }
      
      private function onShipSelected(param1:MouseEvent) : void
      {
         if(!this._viewData || this._viewData.selectionLocked)
         {
            return;
         }
         var _loc2_:int = 0;
         while(_loc2_ < this.shipSelectButtons.length)
         {
            if(param1.currentTarget == this.shipSelectButtons[_loc2_])
            {
               this._viewData.selectedShipIndex = _loc2_;
               this._viewData.changed.dispatch();
               return;
            }
            _loc2_++;
         }
      }
      
      private function onLockShipClick(param1:MouseEvent) : void
      {
         var text:String;
         var confirmLock:Function;
         var shipIndexToLock:int = 0;
         var event:MouseEvent = param1;
         if(!this._viewData || this._viewData.selectionLocked)
         {
            return;
         }
         text = BPLocale.getItem("armoryunlock_draw_confirm_alert");
         shipIndexToLock = this._viewData.selectedShipIndex;
         confirmLock = function():void
         {
            lockSelectedShip(shipIndexToLock);
         };
         CreatePopupView.getInstance().createPopup(confirmLock,text);
      }
      
      private function onExplore01BtnClick(param1:MouseEvent) : void
      {
         if(Boolean(this._viewData) && this._viewData.canReset)
         {
            this.showDrawPrompt();
            return;
         }
         if(this.lootAmount < 1)
         {
            this.goHtmlShop();
            return;
         }
         this.setDrawButtons(false);
         var _loc2_:ArmoryUnlockDrawRequest = new ArmoryUnlockDrawRequest();
         _loc2_.type = 2;
         _loc2_.count = 1;
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,_loc2_);
      }
      
      private function onExplore10BtnClick(param1:MouseEvent) : void
      {
         if(Boolean(this._viewData) && this._viewData.canReset)
         {
            this.showDrawPrompt();
            return;
         }
         if(this.lootAmount < 10)
         {
            this.goHtmlShop();
            return;
         }
         this.setDrawButtons(false);
         var _loc2_:ArmoryUnlockDrawRequest = new ArmoryUnlockDrawRequest();
         _loc2_.type = 2;
         _loc2_.count = 10;
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,_loc2_);
      }
   }
}

