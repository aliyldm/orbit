package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class AttackLaserRequest implements IModule
   {
      
      private static var _instance:AttackLaserRequest;
      
      public var targetId:int = 0;
      
      public var targetX:int = 0;
      
      public var targetY:int = 0;
      
      public function AttackLaserRequest(param1:int = 0, param2:int = 0, param3:int = 0)
      {
         super();
         this.targetId = param1;
         this.targetX = param2;
         this.targetY = param3;
      }
      
      public static function get instance() : AttackLaserRequest
      {
         return _instance || (_instance = new AttackLaserRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 4;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 12;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.targetId = param1.readInt();
         this.targetId = this.targetId >>> 15 % 32 | this.targetId << 32 - 15 % 32;
         this.targetX = param1.readInt();
         this.targetX = this.targetX >>> 9 % 32 | this.targetX << 32 - 9 % 32;
         this.targetY = param1.readInt();
         this.targetY = this.targetY >>> 9 % 32 | this.targetY << 32 - 9 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(4);
         param1.writeInt(this.targetId << 15 % 32 | this.targetId >>> 32 - 15 % 32);
         param1.writeInt(this.targetX << 9 % 32 | this.targetX >>> 32 - 9 % 32);
         param1.writeInt(this.targetY << 9 % 32 | this.targetY >>> 32 - 9 % 32);
      }
   }
}

