package net.bigpoint.darkorbit.delete_in_eic
{
   import flash.utils.Dictionary;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.com.module.InventoryItemAttributeModule;
   import net.bigpoint.darkorbit.com.module.InventoryItemModule;
   import net.bigpoint.darkorbit.items.item.Item;
   import net.bigpoint.darkorbit.items.item.attributes.AmmunitionAttributes;
   import net.bigpoint.darkorbit.items.item.attributes.RecipeAttributes;
   import net.bigpoint.darkorbit.items.item.attributes.drones.DroneAttributes;
   import net.bigpoint.darkorbit.items.item.traits.AbstractTrait;
   import net.bigpoint.darkorbit.items.item.traits.SlotableTrait;
   import net.bigpoint.darkorbit.items.item.vo.Slot;
   import net.bigpoint.darkorbit.items.utils.ItemSortorder;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class ItemVO implements IItemInfo
   {
      
      public static const WEAPON_TYPE_LASER:String = "LASER";
      
      public static const WEAPON_TYPE_MINE:String = "MINE";
      
      public static const WEAPON_TYPE_ROCKET_LAUNCHER:String = "ROCKET_LAUNCHER";
      
      public static const WEAPON_TYPE_HELLSTORM_LAUNCHER:String = "HELLSTORM_LAUNCHER";
      
      public static const LOOT_ERROR:String = "LootError";
      
      public static const LOOTID_SEPARATOR:String = "_";
      
      public static const LOOTID_DESIGN:String = "design";
      
      public static const PREFIX_BPLOCAL_ITEMCATEGORY:String = "items" + LOOTID_SEPARATOR;
      
      public static const POST_ADDENDUM_30x30:String = LOOTID_SEPARATOR + "30x30";
      
      public static const POST_ADDENDUM_100x100:String = LOOTID_SEPARATOR + "100x100";
      
      public static const POST_ADDENDUM_ICON:String = LOOTID_SEPARATOR + "icon";
      
      public static const POST_ADDENDUM_FULLNAME:String = LOOTID_SEPARATOR + "fullname";
      
      public static const POST_ADDENDUM_DESCRIPTIOIN:String = LOOTID_SEPARATOR + "description";
      
      public static const POST_ADDENDUM_CATEGORY:String = LOOTID_SEPARATOR + "category";
      
      public static const POST_ADDENDUM_CODE:String = LOOTID_SEPARATOR + "code";
      
      public static const POST_ADDENDUM_SHORT:String = LOOTID_SEPARATOR + "short";
      
      public static const POST_ADDENDUM_SOURCES:String = LOOTID_SEPARATOR + "sources";
      
      public static const NO_HANGAR:Number = 0;
      
      protected static var __internalIDCounter__:uint = 0;
      
      public static const LOCKSTATE_NONE:String = "none";
      
      public static const LOCKSTATE_FIRST_LOCKED:String = "locked.first";
      
      public static const LOCKSTATE_LAST_LOCKED:String = "locked.last";
      
      public static const LOCKSTATE_LOCKED:String = "locked";
      
      public const itemVOChanged:ISignal = new Signal();
      
      public var item:Item;
      
      private var _lootID:String;
      
      public var id:Number;
      
      protected var _internalID:uint = 0;
      
      public var index:uint;
      
      private var _sortIndex:uint;
      
      private var _amount:Number = 0;
      
      private var _upgradeLevel:int;
      
      public var startLevel:int = 0;
      
      public var attributes:Dictionary = new Dictionary();
      
      private var _device:Object;
      
      private var hangarID:Number = 0;
      
      protected var _locked:String = "none";
      
      protected var _isWeaker:Boolean = false;
      
      public function ItemVO(param1:String = null)
      {
         super();
         this._internalID = this.getNextInternalID();
      }
      
      public static function fromModule(param1:InventoryItemModule) : ItemVO
      {
         var _loc4_:InventoryItemAttributeModule = null;
         var _loc2_:ItemVO = ItemDataProviderHelper.getItem(param1.lootId);
         if(!_loc2_)
         {
            return null;
         }
         _loc2_.amount = param1.amount;
         _loc2_.id = param1.itemId;
         _loc2_.upgradeLevel = param1.upgradeLevel;
         _loc2_.startLevel = param1.star > 0 ? param1.star : 0;
         _loc2_.hangarID = param1.hangarId;
         var _loc3_:int = int(param1.inventoryItemAttributes.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_)
         {
            _loc4_ = param1.inventoryItemAttributes[_loc5_];
            _loc2_.attributes[_loc4_.key] = _loc4_.value;
            _loc5_++;
         }
         return _loc2_;
      }
      
      public function get deviceSpecificData() : Object
      {
         return this._device;
      }
      
      public function isItem() : Boolean
      {
         return this._device == null ? true : false;
      }
      
      public function getItemType() : String
      {
         var _loc1_:String = null;
         if(this.item)
         {
            _loc1_ = this.item.attributes.typeClass;
         }
         return _loc1_;
      }
      
      public function isWeaponType(param1:String) : Boolean
      {
         var _loc3_:AmmunitionAttributes = null;
         var _loc2_:Boolean = false;
         if(this.item)
         {
            _loc3_ = this.item.attributes as AmmunitionAttributes;
            _loc2_ = _loc3_.weaponType == param1 ? true : false;
         }
         return _loc2_;
      }
      
      public function isItemType(param1:String) : Boolean
      {
         var _loc2_:Boolean = false;
         if(this.item)
         {
            if(Boolean(this.item.attributes) && param1 == this.item.attributes.typeClass)
            {
               _loc2_ = true;
            }
         }
         return _loc2_;
      }
      
      public function isItemValue(param1:String) : Boolean
      {
         var _loc2_:Boolean = false;
         if(this.item)
         {
            if(Boolean(this.item.attributes) && param1 == this.item.attributes.typeValue)
            {
               _loc2_ = true;
            }
         }
         return _loc2_;
      }
      
      public function get isEquipped() : Boolean
      {
         return this.hangarID != NO_HANGAR;
      }
      
      public function get xpLevel() : int
      {
         return int(this.attributes[InventoryItemAttributeModule.INVENTORYITEMATTRIBUTEKEY_LEVEL]) || 0;
      }
      
      public function isLaser() : Boolean
      {
         return this.isItemType(ItemFilterTypes.Weapon__LaserType);
      }
      
      public function isLaserAmmunition() : Boolean
      {
         var _loc1_:Boolean = false;
         _loc1_ = this.isItemType(ItemFilterTypes.Ammo__AmmunitionType);
         return _loc1_ && this.isWeaponType(WEAPON_TYPE_LASER);
      }
      
      public function isSpecialAmmunition() : Boolean
      {
         return this.lootID.lastIndexOf("specialammo") >= 0 ? true : false;
      }
      
      public function isMine() : Boolean
      {
         var _loc1_:Boolean = false;
         _loc1_ = this.isItemType(ItemFilterTypes.Ammo__AmmunitionType);
         return _loc1_ && this.isWeaponType(WEAPON_TYPE_MINE);
      }
      
      public function isRocket() : Boolean
      {
         var _loc1_:Boolean = false;
         _loc1_ = this.isItemType(ItemFilterTypes.Ammo__AmmunitionType);
         return _loc1_ && (this.isWeaponType(WEAPON_TYPE_ROCKET_LAUNCHER) || this.isWeaponType(WEAPON_TYPE_HELLSTORM_LAUNCHER));
      }
      
      public function isSpeedGenerator() : Boolean
      {
         return this.isItemType(ItemFilterTypes.EngineType);
      }
      
      public function isShieldGenerator() : Boolean
      {
         return this.isItemType(ItemFilterTypes.ShieldType);
      }
      
      public function isPetGear() : Boolean
      {
         return this.isItemType(ItemFilterTypes.PetGearType);
      }
      
      public function isPetAIProtocol() : Boolean
      {
         return this.isItemType(ItemFilterTypes.PetAIProtocolType);
      }
      
      public function isClanBattleStationModule() : Boolean
      {
         return this.isItemType(ItemFilterTypes.StationModuleType);
      }
      
      public function isSlotExtender() : Boolean
      {
         return this.lootID.indexOf("sle") != -1;
      }
      
      public function isCPU() : Boolean
      {
         return this.typeClass == ItemFilterTypes.CPUType ? true : false;
      }
      
      private function getNextInternalID() : uint
      {
         return this._internalID = __internalIDCounter__++;
      }
      
      public function get internalID() : uint
      {
         return this._internalID;
      }
      
      public function getTraitByType(param1:String) : AbstractTrait
      {
         var _loc2_:AbstractTrait = null;
         if(this.item.traits)
         {
            _loc2_ = this.item.traits.getTraitByType(param1);
         }
         return _loc2_;
      }
      
      public function addTrait(param1:AbstractTrait) : void
      {
         if(this.item.traits)
         {
            this.item.traits.add(param1);
         }
      }
      
      public function getSlotableTrait() : SlotableTrait
      {
         return this.getTraitByType(TraitTypes.SLOTABLE) as SlotableTrait;
      }
      
      public function getSlotByType(param1:String) : Slot
      {
         var _loc4_:Slot = null;
         var _loc2_:Vector.<Slot> = this.getSlotableTrait().slots;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc4_ = _loc2_[_loc3_];
            if(_loc4_.slotsetType == param1)
            {
               return _loc4_;
            }
            _loc3_++;
         }
         return null;
      }
      
      public function getSlotByName(param1:String) : Slot
      {
         var _loc4_:Slot = null;
         var _loc2_:Vector.<Slot> = this.getSlotableTrait().slots;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc4_ = _loc2_[_loc3_];
            if(_loc4_.name == param1)
            {
               return _loc4_;
            }
            _loc3_++;
         }
         return null;
      }
      
      public function getSlots() : Vector.<Slot>
      {
         return this.getSlotableTrait().slots;
      }
      
      public function isAutoBuyCPU() : Boolean
      {
         return Boolean(this.item) && Boolean(this.item.attributes) && (this.item.attributes.typeValue == ItemFilterTypes.AMMUNITION_BUY_CPU_TYPE_VALUE || this.item.attributes.typeValue == ItemFilterTypes.ROCKET_BUY_CPU_TYPE_VALUE);
      }
      
      public function hasValidLootID() : Boolean
      {
         return !(this.lootID == null || this._lastSubLoot_ == LOOT_ERROR);
      }
      
      protected function get _lastSubLoot_() : String
      {
         var _loc1_:String = null;
         if(this.lootID == null)
         {
            return LOOT_ERROR;
         }
         var _loc2_:int = this.lootID.lastIndexOf(LOOTID_SEPARATOR);
         if(_loc2_ >= 0)
         {
            _loc1_ = this.lootID.substr(++_loc2_);
         }
         else
         {
            _loc1_ = this.lootID;
         }
         return _loc1_;
      }
      
      public function getLoot30x30(param1:String = null) : String
      {
         return this._getLoot(POST_ADDENDUM_30x30,param1);
      }
      
      public function getLoot100x100(param1:String = null) : String
      {
         return this._getLoot(POST_ADDENDUM_100x100,param1);
      }
      
      public function getLootCustom(param1:int, param2:int, param3:String = null) : String
      {
         return this._getLoot(LOOTID_SEPARATOR + param1.toString() + "x" + param2.toString(),param3);
      }
      
      public function getLootIcon(param1:String = null) : String
      {
         return this._getLoot(POST_ADDENDUM_ICON,param1);
      }
      
      protected function _getLoot(param1:String, param2:String = null) : String
      {
         var _loc3_:String = null;
         var _loc4_:String = "";
         if(this.item.attributes is DroneAttributes)
         {
            _loc4_ += "-" + Math.max(this.xpLevel - 1,0);
         }
         else if(this.item.attributes is RecipeAttributes)
         {
            return "recipe-default" + param1;
         }
         if(this.isFactionDependent())
         {
            _loc3_ = this._lastSubLoot_ + "-" + param2 + _loc4_ + param1;
         }
         else
         {
            _loc3_ = this._lastSubLoot_ + _loc4_ + param1;
         }
         return _loc3_;
      }
      
      public function isFactionDependent() : Boolean
      {
         var _loc1_:Boolean = false;
         if(this.item)
         {
            if(this.item.attributes)
            {
               _loc1_ = this.item.attributes.isFractionDependent;
            }
         }
         return _loc1_;
      }
      
      public function get fullname() : String
      {
         var _loc1_:String = PREFIX_BPLOCAL_ITEMCATEGORY + this.lootID + POST_ADDENDUM_FULLNAME;
         return BPLocale.getItemInCategory(Constants.BPLOCAL_CATEGORY__ITEMS,_loc1_);
      }
      
      public function get shortName() : String
      {
         var _loc1_:String = PREFIX_BPLOCAL_ITEMCATEGORY + this.lootID + POST_ADDENDUM_SHORT;
         return BPLocale.getItemInCategory(Constants.BPLOCAL_CATEGORY__ITEMS,_loc1_);
      }
      
      public function get rawDescription() : String
      {
         var _loc1_:String = PREFIX_BPLOCAL_ITEMCATEGORY + this.lootID + POST_ADDENDUM_DESCRIPTIOIN;
         return BPLocale.getItemInCategory(Constants.BPLOCAL_CATEGORY__ITEMS,_loc1_);
      }
      
      public function get descriptionName() : String
      {
         return ItemWildcardReplacer.replace(this,this.rawDescription);
      }
      
      public function get sourceName() : Object
      {
         var _loc1_:String = PREFIX_BPLOCAL_ITEMCATEGORY + this.lootID + POST_ADDENDUM_SOURCES;
         return BPLocale.getItemInCategory(Constants.BPLOCAL_CATEGORY__ITEMS,_loc1_);
      }
      
      public function get categoryName() : String
      {
         var _loc1_:String = PREFIX_BPLOCAL_ITEMCATEGORY + this.lootID + POST_ADDENDUM_CATEGORY;
         return BPLocale.getItemInCategory(Constants.BPLOCAL_CATEGORY__ITEMS,_loc1_);
      }
      
      public function get codeName() : String
      {
         var _loc1_:String = PREFIX_BPLOCAL_ITEMCATEGORY + this.lootID + POST_ADDENDUM_CODE;
         return BPLocale.getItemInCategory(Constants.BPLOCAL_CATEGORY__ITEMS,_loc1_);
      }
      
      public function get typeClass() : String
      {
         if(this.item == null || this.item.attributes == null)
         {
            return null;
         }
         return this.item.attributes.typeClass;
      }
      
      public function get typeValue() : String
      {
         if(this.item == null || this.item.attributes == null)
         {
            return null;
         }
         return this.item.attributes.typeValue;
      }
      
      public function clone() : ItemVO
      {
         var _loc1_:ItemVO = new ItemVO();
         _loc1_.write(this);
         return _loc1_;
      }
      
      public function get device() : Object
      {
         return this._device;
      }
      
      public function write(param1:ItemVO) : void
      {
         this.item = param1.item;
         this.lootID = param1.lootID;
         this.id = param1.id;
         this._internalID = param1.internalID;
         this.index = param1.index;
         this._sortIndex = param1._sortIndex;
         this.amount = param1.amount;
         this.upgradeLevel = param1.upgradeLevel;
         this.startLevel = param1.startLevel;
         this._device = param1.device;
         this.attributes = param1.attributes;
         this.hangarID = param1.hangarID;
         this.itemVOChanged.dispatch();
      }
      
      public function isLocked() : Boolean
      {
         return this._locked != LOCKSTATE_NONE;
      }
      
      public function set lockState(param1:String) : void
      {
         this._locked = param1;
      }
      
      public function get lockState() : String
      {
         return this._locked;
      }
      
      public function isWeaker() : Boolean
      {
         return this._isWeaker;
      }
      
      public function isStronger() : Boolean
      {
         return !this._isWeaker;
      }
      
      public function set weakness(param1:Boolean) : void
      {
         this._isWeaker = param1;
      }
      
      public function get weakness() : Boolean
      {
         return this._isWeaker;
      }
      
      public function get sortIndex() : uint
      {
         return this._sortIndex;
      }
      
      public function get lootID() : String
      {
         return this._lootID;
      }
      
      public function set lootID(param1:String) : void
      {
         this._lootID = param1;
         this._sortIndex = ItemSortorder.getSortIndexByLootID(this._lootID);
      }
      
      public function toString() : String
      {
         return "ItemVO.lootID " + this.lootID + " amount: " + this.amount;
      }
      
      public function get amount() : Number
      {
         return this._amount;
      }
      
      public function set amount(param1:Number) : void
      {
         this._amount = param1;
      }
      
      public function get upgradeLevel() : int
      {
         return this._upgradeLevel;
      }
      
      public function set upgradeLevel(param1:int) : void
      {
         this._upgradeLevel = param1;
      }
   }
}

