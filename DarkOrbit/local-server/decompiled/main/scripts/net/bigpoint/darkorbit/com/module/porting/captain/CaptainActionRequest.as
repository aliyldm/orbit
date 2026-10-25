package net.bigpoint.darkorbit.com.module.porting.captain
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class CaptainActionRequest implements IModule
   {
      
      private static var _instance:CaptainActionRequest;
      
      public var perkId:int = 0;
      
      public var upgradeLevel:int = 0;
      
      public var captainId:int = 0;
      
      public var command:String = "";
      
      public function CaptainActionRequest(param1:String = "", param2:int = 0, param3:int = 0, param4:int = 0)
      {
         super();
         this.perkId = param3;
         this.upgradeLevel = param4;
         this.captainId = param2;
         this.command = param1;
      }
      
      public static function get instance() : CaptainActionRequest
      {
         return _instance || (_instance = new CaptainActionRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 11090;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 14;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.perkId = param1.readInt();
         this.perkId = this.perkId << 11 % 32 | this.perkId >>> 32 - 11 % 32;
         this.upgradeLevel = param1.readInt();
         this.upgradeLevel = this.upgradeLevel >>> 15 % 32 | this.upgradeLevel << 32 - 15 % 32;
         this.captainId = param1.readInt();
         this.captainId = this.captainId << 13 % 32 | this.captainId >>> 32 - 13 % 32;
         this.command = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(11090);
         param1.writeInt(this.perkId >>> 11 % 32 | this.perkId << 32 - 11 % 32);
         param1.writeInt(this.upgradeLevel << 15 % 32 | this.upgradeLevel >>> 32 - 15 % 32);
         param1.writeInt(this.captainId >>> 13 % 32 | this.captainId << 32 - 13 % 32);
         param1.writeUTF(this.command);
      }
   }
}

