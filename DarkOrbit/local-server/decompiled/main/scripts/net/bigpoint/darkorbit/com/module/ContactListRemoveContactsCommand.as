package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ContactListRemoveContactsCommand implements IModule
   {
      
      private static var _instance:ContactListRemoveContactsCommand;
      
      public var contactUserIds:Vector.<int>;
      
      public function ContactListRemoveContactsCommand(param1:Vector.<int> = null)
      {
         super();
         if(param1 == null)
         {
            this.contactUserIds = new Vector.<int>();
         }
         else
         {
            this.contactUserIds = param1;
         }
      }
      
      public static function get instance() : ContactListRemoveContactsCommand
      {
         return _instance || (_instance = new ContactListRemoveContactsCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -13415;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.contactUserIds.length > 0)
         {
            this.contactUserIds.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = param1.readInt();
            _loc4_ = _loc4_ << 12 % 32 | _loc4_ >>> 32 - 12 % 32;
            this.contactUserIds.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:int = 0;
         param1.writeShort(-13415);
         param1.writeByte(this.contactUserIds.length);
         for each(_loc2_ in this.contactUserIds)
         {
            param1.writeInt(_loc2_ >>> 12 % 32 | _loc2_ << 32 - 12 % 32);
         }
      }
   }
}

