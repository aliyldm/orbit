package net.bigpoint.darkorbit.com.module.porting.clan
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ClanDeleteOpenDiploRequest implements IModule
   {
      
      private static var _instance:ClanDeleteOpenDiploRequest;
      
      public var toClanId:int = 0;
      
      public var diploId:int = 0;
      
      public function ClanDeleteOpenDiploRequest(param1:int = 0, param2:int = 0)
      {
         super();
         this.toClanId = param2;
         this.diploId = param1;
      }
      
      public static function get instance() : ClanDeleteOpenDiploRequest
      {
         return _instance || (_instance = new ClanDeleteOpenDiploRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -10734;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.toClanId = param1.readInt();
         this.toClanId = this.toClanId << 9 % 32 | this.toClanId >>> 32 - 9 % 32;
         this.diploId = param1.readInt();
         this.diploId = this.diploId << 7 % 32 | this.diploId >>> 32 - 7 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-10734);
         param1.writeInt(this.toClanId >>> 9 % 32 | this.toClanId << 32 - 9 % 32);
         param1.writeInt(this.diploId >>> 7 % 32 | this.diploId << 32 - 7 % 32);
      }
   }
}

