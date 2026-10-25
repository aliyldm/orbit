package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ClanTagChangedCommand implements IModule
   {
      
      private static var _instance:ClanTagChangedCommand;
      
      public var clanTag:String = "";
      
      public var clanId:int = 0;
      
      public var userId:int = 0;
      
      public function ClanTagChangedCommand(param1:String = "", param2:int = 0, param3:int = 0)
      {
         super();
         this.clanTag = param1;
         this.clanId = param2;
         this.userId = param3;
      }
      
      public static function get instance() : ClanTagChangedCommand
      {
         return _instance || (_instance = new ClanTagChangedCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 4444;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 10;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.clanTag = param1.readUTF();
         this.clanId = param1.readInt();
         this.clanId = this.clanId >>> 2 % 32 | this.clanId << 32 - 2 % 32;
         this.userId = param1.readInt();
         this.userId = this.userId << 12 % 32 | this.userId >>> 32 - 12 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(4444);
         param1.writeUTF(this.clanTag);
         param1.writeInt(this.clanId << 2 % 32 | this.clanId >>> 32 - 2 % 32);
         param1.writeInt(this.userId >>> 12 % 32 | this.userId << 32 - 12 % 32);
      }
   }
}

