package net.bigpoint.darkorbit.com.module.porting.clan
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ClanFilterSearchRequest implements IModule
   {
      
      private static var _instance:ClanFilterSearchRequest;
      
      public var memberType:int = 0;
      
      public var orderType:int = 0;
      
      public var recruitionType:int = 0;
      
      public var start:int = 0;
      
      public var factionType:int = 0;
      
      public var range:int = 0;
      
      public var lookup:String = "";
      
      public var rankType:int = 0;
      
      public var desc:Boolean = false;
      
      public function ClanFilterSearchRequest(param1:String = "", param2:int = 0, param3:int = 0, param4:int = 0, param5:int = 0, param6:int = 0, param7:int = 0, param8:int = 0, param9:Boolean = false)
      {
         super();
         this.memberType = param3;
         this.orderType = param2;
         this.recruitionType = param6;
         this.start = param7;
         this.factionType = param5;
         this.range = param8;
         this.lookup = param1;
         this.rankType = param4;
         this.desc = param9;
      }
      
      public static function get instance() : ClanFilterSearchRequest
      {
         return _instance || (_instance = new ClanFilterSearchRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 4228;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 31;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.memberType = param1.readInt();
         this.memberType = this.memberType << 8 % 32 | this.memberType >>> 32 - 8 % 32;
         this.orderType = param1.readInt();
         this.orderType = this.orderType >>> 3 % 32 | this.orderType << 32 - 3 % 32;
         this.recruitionType = param1.readInt();
         this.recruitionType = this.recruitionType << 5 % 32 | this.recruitionType >>> 32 - 5 % 32;
         this.start = param1.readInt();
         this.start = this.start << 15 % 32 | this.start >>> 32 - 15 % 32;
         this.factionType = param1.readInt();
         this.factionType = this.factionType << 1 % 32 | this.factionType >>> 32 - 1 % 32;
         this.range = param1.readInt();
         this.range = this.range >>> 12 % 32 | this.range << 32 - 12 % 32;
         this.lookup = param1.readUTF();
         this.rankType = param1.readInt();
         this.rankType = this.rankType << 12 % 32 | this.rankType >>> 32 - 12 % 32;
         this.desc = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(4228);
         param1.writeInt(this.memberType >>> 8 % 32 | this.memberType << 32 - 8 % 32);
         param1.writeInt(this.orderType << 3 % 32 | this.orderType >>> 32 - 3 % 32);
         param1.writeInt(this.recruitionType >>> 5 % 32 | this.recruitionType << 32 - 5 % 32);
         param1.writeInt(this.start >>> 15 % 32 | this.start << 32 - 15 % 32);
         param1.writeInt(this.factionType >>> 1 % 32 | this.factionType << 32 - 1 % 32);
         param1.writeInt(this.range << 12 % 32 | this.range >>> 32 - 12 % 32);
         param1.writeUTF(this.lookup);
         param1.writeInt(this.rankType >>> 12 % 32 | this.rankType << 32 - 12 % 32);
         param1.writeBoolean(this.desc);
      }
   }
}

