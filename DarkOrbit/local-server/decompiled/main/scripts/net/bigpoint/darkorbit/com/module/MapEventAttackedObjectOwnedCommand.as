package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class MapEventAttackedObjectOwnedCommand implements IModule
   {
      
      private static var _instance:MapEventAttackedObjectOwnedCommand;
      
      public var ownedObjectId:int = 0;
      
      public var ownerId:int = 0;
      
      public function MapEventAttackedObjectOwnedCommand(param1:int = 0, param2:int = 0)
      {
         super();
         this.ownedObjectId = param1;
         this.ownerId = param2;
      }
      
      public static function get instance() : MapEventAttackedObjectOwnedCommand
      {
         return _instance || (_instance = new MapEventAttackedObjectOwnedCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 177;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.ownedObjectId = param1.readInt();
         this.ownedObjectId = this.ownedObjectId << 10 % 32 | this.ownedObjectId >>> 32 - 10 % 32;
         this.ownerId = param1.readInt();
         this.ownerId = this.ownerId << 10 % 32 | this.ownerId >>> 32 - 10 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(177);
         param1.writeInt(this.ownedObjectId >>> 10 % 32 | this.ownedObjectId << 32 - 10 % 32);
         param1.writeInt(this.ownerId >>> 10 % 32 | this.ownerId << 32 - 10 % 32);
      }
   }
}

