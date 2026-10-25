package net.bigpoint.darkorbit.com.module.porting.birthday2025
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class Birthday2025GateEnterRequest implements IModule
   {
      
      private static var _instance:Birthday2025GateEnterRequest;
      
      public var level:int = 0;
      
      public function Birthday2025GateEnterRequest(param1:int = 0)
      {
         super();
         this.level = param1;
      }
      
      public static function get instance() : Birthday2025GateEnterRequest
      {
         return _instance || (_instance = new Birthday2025GateEnterRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 5598;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.level = param1.readInt();
         this.level = this.level << 16 % 32 | this.level >>> 32 - 16 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(5598);
         param1.writeInt(this.level >>> 16 % 32 | this.level << 32 - 16 % 32);
      }
   }
}

