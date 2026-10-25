package net.bigpoint.darkorbit.mvc.gui.windows.synthesis.model.vo
{
   import net.bigpoint.darkorbit.com.module.porting.hangar.HangarShipEquipmentInventoryItem;
   import net.bigpoint.darkorbit.com.module.porting.synthesis.SynthesisCostLootCommand;
   import net.bigpoint.darkorbit.com.module.porting.synthesis.SynthesisGroupCommand;
   import net.bigpoint.darkorbit.com.module.porting.synthesis.SynthesisListCommand;
   import net.bigpoint.darkorbit.com.module.porting.synthesis.SynthesisModuleCommand;
   import net.bigpoint.darkorbit.com.module.porting.synthesis.SynthesisModuleListCommand;
   import org.osflash.signals.Signal;
   
   public class SynthesisViewData
   {
      
      public var change:Signal = new Signal();
      
      public var viewListDataComplet:Boolean = false;
      
      public var inventoryDataComplet:Boolean = false;
      
      private var type_groups:Vector.<SynthesisGroupCommand>;
      
      private var cannonTypes:Object;
      
      private var _buttonTypes:Object;
      
      private var _secondaryButtonTypes:Object;
      
      private var _groupTabTypes:Vector.<String>;
      
      private var _inventoryItems:Vector.<HangarShipEquipmentInventoryItem>;
      
      private var _tabViewButton:Object;
      
      public function SynthesisViewData()
      {
         super();
      }
      
      public function set inventoryItems(param1:Vector.<HangarShipEquipmentInventoryItem>) : void
      {
         this._inventoryItems = param1;
         this.inventoryDataComplet = true;
         this.change.dispatch();
      }
      
      public function updateInventoryItems(param1:Vector.<HangarShipEquipmentInventoryItem>, param2:Boolean) : void
      {
         var _loc3_:int = 0;
         var _loc4_:HangarShipEquipmentInventoryItem = null;
         var _loc5_:int = 0;
         if(!this._inventoryItems)
         {
            this._inventoryItems = new Vector.<HangarShipEquipmentInventoryItem>();
         }
         if(param1)
         {
            _loc3_ = 0;
            while(_loc3_ < param1.length)
            {
               _loc4_ = param1[_loc3_];
               if(_loc4_)
               {
                  _loc5_ = this.getInventoryItemIndexByItemId(_loc4_.itemid);
                  if(param2)
                  {
                     if(_loc5_ >= 0)
                     {
                        this._inventoryItems.splice(_loc5_,1);
                     }
                  }
                  else if(_loc5_ >= 0)
                  {
                     this._inventoryItems[_loc5_] = _loc4_;
                  }
                  else
                  {
                     this._inventoryItems.push(_loc4_);
                  }
               }
               _loc3_++;
            }
         }
         this.inventoryDataComplet = true;
         this.change.dispatch();
      }
      
      public function get MainTabTypes() : Vector.<String>
      {
         return this._groupTabTypes;
      }
      
      public function setData(param1:SynthesisListCommand) : void
      {
         var _loc3_:SynthesisGroupCommand = null;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc6_:SynthesisModuleListCommand = null;
         var _loc7_:String = null;
         var _loc8_:Boolean = false;
         var _loc9_:int = 0;
         var _loc10_:SynthesisModuleCommand = null;
         var _loc11_:String = null;
         var _loc12_:CannonTypeItemVo = null;
         var _loc13_:int = 0;
         var _loc14_:Object = null;
         var _loc15_:String = null;
         this.type_groups = Boolean(param1) && Boolean(param1.groups) ? param1.groups : new Vector.<SynthesisGroupCommand>();
         this.cannonTypes = {};
         this._buttonTypes = {};
         this._secondaryButtonTypes = {};
         this._tabViewButton = {};
         this._groupTabTypes = new Vector.<String>();
         var _loc2_:int = 0;
         while(_loc2_ < this.type_groups.length)
         {
            _loc3_ = this.type_groups[_loc2_];
            if(_loc3_)
            {
               _loc4_ = _loc3_.group;
               if(!(!_loc4_ || _loc4_.length == 0))
               {
                  this._tabViewButton[_loc4_] = _loc3_.button;
                  if(!this.hasGroupTabType(_loc4_))
                  {
                     this._groupTabTypes.push(_loc4_);
                  }
                  if(!this.cannonTypes[_loc4_])
                  {
                     this.cannonTypes[_loc4_] = {};
                  }
                  if(!this._buttonTypes[_loc4_])
                  {
                     this._buttonTypes[_loc4_] = new Vector.<FilterButtonVo>();
                  }
                  if(!this._secondaryButtonTypes[_loc4_])
                  {
                     this._secondaryButtonTypes[_loc4_] = {};
                  }
                  if(_loc3_.moduleList)
                  {
                     _loc5_ = 0;
                     while(_loc5_ < _loc3_.moduleList.length)
                     {
                        _loc6_ = _loc3_.moduleList[_loc5_];
                        if(!(!_loc6_ || !_loc6_.modules))
                        {
                           _loc7_ = _loc6_.moduleListGroupType;
                           _loc8_ = _loc7_ != null && _loc7_.length > 0;
                           _loc9_ = 0;
                           while(_loc9_ < _loc6_.modules.length)
                           {
                              _loc10_ = _loc6_.modules[_loc9_];
                              if(_loc10_)
                              {
                                 _loc11_ = _loc8_ ? _loc7_ : _loc10_.moduleGroupType;
                                 if(!(!_loc11_ || _loc11_.length == 0))
                                 {
                                    _loc12_ = new CannonTypeItemVo(_loc11_,_loc10_);
                                    if(!this.hasButtonTpyes(_loc4_,_loc11_))
                                    {
                                       this._buttonTypes[_loc4_].push(new FilterButtonVo(_loc11_));
                                    }
                                    if(!this.cannonTypes[_loc4_][_loc11_])
                                    {
                                       this.cannonTypes[_loc4_][_loc11_] = new Vector.<CannonTypeItemVo>();
                                    }
                                    this.cannonTypes[_loc4_][_loc11_].push(_loc12_);
                                    if(_loc8_)
                                    {
                                       if(!this._secondaryButtonTypes[_loc4_][_loc11_])
                                       {
                                          this._secondaryButtonTypes[_loc4_][_loc11_] = {};
                                       }
                                       _loc13_ = _loc12_.startLevel;
                                       _loc14_ = this._secondaryButtonTypes[_loc4_][_loc11_];
                                       _loc15_ = _loc10_.moduleGroupType;
                                       if(_loc12_.hasStartLevel && _loc13_ >= 1 && _loc13_ <= SynthesisStartLevelUtil.MAX_START_LEVEL && _loc15_ != null && _loc15_.length > 0 && (!_loc14_[_loc13_] || _loc14_[_loc13_].length == 0))
                                       {
                                          _loc14_[_loc13_] = _loc15_;
                                       }
                                    }
                                 }
                              }
                              _loc9_++;
                           }
                        }
                        _loc5_++;
                     }
                  }
               }
            }
            _loc2_++;
         }
         this.viewListDataComplet = true;
         this.change.dispatch();
      }
      
      public function getButtonTypes(param1:String) : Vector.<FilterButtonVo>
      {
         if(!this._buttonTypes || !this._buttonTypes[param1])
         {
            return new Vector.<FilterButtonVo>();
         }
         return this._buttonTypes[param1];
      }
      
      public function getSecondaryButtonTypes(param1:String, param2:String) : Vector.<FilterButtonVo>
      {
         var _loc8_:CannonTypeItemVo = null;
         var _loc9_:int = 0;
         var _loc10_:String = null;
         var _loc3_:Vector.<FilterButtonVo> = new Vector.<FilterButtonVo>();
         if(!this._secondaryButtonTypes || !this._secondaryButtonTypes[param1] || !this._secondaryButtonTypes[param1][param2])
         {
            return _loc3_;
         }
         var _loc4_:Vector.<CannonTypeItemVo> = this.getCannonAllItemsByType(param1,param2);
         var _loc5_:Object = this._secondaryButtonTypes[param1][param2];
         var _loc6_:Object = {};
         if(!_loc4_)
         {
            return _loc3_;
         }
         var _loc7_:int = 0;
         while(_loc7_ < _loc4_.length)
         {
            _loc8_ = _loc4_[_loc7_];
            if(!(!_loc8_ || !_loc8_.hasStartLevel || _loc8_.startLevel < 1 || _loc8_.startLevel > SynthesisStartLevelUtil.MAX_START_LEVEL))
            {
               _loc9_ = _loc8_.startLevel;
               if(!_loc6_[_loc9_])
               {
                  _loc6_[_loc9_] = true;
                  _loc10_ = _loc5_[_loc9_];
                  if(!_loc10_ || _loc10_.length == 0)
                  {
                     _loc10_ = "Star" + _loc9_;
                  }
                  _loc3_.push(new FilterButtonVo(_loc10_,_loc9_,param2,true));
               }
            }
            _loc7_++;
         }
         return _loc3_;
      }
      
      public function getFlattenedButtonTypes(param1:String, param2:String = null) : Vector.<FilterButtonVo>
      {
         var _loc6_:FilterButtonVo = null;
         var _loc7_:Vector.<FilterButtonVo> = null;
         var _loc8_:int = 0;
         var _loc3_:Vector.<FilterButtonVo> = new Vector.<FilterButtonVo>();
         var _loc4_:Vector.<FilterButtonVo> = this.getButtonTypes(param1);
         if(!_loc4_)
         {
            return _loc3_;
         }
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_.length)
         {
            _loc6_ = _loc4_[_loc5_];
            _loc3_.push(_loc6_);
            if(param2 == _loc6_.type_name)
            {
               _loc7_ = this.getSecondaryButtonTypes(param1,_loc6_.type_name);
               _loc8_ = 0;
               while(_loc8_ < _loc7_.length)
               {
                  _loc3_.push(_loc7_[_loc8_]);
                  _loc8_++;
               }
            }
            _loc5_++;
         }
         return _loc3_;
      }
      
      public function getTypeIndex(param1:String, param2:String) : int
      {
         if(!this._buttonTypes || !this._buttonTypes[param1] || this._buttonTypes[param1].length == 0)
         {
            return -1;
         }
         var _loc3_:Vector.<FilterButtonVo> = this._buttonTypes[param1];
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length)
         {
            if(_loc3_[_loc4_].type_name == param2)
            {
               return _loc4_;
            }
            _loc4_++;
         }
         return -1;
      }
      
      public function getTabTypeIndex(param1:String) : int
      {
         if(!this._groupTabTypes)
         {
            return -1;
         }
         var _loc2_:int = 0;
         while(_loc2_ < this._groupTabTypes.length)
         {
            if(this._groupTabTypes[_loc2_] == param1)
            {
               return _loc2_;
            }
            _loc2_++;
         }
         return -1;
      }
      
      public function getCannonAllItemsByType(param1:String, param2:String, param3:int = -1) : Vector.<CannonTypeItemVo>
      {
         var _loc7_:CannonTypeItemVo = null;
         if(!this.cannonTypes || !this.cannonTypes[param1] || !this.cannonTypes[param1][param2])
         {
            return new Vector.<CannonTypeItemVo>();
         }
         var _loc4_:Vector.<CannonTypeItemVo> = this.cannonTypes[param1][param2];
         if(param3 == SynthesisStartLevelUtil.NO_FILTER)
         {
            return _loc4_;
         }
         var _loc5_:Vector.<CannonTypeItemVo> = new Vector.<CannonTypeItemVo>();
         var _loc6_:int = 0;
         while(_loc6_ < _loc4_.length)
         {
            _loc7_ = _loc4_[_loc6_];
            if((Boolean(_loc7_)) && _loc7_.startLevel == param3)
            {
               _loc5_.push(_loc7_);
            }
            _loc6_++;
         }
         return _loc5_;
      }
      
      public function getInventoryItemsByType(param1:Vector.<SynthesisCostLootCommand>, param2:Boolean = false) : Vector.<HangarShipEquipmentInventoryItem>
      {
         var _loc5_:HangarShipEquipmentInventoryItem = null;
         var _loc6_:int = 0;
         var _loc7_:SynthesisCostLootCommand = null;
         var _loc8_:Object = null;
         var _loc3_:Vector.<HangarShipEquipmentInventoryItem> = new Vector.<HangarShipEquipmentInventoryItem>();
         if(!this._inventoryItems || !param1)
         {
            return _loc3_;
         }
         var _loc4_:int = 0;
         while(_loc4_ < this._inventoryItems.length)
         {
            _loc5_ = this._inventoryItems[_loc4_];
            if(_loc5_)
            {
               _loc6_ = 0;
               while(_loc6_ < param1.length)
               {
                  _loc7_ = param1[_loc6_];
                  if(_loc7_)
                  {
                     if(_loc5_.lootId == _loc7_.lootId)
                     {
                        _loc8_ = _loc7_ as Object;
                        if(!param2 || !SynthesisStartLevelUtil.hasMappedStartLevel(_loc8_) || SynthesisStartLevelUtil.normalizeMappedStartLevel(_loc5_ as Object) == SynthesisStartLevelUtil.normalizeMappedStartLevel(_loc8_))
                        {
                           _loc3_.push(_loc5_);
                           break;
                        }
                     }
                  }
                  _loc6_++;
               }
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      public function getInventoryItemByLootId(param1:String) : HangarShipEquipmentInventoryItem
      {
         var _loc3_:HangarShipEquipmentInventoryItem = null;
         if(!this._inventoryItems)
         {
            return null;
         }
         var _loc2_:int = 0;
         while(_loc2_ < this._inventoryItems.length)
         {
            _loc3_ = this._inventoryItems[_loc2_];
            if(_loc3_.lootId == param1)
            {
               return _loc3_;
            }
            _loc2_++;
         }
         return null;
      }
      
      public function getInventoryItemByItemId(param1:Number) : HangarShipEquipmentInventoryItem
      {
         var _loc2_:int = this.getInventoryItemIndexByItemId(param1);
         return _loc2_ >= 0 ? this._inventoryItems[_loc2_] : null;
      }
      
      private function getInventoryItemIndexByItemId(param1:Number) : int
      {
         if(!this._inventoryItems)
         {
            return -1;
         }
         var _loc2_:int = 0;
         while(_loc2_ < this._inventoryItems.length)
         {
            if(this._inventoryItems[_loc2_].itemid == param1)
            {
               return _loc2_;
            }
            _loc2_++;
         }
         return -1;
      }
      
      private function hasButtonTpyes(param1:String, param2:String) : Boolean
      {
         var _loc3_:Vector.<FilterButtonVo> = this.getButtonTypes(param1);
         if(!_loc3_)
         {
            return false;
         }
         if(_loc3_.length <= 0)
         {
            return false;
         }
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length)
         {
            if(param2 == _loc3_[_loc4_].type_name)
            {
               return true;
            }
            _loc4_++;
         }
         return false;
      }
      
      private function hasGroupTabType(param1:String) : Boolean
      {
         if(!this._groupTabTypes)
         {
            return false;
         }
         var _loc2_:int = 0;
         while(_loc2_ < this._groupTabTypes.length)
         {
            if(this._groupTabTypes[_loc2_] == param1)
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      private function getAllCostLootId(param1:Vector.<SynthesisCostLootCommand>) : Vector.<String>
      {
         var _loc2_:Vector.<String> = new Vector.<String>();
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_.push(param1[_loc3_].lootId);
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function get tabViewButton() : Object
      {
         return this._tabViewButton;
      }
   }
}

