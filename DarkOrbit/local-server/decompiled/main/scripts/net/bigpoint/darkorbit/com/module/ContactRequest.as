package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ContactRequest implements IModule
   {
      
      private static var _instance:ContactRequest;
      
      public static const CONTACTREQUESTTYPE_FRIEND_REQUEST_CREATE:int = 0;
      
      public static const CONTACTREQUESTTYPE_PENDING_REQUEST_ACCEPT:int = 1;
      
      public static const CONTACTREQUESTTYPE_PENDING_REQUEST_DECLINE:int = 2;
      
      public static const CONTACTREQUESTTYPE_RENDING_REQUEST_REMOVE:int = 3;
      
      public static const CONTACTREQUESTTYPE_FRIEND_REMOVE:int = 4;
      
      public static const CONTACTREQUESTTYPE_BLACKLIST_ADD_CONTACT:int = 5;
      
      public static const CONTACTREQUESTTYPE_BLACKLIST_REMOVE_CONTACT:int = 6;
      
      public static const CONTACTREQUESTTYPE__MAX:int = 7;
      
      public var contactRequestType:int = 0;
      
      public var userId:int = 0;
      
      public var userName:String = "";
      
      public function ContactRequest(param1:String = "", param2:int = 0, param3:int = 0)
      {
         super();
         this.contactRequestType = param3;
         this.userId = param2;
         this.userName = param1;
      }
      
      public static function get instance() : ContactRequest
      {
         return _instance || (_instance = new ContactRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 13422;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 6;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.contactRequestType = param1.readShort();
         this.userId = param1.readInt();
         this.userId = this.userId >>> 6 % 32 | this.userId << 32 - 6 % 32;
         this.userName = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(13422);
         param1.writeShort(this.contactRequestType);
         param1.writeInt(this.userId << 6 % 32 | this.userId >>> 32 - 6 % 32);
         param1.writeUTF(this.userName);
      }
   }
}

