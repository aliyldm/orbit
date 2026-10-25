package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class MapEventMapTitleUpdateCommand implements IModule
   {
      
      private static var _instance:MapEventMapTitleUpdateCommand;
      
      public var mapId:int = 0;
      
      public var mapTitle:String = "";
      
      public function MapEventMapTitleUpdateCommand(param1:int = 0, param2:String = "")
      {
         super();
         this.mapId = param1;
         this.mapTitle = param2;
      }
      
      public static function get instance() : MapEventMapTitleUpdateCommand
      {
         return _instance || (_instance = new MapEventMapTitleUpdateCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 188;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 6;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.mapId = param1.readInt();
         this.mapId = this.mapId >>> 8 % 32 | this.mapId << 32 - 8 % 32;
         this.mapTitle = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(188);
         param1.writeInt(this.mapId << 8 % 32 | this.mapId >>> 32 - 8 % 32);
         param1.writeUTF(this.mapTitle);
      }
   }
}

