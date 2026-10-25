package net.bigpoint.darkorbit.com.module.porting.userMessage
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   
   public class ContactListCommand implements IModule
   {
      
      private static var _instance:ContactListCommand;
      
      public var contactList:Vector.<ContactBaseInfoCommand>;
      
      public var startIndex:int = 0;
      
      public var total:int = 0;
      
      public function ContactListCommand(param1:Vector.<ContactBaseInfoCommand> = null, param2:int = 0, param3:int = 0)
      {
         super();
         if(param1 == null)
         {
            this.contactList = new Vector.<ContactBaseInfoCommand>();
         }
         else
         {
            this.contactList = param1;
         }
         this.startIndex = param2;
         this.total = param3;
      }
      
      public static function get instance() : ContactListCommand
      {
         return _instance || (_instance = new ContactListCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -3669;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 12;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:ContactBaseInfoCommand = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.contactList.length > 0)
         {
            this.contactList.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = ContactBaseInfoCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.contactList.push(_loc4_);
            _loc2_++;
         }
         this.startIndex = param1.readInt();
         this.startIndex = this.startIndex >>> 1 % 32 | this.startIndex << 32 - 1 % 32;
         this.total = param1.readInt();
         this.total = this.total << 2 % 32 | this.total >>> 32 - 2 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:ContactBaseInfoCommand = null;
         param1.writeShort(-3669);
         param1.writeByte(this.contactList.length);
         for each(_loc2_ in this.contactList)
         {
            _loc2_.write(param1);
         }
         param1.writeInt(this.startIndex << 1 % 32 | this.startIndex >>> 32 - 1 % 32);
         param1.writeInt(this.total >>> 2 % 32 | this.total << 32 - 2 % 32);
      }
   }
}

