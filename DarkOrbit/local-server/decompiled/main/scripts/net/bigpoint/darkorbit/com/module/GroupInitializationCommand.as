package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class GroupInitializationCommand implements IModule
   {
      
      private static var _instance:GroupInitializationCommand;
      
      public var id:int = 0;
      
      public var leaderId:int = 0;
      
      public var invitationMode:InvitationModeModule;
      
      public var maxSize:int = 0;
      
      public var members:Vector.<GroupMemberInitializationCommand>;
      
      public function GroupInitializationCommand(param1:int = 0, param2:int = 0, param3:int = 0, param4:Vector.<GroupMemberInitializationCommand> = null, param5:InvitationModeModule = null)
      {
         super();
         this.id = param1;
         this.leaderId = param3;
         if(param5 == null)
         {
            this.invitationMode = new InvitationModeModule();
         }
         else
         {
            this.invitationMode = param5;
         }
         this.maxSize = param2;
         if(param4 == null)
         {
            this.members = new Vector.<GroupMemberInitializationCommand>();
         }
         else
         {
            this.members = param4;
         }
      }
      
      public static function get instance() : GroupInitializationCommand
      {
         return _instance || (_instance = new GroupInitializationCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 11796;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 16;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:GroupMemberInitializationCommand = null;
         this.id = param1.readInt();
         this.id = this.id >>> 12 % 32 | this.id << 32 - 12 % 32;
         this.leaderId = param1.readInt();
         this.leaderId = this.leaderId >>> 15 % 32 | this.leaderId << 32 - 15 % 32;
         this.invitationMode = InvitationModeModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.invitationMode)
         {
            this.invitationMode.read(param1);
         }
         this.maxSize = param1.readInt();
         this.maxSize = this.maxSize << 14 % 32 | this.maxSize >>> 32 - 14 % 32;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.members.length > 0)
         {
            this.members.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = GroupMemberInitializationCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.members.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:GroupMemberInitializationCommand = null;
         param1.writeShort(11796);
         param1.writeInt(this.id << 12 % 32 | this.id >>> 32 - 12 % 32);
         param1.writeInt(this.leaderId << 15 % 32 | this.leaderId >>> 32 - 15 % 32);
         if(null != this.invitationMode)
         {
            this.invitationMode.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeInt(this.maxSize >>> 14 % 32 | this.maxSize << 32 - 14 % 32);
         param1.writeByte(this.members.length);
         for each(_loc2_ in this.members)
         {
            _loc2_.write(param1);
         }
      }
   }
}

