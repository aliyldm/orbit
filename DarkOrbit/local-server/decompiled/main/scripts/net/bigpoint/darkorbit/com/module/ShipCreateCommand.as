package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ShipCreateCommand implements IModule
   {
      
      private static var _instance:ShipCreateCommand;
      
      public var userId:int = 0;
      
      public var typeId:String = "";
      
      public var expansionStage:int = 0;
      
      public var clanTag:String = "";
      
      public var userName:String = "";
      
      public var x:int = 0;
      
      public var y:int = 0;
      
      public var factionId:int = 0;
      
      public var clanId:int = 0;
      
      public var dailyRank:int = 0;
      
      public var warnBox:Boolean = false;
      
      public var clanDiplomacy:ClanRelationModule;
      
      public var galaxyGatesDone:int = 0;
      
      public var useSystemFont:Boolean = false;
      
      public var npc:Boolean = false;
      
      public var cloaked:Boolean = false;
      
      public var motherShipId:int = 0;
      
      public var positionIndex:int = 0;
      
      public var designSet:String = "";
      
      public var modifier:Vector.<VisualModifierCommand>;
      
      public var minimapStrategyModule:MinimapStrategyModule;
      
      public var specialNpcType:String = "";
      
      public function ShipCreateCommand(param1:int = 0, param2:String = "", param3:int = 0, param4:String = "", param5:String = "", param6:int = 0, param7:int = 0, param8:int = 0, param9:int = 0, param10:int = 0, param11:Boolean = false, param12:ClanRelationModule = null, param13:int = 0, param14:Boolean = false, param15:Boolean = false, param16:Boolean = false, param17:int = 0, param18:int = 0, param19:String = "", param20:Vector.<VisualModifierCommand> = null, param21:MinimapStrategyModule = null, param22:String = "")
      {
         super();
         this.userId = param1;
         this.typeId = param2;
         this.expansionStage = param3;
         this.clanTag = param4;
         this.userName = param5;
         this.x = param6;
         this.y = param7;
         this.factionId = param8;
         this.clanId = param9;
         this.dailyRank = param10;
         this.warnBox = param11;
         if(param12 == null)
         {
            this.clanDiplomacy = new ClanRelationModule();
         }
         else
         {
            this.clanDiplomacy = param12;
         }
         this.galaxyGatesDone = param13;
         this.useSystemFont = param14;
         this.npc = param15;
         this.cloaked = param16;
         this.motherShipId = param17;
         this.positionIndex = param18;
         this.designSet = param19;
         if(param20 == null)
         {
            this.modifier = new Vector.<VisualModifierCommand>();
         }
         else
         {
            this.modifier = param20;
         }
         if(param21 == null)
         {
            this.minimapStrategyModule = new MinimapStrategyModule();
         }
         else
         {
            this.minimapStrategyModule = param21;
         }
         this.specialNpcType = param22;
      }
      
      public static function get instance() : ShipCreateCommand
      {
         return _instance || (_instance = new ShipCreateCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 83;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 58;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:VisualModifierCommand = null;
         this.userId = param1.readInt();
         this.userId = this.userId >>> 15 % 32 | this.userId << 32 - 15 % 32;
         this.typeId = param1.readUTF();
         this.expansionStage = param1.readInt();
         this.expansionStage = this.expansionStage >>> 8 % 32 | this.expansionStage << 32 - 8 % 32;
         this.clanTag = param1.readUTF();
         this.userName = param1.readUTF();
         this.x = param1.readInt();
         this.x = this.x << 6 % 32 | this.x >>> 32 - 6 % 32;
         this.y = param1.readInt();
         this.y = this.y << 15 % 32 | this.y >>> 32 - 15 % 32;
         this.factionId = param1.readInt();
         this.factionId = this.factionId >>> 1 % 32 | this.factionId << 32 - 1 % 32;
         this.clanId = param1.readInt();
         this.clanId = this.clanId >>> 15 % 32 | this.clanId << 32 - 15 % 32;
         this.dailyRank = param1.readInt();
         this.dailyRank = this.dailyRank << 1 % 32 | this.dailyRank >>> 32 - 1 % 32;
         this.warnBox = param1.readBoolean();
         this.clanDiplomacy = ClanRelationModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.clanDiplomacy)
         {
            this.clanDiplomacy.read(param1);
         }
         this.galaxyGatesDone = param1.readInt();
         this.galaxyGatesDone = this.galaxyGatesDone >>> 12 % 32 | this.galaxyGatesDone << 32 - 12 % 32;
         this.useSystemFont = param1.readBoolean();
         this.npc = param1.readBoolean();
         this.cloaked = param1.readBoolean();
         this.motherShipId = param1.readInt();
         this.motherShipId = this.motherShipId >>> 10 % 32 | this.motherShipId << 32 - 10 % 32;
         this.positionIndex = param1.readInt();
         this.positionIndex = this.positionIndex >>> 1 % 32 | this.positionIndex << 32 - 1 % 32;
         this.designSet = param1.readUTF();
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.modifier.length > 0)
         {
            this.modifier.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = VisualModifierCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.modifier.push(_loc4_);
            _loc2_++;
         }
         this.minimapStrategyModule = MinimapStrategyModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.minimapStrategyModule)
         {
            this.minimapStrategyModule.read(param1);
         }
         this.specialNpcType = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:VisualModifierCommand = null;
         param1.writeShort(83);
         param1.writeInt(this.userId << 15 % 32 | this.userId >>> 32 - 15 % 32);
         param1.writeUTF(this.typeId);
         param1.writeInt(this.expansionStage << 8 % 32 | this.expansionStage >>> 32 - 8 % 32);
         param1.writeUTF(this.clanTag);
         param1.writeUTF(this.userName);
         param1.writeInt(this.x >>> 6 % 32 | this.x << 32 - 6 % 32);
         param1.writeInt(this.y >>> 15 % 32 | this.y << 32 - 15 % 32);
         param1.writeInt(this.factionId << 1 % 32 | this.factionId >>> 32 - 1 % 32);
         param1.writeInt(this.clanId << 15 % 32 | this.clanId >>> 32 - 15 % 32);
         param1.writeInt(this.dailyRank >>> 1 % 32 | this.dailyRank << 32 - 1 % 32);
         param1.writeBoolean(this.warnBox);
         if(null != this.clanDiplomacy)
         {
            this.clanDiplomacy.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeInt(this.galaxyGatesDone << 12 % 32 | this.galaxyGatesDone >>> 32 - 12 % 32);
         param1.writeBoolean(this.useSystemFont);
         param1.writeBoolean(this.npc);
         param1.writeBoolean(this.cloaked);
         param1.writeInt(this.motherShipId << 10 % 32 | this.motherShipId >>> 32 - 10 % 32);
         param1.writeInt(this.positionIndex << 1 % 32 | this.positionIndex >>> 32 - 1 % 32);
         param1.writeUTF(this.designSet);
         param1.writeByte(this.modifier.length);
         for each(_loc2_ in this.modifier)
         {
            _loc2_.write(param1);
         }
         if(null != this.minimapStrategyModule)
         {
            this.minimapStrategyModule.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeUTF(this.specialNpcType);
      }
   }
}

