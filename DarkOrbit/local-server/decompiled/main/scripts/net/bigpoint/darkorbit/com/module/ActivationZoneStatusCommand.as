package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ActivationZoneStatusCommand implements IModule
   {
      
      private static var _instance:ActivationZoneStatusCommand;
      
      public var poiId:String = "";
      
      public var maxValue:int = 0;
      
      public var currentValue:int = 0;
      
      public function ActivationZoneStatusCommand(param1:String = "", param2:int = 0, param3:int = 0)
      {
         super();
         this.poiId = param1;
         this.maxValue = param3;
         this.currentValue = param2;
      }
      
      public static function get instance() : ActivationZoneStatusCommand
      {
         return _instance || (_instance = new ActivationZoneStatusCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 11704;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 10;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.poiId = param1.readUTF();
         this.maxValue = param1.readInt();
         this.maxValue = this.maxValue >>> 8 % 32 | this.maxValue << 32 - 8 % 32;
         this.currentValue = param1.readInt();
         this.currentValue = this.currentValue >>> 13 % 32 | this.currentValue << 32 - 13 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(11704);
         param1.writeUTF(this.poiId);
         param1.writeInt(this.maxValue << 8 % 32 | this.maxValue >>> 32 - 8 % 32);
         param1.writeInt(this.currentValue << 13 % 32 | this.currentValue >>> 32 - 13 % 32);
      }
   }
}

