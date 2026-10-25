package net.bigpoint.darkorbit.mvc.gui.windows.spacemap.model
{
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.gui.GuiManager;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.model.SimpleWindowProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.spacemap.SpaceMapNotifications;
   import net.bigpoint.darkorbit.mvc.gui.windows.spacemap.model.vo.AvailableJumpVO;
   import net.bigpoint.darkorbit.mvc.gui.windows.spacemap.model.vo.JumpCpuStatusVO;
   import net.bigpoint.darkorbit.mvc.gui.windows.spacemap.model.vo.JumpInfoVO;
   import net.bigpoint.darkorbit.mvc.gui.windows.spacemap.model.vo.SpaceMapHardLockVO;
   import net.bigpoint.darkorbit.mvc.gui.windows.spacemap.model.vo.SpaceMapsStatusVO;
   import net.bigpoint.darkorbit.mvc.gui.windows.spacemap.view.ui.meta.SpaceMapDataItem;
   import net.bigpoint.darkorbit.mvc.spaceMap.vo.SpaceMapStationInfoVO;
   
   public class SpaceMapWindowProxy extends SimpleWindowProxy
   {
      
      private var _jumpVoucherAmount:int = 0;
      
      private var _advancedJumpCPUEquipped:Boolean;
      
      private var _jumpStatusVO:JumpInfoVO;
      
      private var _availableJumpVO:AvailableJumpVO;
      
      private var _spaceMapsVO:SpaceMapsStatusVO;
      
      private var _hardLock:SpaceMapHardLockVO = null;
      
      public function SpaceMapWindowProxy(param1:String, param2:Object = null)
      {
         super(param1,param2);
      }
      
      public function get currentMapType() : String
      {
         var _loc1_:int = GuiManager.instance.getMain().screenManager.map.getMapID();
         return SpaceMapConfig.getMapType(_loc1_);
      }
      
      public function get jumpVoucherAmount() : int
      {
         return this._jumpVoucherAmount;
      }
      
      public function get advancedJumpCPUEquipped() : Boolean
      {
         return this._advancedJumpCPUEquipped;
      }
      
      public function get jumpStatusVO() : JumpInfoVO
      {
         return this._jumpStatusVO;
      }
      
      public function get availableJumpVO() : AvailableJumpVO
      {
         return this._availableJumpVO;
      }
      
      public function get spaceMapsVO() : SpaceMapsStatusVO
      {
         return this._spaceMapsVO;
      }
      
      public function get hardLock() : Boolean
      {
         return this._hardLock.status;
      }
      
      public function setHardLock(param1:Boolean) : void
      {
         if(this._hardLock == null)
         {
            this._hardLock = new SpaceMapHardLockVO(false,false);
         }
         var _loc2_:Boolean = this._hardLock.status;
         var _loc3_:Boolean = this._hardLock.obfuscateMapData;
         var _loc4_:Boolean = !Boolean(this.currentMapType);
         this._hardLock = new SpaceMapHardLockVO(param1,_loc4_);
         if(_loc2_ != param1 || _loc3_ != _loc4_)
         {
            sendNotification(SpaceMapNotifications.SPACE_MAP_HARD_LOCK_UPDATED,this._hardLock);
         }
      }
      
      public function updateJumpCPUEquippedStatus(param1:Boolean, param2:Vector.<SpaceMapStationInfoVO>) : void
      {
         this._advancedJumpCPUEquipped = param1;
         var _loc3_:Boolean = this.currentMapType != null && this.currentMapType.length > 0;
         if(!this._advancedJumpCPUEquipped)
         {
            this.setHardLock(!_loc3_);
         }
         var _loc4_:JumpCpuStatusVO = new JumpCpuStatusVO(this._advancedJumpCPUEquipped,param2,_loc3_);
         sendNotification(SpaceMapNotifications.SPACE_MAP_JUMP_CPU_EQUIPPED_STATUS_UPDATED,_loc4_);
      }
      
      public function updateSpaceMapStatus(param1:int, param2:int) : void
      {
         this._jumpStatusVO = new JumpInfoVO(param1,param2);
         sendNotification(SpaceMapNotifications.SPACE_MAP_JUMP_STATUS_UPDATED,this._jumpStatusVO);
      }
      
      public function setAvailableJump(param1:Array) : void
      {
         var _loc2_:int = 3;
         var _loc3_:int = int(param1[++_loc2_]);
         var _loc4_:int = int(param1[++_loc2_]);
         var _loc5_:int = int(param1[++_loc2_]);
         this._availableJumpVO = new AvailableJumpVO(_loc3_,_loc4_,_loc5_,this._jumpVoucherAmount);
         sendNotification(SpaceMapNotifications.SPACE_MAP_SET_AVAILABLE_JUMP,this._availableJumpVO);
      }
      
      public function updateJumpVoucherAmount(param1:Array) : void
      {
         this._jumpVoucherAmount = int(param1[3]);
         sendNotification(SpaceMapNotifications.SPACE_MAP_JUMP_VOUCHER_UPDATED,this._jumpVoucherAmount);
      }
      
      public function updateAdvanceWindow(param1:Array, param2:Vector.<SpaceMapStationInfoVO>) : void
      {
         if(param1.length < 5)
         {
            this.setHardLock(true);
            return;
         }
         this.setHardLock(false);
         var _loc3_:String = "";
         var _loc4_:String = "-1";
         var _loc5_:String = "-2";
         var _loc6_:Array = [];
         var _loc7_:Array = [];
         var _loc8_:Array = [];
         var _loc9_:Array = param1.slice(4,param1.length);
         var _loc10_:int = 0;
         while(_loc10_ < _loc9_.length)
         {
            _loc3_ = String(_loc9_[_loc10_]);
            if(_loc3_.split(";").length < 2)
            {
               if(_loc3_ == _loc4_)
               {
                  _loc6_ = this.getMapIDsList(_loc9_,_loc10_);
               }
               else if(_loc3_ == _loc5_)
               {
                  _loc7_ = this.getMapIDsList(_loc9_,_loc10_);
               }
               else
               {
                  _loc8_.push([_loc3_,this.getMapIDsList(_loc9_,_loc10_)]);
               }
            }
            _loc10_++;
         }
         var _loc11_:Object = {};
         _loc11_ = this.getLevelLockedMaps(_loc6_,_loc11_);
         _loc11_ = this.getUriLockedMaps(_loc7_,_loc11_);
         _loc11_ = this.getAvailableMaps(_loc8_,_loc11_);
         _loc11_ = this.getPirateMaps(_loc11_);
         _loc11_ = this.getEnemyMaps(_loc11_);
         this._spaceMapsVO = new SpaceMapsStatusVO(_loc11_,param2);
         sendNotification(SpaceMapNotifications.SPACE_MAP_MAPS_STATUS_UPDATED,this._spaceMapsVO);
      }
      
      protected function getLevelLockedMaps(param1:Array, param2:Object = null) : Object
      {
         var _loc3_:int = 0;
         if(param2 == null)
         {
            param2 = {};
         }
         var _loc4_:uint = param1.length;
         var _loc5_:uint = 0;
         while(_loc5_ < _loc4_)
         {
            _loc3_ = parseInt(param1[_loc5_]);
            param2[_loc3_] = SpaceMapDataItem.LEVEL_LOCKED;
            _loc5_++;
         }
         return param2;
      }
      
      protected function getUriLockedMaps(param1:Array, param2:Object = null) : Object
      {
         var _loc3_:int = 0;
         if(param2 == null)
         {
            param2 = {};
         }
         var _loc4_:uint = param1.length;
         var _loc5_:uint = 0;
         while(_loc5_ < _loc4_)
         {
            _loc3_ = parseInt(param1[_loc5_]);
            param2[_loc3_] = SpaceMapDataItem.URI_LOCKED;
            _loc5_++;
         }
         return param2;
      }
      
      protected function getPirateMaps(param1:Object = null) : Object
      {
         var _loc2_:int = 0;
         var _loc3_:Array = null;
         if(param1 == null)
         {
            param1 = {};
         }
         _loc3_ = SpaceMapConfig.getMapIds(SpaceMapConfig.PIRATE_MAP);
         var _loc4_:uint = _loc3_.length;
         var _loc5_:uint = 0;
         while(_loc5_ < _loc4_)
         {
            _loc2_ = int(_loc3_[_loc5_]);
            param1[_loc2_] = SpaceMapDataItem.PIRATE_MAP;
            _loc5_++;
         }
         return param1;
      }
      
      protected function getEnemyMaps(param1:Object = null) : Object
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         if(param1 == null)
         {
            param1 = {};
         }
         _loc2_ = SpaceMapConfig.getEnemyMaps(Hero.factionID.value);
         var _loc4_:uint = _loc2_.length;
         var _loc5_:uint = 0;
         while(_loc5_ < _loc4_)
         {
            _loc3_ = int(_loc2_[_loc5_]);
            param1[_loc3_] = SpaceMapDataItem.ENEMY_MAP;
            _loc5_++;
         }
         return param1;
      }
      
      protected function getAvailableMaps(param1:Array, param2:Object = null) : Object
      {
         var _loc5_:Array = null;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         if(param2 == null)
         {
            param2 = {};
         }
         var _loc3_:uint = param1.length;
         var _loc4_:uint = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = param1[_loc4_][1];
            _loc6_ = _loc5_.length;
            _loc7_ = 0;
            while(_loc7_ < _loc6_)
            {
               _loc8_ = parseInt(_loc5_[_loc7_]);
               param2[_loc8_] = SpaceMapDataItem.NO_ICON;
               _loc7_++;
            }
            _loc4_++;
         }
         return param2;
      }
      
      protected function getMapIDsList(param1:Array, param2:int) : Array
      {
         var _loc3_:Array = String(param1[param2 + 1]).split(";");
         _loc3_.pop();
         return _loc3_;
      }
   }
}

