package net.bigpoint.darkorbit.com.module.porting.clan
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ApplyDeclineRequest implements IModule
   {
      
      private static var _instance:ApplyDeclineRequest;
      
      public var applyId:int = 0;
      
      public function ApplyDeclineRequest(param1:int = 0)
      {
         super();
         this.applyId = param1;
      }
      
      public static function get instance() : ApplyDeclineRequest
      {
         return _instance || (_instance = new ApplyDeclineRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 31508;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.applyId = param1.readInt();
         this.applyId = this.applyId << 8 % 32 | this.applyId >>> 32 - 8 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(31508);
         param1.writeInt(this.applyId >>> 8 % 32 | this.applyId << 32 - 8 % 32);
      }
   }
}

