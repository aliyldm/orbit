package net.bigpoint.darkorbit.mvc.gui.windows.armoryUnlock.handler
{
   import com.bigpoint.utils.bindables.BindableCountDown;
   import net.bigpoint.darkorbit.com.module.porting.armoryunlock.ArmoryUnlockClaimInfoCommand;
   import net.bigpoint.darkorbit.com.module.porting.armoryunlock.ArmoryUnlockClaimInfoGroupCommand;
   import net.bigpoint.darkorbit.com.module.porting.armoryunlock.ArmoryUnlockLootShowListCommand;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class ArmoryUnlockInfoData
   {
      
      public const changed:ISignal = new Signal();
      
      public const countdownTimer:BindableCountDown = new BindableCountDown();
      
      public var normal:ArmoryUnlockLootShowListCommand;
      
      public var special:ArmoryUnlockLootShowListCommand;
      
      public var specials:Vector.<ArmoryUnlockLootShowListCommand>;
      
      public var claimInfoCommandList:Vector.<ArmoryUnlockClaimInfoCommand>;
      
      public var claimInfoGroupCommands:Vector.<ArmoryUnlockClaimInfoGroupCommand>;
      
      public var selectedClaimInfoGroupCommand:Vector.<ArmoryUnlockClaimInfoCommand>;
      
      public var selectedGroup:int;
      
      public var canReset:Boolean;
      
      public var shipList:Vector.<ArmoryUnlockShipData> = new Vector.<ArmoryUnlockShipData>();
      
      public var selectedShipIndex:int = 0;
      
      public var lockedShipIndex:int = -1;
      
      public var selectionLocked:Boolean = false;
      
      public var eventRemainSeconds:int;
      
      public function ArmoryUnlockInfoData()
      {
         super();
         this.normal = new ArmoryUnlockLootShowListCommand();
         this.special = new ArmoryUnlockLootShowListCommand();
         this.specials = new Vector.<ArmoryUnlockLootShowListCommand>();
         this.claimInfoCommandList = new Vector.<ArmoryUnlockClaimInfoCommand>();
         this.claimInfoGroupCommands = new Vector.<ArmoryUnlockClaimInfoGroupCommand>();
         this.selectedClaimInfoGroupCommand = new Vector.<ArmoryUnlockClaimInfoCommand>();
      }
   }
}

