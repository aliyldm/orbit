package net.bigpoint.darkorbit.com.module.porting.userMessage
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class UserMessageTargetInfoCommand implements IModule
   {
      
      private static var _instance:UserMessageTargetInfoCommand;
      
      public var id:int = 0;
      
      public var message:String = "";
      
      public var used:Boolean = false;
      
      public function UserMessageTargetInfoCommand(param1:int = 0, param2:String = "", param3:Boolean = false)
      {
         super();
         this.id = param1;
         this.message = param2;
         this.used = param3;
      }
      
      public static function get instance() : UserMessageTargetInfoCommand
      {
         return _instance || (_instance = new UserMessageTargetInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 5199;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 7;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.id = param1.readInt();
         this.id = this.id << 7 % 32 | this.id >>> 32 - 7 % 32;
         this.message = param1.readUTF();
         this.used = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(5199);
         param1.writeInt(this.id >>> 7 % 32 | this.id << 32 - 7 % 32);
         param1.writeUTF(this.message);
         param1.writeBoolean(this.used);
      }
   }
}

