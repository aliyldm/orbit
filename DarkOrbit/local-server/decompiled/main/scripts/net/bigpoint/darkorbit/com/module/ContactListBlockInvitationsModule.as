package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ContactListBlockInvitationsModule implements IModule
   {
      
      private static var _instance:ContactListBlockInvitationsModule;
      
      public var blockAllInvitations:Boolean = false;
      
      public function ContactListBlockInvitationsModule(param1:Boolean = false)
      {
         super();
         this.blockAllInvitations = param1;
      }
      
      public static function get instance() : ContactListBlockInvitationsModule
      {
         return _instance || (_instance = new ContactListBlockInvitationsModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 25806;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 1;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.blockAllInvitations = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(25806);
         param1.writeBoolean(this.blockAllInvitations);
      }
   }
}

