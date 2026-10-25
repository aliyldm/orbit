package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class PlayerQueueAlreadyRegisteredCommand implements IModule
   {
      
      private static var _instance:PlayerQueueAlreadyRegisteredCommand;
      
      public var gateId:int = 0;
      
      public function PlayerQueueAlreadyRegisteredCommand(param1:int = 0)
      {
         super();
         this.gateId = param1;
      }
      
      public static function get instance() : PlayerQueueAlreadyRegisteredCommand
      {
         return _instance || (_instance = new PlayerQueueAlreadyRegisteredCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 6672;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.gateId = param1.readInt();
         this.gateId = this.gateId << 6 % 32 | this.gateId >>> 32 - 6 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(6672);
         param1.writeInt(this.gateId >>> 6 % 32 | this.gateId << 32 - 6 % 32);
      }
   }
}

