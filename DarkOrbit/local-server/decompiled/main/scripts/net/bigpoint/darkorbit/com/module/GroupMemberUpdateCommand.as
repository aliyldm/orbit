package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class GroupMemberUpdateCommand implements IModule
   {
      
      private static var _instance:GroupMemberUpdateCommand;
      
      public var playerId:int = 0;
      
      public var updates:Vector.<PlayerAttributeModule>;
      
      public function GroupMemberUpdateCommand(param1:int = 0, param2:Vector.<PlayerAttributeModule> = null)
      {
         super();
         this.playerId = param1;
         if(param2 == null)
         {
            this.updates = new Vector.<PlayerAttributeModule>();
         }
         else
         {
            this.updates = param2;
         }
      }
      
      public static function get instance() : GroupMemberUpdateCommand
      {
         return _instance || (_instance = new GroupMemberUpdateCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -4047;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:PlayerAttributeModule = null;
         this.playerId = param1.readInt();
         this.playerId = this.playerId << 9 % 32 | this.playerId >>> 32 - 9 % 32;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.updates.length > 0)
         {
            this.updates.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = PlayerAttributeModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.updates.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:PlayerAttributeModule = null;
         param1.writeShort(-4047);
         param1.writeInt(this.playerId >>> 9 % 32 | this.playerId << 32 - 9 % 32);
         param1.writeByte(this.updates.length);
         for each(_loc2_ in this.updates)
         {
            _loc2_.write(param1);
         }
      }
   }
}

