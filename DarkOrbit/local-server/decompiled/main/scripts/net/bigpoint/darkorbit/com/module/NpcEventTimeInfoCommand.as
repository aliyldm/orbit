package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class NpcEventTimeInfoCommand implements IModule
   {
      
      private static var _instance:NpcEventTimeInfoCommand;
      
      public var timeToNextSpawn:Number = 0;
      
      public var timeToEndSpawn:Number = 0;
      
      public function NpcEventTimeInfoCommand(param1:Number = 0, param2:Number = 0)
      {
         super();
         this.timeToNextSpawn = param2;
         this.timeToEndSpawn = param1;
      }
      
      public static function get instance() : NpcEventTimeInfoCommand
      {
         return _instance || (_instance = new NpcEventTimeInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -1234;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 16;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.timeToNextSpawn = param1.readDouble();
         this.timeToEndSpawn = param1.readDouble();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-1234);
         param1.writeDouble(this.timeToNextSpawn);
         param1.writeDouble(this.timeToEndSpawn);
      }
   }
}

