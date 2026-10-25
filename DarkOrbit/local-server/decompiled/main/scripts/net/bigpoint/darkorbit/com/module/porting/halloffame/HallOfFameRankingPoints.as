package net.bigpoint.darkorbit.com.module.porting.halloffame
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class HallOfFameRankingPoints implements IModule
   {
      
      private static var _instance:HallOfFameRankingPoints;
      
      public var honorPoints:Number = 0;
      
      public var belowRanking:int = 0;
      
      public var belowPoints:int = 0;
      
      public var missionsCompleted:int = 0;
      
      public var friendlyPlayersDestroyed:int = 0;
      
      public var ExperiencePoints:Number = 0;
      
      public var aboveRanking:int = 0;
      
      public var DestroyedByEnemies:int = 0;
      
      public var npcShotPoints:int = 0;
      
      public var DestroyedByRadiationZone:int = 0;
      
      public var yourRanking:int = 0;
      
      public var yourLevel:int = 0;
      
      public var daysSinceRegistration:int = 0;
      
      public var yourShipType:int = 0;
      
      public var rankPoints:Number = 0;
      
      public var playerShotPoints:int = 0;
      
      public var abovePoints:int = 0;
      
      public var shipsCategoryName:String = "";
      
      public var phoenixDestroyed:int = 0;
      
      public function HallOfFameRankingPoints(param1:Number = 0, param2:Number = 0, param3:Number = 0, param4:int = 0, param5:int = 0, param6:int = 0, param7:int = 0, param8:int = 0, param9:int = 0, param10:int = 0, param11:int = 0, param12:int = 0, param13:int = 0, param14:String = "", param15:int = 0, param16:int = 0, param17:int = 0, param18:int = 0, param19:int = 0)
      {
         super();
         this.honorPoints = param3;
         this.belowRanking = param17;
         this.belowPoints = param19;
         this.missionsCompleted = param9;
         this.friendlyPlayersDestroyed = param10;
         this.ExperiencePoints = param2;
         this.aboveRanking = param16;
         this.DestroyedByEnemies = param11;
         this.npcShotPoints = param8;
         this.DestroyedByRadiationZone = param12;
         this.yourRanking = param15;
         this.yourLevel = param5;
         this.daysSinceRegistration = param6;
         this.yourShipType = param7;
         this.rankPoints = param1;
         this.playerShotPoints = param4;
         this.abovePoints = param18;
         this.shipsCategoryName = param14;
         this.phoenixDestroyed = param13;
      }
      
      public static function get instance() : HallOfFameRankingPoints
      {
         return _instance || (_instance = new HallOfFameRankingPoints());
      }
      
      public function getLibcomModuleId() : int
      {
         return 31546;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 86;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.honorPoints = param1.readDouble();
         this.belowRanking = param1.readInt();
         this.belowRanking = this.belowRanking >>> 16 % 32 | this.belowRanking << 32 - 16 % 32;
         this.belowPoints = param1.readInt();
         this.belowPoints = this.belowPoints << 15 % 32 | this.belowPoints >>> 32 - 15 % 32;
         this.missionsCompleted = param1.readInt();
         this.missionsCompleted = this.missionsCompleted >>> 14 % 32 | this.missionsCompleted << 32 - 14 % 32;
         this.friendlyPlayersDestroyed = param1.readInt();
         this.friendlyPlayersDestroyed = this.friendlyPlayersDestroyed << 4 % 32 | this.friendlyPlayersDestroyed >>> 32 - 4 % 32;
         this.ExperiencePoints = param1.readDouble();
         this.aboveRanking = param1.readInt();
         this.aboveRanking = this.aboveRanking << 9 % 32 | this.aboveRanking >>> 32 - 9 % 32;
         this.DestroyedByEnemies = param1.readInt();
         this.DestroyedByEnemies = this.DestroyedByEnemies << 12 % 32 | this.DestroyedByEnemies >>> 32 - 12 % 32;
         this.npcShotPoints = param1.readInt();
         this.npcShotPoints = this.npcShotPoints << 1 % 32 | this.npcShotPoints >>> 32 - 1 % 32;
         this.DestroyedByRadiationZone = param1.readInt();
         this.DestroyedByRadiationZone = this.DestroyedByRadiationZone << 11 % 32 | this.DestroyedByRadiationZone >>> 32 - 11 % 32;
         this.yourRanking = param1.readInt();
         this.yourRanking = this.yourRanking >>> 2 % 32 | this.yourRanking << 32 - 2 % 32;
         this.yourLevel = param1.readInt();
         this.yourLevel = this.yourLevel >>> 13 % 32 | this.yourLevel << 32 - 13 % 32;
         this.daysSinceRegistration = param1.readInt();
         this.daysSinceRegistration = this.daysSinceRegistration >>> 9 % 32 | this.daysSinceRegistration << 32 - 9 % 32;
         this.yourShipType = param1.readInt();
         this.yourShipType = this.yourShipType << 6 % 32 | this.yourShipType >>> 32 - 6 % 32;
         this.rankPoints = param1.readDouble();
         this.playerShotPoints = param1.readInt();
         this.playerShotPoints = this.playerShotPoints << 14 % 32 | this.playerShotPoints >>> 32 - 14 % 32;
         this.abovePoints = param1.readInt();
         this.abovePoints = this.abovePoints << 3 % 32 | this.abovePoints >>> 32 - 3 % 32;
         this.shipsCategoryName = param1.readUTF();
         this.phoenixDestroyed = param1.readInt();
         this.phoenixDestroyed = this.phoenixDestroyed >>> 11 % 32 | this.phoenixDestroyed << 32 - 11 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(31546);
         param1.writeDouble(this.honorPoints);
         param1.writeInt(this.belowRanking << 16 % 32 | this.belowRanking >>> 32 - 16 % 32);
         param1.writeInt(this.belowPoints >>> 15 % 32 | this.belowPoints << 32 - 15 % 32);
         param1.writeInt(this.missionsCompleted << 14 % 32 | this.missionsCompleted >>> 32 - 14 % 32);
         param1.writeInt(this.friendlyPlayersDestroyed >>> 4 % 32 | this.friendlyPlayersDestroyed << 32 - 4 % 32);
         param1.writeDouble(this.ExperiencePoints);
         param1.writeInt(this.aboveRanking >>> 9 % 32 | this.aboveRanking << 32 - 9 % 32);
         param1.writeInt(this.DestroyedByEnemies >>> 12 % 32 | this.DestroyedByEnemies << 32 - 12 % 32);
         param1.writeInt(this.npcShotPoints >>> 1 % 32 | this.npcShotPoints << 32 - 1 % 32);
         param1.writeInt(this.DestroyedByRadiationZone >>> 11 % 32 | this.DestroyedByRadiationZone << 32 - 11 % 32);
         param1.writeInt(this.yourRanking << 2 % 32 | this.yourRanking >>> 32 - 2 % 32);
         param1.writeInt(this.yourLevel << 13 % 32 | this.yourLevel >>> 32 - 13 % 32);
         param1.writeInt(this.daysSinceRegistration << 9 % 32 | this.daysSinceRegistration >>> 32 - 9 % 32);
         param1.writeInt(this.yourShipType >>> 6 % 32 | this.yourShipType << 32 - 6 % 32);
         param1.writeDouble(this.rankPoints);
         param1.writeInt(this.playerShotPoints >>> 14 % 32 | this.playerShotPoints << 32 - 14 % 32);
         param1.writeInt(this.abovePoints >>> 3 % 32 | this.abovePoints << 32 - 3 % 32);
         param1.writeUTF(this.shipsCategoryName);
         param1.writeInt(this.phoenixDestroyed << 11 % 32 | this.phoenixDestroyed >>> 32 - 11 % 32);
      }
   }
}

