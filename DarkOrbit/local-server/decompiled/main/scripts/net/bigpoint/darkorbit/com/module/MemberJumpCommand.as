package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class MemberJumpCommand implements IModule
   {
      
      private static var _instance:MemberJumpCommand;
      
      public var memberId:int = 0;
      
      public var fromMapId:int = 0;
      
      public var toMapId:int = 0;
      
      public function MemberJumpCommand(param1:int = 0, param2:int = 0, param3:int = 0)
      {
         super();
         this.memberId = param1;
         this.fromMapId = param2;
         this.toMapId = param3;
      }
      
      public static function get instance() : MemberJumpCommand
      {
         return _instance || (_instance = new MemberJumpCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -31225;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 12;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.memberId = param1.readInt();
         this.memberId = this.memberId << 12 % 32 | this.memberId >>> 32 - 12 % 32;
         this.fromMapId = param1.readInt();
         this.fromMapId = this.fromMapId >>> 9 % 32 | this.fromMapId << 32 - 9 % 32;
         this.toMapId = param1.readInt();
         this.toMapId = this.toMapId << 7 % 32 | this.toMapId >>> 32 - 7 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-31225);
         param1.writeInt(this.memberId >>> 12 % 32 | this.memberId << 32 - 12 % 32);
         param1.writeInt(this.fromMapId << 9 % 32 | this.fromMapId >>> 32 - 9 % 32);
         param1.writeInt(this.toMapId >>> 7 % 32 | this.toMapId << 32 - 7 % 32);
      }
   }
}

