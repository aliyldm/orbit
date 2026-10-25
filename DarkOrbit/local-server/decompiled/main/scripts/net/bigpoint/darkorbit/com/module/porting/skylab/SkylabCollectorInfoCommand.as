package net.bigpoint.darkorbit.com.module.porting.skylab
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class SkylabCollectorInfoCommand implements IModule
   {
      
      private static var _instance:SkylabCollectorInfoCommand;
      
      public var production:int = 0;
      
      public var maxTime:Number = 0;
      
      public var leftTime:Number = 0;
      
      public function SkylabCollectorInfoCommand(param1:int = 0, param2:Number = 0, param3:Number = 0)
      {
         super();
         this.production = param1;
         this.maxTime = param2;
         this.leftTime = param3;
      }
      
      public static function get instance() : SkylabCollectorInfoCommand
      {
         return _instance || (_instance = new SkylabCollectorInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 26390;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 20;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.production = param1.readInt();
         this.production = this.production << 6 % 32 | this.production >>> 32 - 6 % 32;
         this.maxTime = param1.readDouble();
         this.leftTime = param1.readDouble();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(26390);
         param1.writeInt(this.production >>> 6 % 32 | this.production << 32 - 6 % 32);
         param1.writeDouble(this.maxTime);
         param1.writeDouble(this.leftTime);
      }
   }
}

