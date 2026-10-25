package net.bigpoint.darkorbit.com.module.porting.clan
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ClanDeleteDiploRequest implements IModule
   {
      
      private static var _instance:ClanDeleteDiploRequest;
      
      public var diploId:int = 0;
      
      public function ClanDeleteDiploRequest(param1:int = 0)
      {
         super();
         this.diploId = param1;
      }
      
      public static function get instance() : ClanDeleteDiploRequest
      {
         return _instance || (_instance = new ClanDeleteDiploRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -4889;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.diploId = param1.readInt();
         this.diploId = this.diploId >>> 7 % 32 | this.diploId << 32 - 7 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-4889);
         param1.writeInt(this.diploId << 7 % 32 | this.diploId >>> 32 - 7 % 32);
      }
   }
}

