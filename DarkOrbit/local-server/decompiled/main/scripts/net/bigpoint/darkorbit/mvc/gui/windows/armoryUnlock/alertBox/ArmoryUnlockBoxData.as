package net.bigpoint.darkorbit.mvc.gui.windows.armoryUnlock.alertBox
{
   import net.bigpoint.darkorbit.com.module.RewardModule;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class ArmoryUnlockBoxData
   {
      
      public const changed:ISignal = new Signal();
      
      public const rewardModuleList:Vector.<RewardModule> = new Vector.<RewardModule>();
      
      public var _type:int;
      
      public var _count:int;
      
      public function ArmoryUnlockBoxData()
      {
         super();
      }
   }
}

