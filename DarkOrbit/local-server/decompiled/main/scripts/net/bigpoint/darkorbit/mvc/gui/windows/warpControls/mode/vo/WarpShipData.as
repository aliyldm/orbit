package net.bigpoint.darkorbit.mvc.gui.windows.warpControls.mode.vo
{
   import net.bigpoint.darkorbit.com.module.porting.hangar.HangarShipBriefCommand;
   import net.bigpoint.darkorbit.com.module.porting.hangar.HangarShipEquipmentCommand;
   import net.bigpoint.darkorbit.com.module.porting.hangar.HangarShipEquipmentMsg;
   import net.bigpoint.darkorbit.delete_in_eic.ItemDataProviderHelper;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.items.item.traits.SlotableTrait;
   import net.bigpoint.darkorbit.mvc.gui.windows.warpControls.mode.WarpControlsConst;
   
   public class WarpShipData
   {
      
      private var _isActive:Boolean = false;
      
      private var _shipId:Number = 0;
      
      private var _lootId:String = "";
      
      private var _isFavorite:Boolean = false;
      
      private var _itemVo:ItemVO;
      
      private var _hangarId:Number;
      
      private var _equipmentWeapons:Object;
      
      public function WarpShipData(param1:HangarShipBriefCommand = null)
      {
         super();
         if(!param1)
         {
            return;
         }
         this.update(param1);
      }
      
      private function initEquipmentWeapon() : void
      {
         this._equipmentWeapons = {};
         this._equipmentWeapons[WarpControlsConst.CANNONS] = [new Vector.<int>(),new Vector.<int>()];
         this._equipmentWeapons[WarpControlsConst.CANNON_SHIELDS] = [new Vector.<int>(),new Vector.<int>()];
         this._equipmentWeapons[WarpControlsConst.QUANTUMFLUIDCORE] = [new Vector.<int>(),new Vector.<int>()];
         this._equipmentWeapons[WarpControlsConst.ENGINE_WEAPON] = [new Vector.<int>(),new Vector.<int>()];
         this._equipmentWeapons[WarpControlsConst.ENGINE_ARMOR] = [new Vector.<int>(),new Vector.<int>()];
      }
      
      public function update(param1:HangarShipBriefCommand) : void
      {
         this._isActive = param1.isActive;
         this._shipId = param1.shipId;
         this._isFavorite = param1.isFavorite;
         this._lootId = param1.lootId;
         this._itemVo = ItemDataProviderHelper.getItem(this._lootId);
      }
      
      public function updateShipWeapons(param1:HangarShipEquipmentCommand) : void
      {
         var _loc3_:HangarShipEquipmentMsg = null;
         if(!this._equipmentWeapons)
         {
            this.initEquipmentWeapon();
         }
         var _loc2_:int = 0;
         while(_loc2_ < param1.shipConfigs.length)
         {
            _loc3_ = param1.shipConfigs[_loc2_];
            if(_loc3_.cannon)
            {
               this._equipmentWeapons[WarpControlsConst.CANNONS][_loc3_.setId - 1] = _loc3_.cannon;
            }
            if(_loc3_.cannonShield)
            {
               this._equipmentWeapons[WarpControlsConst.CANNON_SHIELDS][_loc3_.setId - 1] = _loc3_.cannonShield;
            }
            if(_loc3_.QuantumFluidCore)
            {
               this._equipmentWeapons[WarpControlsConst.QUANTUMFLUIDCORE][_loc3_.setId - 1] = _loc3_.QuantumFluidCore;
            }
            if(_loc3_.drive)
            {
               this._equipmentWeapons[WarpControlsConst.ENGINE_WEAPON][_loc3_.setId - 1] = _loc3_.drive;
            }
            if(_loc3_.lens)
            {
               this._equipmentWeapons[WarpControlsConst.ENGINE_ARMOR][_loc3_.setId - 1] = _loc3_.lens;
            }
            _loc2_++;
         }
      }
      
      public function removeEquipment(param1:String, param2:int, param3:Number) : void
      {
         var _loc4_:Array = this.equipmentWeapons[param1][param2 - 1];
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_.length)
         {
            if(_loc4_[_loc5_].itemId == param3)
            {
               _loc4_.splice(_loc5_,1);
               return;
            }
            _loc5_++;
         }
      }
      
      public function addEquipment(param1:String, param2:int, param3:Number) : void
      {
         this._equipmentWeapons[param1][param2 - 1].push(param3);
      }
      
      public function get equipmentWeapons() : Object
      {
         return this._equipmentWeapons;
      }
      
      public function get hangarId() : Number
      {
         return this._hangarId;
      }
      
      public function set hangarId(param1:Number) : void
      {
         this._hangarId = param1;
      }
      
      public function get itemVo() : ItemVO
      {
         return this._itemVo;
      }
      
      public function get isActive() : Boolean
      {
         return this._isActive;
      }
      
      public function get shipId() : Number
      {
         return this._shipId;
      }
      
      public function get lootId() : String
      {
         return this._lootId;
      }
      
      public function get isFavorite() : Boolean
      {
         return this._isFavorite;
      }
      
      public function getSoltable(param1:String) : *
      {
         var _loc3_:int = 0;
         var _loc4_:* = undefined;
         var _loc5_:int = 0;
         var _loc6_:* = undefined;
         var _loc2_:* = this._itemVo.item.traits.getTraitsAllByType("slotable");
         if(_loc2_)
         {
            _loc3_ = 0;
            loop0:
            while(_loc3_ < _loc2_.length)
            {
               _loc4_ = (_loc2_[_loc3_] as SlotableTrait).slots;
               _loc5_ = 0;
               while(true)
               {
                  if(_loc5_ >= _loc4_.length)
                  {
                     _loc3_++;
                     continue loop0;
                  }
                  _loc6_ = _loc4_[_loc5_];
                  if(_loc6_.name == param1)
                  {
                     break;
                  }
                  _loc5_++;
               }
               return _loc6_;
            }
         }
      }
   }
}

