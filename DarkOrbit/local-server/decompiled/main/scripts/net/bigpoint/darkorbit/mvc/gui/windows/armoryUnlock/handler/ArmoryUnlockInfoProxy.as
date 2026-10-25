package net.bigpoint.darkorbit.mvc.gui.windows.armoryUnlock.handler
{
   import net.bigpoint.darkorbit.com.module.porting.armoryunlock.ArmoryUnlockClaimInfoCommand;
   import net.bigpoint.darkorbit.com.module.porting.armoryunlock.ArmoryUnlockClaimInfoGroupCommand;
   import net.bigpoint.darkorbit.com.module.porting.armoryunlock.ArmoryUnlockInfoCommand;
   import net.bigpoint.darkorbit.com.module.porting.armoryunlock.ArmoryUnlockLootShowCommand;
   import net.bigpoint.darkorbit.com.module.porting.armoryunlock.ArmoryUnlockLootShowListCommand;
   import net.bigpoint.darkorbit.com.module.porting.events.LootProbabilityModule;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.model.SimpleWindowProxy;
   
   public class ArmoryUnlockInfoProxy extends SimpleWindowProxy
   {
      
      private var _completionNotifiedGroup:int = 0;
      
      public function ArmoryUnlockInfoProxy(param1:String)
      {
         super(param1,new ArmoryUnlockInfoData());
      }
      
      public function get viewData() : ArmoryUnlockInfoData
      {
         return this.data as ArmoryUnlockInfoData;
      }
      
      public function updateViewData(param1:ArmoryUnlockInfoCommand) : void
      {
         if(!param1)
         {
            return;
         }
         var _loc2_:ArmoryUnlockInfoData = this.getData() as ArmoryUnlockInfoData;
         _loc2_.normal = param1.normal ? param1.normal : new ArmoryUnlockLootShowListCommand();
         _loc2_.specials = param1.specials ? param1.specials : new Vector.<ArmoryUnlockLootShowListCommand>();
         _loc2_.claimInfoGroupCommands = param1.claimInfoGroupCommands ? param1.claimInfoGroupCommands : new Vector.<ArmoryUnlockClaimInfoGroupCommand>();
         _loc2_.selectedClaimInfoGroupCommand = param1.selectedClaimInfoGroupCommand ? param1.selectedClaimInfoGroupCommand : new Vector.<ArmoryUnlockClaimInfoCommand>();
         _loc2_.claimInfoCommandList = _loc2_.selectedClaimInfoGroupCommand;
         _loc2_.selectedGroup = param1.selectedGroup;
         _loc2_.canReset = param1.canReset;
         _loc2_.eventRemainSeconds = param1.eventRemainSeconds;
         _loc2_.countdownTimer.value = param1.eventRemainSeconds;
         _loc2_.shipList = this.createShipList(_loc2_.specials,_loc2_.claimInfoGroupCommands,_loc2_.selectedClaimInfoGroupCommand,_loc2_.selectedGroup);
         var _loc3_:int = this.findGroupIndex(_loc2_.shipList,_loc2_.selectedGroup);
         var _loc4_:Boolean = _loc2_.selectedGroup > 0 && _loc2_.canReset && this.allClaimRewardsCollected(_loc2_.selectedClaimInfoGroupCommand);
         _loc2_.selectionLocked = _loc2_.selectedGroup > 0 && !_loc4_;
         if(_loc2_.selectionLocked && _loc3_ >= 0)
         {
            _loc2_.selectedShipIndex = _loc3_;
         }
         else if(_loc2_.selectedShipIndex < 0 || _loc2_.selectedShipIndex >= _loc2_.shipList.length)
         {
            _loc2_.selectedShipIndex = 0;
         }
         _loc2_.lockedShipIndex = _loc2_.selectionLocked ? _loc3_ : -1;
         _loc2_.special = this.findSpecialForGroup(_loc2_.specials,_loc2_.selectedGroup);
         if(!_loc2_.special && _loc2_.specials.length > 0)
         {
            _loc2_.special = _loc2_.specials[0];
         }
         _loc2_.changed.dispatch();
         if(_loc4_ && this._completionNotifiedGroup != _loc2_.selectedGroup)
         {
            this._completionNotifiedGroup = _loc2_.selectedGroup;
            sendNotification(GuiNotifications.MINIMIZE_WINDOW_BY_ID,GuiConstants.ARMORY_UNLOCK);
         }
         if(!_loc4_ && _loc2_.selectedGroup != this._completionNotifiedGroup)
         {
            this._completionNotifiedGroup = 0;
         }
      }
      
      private function createShipList(param1:Vector.<ArmoryUnlockLootShowListCommand>, param2:Vector.<ArmoryUnlockClaimInfoGroupCommand>, param3:Vector.<ArmoryUnlockClaimInfoCommand>, param4:int) : Vector.<ArmoryUnlockShipData>
      {
         var _loc6_:ArmoryUnlockLootShowListCommand = null;
         var _loc7_:int = 0;
         var _loc8_:Vector.<ArmoryUnlockClaimInfoCommand> = null;
         var _loc9_:ArmoryUnlockLootShowListCommand = null;
         var _loc10_:ArmoryUnlockShipData = null;
         var _loc5_:Vector.<ArmoryUnlockShipData> = new Vector.<ArmoryUnlockShipData>();
         if(!param1)
         {
            return _loc5_;
         }
         for each(_loc6_ in param1)
         {
            if(_loc6_)
            {
               _loc7_ = _loc6_.group;
               _loc8_ = this.copyClaimList(_loc6_.claimInfoCommandList);
               if(_loc8_.length == 0)
               {
                  _loc8_ = this.claimsForGroup(_loc7_,param2,param3,param4);
               }
               _loc9_ = this.copyLootList(_loc6_);
               _loc10_ = new ArmoryUnlockShipData(_loc6_.shipLootId,_loc9_,_loc8_,false);
               _loc10_.group = _loc7_;
               _loc5_.push(_loc10_);
            }
         }
         return _loc5_;
      }
      
      private function claimsForGroup(param1:int, param2:Vector.<ArmoryUnlockClaimInfoGroupCommand>, param3:Vector.<ArmoryUnlockClaimInfoCommand>, param4:int) : Vector.<ArmoryUnlockClaimInfoCommand>
      {
         var _loc5_:ArmoryUnlockClaimInfoGroupCommand = null;
         if(param2)
         {
            for each(_loc5_ in param2)
            {
               if(Boolean(_loc5_) && _loc5_.group == param1)
               {
                  return this.copyClaimList(_loc5_.claimInfoCommandList);
               }
            }
         }
         if(param1 == param4)
         {
            return this.copyClaimList(param3);
         }
         return new Vector.<ArmoryUnlockClaimInfoCommand>();
      }
      
      private function copyLootList(param1:ArmoryUnlockLootShowListCommand) : ArmoryUnlockLootShowListCommand
      {
         var _loc2_:ArmoryUnlockLootShowListCommand = null;
         _loc2_ = new ArmoryUnlockLootShowListCommand();
         if(!param1)
         {
            return _loc2_;
         }
         _loc2_.group = param1.group;
         _loc2_.claimInfoCommandList = this.copyClaimList(param1.claimInfoCommandList);
         _loc2_.shipLootId = param1.shipLootId;
         _loc2_.resourceAmount = param1.resourceAmount;
         _loc2_.resourceLootId = param1.resourceLootId;
         _loc2_.showLootCommandList = this.copyShowLootList(param1.showLootCommandList);
         _loc2_.probabilityModuleList = this.copyProbabilityList(param1.probabilityModuleList);
         return _loc2_;
      }
      
      private function copyShowLootList(param1:Vector.<ArmoryUnlockLootShowCommand>) : Vector.<ArmoryUnlockLootShowCommand>
      {
         var _loc3_:ArmoryUnlockLootShowCommand = null;
         var _loc2_:Vector.<ArmoryUnlockLootShowCommand> = new Vector.<ArmoryUnlockLootShowCommand>();
         if(!param1)
         {
            return _loc2_;
         }
         for each(_loc3_ in param1)
         {
            if(_loc3_)
            {
               _loc2_.push(new ArmoryUnlockLootShowCommand(_loc3_.lootId,_loc3_.lootAmount,_loc3_.bg,_loc3_.line,_loc3_.showShipIcon));
            }
         }
         return _loc2_;
      }
      
      private function copyProbabilityList(param1:Vector.<LootProbabilityModule>) : Vector.<LootProbabilityModule>
      {
         var _loc3_:LootProbabilityModule = null;
         var _loc2_:Vector.<LootProbabilityModule> = new Vector.<LootProbabilityModule>();
         if(!param1)
         {
            return _loc2_;
         }
         for each(_loc3_ in param1)
         {
            if(_loc3_)
            {
               _loc2_.push(new LootProbabilityModule(_loc3_.probabilityPercentage,_loc3_.lootId,_loc3_.minLootAmount,_loc3_.maxLootAmount));
            }
         }
         return _loc2_;
      }
      
      private function copyClaimList(param1:Vector.<ArmoryUnlockClaimInfoCommand>) : Vector.<ArmoryUnlockClaimInfoCommand>
      {
         var _loc3_:ArmoryUnlockClaimInfoCommand = null;
         var _loc2_:Vector.<ArmoryUnlockClaimInfoCommand> = new Vector.<ArmoryUnlockClaimInfoCommand>();
         if(!param1)
         {
            return _loc2_;
         }
         for each(_loc3_ in param1)
         {
            if(_loc3_)
            {
               _loc2_.push(new ArmoryUnlockClaimInfoCommand(_loc3_.lootId,_loc3_.lootAmount,_loc3_.desc,_loc3_.progressQuantity,_loc3_.currentProgress,_loc3_.canClaim,_loc3_.claimed,_loc3_.special,_loc3_.index));
            }
         }
         return _loc2_;
      }
      
      private function findGroupIndex(param1:Vector.<ArmoryUnlockShipData>, param2:int) : int
      {
         if(!param1 || param2 <= 0)
         {
            return -1;
         }
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            if(Boolean(param1[_loc3_]) && param1[_loc3_].group == param2)
            {
               return _loc3_;
            }
            _loc3_++;
         }
         return -1;
      }
      
      private function findSpecialForGroup(param1:Vector.<ArmoryUnlockLootShowListCommand>, param2:int) : ArmoryUnlockLootShowListCommand
      {
         var _loc3_:ArmoryUnlockLootShowListCommand = null;
         if(!param1 || param2 <= 0)
         {
            return null;
         }
         for each(_loc3_ in param1)
         {
            if(Boolean(_loc3_) && _loc3_.group == param2)
            {
               return _loc3_;
            }
         }
         return null;
      }
      
      private function allClaimRewardsCollected(param1:Vector.<ArmoryUnlockClaimInfoCommand>) : Boolean
      {
         var _loc2_:ArmoryUnlockClaimInfoCommand = null;
         if(!param1 || param1.length == 0)
         {
            return false;
         }
         for each(_loc2_ in param1)
         {
            if(!_loc2_ || !_loc2_.claimed)
            {
               return false;
            }
         }
         return true;
      }
   }
}

