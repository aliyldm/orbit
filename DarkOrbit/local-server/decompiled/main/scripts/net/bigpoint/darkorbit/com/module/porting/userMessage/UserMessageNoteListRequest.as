package net.bigpoint.darkorbit.com.module.porting.userMessage
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class UserMessageNoteListRequest implements IModule
   {
      
      private static var _instance:UserMessageNoteListRequest;
      
      public function UserMessageNoteListRequest()
      {
         super();
      }
      
      public static function get instance() : UserMessageNoteListRequest
      {
         return _instance || (_instance = new UserMessageNoteListRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 3853;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      public function read(param1:IDataInput) : void
      {
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(3853);
      }
   }
}

