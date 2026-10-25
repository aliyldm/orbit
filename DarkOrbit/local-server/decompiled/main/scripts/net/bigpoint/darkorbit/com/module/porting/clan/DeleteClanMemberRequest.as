package net.bigpoint.darkorbit.com.module.porting.clan
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class DeleteClanMemberRequest implements IModule
   {
      
      private static var _instance:DeleteClanMemberRequest;
      
      public var removeUserID:int = 0;
      
      public function DeleteClanMemberRequest(param1:int = 0)
      {
         super();
         this.removeUserID = param1;
      }
      
      public static function get instance() : DeleteClanMemberRequest
      {
         return _instance || (_instance = new DeleteClanMemberRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -14580;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.removeUserID = param1.readInt();
         this.removeUserID = this.removeUserID << 14 % 32 | this.removeUserID >>> 32 - 14 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-14580);
         param1.writeInt(this.removeUserID >>> 14 % 32 | this.removeUserID << 32 - 14 % 32);
      }
   }
}

