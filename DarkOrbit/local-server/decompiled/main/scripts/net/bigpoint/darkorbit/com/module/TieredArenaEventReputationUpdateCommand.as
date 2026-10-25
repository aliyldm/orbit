package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class TieredArenaEventReputationUpdateCommand implements IModule
   {
      
      private static var _instance:TieredArenaEventReputationUpdateCommand;
      
      public var uid:int = 0;
      
      public var reputation:int = 0;
      
      public function TieredArenaEventReputationUpdateCommand(param1:int = 0, param2:int = 0)
      {
         super();
         this.uid = param1;
         this.reputation = param2;
      }
      
      public static function get instance() : TieredArenaEventReputationUpdateCommand
      {
         return _instance || (_instance = new TieredArenaEventReputationUpdateCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -25367;
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
         this.reputation = this.reputation >>> 13 % 32 | this.reputation << 32 - 13 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-25367);
         param1.writeInt(this.uid << 3 % 32 | this.uid >>> 32 - 3 % 32);
         param1.writeInt(this.reputation << 13 % 32 | this.reputation >>> 32 - 13 % 32);
      }
   }
}

