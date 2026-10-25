package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ClanMemberModule implements IModule
   {
      
      private static var _instance:ClanMemberModule;
      
      public var userId:int = 0;
      
      public var userName:String = "";
      
      public function ClanMemberModule(param1:int = 0, param2:String = "")
      {
         super();
         this.userId = param1;
         this.userName = param2;
      }
      
      public static function get instance() : ClanMemberModule
      {
         return _instance || (_instance = new ClanMemberModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 3336;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 6;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.userId = param1.readInt();
         this.userId = this.userId >>> 11 % 32 | this.userId << 32 - 11 % 32;
         this.userName = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(3336);
         param1.writeInt(this.userId << 11 % 32 | this.userId >>> 32 - 11 % 32);
         param1.writeUTF(this.userName);
      }
   }
}

