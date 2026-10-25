package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class ClanModule extends PlayerAttributeModule
   {
      
      private static var _instance:ClanModule;
      
      public var clanId:int = 0;
      
      public var clanTag:String = "";
      
      public function ClanModule(param1:int = 0, param2:String = "")
      {
         super();
         this.clanId = param1;
         this.clanTag = param2;
      }
      
      public static function get instance() : ClanModule
      {
         return _instance || (_instance = new ClanModule());
      }
      
      override public function getLibcomModuleId() : int
      {
         return -7713;
      }
      
      override public function getLibcomModuleEstimatedLength() : int
      {
         return 6;
      }
      
      override public function read(param1:IDataInput) : void
      {
         param1.readShort();
         super.read(param1);
         this.clanId = param1.readInt();
         this.clanId = this.clanId >>> 9 % 32 | this.clanId << 32 - 9 % 32;
         this.clanTag = param1.readUTF();
      }
      
      override public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-7713);
         super.write(param1);
         param1.writeInt(this.clanId << 9 % 32 | this.clanId >>> 32 - 9 % 32);
         param1.writeUTF(this.clanTag);
      }
   }
}

