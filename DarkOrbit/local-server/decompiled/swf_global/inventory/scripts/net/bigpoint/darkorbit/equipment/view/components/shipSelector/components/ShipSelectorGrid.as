package net.bigpoint.darkorbit.equipment.view.components.shipSelector.components
{
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import mx.utils.ObjectUtil;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.equipment.model.VO.HangarSlotEntity;
   import net.bigpoint.darkorbit.equipment.model.VO.item.ItemLocalisationKeys;
   import net.bigpoint.darkorbit.equipment.view.components.events.GenericDataEvent;
   import net.bigpoint.darkorbit.equipment.view.managers.FocusManager;
   import net.bigpoint.darkorbit.equipment.view.managers.IFocusable;
   
   public class ShipSelectorGrid extends Sprite implements IFocusable
   {
      
      public static const EVENT_ITEM_CONTENT_HEIGHT_CHANGED:String = "EVENT_ITEM_CONTENT_HEIGHT_CHANGED";
      
      public static const EVENT_ITEM_CLICKED:String = "EVENT_ITEM_CLICKED";
      
      public static const EVENT_FOCUSING:String = "EVENT_FOCUSING";
      
      public static const EVENT_UNFOCUSING:String = "EVENT_UNFOCUSING";
      
      public var itemSizeX:uint = 104;
      
      public var itemSizeY:uint = 104;
      
      public var itemGapX:uint = 2;
      
      public var itemGapY:uint = 2;
      
      public var viewSizeWidth:uint;
      
      public var viewSizeHeigth:uint;
      
      protected var _itemContainer:Sprite;
      
      private var _selectedItemData:HangarSlotEntity;
      
      private var _selectedItemRenderer:ShipSelectorItemRenderer;
      
      private var _maxHeight:Number;
      
      private var _hangarList:Vector.<HangarSlotEntity>;
      
      public function ShipSelectorGrid()
      {
         super();
         this.init();
      }
      
      protected function init() : void
      {
         this.viewSizeWidth = 4 * (this.itemSizeX + this.itemGapX);
         this.viewSizeHeigth = 3 * (this.itemSizeY + this.itemGapY);
         this.createItemContainer();
      }
      
      private function createItemContainer() : void
      {
         this._itemContainer = new Sprite();
         addChild(this._itemContainer);
         FocusManager.getInstance().add(this);
         this.addEventListener(MouseEvent.MOUSE_MOVE,this.handleMouseMoveEvent);
      }
      
      private function priceCreditsComparision(param1:HangarSlotEntity, param2:HangarSlotEntity) : Number
      {
         if(param2.priceCredits > param1.priceCredits)
         {
            return 1;
         }
         return -1;
      }
      
      private function priceUridiumComparision(param1:HangarSlotEntity, param2:HangarSlotEntity) : Number
      {
         return param2.priceUridium - param1.priceUridium;
      }
      
      private function splitAndSortByPrice(param1:Vector.<HangarSlotEntity>, param2:Vector.<HangarSlotEntity>) : Vector.<HangarSlotEntity>
      {
         var _loc8_:HangarSlotEntity = null;
         var _loc3_:Vector.<HangarSlotEntity> = new Vector.<HangarSlotEntity>();
         var _loc4_:Vector.<HangarSlotEntity> = new Vector.<HangarSlotEntity>();
         var _loc5_:Vector.<HangarSlotEntity> = new Vector.<HangarSlotEntity>();
         var _loc6_:Vector.<HangarSlotEntity> = new Vector.<HangarSlotEntity>();
         var _loc7_:uint = param1.length;
         var _loc9_:int = 0;
         while(_loc9_ < _loc7_)
         {
            _loc8_ = param1[_loc9_];
            if(_loc8_.priceCredits > 0)
            {
               _loc3_.push(_loc8_);
            }
            else if(_loc8_.priceUridium > 0)
            {
               _loc4_.push(_loc8_);
            }
            else if(_loc8_.isPayment())
            {
               _loc5_.push(_loc8_);
            }
            else
            {
               _loc6_.push(_loc8_);
            }
            _loc9_++;
         }
         _loc3_.sort(this.priceCreditsComparision);
         _loc4_.sort(this.priceUridiumComparision);
         param2 = param2.concat(_loc5_);
         param2 = param2.concat(_loc4_);
         param2 = param2.concat(_loc3_);
         return param2.concat(_loc6_);
      }
      
      private function localisationComparision(param1:HangarSlotEntity, param2:HangarSlotEntity) : Number
      {
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc3_:String = param1.getShip().selectedDesign || param1.getShip().lootID;
         var _loc4_:String = "items_" + _loc3_ + "_fullname";
         var _loc5_:String = param2.getShip().selectedDesign || param2.getShip().lootID;
         var _loc6_:String = "items_" + _loc5_ + "_fullname";
         _loc7_ = BPLocale.getItemInCategory(ItemLocalisationKeys.BPLOCAL_CATEGORY__ITEMS,_loc4_);
         _loc8_ = BPLocale.getItemInCategory(ItemLocalisationKeys.BPLOCAL_CATEGORY__ITEMS,_loc6_);
         return ObjectUtil.stringCompare(_loc7_,_loc8_);
      }
      
      private function upgradeLevelComparison(param1:HangarSlotEntity, param2:HangarSlotEntity) : Number
      {
         if(param1.shipUpgradeLevel != param2.shipUpgradeLevel)
         {
            return param2.shipUpgradeLevel - param1.shipUpgradeLevel;
         }
         return this.localisationComparision(param1,param2);
      }
      
      private function sortByName(param1:Vector.<HangarSlotEntity>, param2:Vector.<HangarSlotEntity>) : Vector.<HangarSlotEntity>
      {
         param1.sort(this.localisationComparision);
         return param2.concat(param1);
      }
      
      private function sortByUpgradeLevel(param1:Vector.<HangarSlotEntity>, param2:Vector.<HangarSlotEntity>) : Vector.<HangarSlotEntity>
      {
         param1.sort(this.upgradeLevelComparison);
         return param2.concat(param1);
      }
      
      private function splitFavorite(param1:Vector.<HangarSlotEntity>, param2:Vector.<HangarSlotEntity>, param3:Vector.<HangarSlotEntity>) : void
      {
         var _loc5_:HangarSlotEntity = null;
         var _loc4_:uint = param1.length;
         var _loc6_:int = 0;
         while(_loc6_ < _loc4_)
         {
            _loc5_ = param1[_loc6_];
            if(_loc5_.isFavourite())
            {
               param2.push(_loc5_);
            }
            else
            {
               param3.push(_loc5_);
            }
            _loc6_++;
         }
      }
      
      private function splitAvailable(param1:Vector.<HangarSlotEntity>, param2:Vector.<HangarSlotEntity>, param3:Vector.<HangarSlotEntity>) : void
      {
         var _loc5_:HangarSlotEntity = null;
         var _loc7_:Boolean = false;
         var _loc4_:uint = param1.length;
         var _loc6_:int = 0;
         while(_loc6_ < _loc4_)
         {
            _loc5_ = param1[_loc6_];
            _loc7_ = _loc5_.isEventActive() || !_loc5_.isEventItem();
            if(_loc7_)
            {
               param2.push(_loc5_);
            }
            else
            {
               param3.push(_loc5_);
            }
            _loc6_++;
         }
      }
      
      private function reorder(param1:Vector.<HangarSlotEntity>, param2:Function) : Vector.<HangarSlotEntity>
      {
         var _loc6_:HangarSlotEntity = null;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc3_:Vector.<HangarSlotEntity> = new Vector.<HangarSlotEntity>();
         var _loc4_:Vector.<HangarSlotEntity> = new Vector.<HangarSlotEntity>();
         var _loc5_:Vector.<HangarSlotEntity> = new Vector.<HangarSlotEntity>();
         _loc8_ = param1.length;
         _loc7_ = 0;
         while(_loc7_ < _loc8_)
         {
            _loc6_ = param1[_loc7_];
            if(_loc6_.isOwned())
            {
               _loc4_.push(_loc6_);
            }
            else
            {
               _loc5_.push(_loc6_);
            }
            _loc7_++;
         }
         var _loc9_:Vector.<HangarSlotEntity> = new Vector.<HangarSlotEntity>();
         var _loc10_:Vector.<HangarSlotEntity> = new Vector.<HangarSlotEntity>();
         this.splitFavorite(_loc4_,_loc9_,_loc10_);
         _loc3_ = param2(_loc9_,_loc3_);
         _loc3_ = param2(_loc10_,_loc3_);
         var _loc11_:Vector.<HangarSlotEntity> = new Vector.<HangarSlotEntity>();
         var _loc12_:Vector.<HangarSlotEntity> = new Vector.<HangarSlotEntity>();
         this.splitAvailable(_loc5_,_loc11_,_loc12_);
         _loc3_ = param2(_loc11_,_loc3_);
         return param2(_loc12_,_loc3_);
      }
      
      public function reorderList() : void
      {
         this.list = this._hangarList;
         if(this.selectedItemData != null)
         {
            this.selectItem(this.selectedItemData,true);
         }
      }
      
      public function get list() : Vector.<HangarSlotEntity>
      {
         return this._hangarList;
      }
      
      public function set list(param1:Vector.<HangarSlotEntity>) : void
      {
         var _loc3_:Sprite = null;
         var _loc8_:HangarSlotEntity = null;
         this._hangarList = this.reorder(param1,this.sortByUpgradeLevel);
         this._itemContainer.removeChildren();
         var _loc2_:uint = this._hangarList.length;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         while(_loc6_ < _loc2_)
         {
            _loc8_ = this._hangarList[_loc6_] as HangarSlotEntity;
            _loc3_ = new ShipSelectorItemRenderer(this.itemSizeX,this.itemSizeY,_loc8_,this.dispatchItemClickEvent);
            _loc3_.addEventListener(ShipSelectorItemRenderer.EVENT_ITEM_SELECTED,this.handleItemSelected);
            _loc3_.x = _loc4_;
            _loc3_.y = _loc5_;
            this._itemContainer.addChild(_loc3_);
            _loc4_ += this.itemSizeX + this.itemGapX;
            if(_loc4_ >= this.viewSizeWidth)
            {
               _loc5_ += this.itemSizeY + this.itemGapY;
               _loc4_ = 0;
            }
            _loc6_++;
         }
         var _loc7_:Number = 0;
         if(_loc2_ % 4 == 0)
         {
            _loc7_ = _loc2_ / 4;
         }
         else
         {
            _loc7_ = Math.ceil(_loc2_ / 4) + 1;
         }
         this._maxHeight = _loc7_ * (this.itemSizeY + this.itemGapY) - this.itemGapY;
         dispatchEvent(new GenericDataEvent(EVENT_ITEM_CONTENT_HEIGHT_CHANGED,this._itemContainer.height));
      }
      
      protected function handleItemSelected(param1:Event) : void
      {
         var _loc4_:ShipSelectorItemRenderer = null;
         var _loc2_:uint = uint(this._itemContainer.numChildren);
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this._itemContainer.getChildAt(_loc3_) as ShipSelectorItemRenderer;
            _loc4_.deselect();
            _loc3_++;
         }
         this._selectedItemRenderer = param1.currentTarget as ShipSelectorItemRenderer;
      }
      
      private function handleMouseMoveEvent(param1:MouseEvent) : void
      {
         this.focusing();
      }
      
      public function focusing() : void
      {
         dispatchEvent(new Event(EVENT_FOCUSING));
      }
      
      public function unfocusing() : void
      {
         dispatchEvent(new Event(EVENT_UNFOCUSING));
      }
      
      public function get selectedItemData() : HangarSlotEntity
      {
         return this._selectedItemData;
      }
      
      public function get selectedItemRenderer() : ShipSelectorItemRenderer
      {
         return this._selectedItemRenderer;
      }
      
      protected function dispatchItemClickEvent(param1:Object) : void
      {
         this._selectedItemData = param1 as HangarSlotEntity;
         dispatchEvent(new GenericDataEvent(ShipSelectorGrid.EVENT_ITEM_CLICKED,param1));
      }
      
      public function selectItem(param1:HangarSlotEntity, param2:Boolean = false) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:ShipSelectorItemRenderer = null;
         if(param1 != this._selectedItemData || param2)
         {
            this._selectedItemData = param1;
            _loc3_ = uint(this._itemContainer.numChildren);
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               _loc5_ = this._itemContainer.getChildAt(_loc4_) as ShipSelectorItemRenderer;
               if(_loc5_.data.hangarID > 0)
               {
                  if(_loc5_.data.hangarID == param1.hangarID)
                  {
                     _loc5_.select();
                     this._selectedItemRenderer = _loc5_;
                  }
                  else
                  {
                     _loc5_.deselect();
                  }
               }
               else
               {
                  _loc5_.deselect();
               }
               _loc4_++;
            }
         }
      }
      
      public function activateItem(param1:HangarSlotEntity) : void
      {
         var _loc4_:ShipSelectorItemRenderer = null;
         var _loc2_:uint = uint(this._itemContainer.numChildren);
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this._itemContainer.getChildAt(_loc3_) as ShipSelectorItemRenderer;
            if(_loc4_.data.hangarID > 0)
            {
               if(_loc4_.data.hangarID == param1.hangarID)
               {
                  _loc4_.setActivate(true);
               }
               else
               {
                  _loc4_.setActivate(false);
               }
            }
            else
            {
               _loc4_.setActivate(false);
            }
            _loc3_++;
         }
      }
      
      public function getFavouriteItemCount() : uint
      {
         var _loc4_:ShipSelectorItemRenderer = null;
         var _loc1_:uint = 0;
         var _loc2_:uint = uint(this._itemContainer.numChildren);
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this._itemContainer.getChildAt(_loc3_) as ShipSelectorItemRenderer;
            if(_loc4_.data.isFavourite())
            {
               _loc1_++;
            }
            _loc3_++;
         }
         return _loc1_;
      }
   }
}

