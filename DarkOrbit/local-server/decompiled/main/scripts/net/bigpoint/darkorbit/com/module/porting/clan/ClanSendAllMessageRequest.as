package net.bigpoint.darkorbit.com.module.porting.clan
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ClanSendAllMessageRequest implements IModule
   {
      
      private static var _instance:ClanSendAllMessageRequest;
      
      public var msgText:String = "";
      
      public var subject:String = "";
      
      public function ClanSendAllMessageRequest(param1:String = "", param2:String = "")
      {
         super();
         this.msgText = param2;
         this.subject = param1;
      }
      
      public static function get instance() : ClanSendAllMessageRequest
      {
         return _instance || (_instance = new ClanSendAllMessageRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 11037;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.msgText = param1.readUTF();
         this.subject = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(11037);
         param1.writeUTF(this.msgText);
         param1.writeUTF(this.subject);
      }
   }
}

