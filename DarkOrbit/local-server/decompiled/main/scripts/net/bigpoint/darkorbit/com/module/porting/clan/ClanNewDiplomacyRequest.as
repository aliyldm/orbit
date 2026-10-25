package net.bigpoint.darkorbit.com.module.porting.clan
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ClanNewDiplomacyRequest implements IModule
   {
      
      private static var _instance:ClanNewDiplomacyRequest;
      
      public var diploClanID:int = 0;
      
      public var diploForm:int = 0;
      
      public var diploId:int = 0;
      
      public var status:String = "";
      
      public var desc:String = "";
      
      public var clanId:int = 0;
      
      public function ClanNewDiplomacyRequest(param1:int = 0, param2:int = 0, param3:String = "", param4:int = 0, param5:int = 0, param6:String = "")
      {
         super();
         this.diploClanID = param5;
         this.diploForm = param4;
         this.diploId = param2;
         this.status = param3;
         this.desc = param6;
         this.clanId = param1;
      }
      
      public static function get instance() : ClanNewDiplomacyRequest
      {
         return _instance || (_instance = new ClanNewDiplomacyRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 28149;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 20;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.diploClanID = param1.readInt();
         this.diploClanID = this.diploClanID >>> 8 % 32 | this.diploClanID << 32 - 8 % 32;
         this.diploForm = param1.readInt();
         this.diploForm = this.diploForm << 2 % 32 | this.diploForm >>> 32 - 2 % 32;
         this.diploId = param1.readInt();
         this.diploId = this.diploId >>> 8 % 32 | this.diploId << 32 - 8 % 32;
         this.status = param1.readUTF();
         this.desc = param1.readUTF();
         this.clanId = param1.readInt();
         this.clanId = this.clanId << 10 % 32 | this.clanId >>> 32 - 10 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(28149);
         param1.writeInt(this.diploClanID << 8 % 32 | this.diploClanID >>> 32 - 8 % 32);
         param1.writeInt(this.diploForm >>> 2 % 32 | this.diploForm << 32 - 2 % 32);
         param1.writeInt(this.diploId << 8 % 32 | this.diploId >>> 32 - 8 % 32);
         param1.writeUTF(this.status);
         param1.writeUTF(this.desc);
         param1.writeInt(this.clanId >>> 10 % 32 | this.clanId << 32 - 10 % 32);
      }
   }
}

