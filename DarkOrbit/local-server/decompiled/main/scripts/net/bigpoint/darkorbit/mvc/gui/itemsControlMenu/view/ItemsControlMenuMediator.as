package net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.view
{
   import com.bigpoint.utils.drag.DragEvent;
   import com.bigpoint.utils.drag.DragManager;
   import com.greensock.TweenLite;
   import flash.display.BitmapData;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.mvc.abstract.view.DOAbstractMediator;
   import net.bigpoint.darkorbit.mvc.common.utils.TextUtils;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.ItemsControlMenuConstants;
   import net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.ItemsControlMenuNotifications;
   import net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.model.ItemsControlMenuProxy;
   import net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.model.vo.ItemVO;
   import net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.model.vo.MenuActionRequestVO;
   import net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.model.vo.categoryBar.CategoryVO;
   import net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.model.vo.slotBar.SlotBarVO;
   import net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.model.vo.slotBar.SlotVO;
   import net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.view.components.ItemsControlMenu;
   import net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.view.components.elements.CategoryElement;
   import net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.view.components.elements.Slot;
   import net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.view.components.elements.slotAndItemElement.SlotAndItemBarElement;
   import net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.view.components.menuBar.MenuBar;
   import net.bigpoint.darkorbit.settings.Settings;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class ItemsControlMenuMediator extends DOAbstractMediator
   {
      
      public static const NAME:String = "ItemsControlMenuMediator";
      
      private var _swfFinisher:SWFFinisher;
      
      private var _categoryItemsMap:Dictionary;
      
      private var _slotsItemsMap:Dictionary;
      
      private var _slots2itemsMap:Dictionary;
      
      private var _categoryMap:Dictionary;
      
      private var _selectedCategoryElement:CategoryElement;
      
      private var _selectedCategoryId:String;
      
      private var _itemsDragManager:DragManager;
      
      private var _configModeGrid:Shape;
      
      public function ItemsControlMenuMediator(param1:ItemsControlMenu, param2:SWFFinisher)
      {
         super(NAME,param1);
         this._swfFinisher = param2;
         this._itemsDragManager = new DragManager(this.view);
      }
      
      override public function onRegister() : void
      {
         super.onRegister();
         this.addListeners();
         registerMediator(new MenuBarsMediator(this.view,this._swfFinisher));
         this.toogleCategoryVisibility(false);
      }
      
      override public function listNotificationInterests() : Array
      {
         return [ItemsControlMenuNotifications.DATA_READY,ItemsControlMenuNotifications.TOOGLE_CATEGORY_VISIBILITY,ItemsControlMenuNotifications.REFRESH_SELECTED_CATEGORY_ITEMS_BAR,GuiNotifications.ADD_REMOVE_MENUS_CONFIG_GRID];
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         switch(param1.getName())
         {
            case ItemsControlMenuNotifications.DATA_READY:
               this._slotsItemsMap = new Dictionary();
               this._slots2itemsMap = new Dictionary();
               this.initCategoryBar();
               this.showSlotBar(this.view.standardSlotBar,this.menuProxy.standartSlotBar);
               this.showSlotBar(this.view.premiumSlotBar,this.menuProxy.premiumSlotbar);
               this.showSlotBar(this.view.proActionBar,this.menuProxy.proActionSlotBar);
               break;
            case ItemsControlMenuNotifications.TOOGLE_CATEGORY_VISIBILITY:
               this.toogleCategoryVisibility(Boolean(param1.getBody()));
               break;
            case GuiNotifications.ADD_REMOVE_MENUS_CONFIG_GRID:
               this.addRemoveConfigGrid(param1.getBody() as Shape);
               break;
            case ItemsControlMenuNotifications.REFRESH_SELECTED_CATEGORY_ITEMS_BAR:
               if(this._selectedCategoryElement)
               {
                  this.showCategoryItemsBar(this._selectedCategoryElement,true);
               }
         }
      }
      
      private function addListeners() : void
      {
         this.view.addEventListener(CategoryElement.CATEGORY_CLICKED,this.categoryClickedHandler);
         this.view.addEventListener(SlotAndItemBarElement.ITEM_CLICKED,this.itemClickHandler);
         this.view.addEventListener(SlotAndItemBarElement.ITEM_DOUBLECLICKED,this.itemClickHandler);
         this.view.addEventListener(DragEvent.DRAG_START,this.itemDragStartHandler);
         this._itemsDragManager.addEventListener(DragEvent.DRAG_ACCEPTED,this.itemDragCompleteHandler);
         this._itemsDragManager.addEventListener(DragEvent.DRAG_NOT_ACCEPTED,this.itemDragCompleteHandler);
         this._itemsDragManager.addEventListener(DragEvent.DRAG_OVER,this.itemDragOverHandler);
         this.view.addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler);
         this.view.addEventListener(Event.ADDED,this.mouseDownHandler);
      }
      
      private function itemDragStartHandler(param1:DragEvent) : void
      {
         var _loc3_:Point = null;
         var _loc4_:Slot = null;
         var _loc2_:SlotAndItemBarElement = param1.target as SlotAndItemBarElement;
         if(this.menuProxy.categoryBarVisible)
         {
            _loc4_ = this._slots2itemsMap[_loc2_] as Slot;
            if(_loc4_)
            {
               this._itemsDragManager.startDrag(_loc2_);
            }
            else
            {
               _loc3_ = _loc2_.localToGlobal(new Point(0,0));
               this._itemsDragManager.startDrag(_loc2_,true,_loc3_);
            }
            this.highlightedSlots = true;
         }
      }
      
      private function itemDragCompleteHandler(param1:DragEvent) : void
      {
         sendNotification(ItemsControlMenuNotifications.SEND_SLOT_BAR_CONFIG_REQUEST,param1);
      }
      
      private function itemDragOverHandler(param1:DragEvent) : void
      {
         this.highlightedSlots = false;
      }
      
      private function categoryClickedHandler(param1:Event) : void
      {
         this.showCategoryItemsBar(param1.target as CategoryElement);
         AudioManager.playSoundEffect(InGameCatalog.SOUND_ID_SELECT_0);
      }
      
      private function itemClickHandler(param1:Event) : void
      {
         var _loc4_:ItemVO = null;
         var _loc5_:String = null;
         var _loc6_:MenuActionRequestVO = null;
         var _loc2_:Boolean = param1.type == SlotAndItemBarElement.ITEM_DOUBLECLICKED;
         var _loc3_:SlotVO = this._slotsItemsMap[this._slots2itemsMap[param1.target]] as SlotVO;
         if(_loc3_)
         {
            _loc4_ = _loc3_.itemVO;
            _loc5_ = _loc3_.slotBarId;
            if(_loc5_ == ItemsControlMenuConstants.PRO_ACTION_BAR)
            {
               if(Settings.proActionBarAutohideEnabled)
               {
                  TweenLite.delayedCall(0.2,this.closeProActionBar);
               }
            }
         }
         else
         {
            _loc4_ = this._categoryItemsMap[param1.target] as ItemVO;
            _loc5_ = ItemsControlMenuConstants.CATEGORY_BAR;
         }
         if(_loc4_)
         {
            _loc6_ = new MenuActionRequestVO(_loc4_,_loc2_,_loc5_);
            sendNotification(ItemsControlMenuNotifications.SEND_MENU_ACTION_REQUEST,_loc6_);
            AudioManager.playSoundEffect(InGameCatalog.SOUND_ID_SELECT_1);
            return;
         }
         throw new Error("not itemVO has been found");
      }
      
      private function closeProActionBar() : void
      {
         if(this.menuProxy.proActionBarVisible)
         {
            facade.sendNotification(ItemsControlMenuNotifications.TOGGLE_PRO_ACTION_BUTTON);
         }
      }
      
      private function mouseDownHandler(param1:Event) : void
      {
         param1.stopPropagation();
      }
      
      private function initCategoryBar() : void
      {
         var _loc3_:CategoryElement = null;
         var _loc5_:CategoryVO = null;
         var _loc6_:CategoryElement = null;
         this._categoryMap = new Dictionary(true);
         var _loc1_:Array = [];
         var _loc2_:int = int(this.menuProxy.categoryBar.categories.length);
         var _loc4_:int = 0;
         while(_loc4_ != _loc2_)
         {
            _loc5_ = this.menuProxy.categoryBar.categories[_loc4_];
            _loc6_ = new CategoryElement(this._swfFinisher,BPLocale.getItem("ttip_menu_" + _loc5_.id),this.getIconBitmapData(_loc5_.id + "_normal"),this.getIconBitmapData(_loc5_.id + "_hover"),this.getIconBitmapData(_loc5_.id + "_select"));
            this._categoryMap[_loc6_] = _loc5_;
            _loc1_.push(_loc6_);
            if(!_loc3_)
            {
               _loc3_ = _loc6_;
            }
            _loc4_++;
         }
         this.showCategoryItemsBar(this.getCategoryElementById(this._selectedCategoryId) || _loc3_);
         this.view.categoryBar.showItems(_loc1_,ItemsControlMenuConstants.MAX_ITEMS_ON_LIST,SlotAndItemBarElement.DEFAULT_SIZE,true);
      }
      
      private function showCategoryItemsBar(param1:CategoryElement, param2:Boolean = false) : void
      {
         var _loc3_:CategoryVO = null;
         if(param1 != this._selectedCategoryElement || param2)
         {
            if(this._selectedCategoryElement)
            {
               this._selectedCategoryElement.selected = false;
            }
            this._selectedCategoryElement = param1;
            if(this._selectedCategoryElement == null)
            {
               return;
            }
            this._selectedCategoryElement.selected = true;
            _loc3_ = this._categoryMap[param1];
            if(_loc3_ == null)
            {
               return;
            }
            this._selectedCategoryId = _loc3_.id;
            this.refreshCategoryItemsBar();
         }
      }
      
      private function refreshCategoryItemsBar() : void
      {
         var _loc5_:ItemVO = null;
         var _loc6_:SlotAndItemBarElement = null;
         if(this.menuProxy == null)
         {
            return;
         }
         var _loc1_:Vector.<ItemVO> = this.menuProxy.getItemBarItems(this._selectedCategoryId);
         this._categoryItemsMap = new Dictionary();
         var _loc2_:Array = [];
         var _loc3_:int = _loc1_ ? int(_loc1_.length) : int(null);
         var _loc4_:int = 0;
         while(_loc4_ != _loc3_)
         {
            _loc5_ = _loc1_[_loc4_];
            if(_loc5_.visible)
            {
               _loc6_ = new SlotAndItemBarElement(this._swfFinisher,_loc5_,this.getIconBitmapData(_loc5_.iconLootId),TextUtils.getTooltipText(_loc5_.toolTipItemBar),true);
               this._categoryItemsMap[_loc6_] = _loc5_;
               _loc2_.push(_loc6_);
            }
            _loc4_++;
         }
         if(Boolean(this.view) && Boolean(this.view.itemBar))
         {
            this.view.itemBar.showItems(_loc2_,ItemsControlMenuConstants.MAX_ITEMS_ON_LIST,SlotAndItemBarElement.DEFAULT_SIZE,true);
         }
      }
      
      private function showSlotBar(param1:MenuBar, param2:SlotBarVO) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:SlotVO = null;
         var _loc7_:int = 0;
         var _loc8_:Slot = null;
         var _loc9_:SlotAndItemBarElement = null;
         var _loc3_:Array = [];
         if(param2)
         {
            _loc4_ = int(param2.slotBars.length);
            _loc5_ = 0;
            while(_loc5_ != _loc4_)
            {
               _loc6_ = param2.slotBars[_loc5_];
               _loc7_ = _loc5_ == 9 ? 0 : int(_loc5_ + 1);
               _loc8_ = new Slot(this._swfFinisher,_loc7_);
               this._slotsItemsMap[_loc8_] = _loc6_;
               if(_loc6_.itemVO)
               {
                  _loc9_ = new SlotAndItemBarElement(this._swfFinisher,_loc6_.itemVO,this.getIconBitmapData(_loc6_.itemVO.iconLootId),TextUtils.getTooltipText(_loc6_.itemVO.toolTipSlotBar));
                  _loc8_.itemElement = _loc9_;
                  this._slots2itemsMap[_loc9_] = _loc8_;
               }
               _loc3_.push(_loc8_);
               _loc5_++;
            }
         }
         param1.showItems(_loc3_,ItemsControlMenuConstants.MAX_ITEMS_ON_LIST,SlotAndItemBarElement.DEFAULT_SIZE,false,param2);
      }
      
      private function set highlightedSlots(param1:Boolean) : void
      {
         var _loc2_:Object = null;
         for(_loc2_ in this._slotsItemsMap)
         {
            (_loc2_ as Slot).highlighted = param1;
         }
      }
      
      private function toogleCategoryVisibility(param1:Boolean) : void
      {
         this.view.itemBar.setVisibility(param1,this.view.itemBar);
         this.view.categoryBar.setVisibility(param1,this.view.categoryBar);
      }
      
      private function addRemoveConfigGrid(param1:Shape) : void
      {
         var _loc2_:Sprite = ScreenManager.getWindowLayer();
         if(param1)
         {
            if(this._configModeGrid)
            {
               this.removeConfigGrid();
            }
            _loc2_.addChildAt(this._configModeGrid = param1,0);
         }
         else
         {
            this.removeConfigGrid();
         }
      }
      
      private function removeConfigGrid() : void
      {
         if(this._configModeGrid != null && this._configModeGrid.parent != null)
         {
            this._configModeGrid.parent.removeChild(this._configModeGrid);
            this._configModeGrid = null;
         }
      }
      
      public function onAddNewElement(param1:ItemVO) : void
      {
         if(this.menuProxy.getCategoryIdByItemVO(param1) == this._selectedCategoryId)
         {
            this.refreshCategoryItemsBar();
         }
      }
      
      public function getSlotBarsItemElementsById(param1:String) : Vector.<SlotAndItemBarElement>
      {
         var _loc3_:Object = null;
         var _loc4_:Slot = null;
         var _loc5_:SlotVO = null;
         var _loc2_:Vector.<SlotAndItemBarElement> = new Vector.<SlotAndItemBarElement>();
         for(_loc3_ in this._slots2itemsMap)
         {
            _loc4_ = this._slots2itemsMap[_loc3_] as Slot;
            _loc5_ = this._slotsItemsMap[_loc4_] as SlotVO;
            if(Boolean(_loc5_.itemVO) && _loc5_.itemVO.id == param1)
            {
               _loc2_.push(_loc3_ as SlotAndItemBarElement);
            }
         }
         return _loc2_;
      }
      
      public function getAllElementsById(param1:String) : Vector.<SlotAndItemBarElement>
      {
         var _loc2_:Vector.<SlotAndItemBarElement> = this.getSlotBarsItemElementsById(param1);
         var _loc3_:SlotAndItemBarElement = this.getSlotAndItemBarElementById(param1);
         if(_loc3_)
         {
            _loc2_.push(_loc3_);
         }
         return _loc2_;
      }
      
      public function getSlotAndItemBarElementById(param1:String) : SlotAndItemBarElement
      {
         var _loc2_:Object = null;
         var _loc3_:ItemVO = null;
         for(_loc2_ in this._categoryItemsMap)
         {
            _loc3_ = this._categoryItemsMap[_loc2_] as ItemVO;
            if(_loc3_.id == param1)
            {
               return _loc2_ as SlotAndItemBarElement;
            }
         }
         return null;
      }
      
      public function getCategoryElementById(param1:String) : CategoryElement
      {
         var _loc2_:Object = null;
         var _loc3_:CategoryVO = null;
         for(_loc2_ in this._categoryMap)
         {
            _loc3_ = this._categoryMap[_loc2_] as CategoryVO;
            if(_loc3_.id == param1)
            {
               return _loc2_ as CategoryElement;
            }
         }
         return null;
      }
      
      public function getSlotBarsItemElementsByCooldownType(param1:int) : Vector.<SlotAndItemBarElement>
      {
         var _loc3_:Object = null;
         var _loc4_:Slot = null;
         var _loc5_:SlotVO = null;
         var _loc2_:Vector.<SlotAndItemBarElement> = new Vector.<SlotAndItemBarElement>();
         for(_loc3_ in this._slots2itemsMap)
         {
            _loc4_ = this._slots2itemsMap[_loc3_] as Slot;
            _loc5_ = this._slotsItemsMap[_loc4_] as SlotVO;
            if(Boolean(_loc5_.itemVO) && _loc5_.itemVO.cooldownGroupType == param1)
            {
               _loc2_.push(_loc3_ as SlotAndItemBarElement);
            }
         }
         return _loc2_;
      }
      
      public function getItemBarElementsByCooldownType(param1:int) : Vector.<SlotAndItemBarElement>
      {
         var _loc3_:Object = null;
         var _loc4_:ItemVO = null;
         var _loc2_:Vector.<SlotAndItemBarElement> = new Vector.<SlotAndItemBarElement>();
         for(_loc3_ in this._categoryItemsMap)
         {
            _loc4_ = this._categoryItemsMap[_loc3_] as ItemVO;
            if(_loc4_.cooldownGroupType == param1)
            {
               _loc2_.push(_loc3_ as SlotAndItemBarElement);
            }
         }
         return _loc2_;
      }
      
      public function getItemVOBySlotId(param1:int, param2:String) : ItemVO
      {
         var _loc3_:Object = null;
         var _loc4_:SlotVO = null;
         for(_loc3_ in this._slotsItemsMap)
         {
            _loc4_ = this._slotsItemsMap[_loc3_] as SlotVO;
            if(_loc4_.id == param1 && _loc4_.slotBarId == param2)
            {
               return _loc4_.itemVO;
            }
         }
         return null;
      }
      
      public function getItemBySlotbarID(param1:String, param2:String) : Vector.<SlotAndItemBarElement>
      {
         var _loc4_:SlotAndItemBarElement = null;
         var _loc5_:Object = null;
         var _loc6_:Slot = null;
         var _loc7_:SlotVO = null;
         var _loc3_:Vector.<SlotAndItemBarElement> = new Vector.<SlotAndItemBarElement>();
         if(param1 == ItemsControlMenuConstants.CATEGORY_BAR)
         {
            _loc4_ = this.getSlotAndItemBarElementById(param2);
            if(_loc4_)
            {
               _loc3_.push(_loc4_);
            }
         }
         else
         {
            for(_loc5_ in this._slots2itemsMap)
            {
               _loc6_ = this._slots2itemsMap[_loc5_] as Slot;
               _loc7_ = this._slotsItemsMap[_loc6_] as SlotVO;
               if(Boolean(_loc7_.slotBarId == param1) && Boolean(_loc7_.itemVO) && _loc7_.itemVO.id == param2)
               {
                  _loc3_.push(_loc5_ as SlotAndItemBarElement);
               }
            }
         }
         return _loc3_;
      }
      
      private function getIconBitmapData(param1:String) : BitmapData
      {
         return assetsProxy.getBitmapDataFromAtlas(param1,ItemsControlMenuConstants.ICONS_BITMAP_ATLAS);
      }
      
      protected function get menuProxy() : ItemsControlMenuProxy
      {
         return facade.retrieveProxy(ItemsControlMenuProxy.NAME) as ItemsControlMenuProxy;
      }
      
      public function get categoryItemsMap() : Dictionary
      {
         return this._categoryItemsMap;
      }
      
      public function get slotsItemsMap() : Dictionary
      {
         return this._slotsItemsMap;
      }
      
      public function get slots2itemsMap() : Dictionary
      {
         return this._slots2itemsMap;
      }
      
      public function get view() : ItemsControlMenu
      {
         return viewComponent as ItemsControlMenu;
      }
      
      public function get selectedCategoryId() : String
      {
         return this._selectedCategoryId;
      }
   }
}

