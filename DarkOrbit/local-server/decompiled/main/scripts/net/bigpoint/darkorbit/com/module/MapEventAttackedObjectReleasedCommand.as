package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class MapEventAttackedObjectReleasedCommand implements IModule
   {
      
      private static var _instance:MapEventAttackedObjectReleasedCommand;
      
      public var releasedObjectId:int = 0;
      
      public function MapEventAttackedObjectReleasedCommand(param1:int = 0)
      {
         super();
         this.releasedObjectId = param1;
      }
      
      public static function get instance() : MapEventAttackedObjectReleasedCommand
      {
         return _instance || (_instance = new MapEventAttackedObjectReleasedCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 178;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.releasedObjectId = param1.readInt();
         this.releasedObjectId = this.releasedObjectId >>> 10 % 32 | this.releasedObjectId << 32 - 10 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(178);
         param1.writeInt(this.releasedObjectId << 10 % 32 | this.releasedObjectId >>> 32 - 10 % 32);
      }
   }
}

