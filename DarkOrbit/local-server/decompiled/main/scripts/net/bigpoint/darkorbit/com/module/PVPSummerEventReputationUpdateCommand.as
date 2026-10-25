package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class PVPSummerEventReputationUpdateCommand implements IModule
   {
      
      private static var _instance:PVPSummerEventReputationUpdateCommand;
      
      public var uid:int = 0;
      
      public var reputation:int = 0;
      
      public function PVPSummerEventReputationUpdateCommand(param1:int = 0, param2:int = 0)
      {
         super();
         this.uid = param1;
         this.reputation = param2;
      }
      
      public static function get instance() : PVPSummerEventReputationUpdateCommand
      {
         return _instance || (_instance = new PVPSummerEventReputationUpdateCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -18578;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.uid = param1.readInt();
         this.uid = this.uid >>> 3 % 32 | this.uid << 32 - 3 % 32;
         this.reputation = param1.readInt();
         this.reputation = this.reputation << 6 % 32 | this.reputation >>> 32 - 6 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-18578);
         param1.writeInt(this.uid << 3 % 32 | this.uid >>> 32 - 3 % 32);
         param1.writeInt(this.reputation >>> 6 % 32 | this.reputation << 32 - 6 % 32);
      }
   }
}

