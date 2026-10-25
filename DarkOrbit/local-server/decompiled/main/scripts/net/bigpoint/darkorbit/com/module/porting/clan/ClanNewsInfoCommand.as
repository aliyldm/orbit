package net.bigpoint.darkorbit.com.module.porting.clan
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ClanNewsInfoCommand implements IModule
   {
      
      private static var _instance:ClanNewsInfoCommand;
      
      public var type:String = "";
      
      public var clanNewsId:int = 0;
      
      public var userName:String = "";
      
      public var clanId:int = 0;
      
      public var context:String = "";
      
      public var userId:int = 0;
      
      public var clanName:String = "";
      
      public var insertDate:String = "";
      
      public function ClanNewsInfoCommand(param1:int = 0, param2:int = 0, param3:int = 0, param4:String = "", param5:String = "", param6:String = "", param7:String = "", param8:String = "")
      {
         super();
         this.type = param8;
         this.clanNewsId = param1;
         this.userName = param6;
         this.clanId = param2;
         this.context = param4;
         this.userId = param3;
         this.clanName = param7;
         this.insertDate = param5;
      }
      
      public static function get instance() : ClanNewsInfoCommand
      {
         return _instance || (_instance = new ClanNewsInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 32343;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 22;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.type = param1.readUTF();
         this.clanNewsId = param1.readInt();
         this.clanNewsId = this.clanNewsId >>> 10 % 32 | this.clanNewsId << 32 - 10 % 32;
         this.userName = param1.readUTF();
         this.clanId = param1.readInt();
         this.clanId = this.clanId >>> 12 % 32 | this.clanId << 32 - 12 % 32;
         this.context = param1.readUTF();
         this.userId = param1.readInt();
         this.userId = this.userId >>> 2 % 32 | this.userId << 32 - 2 % 32;
         this.clanName = param1.readUTF();
         this.insertDate = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(32343);
         param1.writeUTF(this.type);
         param1.writeInt(this.clanNewsId << 10 % 32 | this.clanNewsId >>> 32 - 10 % 32);
         param1.writeUTF(this.userName);
         param1.writeInt(this.clanId << 12 % 32 | this.clanId >>> 32 - 12 % 32);
         param1.writeUTF(this.context);
         param1.writeInt(this.userId << 2 % 32 | this.userId >>> 32 - 2 % 32);
         param1.writeUTF(this.clanName);
         param1.writeUTF(this.insertDate);
      }
   }
}

