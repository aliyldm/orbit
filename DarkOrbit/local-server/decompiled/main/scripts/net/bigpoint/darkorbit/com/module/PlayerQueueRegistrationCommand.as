package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class PlayerQueueRegistrationCommand implements IModule
   {
      
      private static var _instance:PlayerQueueRegistrationCommand;
      
      public var gateId:int = 0;
      
      public var positionInQueue:int = 0;
      
      public function PlayerQueueRegistrationCommand(param1:int = 0, param2:int = 0)
      {
         super();
         this.gateId = param1;
         this.positionInQueue = param2;
      }
      
      public static function get instance() : PlayerQueueRegistrationCommand
      {
         return _instance || (_instance = new PlayerQueueRegistrationCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 6671;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.gateId = param1.readInt();
         this.gateId = this.gateId << 3 % 32 | this.gateId >>> 32 - 3 % 32;
         this.positionInQueue = param1.readInt();
         this.positionInQueue = this.positionInQueue >>> 11 % 32 | this.positionInQueue << 32 - 11 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(6671);
         param1.writeInt(this.gateId >>> 3 % 32 | this.gateId << 32 - 3 % 32);
         param1.writeInt(this.positionInQueue << 11 % 32 | this.positionInQueue >>> 32 - 11 % 32);
      }
   }
}

