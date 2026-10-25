package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ReturneeLoginRewardDayInfoCommand implements IModule
   {
      
      private static var _instance:ReturneeLoginRewardDayInfoCommand;
      
      public var daysClaimed:int = 0;
      
      public var isClaimable:Boolean = false;
      
      public function ReturneeLoginRewardDayInfoCommand(param1:int = 0, param2:Boolean = false)
      {
         super();
         this.daysClaimed = param1;
         this.isClaimable = param2;
      }
      
      public static function get instance() : ReturneeLoginRewardDayInfoCommand
      {
         return _instance || (_instance = new ReturneeLoginRewardDayInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 16089;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 3;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.daysClaimed = param1.readShort();
         this.daysClaimed = 0xFFFF & ((0xFFFF & this.daysClaimed) << 9 % 16 | (0xFFFF & this.daysClaimed) >>> 16 - 9 % 16);
         this.daysClaimed = this.daysClaimed > 32767 ? int(this.daysClaimed - 65536) : this.daysClaimed;
         this.isClaimable = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(16089);
         param1.writeShort(0xFFFF & ((0xFFFF & this.daysClaimed) >>> 9 % 16 | (0xFFFF & this.daysClaimed) << 16 - 9 % 16));
         param1.writeBoolean(this.isClaimable);
      }
   }
}

