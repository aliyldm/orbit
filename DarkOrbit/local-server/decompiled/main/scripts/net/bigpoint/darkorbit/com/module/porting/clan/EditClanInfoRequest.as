package net.bigpoint.darkorbit.com.module.porting.clan
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class EditClanInfoRequest implements IModule
   {
      
      private static var _instance:EditClanInfoRequest;
      
      public var clanName:String = "";
      
      public var clanHp:int = 0;
      
      public var clanTS:String = "";
      
      public var newFraction:int = 0;
      
      public var recuritingInfo:int = 0;
      
      public var recruitingStatus:int = 0;
      
      public var clanTag:String = "";
      
      public function EditClanInfoRequest(param1:String = "", param2:String = "", param3:int = 0, param4:String = "", param5:int = 0, param6:int = 0, param7:int = 0)
      {
         super();
         this.clanName = param1;
         this.clanHp = param3;
         this.clanTS = param4;
         this.newFraction = param5;
         this.recuritingInfo = param6;
         this.recruitingStatus = param7;
         this.clanTag = param2;
      }
      
      public static function get instance() : EditClanInfoRequest
      {
         return _instance || (_instance = new EditClanInfoRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -29616;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 22;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.clanName = param1.readUTF();
         this.clanHp = param1.readInt();
         this.clanHp = this.clanHp >>> 5 % 32 | this.clanHp << 32 - 5 % 32;
         this.clanTS = param1.readUTF();
         this.newFraction = param1.readInt();
         this.newFraction = this.newFraction << 6 % 32 | this.newFraction >>> 32 - 6 % 32;
         this.recuritingInfo = param1.readInt();
         this.recuritingInfo = this.recuritingInfo << 5 % 32 | this.recuritingInfo >>> 32 - 5 % 32;
         this.recruitingStatus = param1.readInt();
         this.recruitingStatus = this.recruitingStatus << 13 % 32 | this.recruitingStatus >>> 32 - 13 % 32;
         this.clanTag = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-29616);
         param1.writeUTF(this.clanName);
         param1.writeInt(this.clanHp << 5 % 32 | this.clanHp >>> 32 - 5 % 32);
         param1.writeUTF(this.clanTS);
         param1.writeInt(this.newFraction >>> 6 % 32 | this.newFraction << 32 - 6 % 32);
         param1.writeInt(this.recuritingInfo >>> 5 % 32 | this.recuritingInfo << 32 - 5 % 32);
         param1.writeInt(this.recruitingStatus >>> 13 % 32 | this.recruitingStatus << 32 - 13 % 32);
         param1.writeUTF(this.clanTag);
      }
   }
}

