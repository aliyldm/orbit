package net.bigpoint.darkorbit.com.module.porting.clan
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   
   public class ClanMemberListCommand implements IModule
   {
      
      private static var _instance:ClanMemberListCommand;
      
      public var memberList:Vector.<ClanMemberInfoCommand>;
      
      public function ClanMemberListCommand(param1:Vector.<ClanMemberInfoCommand> = null)
      {
         super();
         if(param1 == null)
         {
            this.memberList = new Vector.<ClanMemberInfoCommand>();
         }
         else
         {
            this.memberList = param1;
         }
      }
      
      public static function get instance() : ClanMemberListCommand
      {
         return _instance || (_instance = new ClanMemberListCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -4583;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:ClanMemberInfoCommand = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.memberList.length > 0)
         {
            this.memberList.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = ClanMemberInfoCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.memberList.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:ClanMemberInfoCommand = null;
         param1.writeShort(-4583);
         param1.writeByte(this.memberList.length);
         for each(_loc2_ in this.memberList)
         {
            _loc2_.write(param1);
         }
      }
   }
}

