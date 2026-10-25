package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class MapEventCloakStateCommand implements IModule
   {
      
      private static var _instance:MapEventCloakStateCommand;
      
      public var shipId:int = 0;
      
      public var visible:Boolean = false;
      
      public function MapEventCloakStateCommand(param1:int = 0, param2:Boolean = false)
      {
         super();
         this.shipId = param1;
         this.visible = param2;
      }
      
      public static function get instance() : MapEventCloakStateCommand
      {
         return _instance || (_instance = new MapEventCloakStateCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 179;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 5;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.shipId = param1.readInt();
         this.shipId = this.shipId >>> 5 % 32 | this.shipId << 32 - 5 % 32;
         this.visible = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(179);
         param1.writeInt(this.shipId << 5 % 32 | this.shipId >>> 32 - 5 % 32);
         param1.writeBoolean(this.visible);
      }
   }
}

