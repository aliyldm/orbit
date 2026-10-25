package net.bigpoint.darkorbit.com.module.porting.clan
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ClanRankInfoCommand implements IModule
   {
      
      private static var _instance:ClanRankInfoCommand;
      
      public var rankId:int = 0;
      
      public var clanId:int = 0;
      
      public var rankName:String = "";
      
      public var rights:Vector.<String>;
      
      public function ClanRankInfoCommand(param1:int = 0, param2:int = 0, param3:String = "", param4:Vector.<String> = null)
      {
         super();
         this.rankId = param2;
         this.clanId = param1;
         this.rankName = param3;
         if(param4 == null)
         {
            this.rights = new Vector.<String>();
         }
         else
         {
            this.rights = param4;
         }
      }
      
      public static function get instance() : ClanRankInfoCommand
      {
         return _instance || (_instance = new ClanRankInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 17918;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 14;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.rankId = param1.readInt();
         this.rankId = this.rankId >>> 1 % 32 | this.rankId << 32 - 1 % 32;
         this.clanId = param1.readInt();
         this.clanId = this.clanId << 4 % 32 | this.clanId >>> 32 - 4 % 32;
         this.rankName = param1.readUTF();
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.rights.length > 0)
         {
            this.rights.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            this.rights.push(param1.readUTF());
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:String = null;
         param1.writeShort(17918);
         param1.writeInt(this.rankId << 1 % 32 | this.rankId >>> 32 - 1 % 32);
         param1.writeInt(this.clanId >>> 4 % 32 | this.clanId << 32 - 4 % 32);
         param1.writeUTF(this.rankName);
         param1.writeByte(this.rights.length);
         for each(_loc2_ in this.rights)
         {
            param1.writeUTF(_loc2_);
         }
      }
   }
}

