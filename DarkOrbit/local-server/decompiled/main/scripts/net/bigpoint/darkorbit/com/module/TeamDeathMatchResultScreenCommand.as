package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class TeamDeathMatchResultScreenCommand implements IModule
   {
      
      private static var _instance:TeamDeathMatchResultScreenCommand;
      
      public static const RESULTSTATE_WIN:int = 0;
      
      public static const RESULTSTATE_LOSE:int = 1;
      
      public static const RESULTSTATE_NO_LIFES_LEFT:int = 2;
      
      public static const RESULTSTATE_DRAW:int = 3;
      
      public static const RESULTSTATE__MAX:int = 4;
      
      public var ownFaction:FactionModule;
      
      public var hint:HintModule;
      
      public var opponentPlayers:Vector.<TeamDeathMatchResultScreenPlayerModule>;
      
      public var playerSessionKills:int = 0;
      
      public var playerSessionDeaths:int = 0;
      
      public var opponentFaction:FactionModule;
      
      public var ownPlayers:Vector.<TeamDeathMatchResultScreenPlayerModule>;
      
      public var rewards:Vector.<RewardModule>;
      
      public var resultState:int = 0;
      
      public function TeamDeathMatchResultScreenCommand(param1:int = 0, param2:int = 0, param3:int = 0, param4:FactionModule = null, param5:FactionModule = null, param6:Vector.<TeamDeathMatchResultScreenPlayerModule> = null, param7:Vector.<TeamDeathMatchResultScreenPlayerModule> = null, param8:Vector.<RewardModule> = null, param9:HintModule = null)
      {
         super();
         if(param4 == null)
         {
            this.ownFaction = new FactionModule();
         }
         else
         {
            this.ownFaction = param4;
         }
         if(param9 == null)
         {
            this.hint = new HintModule();
         }
         else
         {
            this.hint = param9;
         }
         if(param7 == null)
         {
            this.opponentPlayers = new Vector.<TeamDeathMatchResultScreenPlayerModule>();
         }
         else
         {
            this.opponentPlayers = param7;
         }
         this.playerSessionKills = param2;
         this.playerSessionDeaths = param3;
         if(param5 == null)
         {
            this.opponentFaction = new FactionModule();
         }
         else
         {
            this.opponentFaction = param5;
         }
         if(param6 == null)
         {
            this.ownPlayers = new Vector.<TeamDeathMatchResultScreenPlayerModule>();
         }
         else
         {
            this.ownPlayers = param6;
         }
         if(param8 == null)
         {
            this.rewards = new Vector.<RewardModule>();
         }
         else
         {
            this.rewards = param8;
         }
         this.resultState = param1;
      }
      
      public static function get instance() : TeamDeathMatchResultScreenCommand
      {
         return _instance || (_instance = new TeamDeathMatchResultScreenCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 26900;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 20;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:TeamDeathMatchResultScreenPlayerModule = null;
         var _loc5_:TeamDeathMatchResultScreenPlayerModule = null;
         var _loc6_:RewardModule = null;
         this.ownFaction = FactionModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.ownFaction)
         {
            this.ownFaction.read(param1);
         }
         this.hint = HintModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.hint)
         {
            this.hint.read(param1);
         }
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.opponentPlayers.length > 0)
         {
            this.opponentPlayers.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = TeamDeathMatchResultScreenPlayerModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.opponentPlayers.push(_loc4_);
            _loc2_++;
         }
         this.playerSessionKills = param1.readInt();
         this.playerSessionKills = this.playerSessionKills << 5 % 32 | this.playerSessionKills >>> 32 - 5 % 32;
         this.playerSessionDeaths = param1.readInt();
         this.playerSessionDeaths = this.playerSessionDeaths << 3 % 32 | this.playerSessionDeaths >>> 32 - 3 % 32;
         this.opponentFaction = FactionModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.opponentFaction)
         {
            this.opponentFaction.read(param1);
         }
         while(this.ownPlayers.length > 0)
         {
            this.ownPlayers.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc5_ = TeamDeathMatchResultScreenPlayerModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc5_.read(param1);
            this.ownPlayers.push(_loc5_);
            _loc2_++;
         }
         while(this.rewards.length > 0)
         {
            this.rewards.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc6_ = RewardModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc6_.read(param1);
            this.rewards.push(_loc6_);
            _loc2_++;
         }
         this.resultState = param1.readShort();
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:TeamDeathMatchResultScreenPlayerModule = null;
         var _loc3_:TeamDeathMatchResultScreenPlayerModule = null;
         var _loc4_:RewardModule = null;
         param1.writeShort(26900);
         if(null != this.ownFaction)
         {
            this.ownFaction.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         if(null != this.hint)
         {
            this.hint.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeByte(this.opponentPlayers.length);
         for each(_loc2_ in this.opponentPlayers)
         {
            _loc2_.write(param1);
         }
         param1.writeInt(this.playerSessionKills >>> 5 % 32 | this.playerSessionKills << 32 - 5 % 32);
         param1.writeInt(this.playerSessionDeaths >>> 3 % 32 | this.playerSessionDeaths << 32 - 3 % 32);
         if(null != this.opponentFaction)
         {
            this.opponentFaction.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeByte(this.ownPlayers.length);
         for each(_loc3_ in this.ownPlayers)
         {
            _loc3_.write(param1);
         }
         param1.writeByte(this.rewards.length);
         for each(_loc4_ in this.rewards)
         {
            _loc4_.write(param1);
         }
         param1.writeShort(this.resultState);
      }
   }
}

