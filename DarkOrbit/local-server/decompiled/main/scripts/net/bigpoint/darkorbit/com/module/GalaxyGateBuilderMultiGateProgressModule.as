package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class GalaxyGateBuilderMultiGateProgressModule implements IModule
   {
      
      private static var _instance:GalaxyGateBuilderMultiGateProgressModule;
      
      public var total:int = 0;
      
      public var current:int = 0;
      
      public var name:String = "";
      
      public function GalaxyGateBuilderMultiGateProgressModule(param1:String = "", param2:int = 0, param3:int = 0)
      {
         super();
         this.total = param2;
         this.current = param3;
         this.name = param1;
      }
      
      public static function get instance() : GalaxyGateBuilderMultiGateProgressModule
      {
         return _instance || (_instance = new GalaxyGateBuilderMultiGateProgressModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 14839;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 6;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.total = param1.readShort();
         this.total = 0xFFFF & ((0xFFFF & this.total) << 12 % 16 | (0xFFFF & this.total) >>> 16 - 12 % 16);
         this.total = this.total > 32767 ? int(this.total - 65536) : this.total;
         this.current = param1.readShort();
         this.current = 0xFFFF & ((0xFFFF & this.current) << 11 % 16 | (0xFFFF & this.current) >>> 16 - 11 % 16);
         this.current = this.current > 32767 ? int(this.current - 65536) : this.current;
         this.name = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(14839);
         param1.writeShort(0xFFFF & ((0xFFFF & this.total) >>> 12 % 16 | (0xFFFF & this.total) << 16 - 12 % 16));
         param1.writeShort(0xFFFF & ((0xFFFF & this.current) >>> 11 % 16 | (0xFFFF & this.current) << 16 - 11 % 16));
         param1.writeUTF(this.name);
      }
   }
}

