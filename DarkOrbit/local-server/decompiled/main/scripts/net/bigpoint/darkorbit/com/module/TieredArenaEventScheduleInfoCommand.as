package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class TieredArenaEventScheduleInfoCommand implements IModule
   {
      
      private static var _instance:TieredArenaEventScheduleInfoCommand;
      
      public var timeToArenaClose:Number = 0;
      
      public var timeToNextArenaOpen:Number = 0;
      
      public function TieredArenaEventScheduleInfoCommand(param1:Number = 0, param2:Number = 0)
      {
         super();
         this.timeToArenaClose = param1;
         this.timeToNextArenaOpen = param2;
      }
      
      public static function get instance() : TieredArenaEventScheduleInfoCommand
      {
         return _instance || (_instance = new TieredArenaEventScheduleInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 14407;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 16;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.timeToArenaClose = param1.readDouble();
         this.timeToNextArenaOpen = param1.readDouble();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(14407);
         param1.writeDouble(this.timeToArenaClose);
         param1.writeDouble(this.timeToNextArenaOpen);
      }
   }
}

