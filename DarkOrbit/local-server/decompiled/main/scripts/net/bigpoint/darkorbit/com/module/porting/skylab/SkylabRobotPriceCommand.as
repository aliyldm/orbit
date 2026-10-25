package net.bigpoint.darkorbit.com.module.porting.skylab
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class SkylabRobotPriceCommand implements IModule
   {
      
      private static var _instance:SkylabRobotPriceCommand;
      
      public var priceType:String = "";
      
      public var value:int = 0;
      
      public function SkylabRobotPriceCommand(param1:String = "", param2:int = 0)
      {
         super();
         this.priceType = param1;
         this.value = param2;
      }
      
      public static function get instance() : SkylabRobotPriceCommand
      {
         return _instance || (_instance = new SkylabRobotPriceCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -22695;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 6;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.priceType = param1.readUTF();
         this.value = param1.readInt();
         this.value = this.value << 3 % 32 | this.value >>> 32 - 3 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-22695);
         param1.writeUTF(this.priceType);
         param1.writeInt(this.value >>> 3 % 32 | this.value << 32 - 3 % 32);
      }
   }
}

