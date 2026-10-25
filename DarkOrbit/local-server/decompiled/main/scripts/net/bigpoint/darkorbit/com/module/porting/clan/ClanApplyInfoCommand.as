package net.bigpoint.darkorbit.com.module.porting.clan
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ClanApplyInfoCommand implements IModule
   {
      
      private static var _instance:ClanApplyInfoCommand;
      
      public var userName:String = "";
      
      public var clanApplyId:int = 0;
      
      public var insertDate:String = "";
      
      public var EP:Number = 0;
      
      public var applyDesc:String = "";
      
      public var level:int = 0;
      
      public var company:int = 0;
      
      public function ClanApplyInfoCommand(param1:int = 0, param2:String = "", param3:String = "", param4:int = 0, param5:String = "", param6:Number = 0, param7:int = 0)
      {
         super();
         this.userName = param2;
         this.clanApplyId = param1;
         this.insertDate = param5;
         this.EP = param6;
         this.applyDesc = param3;
         this.level = param4;
         this.company = param7;
      }
      
      public static function get instance() : ClanApplyInfoCommand
      {
         return _instance || (_instance = new ClanApplyInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -20667;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 26;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.userName = param1.readUTF();
         this.clanApplyId = param1.readInt();
         this.clanApplyId = this.clanApplyId << 14 % 32 | this.clanApplyId >>> 32 - 14 % 32;
         this.insertDate = param1.readUTF();
         this.EP = param1.readDouble();
         this.applyDesc = param1.readUTF();
         this.level = param1.readInt();
         this.level = this.level << 1 % 32 | this.level >>> 32 - 1 % 32;
         this.company = param1.readInt();
         this.company = this.company << 12 % 32 | this.company >>> 32 - 12 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-20667);
         param1.writeUTF(this.userName);
         param1.writeInt(this.clanApplyId >>> 14 % 32 | this.clanApplyId << 32 - 14 % 32);
         param1.writeUTF(this.insertDate);
         param1.writeDouble(this.EP);
         param1.writeUTF(this.applyDesc);
         param1.writeInt(this.level >>> 1 % 32 | this.level << 32 - 1 % 32);
         param1.writeInt(this.company >>> 12 % 32 | this.company << 32 - 12 % 32);
      }
   }
}

