package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class TieredArenaEventSelfReputationUpdateCommand implements IModule
   {
      
      private static var _instance:TieredArenaEventSelfReputationUpdateCommand;
      
      public var participationReputation:int = 0;
      
      public var reputation:int = 0;
      
      public function TieredArenaEventSelfReputationUpdateCommand(param1:int = 0, param2:int = 0)
      {
         super();
         this.participationReputation = param2;
         this.reputation = param1;
      }
      
      public static function get instance() : TieredArenaEventSelfReputationUpdateCommand
      {
         return _instance || (_instance = new TieredArenaEventSelfReputationUpdateCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 2853;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.participationReputation = param1.readInt();
         this.participationReputation = this.participationReputation << 14 % 32 | this.participationReputation >>> 32 - 14 % 32;
         this.reputation = param1.readInt();
         this.reputation = this.reputation << 2 % 32 | this.reputation >>> 32 - 2 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(2853);
         param1.writeInt(this.participationReputation >>> 14 % 32 | this.participationReputation << 32 - 14 % 32);
         param1.writeInt(this.reputation >>> 2 % 32 | this.reputation << 32 - 2 % 32);
      }
   }
}

