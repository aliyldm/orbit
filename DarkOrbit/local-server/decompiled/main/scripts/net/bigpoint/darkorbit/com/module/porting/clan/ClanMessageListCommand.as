package net.bigpoint.darkorbit.com.module.porting.clan
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   
   public class ClanMessageListCommand implements IModule
   {
      
      private static var _instance:ClanMessageListCommand;
      
      public var messageList:Vector.<ClanMessageInfoCommand>;
      
      public function ClanMessageListCommand(param1:Vector.<ClanMessageInfoCommand> = null)
      {
         super();
         if(param1 == null)
         {
            this.messageList = new Vector.<ClanMessageInfoCommand>();
         }
         else
         {
            this.messageList = param1;
         }
      }
      
      public static function get instance() : ClanMessageListCommand
      {
         return _instance || (_instance = new ClanMessageListCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -22169;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:ClanMessageInfoCommand = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.messageList.length > 0)
         {
            this.messageList.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = ClanMessageInfoCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.messageList.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:ClanMessageInfoCommand = null;
         param1.writeShort(-22169);
         param1.writeByte(this.messageList.length);
         for each(_loc2_ in this.messageList)
         {
            _loc2_.write(param1);
         }
      }
   }
}

