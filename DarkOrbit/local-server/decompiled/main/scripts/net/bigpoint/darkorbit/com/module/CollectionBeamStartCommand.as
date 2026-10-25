package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class CollectionBeamStartCommand implements IModule
   {
      
      private static var _instance:CollectionBeamStartCommand;
      
      public var isPlayer:Boolean = false;
      
      public var mapObjectId:int = 0;
      
      public var duration:int = 0;
      
      public function CollectionBeamStartCommand(param1:Boolean = false, param2:int = 0, param3:int = 0)
      {
         super();
         this.isPlayer = param1;
         this.mapObjectId = param2;
         this.duration = param3;
      }
      
      public static function get instance() : CollectionBeamStartCommand
      {
         return _instance || (_instance = new CollectionBeamStartCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 250;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 9;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.isPlayer = param1.readBoolean();
         this.mapObjectId = param1.readInt();
         this.mapObjectId = this.mapObjectId >>> 3 % 32 | this.mapObjectId << 32 - 3 % 32;
         this.duration = param1.readInt();
         this.duration = this.duration << 10 % 32 | this.duration >>> 32 - 10 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(250);
         param1.writeBoolean(this.isPlayer);
         param1.writeInt(this.mapObjectId << 3 % 32 | this.mapObjectId >>> 32 - 3 % 32);
         param1.writeInt(this.duration >>> 10 % 32 | this.duration << 32 - 10 % 32);
      }
   }
}

