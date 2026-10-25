package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class MapChangedCommand implements IModule
   {
      
      private static var _instance:MapChangedCommand;
      
      public var newMapId:int = 0;
      
      public function MapChangedCommand(param1:int = 0)
      {
         super();
         this.newMapId = param1;
      }
      
      public static function get instance() : MapChangedCommand
      {
         return _instance || (_instance = new MapChangedCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 138;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.newMapId = param1.readInt();
         this.newMapId = this.newMapId >>> 4 % 32 | this.newMapId << 32 - 4 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(138);
         param1.writeInt(this.newMapId << 4 % 32 | this.newMapId >>> 32 - 4 % 32);
      }
   }
}

