package net.bigpoint.darkorbit.com.module.porting.clan
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ApplyAcceptRequest implements IModule
   {
      
      private static var _instance:ApplyAcceptRequest;
      
      public var applyId:int = 0;
      
      public function ApplyAcceptRequest(param1:int = 0)
      {
         super();
         this.applyId = param1;
      }
      
      public static function get instance() : ApplyAcceptRequest
      {
         return _instance || (_instance = new ApplyAcceptRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 12260;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.applyId = param1.readInt();
         this.applyId = this.applyId >>> 12 % 32 | this.applyId << 32 - 12 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(12260);
         param1.writeInt(this.applyId << 12 % 32 | this.applyId >>> 32 - 12 % 32);
      }
   }
}

