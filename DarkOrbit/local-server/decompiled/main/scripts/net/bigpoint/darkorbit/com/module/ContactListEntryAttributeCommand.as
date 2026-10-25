package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ContactListEntryAttributeCommand implements IModule
   {
      
      private static var _instance:ContactListEntryAttributeCommand;
      
      public var userId:int = 0;
      
      public var attributes:Vector.<ContactListEntryAttributeBaseModule>;
      
      public function ContactListEntryAttributeCommand(param1:int = 0, param2:Vector.<ContactListEntryAttributeBaseModule> = null)
      {
         super();
         this.userId = param1;
         if(param2 == null)
         {
            this.attributes = new Vector.<ContactListEntryAttributeBaseModule>();
         }
         else
         {
            this.attributes = param2;
         }
      }
      
      public static function get instance() : ContactListEntryAttributeCommand
      {
         return _instance || (_instance = new ContactListEntryAttributeCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 26896;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:ContactListEntryAttributeBaseModule = null;
         this.userId = param1.readInt();
         this.userId = this.userId << 7 % 32 | this.userId >>> 32 - 7 % 32;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.attributes.length > 0)
         {
            this.attributes.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = ContactListEntryAttributeBaseModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.attributes.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:ContactListEntryAttributeBaseModule = null;
         param1.writeShort(26896);
         param1.writeInt(this.userId >>> 7 % 32 | this.userId << 32 - 7 % 32);
         param1.writeByte(this.attributes.length);
         for each(_loc2_ in this.attributes)
         {
            _loc2_.write(param1);
         }
      }
   }
}

