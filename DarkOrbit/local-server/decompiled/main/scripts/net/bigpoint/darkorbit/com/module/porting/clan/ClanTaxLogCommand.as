package net.bigpoint.darkorbit.com.module.porting.clan
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ClanTaxLogCommand implements IModule
   {
      
      private static var _instance:ClanTaxLogCommand;
      
      public var balanceUserId:int = 0;
      
      public var credits:Number = 0;
      
      public var insertDate:String = "";
      
      public var toName:String = "";
      
      public var fromName:String = "";
      
      public var moneyType:String = "";
      
      public var reason:String = "";
      
      public function ClanTaxLogCommand(param1:Number = 0, param2:String = "", param3:String = "", param4:String = "", param5:int = 0, param6:String = "", param7:String = "")
      {
         super();
         this.balanceUserId = param5;
         this.credits = param1;
         this.insertDate = param6;
         this.toName = param2;
         this.fromName = param3;
         this.moneyType = param7;
         this.reason = param4;
      }
      
      public static function get instance() : ClanTaxLogCommand
      {
         return _instance || (_instance = new ClanTaxLogCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -1692;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 22;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.balanceUserId = param1.readInt();
         this.balanceUserId = this.balanceUserId >>> 9 % 32 | this.balanceUserId << 32 - 9 % 32;
         this.credits = param1.readDouble();
         this.insertDate = param1.readUTF();
         this.toName = param1.readUTF();
         this.fromName = param1.readUTF();
         this.moneyType = param1.readUTF();
         this.reason = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-1692);
         param1.writeInt(this.balanceUserId << 9 % 32 | this.balanceUserId >>> 32 - 9 % 32);
         param1.writeDouble(this.credits);
         param1.writeUTF(this.insertDate);
         param1.writeUTF(this.toName);
         param1.writeUTF(this.fromName);
         param1.writeUTF(this.moneyType);
         param1.writeUTF(this.reason);
      }
   }
}

