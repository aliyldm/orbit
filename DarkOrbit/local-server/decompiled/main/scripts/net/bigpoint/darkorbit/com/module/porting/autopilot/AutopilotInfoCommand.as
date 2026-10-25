package net.bigpoint.darkorbit.com.module.porting.autopilot
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class AutopilotInfoCommand implements IModule
   {
      
      private static var _instance:AutopilotInfoCommand;
      
      public var remainingSeconds:Number = 0;
      
      public var laserRange:int = 0;
      
      public var result:Boolean = false;
      
      public var autopilotInfos:String = "";
      
      public function AutopilotInfoCommand(param1:Boolean = false, param2:String = "", param3:int = 0, param4:Number = 0)
      {
         super();
         this.remainingSeconds = param4;
         this.laserRange = param3;
         this.result = param1;
         this.autopilotInfos = param2;
      }
      
      public static function get instance() : AutopilotInfoCommand
      {
         return _instance || (_instance = new AutopilotInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -27444;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 15;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.remainingSeconds = param1.readDouble();
         this.laserRange = param1.readInt();
         this.laserRange = this.laserRange << 14 % 32 | this.laserRange >>> 32 - 14 % 32;
         this.result = param1.readBoolean();
         this.autopilotInfos = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-27444);
         param1.writeDouble(this.remainingSeconds);
         param1.writeInt(this.laserRange >>> 14 % 32 | this.laserRange << 32 - 14 % 32);
         param1.writeBoolean(this.result);
         param1.writeUTF(this.autopilotInfos);
      }
   }
}

