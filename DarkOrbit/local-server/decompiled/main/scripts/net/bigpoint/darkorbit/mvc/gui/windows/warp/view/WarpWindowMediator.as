package net.bigpoint.darkorbit.mvc.gui.windows.warp.view
{
   import flash.events.MouseEvent;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.com.module.ShipWarpModule;
   import net.bigpoint.darkorbit.com.module.ShipWarpRequest;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.data.VectorCollection;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemList;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemListEvent;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowEvent;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.featuresMenu.FeaturesMenuNotifications;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.interfaces.IWindow;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.mediator.SimpleWindowMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.warp.WarpWindowNotifications;
   import net.bigpoint.darkorbit.mvc.gui.windows.warp.model.vo.WarpWindowVO;
   import net.bigpoint.darkorbit.mvc.gui.windows.warp.view.ui.WarpShipsAssigner;
   import net.bigpoint.darkorbit.net.ConnectionManager;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class WarpWindowMediator extends SimpleWindowMediator
   {
      
      private var _currentShipWarpModule:ShipWarpModule;
      
      private var _isNearSpaceStation:Boolean;
      
      private var _warpWindowVO:WarpWindowVO = null;
      
      private var _shipDataUpdated:Boolean = false;
      
      private var _comps:WarpWindowComponents;
      
      private var _currentIndex:int;
      
      private var _con:ConnectionManager;
      
      public function WarpWindowMediator(param1:String, param2:IWindow)
      {
         super(param1,param2);
         this._comps = new WarpWindowComponents(param2.getUIContainer());
      }
      
      override public function onRegister() : void
      {
         super.onRegister();
         window.addEventListener(SimpleWindowEvent.ON_MINIMIZE,this.minimizeHandler);
         this._con = guiManager.getMain().getConnectionManager();
         window.setSize(500,310);
      }
      
      override public function onRemove() : void
      {
         this.removeListeners();
         super.onRemove();
      }
      
      override public function listNotificationInterests() : Array
      {
         var _loc1_:Array = super.listNotificationInterests();
         _loc1_.push(WarpWindowNotifications.WARP_WINDOW_SHIPS_UPDATED);
         _loc1_.push(WarpWindowNotifications.WARP_WINDOW_MINIMIZE);
         return _loc1_;
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         super.handleNotification(param1);
         var _loc2_:String = param1.getName();
         switch(_loc2_)
         {
            case WarpWindowNotifications.WARP_WINDOW_SHIPS_UPDATED:
               this.updateDataModel(param1);
               break;
            case WarpWindowNotifications.WARP_WINDOW_MINIMIZE:
               this.minimizeWindow();
         }
      }
      
      private function updateDataModel(param1:INotification) : void
      {
         if(this._warpWindowVO)
         {
            this._warpWindowVO.changed.remove(this.warpWindowShipsUpdated);
         }
         this._warpWindowVO = param1.getBody() as WarpWindowVO;
         if(this._warpWindowVO)
         {
            this._warpWindowVO.changed.add(this.warpWindowShipsUpdated);
         }
         this.warpWindowShipsUpdated();
      }
      
      override protected function handleLoadAndBuildContentCallback(param1:Array) : void
      {
         super.handleLoadAndBuildContentCallback(param1);
         this.setListeners();
         if(this._shipDataUpdated)
         {
            this.validateShipData();
         }
      }
      
      public function checkWarpableStatus() : void
      {
         var _loc1_:Button = null;
         if(this._currentShipWarpModule)
         {
            _loc1_ = this._comps.confirmButton;
            if(this._isNearSpaceStation || Hero.jumpVouchersAmount > 0 || this._currentShipWarpModule.uridiumPrice < Hero.uridiumAmount)
            {
               _loc1_.enabled = true;
               _loc1_.addEventListener(MouseEvent.CLICK,this.handleConfirmButtonClicked);
            }
            else
            {
               _loc1_.enabled = false;
               _loc1_.removeEventListener(MouseEvent.CLICK,this.handleConfirmButtonClicked);
            }
         }
      }
      
      private function warpWindowShipsUpdated() : void
      {
         this._shipDataUpdated = true;
         if(isUIReady())
         {
            this.validateShipData();
         }
      }
      
      private function setListeners() : void
      {
         this._comps.rightListButton.addEventListener(MouseEvent.CLICK,this.handleRightClicked);
         this._comps.leftListButton.addEventListener(MouseEvent.CLICK,this.handleLeftClicked);
         this._comps.shipsItemList.addEventListener(ItemListEvent.ITEM_SELECTION_CHANGED,this.handleSelectionChanged);
      }
      
      private function removeListeners() : void
      {
         window.removeEventListener(SimpleWindowEvent.ON_MINIMIZE,this.minimizeHandler);
         this._comps.confirmButton.removeEventListener(MouseEvent.CLICK,this.handleConfirmButtonClicked);
         this._comps.rightListButton.removeEventListener(MouseEvent.CLICK,this.handleRightClicked);
         this._comps.leftListButton.removeEventListener(MouseEvent.CLICK,this.handleLeftClicked);
         this._comps.shipsItemList.removeEventListener(ItemListEvent.ITEM_SELECTION_CHANGED,this.handleSelectionChanged);
      }
      
      private function validateShipData() : void
      {
         this._comps.confirmButton.enabled = false;
         this._shipDataUpdated = false;
         this._isNearSpaceStation = this._warpWindowVO.isNearSpacestation;
         this.handleCostFieldUpdates();
         var _loc1_:ItemList = this._comps.shipsItemList;
         var _loc2_:Vector.<ShipWarpModule> = this.returnSortedShips(this._warpWindowVO.ships);
         _loc1_.itemDataAssigner = WarpShipsAssigner;
         _loc1_.list = new VectorCollection(_loc2_);
      }
      
      private function returnSortedShips(param1:Vector.<ShipWarpModule>) : Vector.<ShipWarpModule>
      {
         var _loc3_:int = 0;
         var _loc4_:ShipWarpModule = null;
         var _loc5_:ShipWarpModule = null;
         var _loc6_:ShipWarpModule = null;
         var _loc2_:Boolean = false;
         while(!_loc2_)
         {
            _loc2_ = true;
            _loc3_ = 0;
            while(_loc3_ < param1.length - 1)
            {
               _loc4_ = param1[_loc3_] as ShipWarpModule;
               _loc5_ = param1[_loc3_ + 1] as ShipWarpModule;
               if(_loc4_.hangarId > _loc5_.hangarId)
               {
                  _loc2_ = false;
                  _loc6_ = param1[_loc3_];
                  param1[_loc3_] = param1[_loc3_ + 1];
                  param1[_loc3_ + 1] = _loc6_;
                  _loc6_ = null;
               }
               _loc3_++;
            }
         }
         return param1;
      }
      
      private function minimizeWindow() : void
      {
         if(window.maximized && !window.isTweening())
         {
            window.minimize();
            this.minimizeHandler();
            sendNotification(FeaturesMenuNotifications.TOGGLE_BTN_SELECTION,false,GuiConstants.SHIP_WARP_WINDOW);
         }
      }
      
      private function maximizeWindow() : void
      {
         window.maximize();
         sendNotification(FeaturesMenuNotifications.TOGGLE_BTN_SELECTION,true,GuiConstants.SHIP_WARP_WINDOW);
      }
      
      private function handleCostFieldUpdates(param1:ShipWarpModule = null) : void
      {
         var _loc2_:ShipWarpModule = null;
         if(param1)
         {
            _loc2_ = param1;
         }
         else
         {
            _loc2_ = this._currentShipWarpModule;
         }
         if(this._isNearSpaceStation)
         {
            this.shipNearSpaceStationPrices(_loc2_);
         }
         else
         {
            this.shipNotNearSpaceStationPrices(_loc2_);
         }
      }
      
      private function shipNearSpaceStationPrices(param1:ShipWarpModule) : void
      {
         if(param1 != null)
         {
            this._comps.warpCost.text = BPLocale.getItem("pricetag_uridium_compact").replace(/%VALUE%/,"0");
         }
         else
         {
            this._comps.warpCost.text = "-";
         }
         this._comps.jumpCreditCost.text = BPLocale.getItem("desc_shipwarp_costs_spacestation");
      }
      
      private function shipNotNearSpaceStationPrices(param1:ShipWarpModule) : void
      {
         this._comps.warpCost.text = BPLocale.getItem("pricetag_uridium_compact").replace(/%VALUE%/,"0");
         this._comps.jumpCreditCost.text = " ";
         if(param1 != null)
         {
            if(Hero.jumpVouchersAmount > 0)
            {
               this.setVoucherPrices(param1);
            }
            else
            {
               this._comps.warpCost.text = BPLocale.getItem("pricetag_uridium_compact").replace(/%VALUE%/,param1.uridiumPrice.toString());
               this._comps.jumpCreditCost.text = " ";
            }
         }
         else
         {
            this._comps.warpCost.text = "-";
         }
      }
      
      private function setVoucherPrices(param1:ShipWarpModule) : void
      {
         this._comps.warpCost.text = BPLocale.getItem("pricetag_uridium_compact").replace(/%VALUE%/,param1.uridiumPrice.toString());
         if(param1.voucherPrice == 1)
         {
            this._comps.jumpCreditCost.text += BPLocale.getItem("desc_shipwarp_costs_jump-voucher_s");
         }
         else
         {
            this._comps.jumpCreditCost.text += BPLocale.getItem("desc_shipwarp_costs_jump-voucher_p").replace("%COUNT%",param1.voucherPrice);
         }
         if(Hero.jumpVouchersAmount == 1)
         {
            this._comps.jumpCreditCost.text += BPLocale.getItem("desc_shipwarp_remaining_jump-voucher_s");
         }
         else
         {
            this._comps.jumpCreditCost.text += BPLocale.getItem("desc_shipwarp_remaining_jump-voucher_p").replace("%REMAINING%",Hero.jumpVouchersAmount);
         }
      }
      
      private function minimizeHandler(param1:SimpleWindowEvent = null) : void
      {
         var _loc2_:ItemList = this._comps.shipsItemList;
         _loc2_.clearList();
         this._currentShipWarpModule = null;
         this._comps.confirmButton.enabled = false;
      }
      
      private function handleRightClicked(param1:MouseEvent) : void
      {
         var _loc2_:ItemList = this._comps.shipsItemList;
         var _loc3_:Number = _loc2_.getScrollOneItemAmount();
         _loc2_.setScrollPositionInPercent(_loc2_.getScrollPositionInPercent() + _loc3_);
      }
      
      private function handleLeftClicked(param1:MouseEvent) : void
      {
         var _loc2_:ItemList = this._comps.shipsItemList;
         var _loc3_:Number = _loc2_.getScrollOneItemAmount();
         _loc2_.setScrollPositionInPercent(_loc2_.getScrollPositionInPercent() - _loc3_);
      }
      
      private function handleSelectionChanged(param1:ItemListEvent) : void
      {
         this._currentIndex = param1.item.index;
         this._currentShipWarpModule = param1.itemVO as ShipWarpModule;
         this.checkWarpableStatus();
         this.handleCostFieldUpdates();
      }
      
      private function handleConfirmButtonClicked(param1:MouseEvent) : void
      {
         var _loc2_:ShipWarpRequest = new ShipWarpRequest();
         _loc2_.shipId = this._currentShipWarpModule.shipId;
         this.minimizeWindow();
         this._con.sendRequest(_loc2_);
         sendNotification(FeaturesMenuNotifications.TOGGLE_BTN_SELECTION,false,GuiConstants.SHIP_WARP_WINDOW);
      }
   }
}

