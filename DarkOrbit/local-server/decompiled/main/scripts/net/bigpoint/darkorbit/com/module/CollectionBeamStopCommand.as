package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class CollectionBeamStopCommand implements IModule
   {
      
      private static var _instance:CollectionBeamStopCommand;
      
      public var isPlayer:Boolean = false;
      
      public var mapObjectId:int = 0;
      
      public function CollectionBeamStopCommand(param1:Boolean = false, param2:int = 0)
      {
         super();
         this.isPlayer = param1;
         this.mapObjectId = param2;
      }
      
      public static function get instance() : CollectionBeamStopCommand
      {
         return _instance || (_instance = new CollectionBeamStopCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 251;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 5;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.isPlayer = param1.readBoolean();
         this.mapObjectId = param1.readInt();
         this.mapObjectId = this.mapObjectId >>> 12 % 32 | this.mapObjectId << 32 - 12 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(251);
         param1.writeBoolean(this.isPlayer);
         param1.writeInt(this.mapObjectId << 12 % 32 | this.mapObjectId >>> 32 - 12 % 32);
      }
   }
}

