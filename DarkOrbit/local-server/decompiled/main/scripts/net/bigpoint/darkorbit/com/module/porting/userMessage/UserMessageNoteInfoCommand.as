package net.bigpoint.darkorbit.com.module.porting.userMessage
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class UserMessageNoteInfoCommand implements IModule
   {
      
      private static var _instance:UserMessageNoteInfoCommand;
      
      public var insertDate:String = "";
      
      public var noteId:int = 0;
      
      public var body:String = "";
      
      public var subject:String = "";
      
      public function UserMessageNoteInfoCommand(param1:int = 0, param2:String = "", param3:String = "", param4:String = "")
      {
         super();
         this.insertDate = param4;
         this.noteId = param1;
         this.body = param3;
         this.subject = param2;
      }
      
      public static function get instance() : UserMessageNoteInfoCommand
      {
         return _instance || (_instance = new UserMessageNoteInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -1965;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 10;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.insertDate = param1.readUTF();
         this.noteId = param1.readInt();
         this.noteId = this.noteId >>> 10 % 32 | this.noteId << 32 - 10 % 32;
         this.body = param1.readUTF();
         this.subject = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-1965);
         param1.writeUTF(this.insertDate);
         param1.writeInt(this.noteId << 10 % 32 | this.noteId >>> 32 - 10 % 32);
         param1.writeUTF(this.body);
         param1.writeUTF(this.subject);
      }
   }
}

