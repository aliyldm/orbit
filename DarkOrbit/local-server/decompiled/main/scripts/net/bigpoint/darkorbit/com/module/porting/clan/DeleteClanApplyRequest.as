package net.bigpoint.darkorbit.com.module.porting.clan
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class DeleteClanApplyRequest implements IModule
   {
      
      private static var _instance:DeleteClanApplyRequest;
      
      public var applyId:int = 0;
      
      public function DeleteClanApplyRequest(param1:int = 0)
      {
         super();
         this.applyId = param1;
      }
      
      public static function get instance() : DeleteClanApplyRequest
      {
         return _instance || (_instance = new DeleteClanApplyRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -9150;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.applyId = param1.readInt();
         this.applyId = this.applyId << 4 % 32 | this.applyId >>> 32 - 4 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-9150);
         param1.writeInt(this.applyId >>> 4 % 32 | this.applyId << 32 - 4 % 32);
      }
   }
}

