package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class GroupMemberSelectRequest implements IModule
   {
      
      private static var _instance:GroupMemberSelectRequest;
      
      public var targetId:int = 0;
      
      public function GroupMemberSelectRequest(param1:int = 0)
      {
         super();
         this.targetId = param1;
      }
      
      public static function get instance() : GroupMemberSelectRequest
      {
         return _instance || (_instance = new GroupMemberSelectRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -2023;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.targetId = param1.readInt();
         this.targetId = this.targetId >>> 5 % 32 | this.targetId << 32 - 5 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-2023);
         param1.writeInt(this.targetId << 5 % 32 | this.targetId >>> 32 - 5 % 32);
      }
   }
}

