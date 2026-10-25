package net.bigpoint.darkorbit.com.module.porting.userMessage
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class UserMessageNoteUpdateRequest implements IModule
   {
      
      private static var _instance:UserMessageNoteUpdateRequest;
      
      public var noteId:int = 0;
      
      public var subject:String = "";
      
      public var body:String = "";
      
      public function UserMessageNoteUpdateRequest(param1:int = 0, param2:String = "", param3:String = "")
      {
         super();
         this.noteId = param1;
         this.subject = param2;
         this.body = param3;
      }
      
      public static function get instance() : UserMessageNoteUpdateRequest
      {
         return _instance || (_instance = new UserMessageNoteUpdateRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -27566;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.noteId = param1.readInt();
         this.noteId = this.noteId >>> 7 % 32 | this.noteId << 32 - 7 % 32;
         this.subject = param1.readUTF();
         this.body = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-27566);
         param1.writeInt(this.noteId << 7 % 32 | this.noteId >>> 32 - 7 % 32);
         param1.writeUTF(this.subject);
         param1.writeUTF(this.body);
      }
   }
}

