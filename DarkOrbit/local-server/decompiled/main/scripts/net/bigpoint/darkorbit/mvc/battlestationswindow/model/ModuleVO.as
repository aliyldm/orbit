package net.bigpoint.darkorbit.mvc.battlestationswindow.model
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   import net.bigpoint.darkorbit.com.module.StationModuleModule;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.BattleStationConstants;
   
   public class ModuleVO implements IEventDispatcher
   {
      
      public static const NONE:uint = 0;
      
      public static const DESTROYED:uint = 1;
      
      public static const HULL:uint = 2;
      
      public static const DEFLECTOR:uint = 3;
      
      public static const REPAIR:uint = 4;
      
      public static const LASER_HIGH_RANGE:uint = 5;
      
      public static const LASER_MID_RANGE:uint = 6;
      
      public static const LASER_LOW_RANGE:uint = 7;
      
      public static const ROCKET_MID_ACCURACY:uint = 8;
      
      public static const ROCKET_LOW_ACCURACY:uint = 9;
      
      public static const HONOR_BOOSTER:uint = 10;
      
      public static const DAMAGE_BOOSTER:uint = 11;
      
      public static const EXPERIENCE_BOOSTER:uint = 12;
      
      private var _itemId:int;
      
      private var _type:int;
      
      private var _slotOccupying:int = -1;
      
      private var _currentHitpoints:int;
      
      private var _currentShield:int;
      
      private var _maxHitpoints:int;
      
      private var _installationSecondsTotal:int;
      
      private var _installationSecondsLeft:Number;
      
      private var _instalationDuration:Number;
      
      private var _buildStartTime:Number = 0;
      
      private var _emergencyRepairSecondsLeft:int = 0;
      
      private var _emergencyRepairCost:int;
      
      private var _upgradeLevel:int;
      
      private var _maxShield:int;
      
      private var _ownerName:String;
      
      private var _emergencyRepairSecondsTotal:int;
      
      private var _draggable:Boolean = true;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function ModuleVO(param1:int = 0, param2:int = 0, param3:int = -1, param4:int = -1, param5:int = -1, param6:int = -1, param7:Number = -1, param8:int = -1, param9:int = -1, param10:int = -1, param11:int = -1, param12:String = "", param13:int = -1, param14:int = -1, param15:Boolean = true)
      {
         super();
         this._itemId = param1;
         this._type = param2;
         this._slotOccupying = param14;
         this._currentHitpoints = param3;
         this._currentShield = param4;
         this._maxHitpoints = param5;
         this._installationSecondsTotal = param6;
         this._installationSecondsLeft = param7;
         this._emergencyRepairSecondsLeft = param8;
         this._emergencyRepairCost = param9;
         this._upgradeLevel = param10;
         this._maxShield = param11;
         this._ownerName = param12;
         this._emergencyRepairSecondsTotal = param13;
         this._draggable = param15;
      }
      
      public function init(param1:StationModuleModule) : void
      {
         this._itemId = param1.itemId;
         this._type = param1.type;
         this._currentHitpoints = param1.currentHitpoints;
         this._currentShield = param1.currentShield;
         this._maxHitpoints = param1.maxHitpoints;
         this._maxShield = param1.maxShield;
         this._upgradeLevel = param1.upgradeLevel;
         this._ownerName = param1.ownerName;
         this._emergencyRepairCost = param1.emergencyRepairCost;
         this._emergencyRepairSecondsLeft = param1.emergencyRepairSecondsLeft;
         this._emergencyRepairSecondsTotal = param1.emergencyRepairSecondsTotal;
         this._installationSecondsTotal = param1.installationSeconds;
         this._installationSecondsLeft = param1.installationSecondsLeft;
         if(this._installationSecondsLeft > 0)
         {
            this._instalationDuration = 0;
            this._buildStartTime = new Date().getTime();
         }
      }
      
      public function update(param1:int, param2:int, param3:int, param4:int) : void
      {
         this._emergencyRepairSecondsLeft = param1;
         this._emergencyRepairSecondsTotal = param2;
         this._currentHitpoints = param3;
         this._currentShield = param4;
      }
      
      public function updateInstallacionTime(param1:int) : void
      {
         this._instalationDuration = 0;
         this.installationSecondsLeft = param1;
      }
      
      public function get moduleId() : String
      {
         return BattleStationConstants.MODULES_IDS_MAP[this._type];
      }
      
      public function get category() : String
      {
         return BattleStationConstants.CATEGORIES_IDS_MAP[this._type];
      }
      
      public function clone() : ModuleVO
      {
         return new ModuleVO(this._itemId,this._type,this._currentHitpoints,this._currentShield,this._maxHitpoints,this._installationSecondsTotal,this._installationSecondsLeft,this._emergencyRepairSecondsLeft,this._emergencyRepairCost,this._upgradeLevel,this._maxShield,this._ownerName,this._emergencyRepairSecondsTotal,this._slotOccupying,this._draggable);
      }
      
      public function reset() : void
      {
         this._itemId = 0;
         this._type = NONE;
         this._currentHitpoints = this._currentShield = 0;
         this._slotOccupying = -1;
         this._installationSecondsLeft = this._buildStartTime = this._emergencyRepairSecondsLeft = this._emergencyRepairCost = 0;
      }
      
      public function get destroyed() : Boolean
      {
         return this._currentHitpoints == 0;
      }
      
      public function get itemId() : int
      {
         return this._itemId;
      }
      
      private function set _1178662002itemId(param1:int) : void
      {
         this._itemId = param1;
      }
      
      public function get type() : int
      {
         return this._type;
      }
      
      private function set _3575610type(param1:int) : void
      {
         this._type = param1;
      }
      
      public function get slotOccupying() : int
      {
         return this._slotOccupying;
      }
      
      private function set _729556139slotOccupying(param1:int) : void
      {
         this._slotOccupying = param1;
      }
      
      public function get currentHitpoints() : int
      {
         return this._currentHitpoints;
      }
      
      private function set _657903427currentHitpoints(param1:int) : void
      {
         this._currentHitpoints = param1;
      }
      
      public function get currentShield() : int
      {
         return this._currentShield;
      }
      
      private function set _2063005118currentShield(param1:int) : void
      {
         this._currentShield = param1;
      }
      
      public function get maxHitpoints() : int
      {
         return this._maxHitpoints;
      }
      
      private function set _1074921778maxHitpoints(param1:int) : void
      {
         this._maxHitpoints = param1;
      }
      
      public function get installationSecondsTotal() : int
      {
         return this._installationSecondsTotal;
      }
      
      private function set _123239585installationSecondsTotal(param1:int) : void
      {
         this._installationSecondsTotal = param1;
      }
      
      public function get installationSecondsLeft() : Number
      {
         return this._installationSecondsLeft;
      }
      
      public function get emergencyRepairSecondsLeft() : int
      {
         return this._emergencyRepairSecondsLeft;
      }
      
      public function get emergencyRepairCost() : int
      {
         return this._emergencyRepairCost;
      }
      
      public function get upgradeLevel() : int
      {
         return this._upgradeLevel;
      }
      
      private function set _1354890552upgradeLevel(param1:int) : void
      {
         this._upgradeLevel = param1;
      }
      
      public function get maxShield() : int
      {
         return this._maxShield;
      }
      
      private function set _588376595maxShield(param1:int) : void
      {
         this._maxShield = param1;
      }
      
      public function get ownerName() : String
      {
         return this._ownerName;
      }
      
      private function set _17453022ownerName(param1:String) : void
      {
         this._ownerName = param1;
      }
      
      public function get emergencyRepairSecondsTotal() : int
      {
         return this._emergencyRepairSecondsTotal;
      }
      
      private function set _1518239651emergencyRepairSecondsTotal(param1:int) : void
      {
         this._emergencyRepairSecondsTotal = param1;
      }
      
      public function get draggable() : Boolean
      {
         return this._draggable;
      }
      
      private function set _304480883draggable(param1:Boolean) : void
      {
         this._draggable = param1;
      }
      
      public function get buildStartTime() : Number
      {
         return this._buildStartTime;
      }
      
      private function set _698794111buildStartTime(param1:Number) : void
      {
         this._buildStartTime = param1;
      }
      
      public function get instalationDuration() : Number
      {
         return this._instalationDuration;
      }
      
      private function set _1241711016instalationDuration(param1:Number) : void
      {
         this._instalationDuration = param1;
      }
      
      private function set _1112602484installationSecondsLeft(param1:Number) : void
      {
         this._installationSecondsLeft = param1;
         if(this._installationSecondsLeft > 0)
         {
            this._buildStartTime = new Date().getTime();
         }
      }
      
      private function set _89820216emergencyRepairSecondsLeft(param1:int) : void
      {
         this._emergencyRepairSecondsLeft = param1;
      }
      
      [Bindable(event="propertyChange")]
      public function set maxHitpoints(param1:int) : void
      {
         var _loc2_:Object = this.maxHitpoints;
         if(_loc2_ !== param1)
         {
            this._1074921778maxHitpoints = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"maxHitpoints",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set installationSecondsLeft(param1:Number) : void
      {
         var _loc2_:Object = this.installationSecondsLeft;
         if(_loc2_ !== param1)
         {
            this._1112602484installationSecondsLeft = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"installationSecondsLeft",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set maxShield(param1:int) : void
      {
         var _loc2_:Object = this.maxShield;
         if(_loc2_ !== param1)
         {
            this._588376595maxShield = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"maxShield",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set instalationDuration(param1:Number) : void
      {
         var _loc2_:Object = this.instalationDuration;
         if(_loc2_ !== param1)
         {
            this._1241711016instalationDuration = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"instalationDuration",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set currentShield(param1:int) : void
      {
         var _loc2_:Object = this.currentShield;
         if(_loc2_ !== param1)
         {
            this._2063005118currentShield = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"currentShield",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set type(param1:int) : void
      {
         var _loc2_:Object = this.type;
         if(_loc2_ !== param1)
         {
            this._3575610type = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"type",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set emergencyRepairSecondsLeft(param1:int) : void
      {
         var _loc2_:Object = this.emergencyRepairSecondsLeft;
         if(_loc2_ !== param1)
         {
            this._89820216emergencyRepairSecondsLeft = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"emergencyRepairSecondsLeft",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set itemId(param1:int) : void
      {
         var _loc2_:Object = this.itemId;
         if(_loc2_ !== param1)
         {
            this._1178662002itemId = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"itemId",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set currentHitpoints(param1:int) : void
      {
         var _loc2_:Object = this.currentHitpoints;
         if(_loc2_ !== param1)
         {
            this._657903427currentHitpoints = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"currentHitpoints",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set ownerName(param1:String) : void
      {
         var _loc2_:Object = this.ownerName;
         if(_loc2_ !== param1)
         {
            this._17453022ownerName = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"ownerName",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set draggable(param1:Boolean) : void
      {
         var _loc2_:Object = this.draggable;
         if(_loc2_ !== param1)
         {
            this._304480883draggable = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"draggable",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set slotOccupying(param1:int) : void
      {
         var _loc2_:Object = this.slotOccupying;
         if(_loc2_ !== param1)
         {
            this._729556139slotOccupying = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"slotOccupying",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set upgradeLevel(param1:int) : void
      {
         var _loc2_:Object = this.upgradeLevel;
         if(_loc2_ !== param1)
         {
            this._1354890552upgradeLevel = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"upgradeLevel",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set installationSecondsTotal(param1:int) : void
      {
         var _loc2_:Object = this.installationSecondsTotal;
         if(_loc2_ !== param1)
         {
            this._123239585installationSecondsTotal = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"installationSecondsTotal",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set buildStartTime(param1:Number) : void
      {
         var _loc2_:Object = this.buildStartTime;
         if(_loc2_ !== param1)
         {
            this._698794111buildStartTime = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"buildStartTime",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set emergencyRepairSecondsTotal(param1:int) : void
      {
         var _loc2_:Object = this.emergencyRepairSecondsTotal;
         if(_loc2_ !== param1)
         {
            this._1518239651emergencyRepairSecondsTotal = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"emergencyRepairSecondsTotal",_loc2_,param1));
            }
         }
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
   }
}

