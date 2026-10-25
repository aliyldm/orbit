package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class MiniClientRewardDayInfoCommand implements IModule
   {
      
      private static var _instance:MiniClientRewardDayInfoCommand;
      
      public var isClaimable:Boolean = false;
      
      public var daysClaimed:int = 0;
      
      public function MiniClientRewardDayInfoCommand(param1:int = 0, param2:Boolean = false)
      {
         super();
         this.isClaimable = param2;
         this.daysClaimed = param1;
      }
      
      public static function get instance() : MiniClientRewardDayInfoCommand
      {
         return _instance || (_instance = new MiniClientRewardDayInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 28159;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 3;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.isClaimable = param1.readBoolean();
         this.daysClaimed = param1.readShort();
         this.daysClaimed = 0xFFFF & ((0xFFFF & this.daysClaimed) >>> 1 % 16 | (0xFFFF & this.daysClaimed) << 16 - 1 % 16);
         this.daysClaimed = this.daysClaimed > 32767 ? int(this.daysClaimed - 65536) : this.daysClaimed;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(28159);
         param1.writeBoolean(this.isClaimable);
         param1.writeShort(0xFFFF & ((0xFFFF & this.daysClaimed) << 1 % 16 | (0xFFFF & this.daysClaimed) >>> 16 - 1 % 16));
      }
   }
}

