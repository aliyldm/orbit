package net.bigpoint.darkorbit.mvc.gui.windows.armoryUnlock.handler
{
   import net.bigpoint.darkorbit.com.module.porting.armoryunlock.ArmoryUnlockClaimInfoCommand;
   import net.bigpoint.darkorbit.com.module.porting.armoryunlock.ArmoryUnlockLootShowListCommand;
   
   public class ArmoryUnlockShipData
   {
      
      public var group:int;
      
      public var shipLootId:String;
      
      public var lootShowList:ArmoryUnlockLootShowListCommand;
      
      public var itemList:Vector.<ArmoryUnlockClaimInfoCommand>;
      
      public var locked:Boolean;
      
      public function ArmoryUnlockShipData(param1:String = "", param2:ArmoryUnlockLootShowListCommand = null, param3:Vector.<ArmoryUnlockClaimInfoCommand> = null, param4:Boolean = false)
      {
         super();
         this.shipLootId = param1;
         this.lootShowList = param2 ? param2 : new ArmoryUnlockLootShowListCommand();
         if(!param2)
         {
            this.lootShowList.shipLootId = param1;
         }
         this.group = this.lootShowList.group;
         this.itemList = param3 ? param3 : new Vector.<ArmoryUnlockClaimInfoCommand>();
         this.locked = param4;
      }
   }
}

