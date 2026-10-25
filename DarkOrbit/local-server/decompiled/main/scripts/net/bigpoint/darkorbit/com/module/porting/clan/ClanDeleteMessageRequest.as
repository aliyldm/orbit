package net.bigpoint.darkorbit.com.module.porting.clan
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ClanDeleteMessageRequest implements IModule
   {
      
      private static var _instance:ClanDeleteMessageRequest;
      
      public var messageId:int = 0;
      
      public function ClanDeleteMessageRequest(param1:int = 0)
      {
         super();
         this.messageId = param1;
      }
      
      public static function get instance() : ClanDeleteMessageRequest
      {
         return _instance || (_instance = new ClanDeleteMessageRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 5478;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.messageId = param1.readInt();
         this.messageId = this.messageId >>> 9 % 32 | this.messageId << 32 - 9 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(5478);
         param1.writeInt(this.messageId << 9 % 32 | this.messageId >>> 32 - 9 % 32);
      }
   }
}

