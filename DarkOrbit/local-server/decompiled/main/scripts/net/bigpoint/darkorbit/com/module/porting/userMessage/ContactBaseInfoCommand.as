package net.bigpoint.darkorbit.com.module.porting.userMessage
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ContactBaseInfoCommand implements IModule
   {
      
      private static var _instance:ContactBaseInfoCommand;
      
      public var userId:int = 0;
      
      public var userName:String = "";
      
      public var type:int = 0;
      
      public var avatarURL:String = "";
      
      public function ContactBaseInfoCommand(param1:int = 0, param2:String = "", param3:String = "", param4:int = 0)
      {
         super();
         this.userId = param1;
         this.userName = param2;
         this.type = param4;
         this.avatarURL = param3;
      }
      
      public static function get instance() : ContactBaseInfoCommand
      {
         return _instance || (_instance = new ContactBaseInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 15458;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 12;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.userId = param1.readInt();
         this.userId = this.userId >>> 6 % 32 | this.userId << 32 - 6 % 32;
         this.userName = param1.readUTF();
         this.type = param1.readInt();
         this.type = this.type << 6 % 32 | this.type >>> 32 - 6 % 32;
         this.avatarURL = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(15458);
         param1.writeInt(this.userId << 6 % 32 | this.userId >>> 32 - 6 % 32);
         param1.writeUTF(this.userName);
         param1.writeInt(this.type >>> 6 % 32 | this.type << 32 - 6 % 32);
         param1.writeUTF(this.avatarURL);
      }
   }
}

