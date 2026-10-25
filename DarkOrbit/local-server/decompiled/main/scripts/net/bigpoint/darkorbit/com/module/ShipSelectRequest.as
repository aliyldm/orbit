package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ShipSelectRequest implements IModule
   {
      
      private static var _instance:ShipSelectRequest;
      
      public var targetId:int = 0;
      
      public var targetX:int = 0;
      
      public var targetY:int = 0;
      
      public var posX:int = 0;
      
      public var posY:int = 0;
      
      public var clickX:int = 0;
      
      public var clickY:int = 0;
      
      public var radius:int = 0;
      
      public function ShipSelectRequest(param1:int = 0, param2:int = 0, param3:int = 0, param4:int = 0, param5:int = 0, param6:int = 0, param7:int = 0, param8:int = 0)
      {
         super();
         this.targetId = param1;
         this.targetX = param2;
         this.targetY = param3;
         this.posX = param4;
         this.posY = param5;
         this.clickX = param6;
         this.clickY = param7;
         this.radius = param8;
      }
      
      public static function get instance() : ShipSelectRequest
      {
         return _instance || (_instance = new ShipSelectRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 165;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 32;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.targetId = param1.readInt();
         this.targetId = this.targetId >>> 5 % 32 | this.targetId << 32 - 5 % 32;
         this.targetX = param1.readInt();
         this.targetX = this.targetX << 2 % 32 | this.targetX >>> 32 - 2 % 32;
         this.targetY = param1.readInt();
         this.targetY = this.targetY << 10 % 32 | this.targetY >>> 32 - 10 % 32;
         this.posX = param1.readInt();
         this.posX = this.posX << 1 % 32 | this.posX >>> 32 - 1 % 32;
         this.posY = param1.readInt();
         this.posY = this.posY << 1 % 32 | this.posY >>> 32 - 1 % 32;
         this.clickX = param1.readInt();
         this.clickX = this.clickX >>> 15 % 32 | this.clickX << 32 - 15 % 32;
         this.clickY = param1.readInt();
         this.clickY = this.clickY >>> 2 % 32 | this.clickY << 32 - 2 % 32;
         this.radius = param1.readInt();
         this.radius = this.radius << 6 % 32 | this.radius >>> 32 - 6 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(165);
         param1.writeInt(this.targetId << 5 % 32 | this.targetId >>> 32 - 5 % 32);
         param1.writeInt(this.targetX >>> 2 % 32 | this.targetX << 32 - 2 % 32);
         param1.writeInt(this.targetY >>> 10 % 32 | this.targetY << 32 - 10 % 32);
         param1.writeInt(this.posX >>> 1 % 32 | this.posX << 32 - 1 % 32);
         param1.writeInt(this.posY >>> 1 % 32 | this.posY << 32 - 1 % 32);
         param1.writeInt(this.clickX << 15 % 32 | this.clickX >>> 32 - 15 % 32);
         param1.writeInt(this.clickY << 2 % 32 | this.clickY >>> 32 - 2 % 32);
         param1.writeInt(this.radius >>> 6 % 32 | this.radius << 32 - 6 % 32);
      }
   }
}

