package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ConfigChangeRequest implements IModule
   {
      
      private static var _instance:ConfigChangeRequest;
      
      public var presetId:int = 0;
      
      public function ConfigChangeRequest(param1:int = 0)
      {
         super();
         this.presetId = param1;
      }
      
      public static function get instance() : ConfigChangeRequest
      {
         return _instance || (_instance = new ConfigChangeRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 35;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 2;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.presetId = param1.readShort();
         this.presetId = 0xFFFF & ((0xFFFF & this.presetId) << 2 % 16 | (0xFFFF & this.presetId) >>> 16 - 2 % 16);
         this.presetId = this.presetId > 32767 ? int(this.presetId - 65536) : this.presetId;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(35);
         param1.writeShort(0xFFFF & ((0xFFFF & this.presetId) >>> 2 % 16 | (0xFFFF & this.presetId) << 16 - 2 % 16));
      }
   }
}

