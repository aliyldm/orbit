package net.bigpoint.darkorbit.mvc.gui.windows.warpControls.ui
{
   import flash.events.MouseEvent;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.delete_in_eic.ItemFilterTypes;
   import net.bigpoint.darkorbit.fui.components.core.data.VectorCollection;
   import net.bigpoint.darkorbit.fui.system.utils.BindingsUtils;
   import net.bigpoint.darkorbit.gui.GuiManager;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowCreationVO;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.windows.SimpleWindowCreationMap;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.interfaces.IWindow;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.mediator.SimpleWindowMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.warpControls.golbalEvent.EventCenter;
   import net.bigpoint.darkorbit.mvc.gui.windows.warpControls.golbalEvent.GameEvent;
   import net.bigpoint.darkorbit.mvc.gui.windows.warpControls.golbalEvent.GameEventConst;
   import net.bigpoint.darkorbit.mvc.gui.windows.warpControls.mode.WarpControlsConst;
   import net.bigpoint.darkorbit.mvc.gui.windows.warpControls.mode.WarpControlsProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.warpControls.mode.vo.WarpChangeData;
   import net.bigpoint.darkorbit.mvc.gui.windows.warpControls.mode.vo.WarpControlsItemData;
   import net.bigpoint.darkorbit.mvc.gui.windows.warpControls.ui.item.WarpControlsListItemRender;
   import net.bigpoint.darkorbit.mvc.hintSystem.view.hintWindow.uistructures.HintWindowViewSetup;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class WarpControlsUIMediator extends SimpleWindowMediator
   {
      
      public static const NAME:String = "WarpControlsUIMediator";
      
      private var _view:WarpControlsView;
      
      private var proxy:WarpControlsProxy;
      
      private var _currentSetId:int = 1;
      
      public function WarpControlsUIMediator(param1:String, param2:SimpleWindow)
      {
         super(param1,param2);
      }
      
      public function get view() : WarpControlsView
      {
         return this._view;
      }
      
      override protected function handleLoadAndBuildContentCallback(param1:Array) : void
      {
         super.handleLoadAndBuildContentCallback(param1);
         this._view = new WarpControlsView(simpleWindow);
         this.view.centerView.upList.itemDataAssigner = WarpControlsListItemRender;
         this.view.centerView.dowList.itemDataAssigner = WarpControlsListItemRender;
         this.view.centerView.quantumList.itemDataAssigner = WarpControlsListItemRender;
         this.view.right_list.itemDataAssigner = WarpControlsListItemRender;
         this.view.right_list_bg.itemDataAssigner = WarpControlsListItemRender;
         this.view.centerView_tab2.upList.itemDataAssigner = WarpControlsListItemRender;
         this.view.centerView_tab2.dowList.itemDataAssigner = WarpControlsListItemRender;
         this.view.shipView.title_Label.text = BPLocale.getItemInCategory("","mini_hanger_configuration");
         this.view.centerView.up_title_label.text = BPLocale.getItemInCategory("","mini_hanger_slot_railgun");
         this.view.centerView.down_title_label.text = BPLocale.getItemInCategory("","mini_hanger_slot_refractor");
         this.view.centerView.quantum_title_label.text = BPLocale.getItemInCategory("inventory","label_slotset_ship_luck_module");
         this.view.right_title_label.text = BPLocale.getItemInCategory("","mini_hanger_inventory");
         this.view.centerView_tab2.up_title_label.text = BPLocale.getItemInCategory("","hangar_spaceship_drive_attack");
         this.view.centerView_tab2.down_title_label.text = BPLocale.getItemInCategory("","hangar_spaceship_lens_defense");
         this.addEventListener();
         this.tryCreateAndOpen();
         this.initData();
      }
      
      override public function listNotificationInterests() : Array
      {
         return [GuiNotifications.WARP_CONTROLS_INIT,GuiNotifications.WARP_CONTROLS_UPDATE];
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         super.handleNotification(param1);
         switch(param1.getName())
         {
            case GuiNotifications.WARP_CONTROLS_INIT:
               this.initData();
               break;
            case GuiNotifications.WARP_CONTROLS_UPDATE:
               if(window.maximized)
               {
                  this.proxy.sendListRequest();
               }
         }
      }
      
      private function initData() : void
      {
         this.proxy = WarpControlsProxy.getProxy(this.facade);
         if(Boolean(this.view) && this.proxy.isDataComplete)
         {
            this.view.right_list_bg.list = new VectorCollection(this.nullListData(24));
            this.view.right_list.list = new VectorCollection(this.proxy.getAllNotHangarItems(this._currentSetId));
            BindingsUtils.bindScrollComponents(this.view.right_list,this.view.right_list_scroll);
            this.view.shipView.shipData = this.proxy.shipData;
            this.updateShipListView();
            BindingsUtils.bindScrollComponents(this.view.centerView.upList,this.view.centerView.up_scroll_bar);
            BindingsUtils.bindScrollComponents(this.view.centerView.dowList,this.view.centerView.down_scroll_bar);
            BindingsUtils.bindScrollComponents(this.view.centerView.quantumList,this.view.centerView.quantum_scroll_bar);
            BindingsUtils.bindScrollComponents(this.view.centerView_tab2.upList,this.view.centerView_tab2.up_scroll_bar);
            BindingsUtils.bindScrollComponents(this.view.centerView_tab2.dowList,this.view.centerView_tab2.down_scroll_bar);
         }
      }
      
      private function updateInventory() : void
      {
         this.view.right_list.list = new VectorCollection(this.proxy.getAllNotHangarItems(this._currentSetId));
      }
      
      private function updateShipListView() : void
      {
         this.view.centerView.upList.list = new VectorCollection(this.proxy.getShipCannonDatas(this._currentSetId));
         this.view.centerView.dowList.list = new VectorCollection(this.proxy.getShipCannonShieldsDatas(this._currentSetId));
         this.view.centerView.quantumList.list = new VectorCollection(this.proxy.getShipQuantumFluidCoreDatas(this._currentSetId));
         this.view.centerView_tab2.upList.list = new VectorCollection(this.proxy.getShipDrivesDatas(this._currentSetId));
         this.view.centerView_tab2.dowList.list = new VectorCollection(this.proxy.getShipLensDatas(this._currentSetId));
      }
      
      override public function onRegister() : void
      {
         super.onRegister();
      }
      
      override public function onRemove() : void
      {
         this.removeEventListener();
         super.onRemove();
      }
      
      private function addEventListener() : void
      {
         EventCenter.instance.addEventListener(GameEventConst.CLICK_WARP_CONTROLS_VIEW_ITEM,this.clickItem);
         this.view.shipView.btn1.addEventListener(MouseEvent.CLICK,this.clickBtn);
         this.view.shipView.btn2.addEventListener(MouseEvent.CLICK,this.clickBtn);
         this.view.centerPageBtn1.addEventListener(MouseEvent.CLICK,this.clickCenterPageBtn);
         this.view.centerPageBtn2.addEventListener(MouseEvent.CLICK,this.clickCenterPageBtn);
      }
      
      private function removeEventListener() : void
      {
         EventCenter.instance.removeEventListener(GameEventConst.CLICK_WARP_CONTROLS_VIEW_ITEM,this.clickItem);
         this.view.shipView.btn1.removeEventListener(MouseEvent.CLICK,this.clickBtn);
         this.view.shipView.btn2.removeEventListener(MouseEvent.CLICK,this.clickBtn);
         this.view.centerPageBtn1.removeEventListener(MouseEvent.CLICK,this.clickCenterPageBtn);
         this.view.centerPageBtn2.removeEventListener(MouseEvent.CLICK,this.clickCenterPageBtn);
      }
      
      private function clickCenterPageBtn(param1:MouseEvent) : void
      {
         if(param1.target == this.view.centerPageBtn1)
         {
            this.view.updateBtnVisible(1);
            this.view.centerView.visible = true;
            this.view.centerView_tab2.visible = false;
         }
         else if(param1.target == this.view.centerPageBtn2)
         {
            this.view.updateBtnVisible(2);
            this.view.centerView.visible = false;
            this.view.centerView_tab2.visible = true;
         }
      }
      
      public function getSetId() : int
      {
         return this._currentSetId;
      }
      
      private function clickBtn(param1:MouseEvent) : void
      {
         if(param1.target == this.view.shipView.btn1)
         {
            this.view.shipView.updateBtnVisible(1);
            this._currentSetId = 1;
         }
         else if(param1.target == this.view.shipView.btn2)
         {
            this.view.shipView.updateBtnVisible(2);
            this._currentSetId = 2;
         }
         this.updateShipListView();
         this.updateInventory();
      }
      
      private function clickItem(param1:GameEvent) : void
      {
         var _loc2_:WarpControlsItemData = param1.body as WarpControlsItemData;
         if(!_loc2_.itemVo)
         {
            return;
         }
         var _loc3_:WarpChangeData = new WarpChangeData();
         if(_loc2_.itemVo.lootType == ItemFilterTypes.Weapon__CannonType)
         {
            _loc3_.slotSet = WarpControlsConst.CANNONS;
         }
         else if(_loc2_.itemVo.lootType == ItemFilterTypes.Weapon__CannonShieldType)
         {
            _loc3_.slotSet = WarpControlsConst.CANNON_SHIELDS;
         }
         else if(_loc2_.itemVo.lootType == ItemFilterTypes.Weapon__QuantumFluidCoreType)
         {
            _loc3_.slotSet = WarpControlsConst.QUANTUMFLUIDCORE;
         }
         else if(_loc2_.itemVo.lootType == ItemFilterTypes.Equipment__DriveType)
         {
            _loc3_.slotSet = WarpControlsConst.ENGINE_WEAPON;
         }
         else if(_loc2_.itemVo.lootType == ItemFilterTypes.Equipment__LensType)
         {
            _loc3_.slotSet = WarpControlsConst.ENGINE_ARMOR;
         }
         _loc3_.hangarId = this.proxy.shipData.hangarId;
         _loc3_.configId = this._currentSetId;
         switch(_loc2_.viewName)
         {
            case WarpControlsConst.INVENTORY:
               _loc3_.items.push(_loc2_.itemVo.itemid);
               _loc3_.source = WarpControlsConst.INVENTORY;
               _loc3_.destination = WarpControlsConst.SHIP;
               break;
            case WarpControlsConst.CANNON_SHIELDS:
               _loc3_.items.push(_loc2_.itemVo.itemid);
               _loc3_.source = WarpControlsConst.SHIP;
               _loc3_.destination = WarpControlsConst.INVENTORY;
               break;
            case WarpControlsConst.CANNONS:
               _loc3_.items.push(_loc2_.itemVo.itemid);
               _loc3_.source = WarpControlsConst.SHIP;
               _loc3_.destination = WarpControlsConst.INVENTORY;
               break;
            case WarpControlsConst.QUANTUMFLUIDCORE:
               _loc3_.items.push(_loc2_.itemVo.itemid);
               _loc3_.source = WarpControlsConst.SHIP;
               _loc3_.destination = WarpControlsConst.INVENTORY;
               break;
            case WarpControlsConst.ENGINE_WEAPON:
               _loc3_.items.push(_loc2_.itemVo.itemid);
               _loc3_.source = WarpControlsConst.SHIP;
               _loc3_.destination = WarpControlsConst.INVENTORY;
               break;
            case WarpControlsConst.ENGINE_ARMOR:
               _loc3_.items.push(_loc2_.itemVo.itemid);
               _loc3_.source = WarpControlsConst.SHIP;
               _loc3_.destination = WarpControlsConst.INVENTORY;
         }
         this.proxy.shipsItemMoveRequest(_loc3_);
      }
      
      private function removeListItemData(param1:WarpControlsItemData) : *
      {
         var _loc2_:String = null;
         switch(param1.viewName)
         {
            case WarpControlsConst.INVENTORY:
               _loc2_ = param1.itemVo.lootType == ItemFilterTypes.Weapon__CannonShieldType ? WarpControlsConst.CANNON_SHIELDS : WarpControlsConst.CANNONS;
               this.proxy.shipData.addEquipment(_loc2_,this._currentSetId,param1.itemVo.itemid);
               this.proxy.setItemHangarID(param1.itemVo.itemid,this.proxy.shipData.hangarId);
               break;
            case WarpControlsConst.CANNON_SHIELDS:
               this.proxy.shipData.removeEquipment(WarpControlsConst.CANNON_SHIELDS,this._currentSetId,param1.itemVo.itemid);
               this.proxy.setItemHangarID(param1.itemVo.itemid,0);
               break;
            case WarpControlsConst.CANNONS:
               this.proxy.shipData.removeEquipment(WarpControlsConst.CANNONS,this._currentSetId,param1.itemVo.itemid);
               this.proxy.setItemHangarID(param1.itemVo.itemid,0);
         }
      }
      
      private function nullListData(param1:int, param2:Boolean = false) : Vector.<Object>
      {
         var _loc3_:Vector.<Object> = new Vector.<Object>();
         var _loc4_:int = 0;
         _loc4_ = 0;
         while(_loc4_ < param1)
         {
            _loc3_.push({"icon":""});
            _loc4_++;
         }
         return _loc3_;
      }
      
      private function tryCreateAndOpen() : Boolean
      {
         var windowId:String = null;
         var window:IWindow = null;
         var uiSetup:HintWindowViewSetup = null;
         var creationVO:SimpleWindowCreationVO = null;
         try
         {
            windowId = GuiConstants.WARP_CONTROLS;
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
            }
            window.maximize();
            return true;
         }
         catch(e:Error)
         {
         }
         return false;
      }
   }
}

