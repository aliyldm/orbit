package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ShipInitializationCommand implements IModule
   {
      
      private static var _instance:ShipInitializationCommand;
      
      public var userId:int = 0;
      
      public var userName:String = "";
      
      public var typeId:String = "";
      
      public var speed:int = 0;
      
      public var shield:int = 0;
      
      public var shieldMax:int = 0;
      
      public var hitPoints:Number = 0;
      
      public var hitMax:Number = 0;
      
      public var cargoSpace:int = 0;
      
      public var cargoSpaceMax:int = 0;
      
      public var nanoHull:int = 0;
      
      public var maxNanoHull:int = 0;
      
      public var x:int = 0;
      
      public var y:int = 0;
      
      public var mapId:int = 0;
      
      public var factionId:int = 0;
      
      public var clanId:int = 0;
      
      public var expansionStage:int = 0;
      
      public var premium:Boolean = false;
      
      public var ep:Number = 0;
      
      public var honourPoints:Number = 0;
      
      public var level:int = 0;
      
      public var credits:Number = 0;
      
      public var uridium:Number = 0;
      
      public var jackpot:Number = 0;
      
      public var dailyRank:int = 0;
      
      public var clanTag:String = "";
      
      public var galaxyGatesDone:int = 0;
      
      public var useSystemFont:Boolean = false;
      
      public var cloaked:Boolean = false;
      
      public var refreshMap:Boolean = false;
      
      public var captainEnergy:int = 0;
      
      public var maxCaptainEnergy:int = 0;
      
      public var modifier:Vector.<VisualModifierCommand>;
      
      public function ShipInitializationCommand(param1:int = 0, param2:String = "", param3:String = "", param4:int = 0, param5:int = 0, param6:int = 0, param7:Number = 0, param8:Number = 0, param9:int = 0, param10:int = 0, param11:int = 0, param12:int = 0, param13:int = 0, param14:int = 0, param15:int = 0, param16:int = 0, param17:int = 0, param18:int = 0, param19:Boolean = false, param20:Number = 0, param21:Number = 0, param22:int = 0, param23:Number = 0, param24:Number = 0, param25:Number = 0, param26:int = 0, param27:String = "", param28:int = 0, param29:Boolean = false, param30:Boolean = false, param31:Boolean = false, param32:int = 0, param33:int = 0, param34:Vector.<VisualModifierCommand> = null)
      {
         super();
         this.userId = param1;
         this.userName = param2;
         this.typeId = param3;
         this.speed = param4;
         this.shield = param5;
         this.shieldMax = param6;
         this.hitPoints = param7;
         this.hitMax = param8;
         this.cargoSpace = param9;
         this.cargoSpaceMax = param10;
         this.nanoHull = param11;
         this.maxNanoHull = param12;
         this.x = param13;
         this.y = param14;
         this.mapId = param15;
         this.factionId = param16;
         this.clanId = param17;
         this.expansionStage = param18;
         this.premium = param19;
         this.ep = param20;
         this.honourPoints = param21;
         this.level = param22;
         this.credits = param23;
         this.uridium = param24;
         this.jackpot = param25;
         this.dailyRank = param26;
         this.clanTag = param27;
         this.galaxyGatesDone = param28;
         this.useSystemFont = param29;
         this.cloaked = param30;
         this.refreshMap = param31;
         this.captainEnergy = param32;
         this.maxCaptainEnergy = param33;
         if(param34 == null)
         {
            this.modifier = new Vector.<VisualModifierCommand>();
         }
         else
         {
            this.modifier = param34;
         }
      }
      
      public static function get instance() : ShipInitializationCommand
      {
         return _instance || (_instance = new ShipInitializationCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 49;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 142;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:VisualModifierCommand = null;
         this.userId = param1.readInt();
         this.userId = this.userId >>> 14 % 32 | this.userId << 32 - 14 % 32;
         this.userName = param1.readUTF();
         this.typeId = param1.readUTF();
         this.speed = param1.readInt();
         this.speed = this.speed << 12 % 32 | this.speed >>> 32 - 12 % 32;
         this.shield = param1.readInt();
         this.shield = this.shield << 14 % 32 | this.shield >>> 32 - 14 % 32;
         this.shieldMax = param1.readInt();
         this.shieldMax = this.shieldMax << 13 % 32 | this.shieldMax >>> 32 - 13 % 32;
         this.hitPoints = param1.readDouble();
         this.hitMax = param1.readDouble();
         this.cargoSpace = param1.readInt();
         this.cargoSpace = this.cargoSpace << 10 % 32 | this.cargoSpace >>> 32 - 10 % 32;
         this.cargoSpaceMax = param1.readInt();
         this.cargoSpaceMax = this.cargoSpaceMax >>> 14 % 32 | this.cargoSpaceMax << 32 - 14 % 32;
         this.nanoHull = param1.readInt();
         this.nanoHull = this.nanoHull >>> 11 % 32 | this.nanoHull << 32 - 11 % 32;
         this.maxNanoHull = param1.readInt();
         this.maxNanoHull = this.maxNanoHull >>> 15 % 32 | this.maxNanoHull << 32 - 15 % 32;
         this.x = param1.readInt();
         this.x = this.x >>> 14 % 32 | this.x << 32 - 14 % 32;
         this.y = param1.readInt();
         this.y = this.y >>> 4 % 32 | this.y << 32 - 4 % 32;
         this.mapId = param1.readInt();
         this.mapId = this.mapId << 11 % 32 | this.mapId >>> 32 - 11 % 32;
         this.factionId = param1.readInt();
         this.factionId = this.factionId << 5 % 32 | this.factionId >>> 32 - 5 % 32;
         this.clanId = param1.readInt();
         this.clanId = this.clanId >>> 3 % 32 | this.clanId << 32 - 3 % 32;
         this.expansionStage = param1.readInt();
         this.expansionStage = this.expansionStage >>> 5 % 32 | this.expansionStage << 32 - 5 % 32;
         this.premium = param1.readBoolean();
         this.ep = param1.readDouble();
         this.honourPoints = param1.readDouble();
         this.level = param1.readInt();
         this.level = this.level >>> 15 % 32 | this.level << 32 - 15 % 32;
         this.credits = param1.readDouble();
         this.uridium = param1.readDouble();
         this.jackpot = param1.readFloat();
         this.dailyRank = param1.readInt();
         this.dailyRank = this.dailyRank << 14 % 32 | this.dailyRank >>> 32 - 14 % 32;
         this.clanTag = param1.readUTF();
         this.galaxyGatesDone = param1.readInt();
         this.galaxyGatesDone = this.galaxyGatesDone << 5 % 32 | this.galaxyGatesDone >>> 32 - 5 % 32;
         this.useSystemFont = param1.readBoolean();
         this.cloaked = param1.readBoolean();
         this.refreshMap = param1.readBoolean();
         this.captainEnergy = param1.readInt();
         this.captainEnergy = this.captainEnergy << 9 % 32 | this.captainEnergy >>> 32 - 9 % 32;
         this.maxCaptainEnergy = param1.readInt();
         this.maxCaptainEnergy = this.maxCaptainEnergy << 1 % 32 | this.maxCaptainEnergy >>> 32 - 1 % 32;
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
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:VisualModifierCommand = null;
         param1.writeShort(49);
         param1.writeInt(this.userId << 14 % 32 | this.userId >>> 32 - 14 % 32);
         param1.writeUTF(this.userName);
         param1.writeUTF(this.typeId);
         param1.writeInt(this.speed >>> 12 % 32 | this.speed << 32 - 12 % 32);
         param1.writeInt(this.shield >>> 14 % 32 | this.shield << 32 - 14 % 32);
         param1.writeInt(this.shieldMax >>> 13 % 32 | this.shieldMax << 32 - 13 % 32);
         param1.writeDouble(this.hitPoints);
         param1.writeDouble(this.hitMax);
         param1.writeInt(this.cargoSpace >>> 10 % 32 | this.cargoSpace << 32 - 10 % 32);
         param1.writeInt(this.cargoSpaceMax << 14 % 32 | this.cargoSpaceMax >>> 32 - 14 % 32);
         param1.writeInt(this.nanoHull << 11 % 32 | this.nanoHull >>> 32 - 11 % 32);
         param1.writeInt(this.maxNanoHull << 15 % 32 | this.maxNanoHull >>> 32 - 15 % 32);
         param1.writeInt(this.x << 14 % 32 | this.x >>> 32 - 14 % 32);
         param1.writeInt(this.y << 4 % 32 | this.y >>> 32 - 4 % 32);
         param1.writeInt(this.mapId >>> 11 % 32 | this.mapId << 32 - 11 % 32);
         param1.writeInt(this.factionId >>> 5 % 32 | this.factionId << 32 - 5 % 32);
         param1.writeInt(this.clanId << 3 % 32 | this.clanId >>> 32 - 3 % 32);
         param1.writeInt(this.expansionStage << 5 % 32 | this.expansionStage >>> 32 - 5 % 32);
         param1.writeBoolean(this.premium);
         param1.writeDouble(this.ep);
         param1.writeDouble(this.honourPoints);
         param1.writeInt(this.level << 15 % 32 | this.level >>> 32 - 15 % 32);
         param1.writeDouble(this.credits);
         param1.writeDouble(this.uridium);
         param1.writeFloat(this.jackpot);
         param1.writeInt(this.dailyRank >>> 14 % 32 | this.dailyRank << 32 - 14 % 32);
         param1.writeUTF(this.clanTag);
         param1.writeInt(this.galaxyGatesDone >>> 5 % 32 | this.galaxyGatesDone << 32 - 5 % 32);
         param1.writeBoolean(this.useSystemFont);
         param1.writeBoolean(this.cloaked);
         param1.writeBoolean(this.refreshMap);
         param1.writeInt(this.captainEnergy >>> 9 % 32 | this.captainEnergy << 32 - 9 % 32);
         param1.writeInt(this.maxCaptainEnergy >>> 1 % 32 | this.maxCaptainEnergy << 32 - 1 % 32);
         param1.writeByte(this.modifier.length);
         for each(_loc2_ in this.modifier)
         {
            _loc2_.write(param1);
         }
      }
   }
}

