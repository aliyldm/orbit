package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ContactListSettingsModule implements IModule
   {
      
      private static var _instance:ContactListSettingsModule;
      
      public var showClanMembers:Boolean = false;
      
      public var showRequests:Boolean = false;
      
      public var showFriends:Boolean = false;
      
      public var showBlacklistPlayers:Boolean = false;
      
      public function ContactListSettingsModule(param1:Boolean = false, param2:Boolean = false, param3:Boolean = false, param4:Boolean = false)
      {
         super();
         this.showClanMembers = param2;
         this.showRequests = param3;
         this.showFriends = param1;
         this.showBlacklistPlayers = param4;
      }
      
      public static function get instance() : ContactListSettingsModule
      {
         return _instance || (_instance = new ContactListSettingsModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 27750;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.showClanMembers = param1.readBoolean();
         this.showRequests = param1.readBoolean();
         this.showFriends = param1.readBoolean();
         this.showBlacklistPlayers = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(27750);
         param1.writeBoolean(this.showClanMembers);
         param1.writeBoolean(this.showRequests);
         param1.writeBoolean(this.showFriends);
         param1.writeBoolean(this.showBlacklistPlayers);
      }
   }
}

