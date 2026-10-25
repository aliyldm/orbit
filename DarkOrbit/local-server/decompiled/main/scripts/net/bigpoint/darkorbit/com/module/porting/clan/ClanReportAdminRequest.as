package net.bigpoint.darkorbit.com.module.porting.clan
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ClanReportAdminRequest implements IModule
   {
      
      private static var _instance:ClanReportAdminRequest;
      
      public var diploId:int = 0;
      
      public function ClanReportAdminRequest(param1:int = 0)
      {
         super();
         this.diploId = param1;
      }
      
      public static function get instance() : ClanReportAdminRequest
      {
         return _instance || (_instance = new ClanReportAdminRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -719;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.diploId = param1.readInt();
         this.diploId = this.diploId << 9 % 32 | this.diploId >>> 32 - 9 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-719);
         param1.writeInt(this.diploId >>> 9 % 32 | this.diploId << 32 - 9 % 32);
      }
   }
}

