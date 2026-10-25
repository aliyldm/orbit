package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class WarGameInitLobbyCommand implements IModule
   {
      
      private static var _instance:WarGameInitLobbyCommand;
      
      public var lobbyStatus:WarGameLobbyStatusModule;
      
      public var rewards:Vector.<RewardContentModule>;
      
      public function WarGameInitLobbyCommand(param1:Vector.<RewardContentModule> = null, param2:WarGameLobbyStatusModule = null)
      {
         super();
         if(param2 == null)
         {
            this.lobbyStatus = new WarGameLobbyStatusModule();
         }
         else
         {
            this.lobbyStatus = param2;
         }
         if(param1 == null)
         {
            this.rewards = new Vector.<RewardContentModule>();
         }
         else
         {
            this.rewards = param1;
         }
      }
      
      public static function get instance() : WarGameInitLobbyCommand
      {
         return _instance || (_instance = new WarGameInitLobbyCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -31315;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:RewardContentModule = null;
         this.lobbyStatus = WarGameLobbyStatusModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.lobbyStatus)
         {
            this.lobbyStatus.read(param1);
         }
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.rewards.length > 0)
         {
            this.rewards.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = RewardContentModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.rewards.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:RewardContentModule = null;
         param1.writeShort(-31315);
         if(null != this.lobbyStatus)
         {
            this.lobbyStatus.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeByte(this.rewards.length);
         for each(_loc2_ in this.rewards)
         {
            _loc2_.write(param1);
         }
      }
   }
}

