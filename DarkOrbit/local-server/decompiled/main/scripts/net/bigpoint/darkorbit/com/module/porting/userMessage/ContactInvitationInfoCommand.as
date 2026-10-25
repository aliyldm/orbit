package net.bigpoint.darkorbit.com.module.porting.userMessage
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class ContactInvitationInfoCommand extends ContactBaseInfoCommand
   {
      
      private static var _instance:ContactInvitationInfoCommand;
      
      public function ContactInvitationInfoCommand(param1:int = 0, param2:String = "", param3:String = "", param4:int = 0)
      {
         super(param1,param2,param3,param4);
      }
      
      public static function get instance() : ContactInvitationInfoCommand
      {
         return _instance || (_instance = new ContactInvitationInfoCommand());
      }
      
      override public function getLibcomModuleId() : int
      {
         return 30697;
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
         param1.writeShort(30697);
         super.write(param1);
      }
   }
}

