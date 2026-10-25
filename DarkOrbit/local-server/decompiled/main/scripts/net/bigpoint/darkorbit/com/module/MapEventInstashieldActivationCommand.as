package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class MapEventInstashieldActivationCommand implements IModule
   {
      
      private static var _instance:MapEventInstashieldActivationCommand;
      
      public var shieldedObjectId:int = 0;
      
      public function MapEventInstashieldActivationCommand(param1:int = 0)
      {
         super();
         this.shieldedObjectId = param1;
      }
      
      public static function get instance() : MapEventInstashieldActivationCommand
      {
         return _instance || (_instance = new MapEventInstashieldActivationCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 185;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.shieldedObjectId = param1.readInt();
         this.shieldedObjectId = this.shieldedObjectId >>> 7 % 32 | this.shieldedObjectId << 32 - 7 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(185);
         param1.writeInt(this.shieldedObjectId << 7 % 32 | this.shieldedObjectId >>> 32 - 7 % 32);
      }
   }
}

