package net.bigpoint.darkorbit.delete_in_eic
{
   import com.adobe.utils.StringUtil;
   import com.bigpoint.utils.bindables.BindableBoolean;
   import flash.utils.Dictionary;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class InventoryModel
   {
      
      public var jumpVoucherStackItemVOID:Number = -1;
      
      public var repairVoucherStackItemVOID:Number = -1;
      
      public const itemChanged:ISignal = new Signal();
      
      public const itemAdded:ISignal = new Signal();
      
      public const itemRemoved:ISignal = new Signal();
      
      public const isInitialized:BindableBoolean = new BindableBoolean();
      
      public const shipChanged:ISignal = new Signal();
      
      private var _internalIdLookUp:Object = {};
      
      private var _inventoryItemsById:Object = {};
      
      private var _itemsByLootId:Dictionary = new Dictionary();
      
      public const assemblyChangedItemIds:Dictionary = new Dictionary();
      
      public var assemblyInventoryRevision:uint;
      
      private const _inventoryItemList:Vector.<ItemVO> = new Vector.<ItemVO>();
      
      private const _shipList:Vector.<ItemVO> = new Vector.<ItemVO>();
      
      private var _invalidateTimerID:uint;
      
      public function InventoryModel()
      {
         super();
         this.itemChanged.addOnce(this.handleInitialItemChanged);
      }
      
      private function handleInitialItemChanged() : void
      {
         this.isInitialized.value = true;
      }
      
      public function clear() : void
      {
         this.removeAllItems();
         this._inventoryItemList.length = 0;
         this._shipList.length = 0;
         this._internalIdLookUp = {};
         this._inventoryItemsById = {};
         this._itemsByLootId = new Dictionary();
         this.clearAssemblyChanges();
         ++this.assemblyInventoryRevision;
         this.itemChanged.dispatch();
         this.shipChanged.dispatch();
         this.isInitialized.value = false;
         this.itemChanged.addOnce(this.handleInitialItemChanged);
      }
      
      private function removeAllItems() : void
      {
         var _loc3_:ItemVO = null;
         var _loc1_:int = int(this._inventoryItemList.length);
         var _loc2_:* = int(_loc1_ - 1);
         while(_loc2_ >= 0)
         {
            _loc3_ = this._inventoryItemList[_loc2_];
            this.internalRemoveItem(_loc3_);
            _loc2_--;
         }
      }
      
      public function get inventoryItemList() : Vector.<ItemVO>
      {
         return this._inventoryItemList.concat();
      }
      
      public function get shipList() : Vector.<ItemVO>
      {
         return this._shipList.concat();
      }
      
      public function getItemById(param1:int) : ItemVO
      {
         return this._internalIdLookUp[param1];
      }
      
      public function getWithPrefix(param1:String) : Vector.<ItemVO>
      {
         var _loc5_:ItemVO = null;
         var _loc2_:Vector.<ItemVO> = new Vector.<ItemVO>(0);
         var _loc3_:int = int(this._inventoryItemList.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = this._inventoryItemList[_loc4_];
            if(StringUtil.beginsWith(_loc5_.lootID,param1))
            {
               _loc2_.push(_loc5_);
            }
            _loc4_++;
         }
         return _loc2_;
      }
      
      public function getById(param1:String) : Vector.<ItemVO>
      {
         var _loc2_:Vector.<ItemVO> = this._itemsByLootId[param1] as Vector.<ItemVO>;
         return _loc2_ == null ? new Vector.<ItemVO>(0) : _loc2_.concat();
      }
      
      public function clearAssemblyChanges() : void
      {
         var _loc1_:Object = null;
         for(_loc1_ in this.assemblyChangedItemIds)
         {
            delete this.assemblyChangedItemIds[_loc1_];
         }
      }
      
      public function getByItemId(param1:Number) : ItemVO
      {
         return this._inventoryItemsById[param1];
      }
      
      public function getFirstWithPrefix(param1:String) : ItemVO
      {
         var _loc4_:ItemVO = null;
         var _loc2_:int = int(this._inventoryItemList.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this._inventoryItemList[_loc3_];
            if(StringUtil.beginsWith(_loc4_.lootID,param1))
            {
               return _loc4_;
            }
            _loc3_++;
         }
         return null;
      }
      
      public function removeItems(param1:Vector.<ItemVO>) : void
      {
         var _loc5_:ItemVO = null;
         var _loc2_:Boolean = false;
         var _loc3_:int = int(param1.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = param1[_loc4_];
            _loc2_ = this.internalRemoveItem(_loc5_) || _loc2_;
            _loc4_++;
         }
         if(_loc2_)
         {
            this.itemChanged.dispatch();
         }
      }
      
      public function removeItem(param1:ItemVO) : void
      {
         if(!param1)
         {
            return;
         }
         var _loc2_:Boolean = this.internalRemoveItem(param1);
         if(_loc2_)
         {
            this.itemChanged.dispatch();
         }
      }
      
      public function removeShips(param1:Vector.<ItemVO>) : void
      {
         var _loc5_:ItemVO = null;
         var _loc2_:Boolean = false;
         var _loc3_:int = int(param1.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = param1[_loc4_];
            _loc2_ = this.internalRemoveShip(_loc5_) || _loc2_;
            _loc4_++;
         }
         if(_loc2_)
         {
            this.shipChanged.dispatch();
         }
      }
      
      public function removeShip(param1:ItemVO) : void
      {
         if(param1 != null && this.internalRemoveShip(param1))
         {
            this.shipChanged.dispatch();
         }
      }
      
      public function addItems(param1:Vector.<ItemVO>) : void
      {
         var _loc4_:ItemVO = null;
         var _loc2_:int = int(param1.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = param1[_loc3_];
            this.internalAddItem(_loc4_);
            _loc3_++;
         }
         this.itemChanged.dispatch();
      }
      
      private function internalAddItem(param1:ItemVO) : void
      {
         this.internalRemoveItem(param1);
         this._inventoryItemList.push(param1);
         this._inventoryItemsById[param1.id] = param1;
         var _loc2_:Vector.<ItemVO> = this._itemsByLootId[param1.lootID] as Vector.<ItemVO>;
         if(_loc2_ == null)
         {
            _loc2_ = this._itemsByLootId[param1.lootID] = new Vector.<ItemVO>(0);
         }
         _loc2_.push(param1);
         this._internalIdLookUp[param1.id] = param1;
         this.assemblyChangedItemIds[param1.id] = true;
         this.itemAdded.dispatch(param1);
      }
      
      private function internalRemoveItem(param1:ItemVO) : Boolean
      {
         param1 = this._inventoryItemsById[param1.id];
         if(!param1)
         {
            return false;
         }
         var _loc2_:int = this._inventoryItemList.indexOf(param1);
         delete this._inventoryItemsById[param1.id];
         this.removeFromLootIndex(param1);
         if(this._internalIdLookUp[param1.id] === param1)
         {
            delete this._internalIdLookUp[param1.id];
         }
         if(_loc2_ != -1)
         {
            this._inventoryItemList.splice(_loc2_,1);
            this.assemblyChangedItemIds[param1.id] = true;
            this.itemRemoved.dispatch(param1);
            return true;
         }
         return false;
      }
      
      private function removeFromLootIndex(param1:ItemVO) : void
      {
         var _loc2_:Vector.<ItemVO> = this._itemsByLootId[param1.lootID] as Vector.<ItemVO>;
         if(_loc2_ == null)
         {
            return;
         }
         var _loc3_:int = _loc2_.indexOf(param1);
         if(_loc3_ != -1)
         {
            _loc2_.splice(_loc3_,1);
         }
         if(_loc2_.length == 0)
         {
            delete this._itemsByLootId[param1.lootID];
         }
      }
      
      private function internalAddShip(param1:ItemVO) : void
      {
         this.internalRemoveShip(param1);
         this._shipList.push(param1);
         this._internalIdLookUp[param1.id] = param1;
      }
      
      private function internalRemoveShip(param1:ItemVO) : Boolean
      {
         var _loc2_:ItemVO = this._internalIdLookUp[param1.id];
         if(_loc2_ == null)
         {
            return false;
         }
         var _loc3_:int = this._shipList.indexOf(_loc2_);
         if(_loc3_ == -1)
         {
            return false;
         }
         this._shipList.splice(_loc3_,1);
         delete this._internalIdLookUp[_loc2_.id];
         return true;
      }
      
      public function addShip(param1:ItemVO) : void
      {
         this.internalAddShip(param1);
         this.shipChanged.dispatch();
      }
      
      public function addItem(param1:ItemVO) : void
      {
         this.internalAddItem(param1);
         this.invalidateItems();
      }
      
      private function invalidateItems() : void
      {
         clearTimeout(this._invalidateTimerID);
         this._invalidateTimerID = setTimeout(this.itemChanged.dispatch,1);
      }
      
      public function addShips(param1:Vector.<ItemVO>) : void
      {
         var _loc4_:ItemVO = null;
         var _loc2_:int = int(param1.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = param1[_loc3_];
            this.internalAddShip(_loc4_);
            _loc3_++;
         }
         this.shipChanged.dispatch();
      }
      
      public function updateItem(param1:ItemVO, param2:Boolean = true) : void
      {
         var _loc4_:Vector.<ItemVO> = null;
         var _loc5_:ItemVO = null;
         var _loc3_:ItemVO = this._inventoryItemsById[param1.id];
         if(_loc3_ != null)
         {
            if(_loc3_.lootID != param1.lootID)
            {
               this.removeFromLootIndex(_loc3_);
               _loc4_ = new Vector.<ItemVO>(0);
               for each(_loc5_ in this._inventoryItemList)
               {
                  if(_loc5_ === _loc3_ || _loc5_.lootID == param1.lootID)
                  {
                     _loc4_.push(_loc5_);
                  }
               }
               this._itemsByLootId[param1.lootID] = _loc4_;
            }
            this.assemblyChangedItemIds[param1.id] = true;
            _loc3_.write(param1);
            if(param2)
            {
               this.itemChanged.dispatch();
            }
            return;
         }
         this.addItem(param1);
      }
      
      public function dispatchItemChanged() : void
      {
         var _loc2_:Object = null;
         var _loc1_:Boolean = false;
         var _loc3_:int = 0;
         var _loc4_:* = this.assemblyChangedItemIds;
         for(_loc2_ in _loc4_)
         {
            _loc1_ = true;
         }
         if(!_loc1_)
         {
            ++this.assemblyInventoryRevision;
         }
         this.itemChanged.dispatch();
      }
      
      public function getAll() : Vector.<ItemVO>
      {
         return this._inventoryItemList.concat();
      }
   }
}

