package net.bigpoint.darkorbit.com.module.porting.skylab
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class SkylabActiveRobotsLeftTimeCommand implements IModule
   {
      
      private static var _instance:SkylabActiveRobotsLeftTimeCommand;
      
      public var uridium:int = 0;
      
      public var leftTime:Number = 0;
      
      public function SkylabActiveRobotsLeftTimeCommand(param1:Number = 0, param2:int = 0)
      {
         super();
         this.uridium = param2;
         this.leftTime = param1;
      }
      
      public static function get instance() : SkylabActiveRobotsLeftTimeCommand
      {
         return _instance || (_instance = new SkylabActiveRobotsLeftTimeCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 5366;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 12;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.uridium = param1.readInt();
         this.uridium = this.uridium << 11 % 32 | this.uridium >>> 32 - 11 % 32;
         this.leftTime = param1.readDouble();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(5366);
         param1.writeInt(this.uridium >>> 11 % 32 | this.uridium << 32 - 11 % 32);
         param1.writeDouble(this.leftTime);
      }
   }
}

