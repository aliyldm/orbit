package net.bigpoint.darkorbit.com.module.porting.SpaceSearch
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class EventCommand implements IModule
   {
      
      private static var _instance:EventCommand;
      
      public var eventId:int = 0;
      
      public var planetId:int = 0;
      
      public function EventCommand(param1:int = 0, param2:int = 0)
      {
         super();
         this.eventId = param1;
         this.planetId = param2;
      }
      
      public static function get instance() : EventCommand
      {
         return _instance || (_instance = new EventCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 18960;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.eventId = param1.readInt();
         this.eventId = this.eventId << 3 % 32 | this.eventId >>> 32 - 3 % 32;
         this.planetId = param1.readInt();
         this.planetId = this.planetId << 8 % 32 | this.planetId >>> 32 - 8 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(18960);
         param1.writeInt(this.eventId >>> 3 % 32 | this.eventId << 32 - 3 % 32);
         param1.writeInt(this.planetId >>> 8 % 32 | this.planetId << 32 - 8 % 32);
      }
   }
}

