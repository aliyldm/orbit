package net.bigpoint.darkorbit.com.module.porting.clan
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class EditClanMemberRequest implements IModule
   {
      
      private static var _instance:EditClanMemberRequest;
      
      public var memberId:int = 0;
      
      public var rankId:int = 0;
      
      public function EditClanMemberRequest(param1:int = 0, param2:int = 0)
      {
         super();
         this.memberId = param1;
         this.rankId = param2;
      }
      
      public static function get instance() : EditClanMemberRequest
      {
         return _instance || (_instance = new EditClanMemberRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 6745;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.memberId = param1.readInt();
         this.memberId = this.memberId >>> 15 % 32 | this.memberId << 32 - 15 % 32;
         this.rankId = param1.readInt();
         this.rankId = this.rankId << 11 % 32 | this.rankId >>> 32 - 11 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(6745);
         param1.writeInt(this.memberId << 15 % 32 | this.memberId >>> 32 - 15 % 32);
         param1.writeInt(this.rankId >>> 11 % 32 | this.rankId << 32 - 11 % 32);
      }
   }
}

