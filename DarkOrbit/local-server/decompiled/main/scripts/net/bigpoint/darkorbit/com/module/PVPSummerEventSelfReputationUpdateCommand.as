package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class PVPSummerEventSelfReputationUpdateCommand implements IModule
   {
      
      private static var _instance:PVPSummerEventSelfReputationUpdateCommand;
      
      public var repPerKill:int = 0;
      
      public var nextMilestone:int = 0;
      
      public var reputation:int = 0;
      
      public function PVPSummerEventSelfReputationUpdateCommand(param1:int = 0, param2:int = 0, param3:int = 0)
      {
         super();
         this.repPerKill = param2;
         this.nextMilestone = param3;
         this.reputation = param1;
      }
      
      public static function get instance() : PVPSummerEventSelfReputationUpdateCommand
      {
         return _instance || (_instance = new PVPSummerEventSelfReputationUpdateCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -30100;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 12;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.repPerKill = param1.readInt();
         this.repPerKill = this.repPerKill << 6 % 32 | this.repPerKill >>> 32 - 6 % 32;
         this.nextMilestone = param1.readInt();
         this.nextMilestone = this.nextMilestone >>> 1 % 32 | this.nextMilestone << 32 - 1 % 32;
         this.reputation = param1.readInt();
         this.reputation = this.reputation >>> 15 % 32 | this.reputation << 32 - 15 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-30100);
         param1.writeInt(this.repPerKill >>> 6 % 32 | this.repPerKill << 32 - 6 % 32);
         param1.writeInt(this.nextMilestone << 1 % 32 | this.nextMilestone >>> 32 - 1 % 32);
         param1.writeInt(this.reputation << 15 % 32 | this.reputation >>> 32 - 15 % 32);
      }
   }
}

