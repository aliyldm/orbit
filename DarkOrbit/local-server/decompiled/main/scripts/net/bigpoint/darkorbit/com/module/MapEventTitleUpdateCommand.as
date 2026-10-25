package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class MapEventTitleUpdateCommand implements IModule
   {
      
      private static var _instance:MapEventTitleUpdateCommand;
      
      public static const ACTION_SET_TITLE:int = 0;
      
      public static const ACTION_REMOVE_TITLE:int = 1;
      
      public static const ACTION__MAX:int = 2;
      
      public static const TITLETYPE_UNIQUE_PERMANENT:int = 0;
      
      public static const TITLETYPE_UNIQUE_LOSABLE:int = 1;
      
      public static const TITLETYPE_MULTIPLE_PERMANENT:int = 2;
      
      public static const TITLETYPE_MULTIPLE_USABLE:int = 3;
      
      public static const TITLETYPE__MAX:int = 4;
      
      public var type:int = 0;
      
      public var titleAction:int = 0;
      
      public var userId:int = 0;
      
      public var titleKey:String = "";
      
      public function MapEventTitleUpdateCommand(param1:int = 0, param2:int = 0, param3:int = 0, param4:String = "")
      {
         super();
         this.type = param1;
         this.titleAction = param2;
         this.userId = param3;
         this.titleKey = param4;
      }
      
      public static function get instance() : MapEventTitleUpdateCommand
      {
         return _instance || (_instance = new MapEventTitleUpdateCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 183;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 6;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.type = param1.readShort();
         this.titleAction = param1.readShort();
         this.userId = param1.readInt();
         this.userId = this.userId >>> 5 % 32 | this.userId << 32 - 5 % 32;
         this.titleKey = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(183);
         param1.writeShort(this.type);
         param1.writeShort(this.titleAction);
         param1.writeInt(this.userId << 5 % 32 | this.userId >>> 32 - 5 % 32);
         param1.writeUTF(this.titleKey);
      }
   }
}

