package net.bigpoint.darkorbit.com.module.porting.skylab
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class SkylabStorageOreCommand implements IModule
   {
      
      private static var _instance:SkylabStorageOreCommand;
      
      public var current:int = 0;
      
      public var oreId:int = 0;
      
      public var capacity:int = 0;
      
      public var oreName:String = "";
      
      public function SkylabStorageOreCommand(param1:int = 0, param2:String = "", param3:int = 0, param4:int = 0)
      {
         super();
         this.current = param3;
         this.oreId = param1;
         this.capacity = param4;
         this.oreName = param2;
      }
      
      public static function get instance() : SkylabStorageOreCommand
      {
         return _instance || (_instance = new SkylabStorageOreCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 8345;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 14;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.current = param1.readInt();
         this.current = this.current >>> 11 % 32 | this.current << 32 - 11 % 32;
         this.oreId = param1.readInt();
         this.oreId = this.oreId << 4 % 32 | this.oreId >>> 32 - 4 % 32;
         this.capacity = param1.readInt();
         this.capacity = this.capacity >>> 2 % 32 | this.capacity << 32 - 2 % 32;
         this.oreName = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(8345);
         param1.writeInt(this.current << 11 % 32 | this.current >>> 32 - 11 % 32);
         param1.writeInt(this.oreId >>> 4 % 32 | this.oreId << 32 - 4 % 32);
         param1.writeInt(this.capacity << 2 % 32 | this.capacity >>> 32 - 2 % 32);
         param1.writeUTF(this.oreName);
      }
   }
}

