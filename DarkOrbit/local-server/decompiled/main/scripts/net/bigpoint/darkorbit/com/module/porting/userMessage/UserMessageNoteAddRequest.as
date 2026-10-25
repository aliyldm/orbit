package net.bigpoint.darkorbit.com.module.porting.userMessage
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class UserMessageNoteAddRequest implements IModule
   {
      
      private static var _instance:UserMessageNoteAddRequest;
      
      public var body:String = "";
      
      public var subject:String = "";
      
      public function UserMessageNoteAddRequest(param1:String = "", param2:String = "")
      {
         super();
         this.body = param2;
         this.subject = param1;
      }
      
      public static function get instance() : UserMessageNoteAddRequest
      {
         return _instance || (_instance = new UserMessageNoteAddRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -5164;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.body = param1.readUTF();
         this.subject = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-5164);
         param1.writeUTF(this.body);
         param1.writeUTF(this.subject);
      }
   }
}

