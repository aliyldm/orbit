package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class JumpGateRemoveCommand implements IModule
   {
      
      private static var _instance:JumpGateRemoveCommand;
      
      public var gateId:int = 0;
      
      public function JumpGateRemoveCommand(param1:int = 0)
      {
         super();
         this.gateId = param1;
      }
      
      public static function get instance() : JumpGateRemoveCommand
      {
         return _instance || (_instance = new JumpGateRemoveCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 4274;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.gateId = param1.readInt();
         this.gateId = this.gateId >>> 12 % 32 | this.gateId << 32 - 12 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(4274);
         param1.writeInt(this.gateId << 12 % 32 | this.gateId >>> 32 - 12 % 32);
      }
   }
}

