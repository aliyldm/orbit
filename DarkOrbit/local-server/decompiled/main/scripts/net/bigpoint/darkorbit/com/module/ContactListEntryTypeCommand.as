package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ContactListEntryTypeCommand implements IModule
   {
      
      private static var _instance:ContactListEntryTypeCommand;
      
      public var contactEntryTypes:Vector.<ContactListEntryTypeModule>;
      
      public var userId:int = 0;
      
      public function ContactListEntryTypeCommand(param1:int = 0, param2:Vector.<ContactListEntryTypeModule> = null)
      {
         super();
         if(param2 == null)
         {
            this.contactEntryTypes = new Vector.<ContactListEntryTypeModule>();
         }
         else
         {
            this.contactEntryTypes = param2;
         }
         this.userId = param1;
      }
      
      public static function get instance() : ContactListEntryTypeCommand
      {
         return _instance || (_instance = new ContactListEntryTypeCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 4076;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:ContactListEntryTypeModule = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.contactEntryTypes.length > 0)
         {
            this.contactEntryTypes.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = ContactListEntryTypeModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.contactEntryTypes.push(_loc4_);
            _loc2_++;
         }
         this.userId = param1.readInt();
         this.userId = this.userId >>> 9 % 32 | this.userId << 32 - 9 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:ContactListEntryTypeModule = null;
         param1.writeShort(4076);
         param1.writeByte(this.contactEntryTypes.length);
         for each(_loc2_ in this.contactEntryTypes)
         {
            _loc2_.write(param1);
         }
         param1.writeInt(this.userId << 9 % 32 | this.userId >>> 32 - 9 % 32);
      }
   }
}

