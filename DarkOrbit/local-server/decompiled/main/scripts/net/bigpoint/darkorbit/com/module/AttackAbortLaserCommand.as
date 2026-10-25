package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class AttackAbortLaserCommand implements IModule
   {
      
      private static var _instance:AttackAbortLaserCommand;
      
      public var uid:int = 0;
      
      public function AttackAbortLaserCommand(param1:int = 0)
      {
         super();
         this.uid = param1;
      }
      
      public static function get instance() : AttackAbortLaserCommand
      {
         return _instance || (_instance = new AttackAbortLaserCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 10141;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.uid = param1.readInt();
         this.uid = this.uid >>> 2 % 32 | this.uid << 32 - 2 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(10141);
         param1.writeInt(this.uid << 2 % 32 | this.uid >>> 32 - 2 % 32);
      }
   }
}

