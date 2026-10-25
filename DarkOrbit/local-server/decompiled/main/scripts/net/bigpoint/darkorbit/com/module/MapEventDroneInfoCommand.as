package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class MapEventDroneInfoCommand implements IModule
   {
      
      private static var _instance:MapEventDroneInfoCommand;
      
      public var simple:Boolean = false;
      
      public var legacyDroneCommandString:String = "";
      
      public function MapEventDroneInfoCommand(param1:Boolean = false, param2:String = "")
      {
         super();
         this.simple = param1;
         this.legacyDroneCommandString = param2;
      }
      
      public static function get instance() : MapEventDroneInfoCommand
      {
         return _instance || (_instance = new MapEventDroneInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 180;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 3;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.simple = param1.readBoolean();
         this.legacyDroneCommandString = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(180);
         param1.writeBoolean(this.simple);
         param1.writeUTF(this.legacyDroneCommandString);
      }
   }
}

