package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class UnstableModulesShardCommand implements IModule
   {
      
      private static var _instance:UnstableModulesShardCommand;
      
      public var chipLeft:int = 0;
      
      public var shardsLeft:int = 0;
      
      public function UnstableModulesShardCommand(param1:int = 0, param2:int = 0)
      {
         super();
         this.chipLeft = param2;
         this.shardsLeft = param1;
      }
      
      public static function get instance() : UnstableModulesShardCommand
      {
         return _instance || (_instance = new UnstableModulesShardCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -24468;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.chipLeft = param1.readInt();
         this.chipLeft = this.chipLeft << 6 % 32 | this.chipLeft >>> 32 - 6 % 32;
         this.shardsLeft = param1.readInt();
         this.shardsLeft = this.shardsLeft << 14 % 32 | this.shardsLeft >>> 32 - 14 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-24468);
         param1.writeInt(this.chipLeft >>> 6 % 32 | this.chipLeft << 32 - 6 % 32);
         param1.writeInt(this.shardsLeft >>> 14 % 32 | this.shardsLeft << 32 - 14 % 32);
      }
   }
}

