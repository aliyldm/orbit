package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class TrainingGroundFightInfoCommand implements IModule
   {
      
      private static var _instance:TrainingGroundFightInfoCommand;
      
      public var playerShield:int = 0;
      
      public var playerVictoryPoint:int = 0;
      
      public var opponentShieldMax:int = 0;
      
      public var opponentHitpoints:int = 0;
      
      public var opponentShield:int = 0;
      
      public var opponentVictoryPoint:int = 0;
      
      public var playerHitpointsMax:int = 0;
      
      public var playerShieldMax:int = 0;
      
      public var playerHitpoints:int = 0;
      
      public var opponentHitpointsMax:int = 0;
      
      public function TrainingGroundFightInfoCommand(param1:int = 0, param2:int = 0, param3:int = 0, param4:int = 0, param5:int = 0, param6:int = 0, param7:int = 0, param8:int = 0, param9:int = 0, param10:int = 0)
      {
         super();
         this.playerShield = param8;
         this.playerVictoryPoint = param10;
         this.opponentShieldMax = param4;
         this.opponentHitpoints = param1;
         this.opponentShield = param3;
         this.opponentVictoryPoint = param5;
         this.playerHitpointsMax = param7;
         this.playerShieldMax = param9;
         this.playerHitpoints = param6;
         this.opponentHitpointsMax = param2;
      }
      
      public static function get instance() : TrainingGroundFightInfoCommand
      {
         return _instance || (_instance = new TrainingGroundFightInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -13847;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 40;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.playerShield = param1.readInt();
         this.playerShield = this.playerShield << 16 % 32 | this.playerShield >>> 32 - 16 % 32;
         this.playerVictoryPoint = param1.readInt();
         this.playerVictoryPoint = this.playerVictoryPoint << 9 % 32 | this.playerVictoryPoint >>> 32 - 9 % 32;
         this.opponentShieldMax = param1.readInt();
         this.opponentShieldMax = this.opponentShieldMax >>> 11 % 32 | this.opponentShieldMax << 32 - 11 % 32;
         this.opponentHitpoints = param1.readInt();
         this.opponentHitpoints = this.opponentHitpoints << 1 % 32 | this.opponentHitpoints >>> 32 - 1 % 32;
         this.opponentShield = param1.readInt();
         this.opponentShield = this.opponentShield >>> 12 % 32 | this.opponentShield << 32 - 12 % 32;
         this.opponentVictoryPoint = param1.readInt();
         this.opponentVictoryPoint = this.opponentVictoryPoint << 7 % 32 | this.opponentVictoryPoint >>> 32 - 7 % 32;
         this.playerHitpointsMax = param1.readInt();
         this.playerHitpointsMax = this.playerHitpointsMax >>> 10 % 32 | this.playerHitpointsMax << 32 - 10 % 32;
         this.playerShieldMax = param1.readInt();
         this.playerShieldMax = this.playerShieldMax >>> 4 % 32 | this.playerShieldMax << 32 - 4 % 32;
         this.playerHitpoints = param1.readInt();
         this.playerHitpoints = this.playerHitpoints >>> 13 % 32 | this.playerHitpoints << 32 - 13 % 32;
         this.opponentHitpointsMax = param1.readInt();
         this.opponentHitpointsMax = this.opponentHitpointsMax >>> 13 % 32 | this.opponentHitpointsMax << 32 - 13 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-13847);
         param1.writeInt(this.playerShield >>> 16 % 32 | this.playerShield << 32 - 16 % 32);
         param1.writeInt(this.playerVictoryPoint >>> 9 % 32 | this.playerVictoryPoint << 32 - 9 % 32);
         param1.writeInt(this.opponentShieldMax << 11 % 32 | this.opponentShieldMax >>> 32 - 11 % 32);
         param1.writeInt(this.opponentHitpoints >>> 1 % 32 | this.opponentHitpoints << 32 - 1 % 32);
         param1.writeInt(this.opponentShield << 12 % 32 | this.opponentShield >>> 32 - 12 % 32);
         param1.writeInt(this.opponentVictoryPoint >>> 7 % 32 | this.opponentVictoryPoint << 32 - 7 % 32);
         param1.writeInt(this.playerHitpointsMax << 10 % 32 | this.playerHitpointsMax >>> 32 - 10 % 32);
         param1.writeInt(this.playerShieldMax << 4 % 32 | this.playerShieldMax >>> 32 - 4 % 32);
         param1.writeInt(this.playerHitpoints << 13 % 32 | this.playerHitpoints >>> 32 - 13 % 32);
         param1.writeInt(this.opponentHitpointsMax << 13 % 32 | this.opponentHitpointsMax >>> 32 - 13 % 32);
      }
   }
}

