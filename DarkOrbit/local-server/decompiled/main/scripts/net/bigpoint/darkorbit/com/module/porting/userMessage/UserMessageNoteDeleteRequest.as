package net.bigpoint.darkorbit.com.module.porting.userMessage
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class UserMessageNoteDeleteRequest implements IModule
   {
      
      private static var _instance:UserMessageNoteDeleteRequest;
      
      public var noteId:int = 0;
      
      public function UserMessageNoteDeleteRequest(param1:int = 0)
      {
         super();
         this.noteId = param1;
      }
      
      public static function get instance() : UserMessageNoteDeleteRequest
      {
         return _instance || (_instance = new UserMessageNoteDeleteRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -8223;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.noteId = param1.readInt();
         this.noteId = this.noteId << 7 % 32 | this.noteId >>> 32 - 7 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-8223);
         param1.writeInt(this.noteId >>> 7 % 32 | this.noteId << 32 - 7 % 32);
      }
   }
}

