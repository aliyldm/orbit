package net.bigpoint.darkorbit.com.module.porting.skylab
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class SkylabPurchaseRobotRequest implements IModule
   {
      
      private static var _instance:SkylabPurchaseRobotRequest;
      
      public var construction:String = "";
      
      public var robotType:int = 0;
      
      public function SkylabPurchaseRobotRequest(param1:String = "", param2:int = 0)
      {
         super();
         this.construction = param1;
         this.robotType = param2;
      }
      
      public static function get instance() : SkylabPurchaseRobotRequest
      {
         return _instance || (_instance = new SkylabPurchaseRobotRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -27491;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 6;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.construction = param1.readUTF();
         this.robotType = param1.readInt();
         this.robotType = this.robotType << 12 % 32 | this.robotType >>> 32 - 12 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-27491);
         param1.writeUTF(this.construction);
         param1.writeInt(this.robotType >>> 12 % 32 | this.robotType << 32 - 12 % 32);
      }
   }
}

