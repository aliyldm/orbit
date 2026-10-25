package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class MapEventSmartbombExplosionCommand implements IModule
   {
      
      private static var _instance:MapEventSmartbombExplosionCommand;
      
      public var ownerId:int = 0;
      
      public function MapEventSmartbombExplosionCommand(param1:int = 0)
      {
         super();
         this.ownerId = param1;
      }
      
      public static function get instance() : MapEventSmartbombExplosionCommand
      {
         return _instance || (_instance = new MapEventSmartbombExplosionCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 184;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.ownerId = param1.readInt();
         this.ownerId = this.ownerId >>> 7 % 32 | this.ownerId << 32 - 7 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(184);
         param1.writeInt(this.ownerId << 7 % 32 | this.ownerId >>> 32 - 7 % 32);
      }
   }
}

