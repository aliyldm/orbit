package net.bigpoint.darkorbit.com.module.porting.userMessage
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class ContactFriendInfoCommand extends ContactBaseInfoCommand
   {
      
      private static var _instance:ContactFriendInfoCommand;
      
      public function ContactFriendInfoCommand(param1:int = 0, param2:String = "", param3:String = "", param4:int = 0)
      {
         super(param1,param2,param3,param4);
      }
      
      public static function get instance() : ContactFriendInfoCommand
      {
         return _instance || (_instance = new ContactFriendInfoCommand());
      }
      
      override public function getLibcomModuleId() : int
      {
         return -18421;
      }
      
      override public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      override public function read(param1:IDataInput) : void
      {
         param1.readShort();
         super.read(param1);
      }
      
      override public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-18421);
         super.write(param1);
      }
   }
}

