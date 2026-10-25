package net.bigpoint.darkorbit.com.module.porting.userMessage
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ContactFriendAcceptTipsCommand implements IModule
   {
      
      private static var _instance:ContactFriendAcceptTipsCommand;
      
      public function ContactFriendAcceptTipsCommand()
      {
         super();
      }
      
      public static function get instance() : ContactFriendAcceptTipsCommand
      {
         return _instance || (_instance = new ContactFriendAcceptTipsCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 7763;
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
         param1.writeShort(7763);
      }
   }
}

