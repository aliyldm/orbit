package net.bigpoint.darkorbit.com.module.porting.clan
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ClanMemberInfoCommand implements IModule
   {
      
      private static var _instance:ClanMemberInfoCommand;
      
      public var faction:int = 0;
      
      public var mapName:String = "";
      
      public var name:String = "";
      
      public var maxPayout:int = 0;
      
      public var insertDate:String = "";
      
      public var ep:Number = 0;
      
      public var userId:int = 0;
      
      public var ranksId:int = 0;
      
      public var rank:int = 0;
      
      public function ClanMemberInfoCommand(param1:int = 0, param2:String = "", param3:String = "", param4:int = 0, param5:Number = 0, param6:int = 0, param7:String = "", param8:int = 0, param9:int = 0)
      {
         super();
         this.faction = param4;
         this.mapName = param7;
         this.name = param2;
         this.maxPayout = param9;
         this.insertDate = param3;
         this.ep = param5;
         this.userId = param1;
         this.ranksId = param8;
         this.rank = param6;
      }
      
      public static function get instance() : ClanMemberInfoCommand
      {
         return _instance || (_instance = new ClanMemberInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -28410;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 34;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.faction = param1.readInt();
         this.faction = this.faction >>> 6 % 32 | this.faction << 32 - 6 % 32;
         this.mapName = param1.readUTF();
         this.name = param1.readUTF();
         this.maxPayout = param1.readInt();
         this.maxPayout = this.maxPayout >>> 13 % 32 | this.maxPayout << 32 - 13 % 32;
         this.insertDate = param1.readUTF();
         this.ep = param1.readDouble();
         this.userId = param1.readInt();
         this.userId = this.userId << 4 % 32 | this.userId >>> 32 - 4 % 32;
         this.ranksId = param1.readInt();
         this.ranksId = this.ranksId >>> 9 % 32 | this.ranksId << 32 - 9 % 32;
         this.rank = param1.readInt();
         this.rank = this.rank >>> 12 % 32 | this.rank << 32 - 12 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-28410);
         param1.writeInt(this.faction << 6 % 32 | this.faction >>> 32 - 6 % 32);
         param1.writeUTF(this.mapName);
         param1.writeUTF(this.name);
         param1.writeInt(this.maxPayout << 13 % 32 | this.maxPayout >>> 32 - 13 % 32);
         param1.writeUTF(this.insertDate);
         param1.writeDouble(this.ep);
         param1.writeInt(this.userId >>> 4 % 32 | this.userId << 32 - 4 % 32);
         param1.writeInt(this.ranksId << 9 % 32 | this.ranksId >>> 32 - 9 % 32);
         param1.writeInt(this.rank << 12 % 32 | this.rank >>> 32 - 12 % 32);
      }
   }
}

