package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ExtraInfoCommand implements IModule
   {
      
      private static var _instance:ExtraInfoCommand;
      
      public var droneCPU:int = 0;
      
      public var diploCPU:int = 0;
      
      public var jumpCPU:int = 0;
      
      public var ammoCPU:int = 0;
      
      public var smartBomb:int = 0;
      
      public var instaShield:int = 0;
      
      public var mineTurbo:int = 0;
      
      public var aimCPU:int = 0;
      
      public var arolCPU:int = 0;
      
      public var cloakCPU:int = 0;
      
      public var autoRlCPU:int = 0;
      
      public var rocketBuyCPU:int = 0;
      
      public var specialJumpCPU:int = 0;
      
      public function ExtraInfoCommand(param1:int = 0, param2:int = 0, param3:int = 0, param4:int = 0, param5:int = 0, param6:int = 0, param7:int = 0, param8:int = 0, param9:int = 0, param10:int = 0, param11:int = 0, param12:int = 0, param13:int = 0)
      {
         super();
         this.droneCPU = param1;
         this.diploCPU = param2;
         this.jumpCPU = param3;
         this.ammoCPU = param4;
         this.smartBomb = param5;
         this.instaShield = param6;
         this.mineTurbo = param7;
         this.aimCPU = param8;
         this.arolCPU = param9;
         this.cloakCPU = param10;
         this.autoRlCPU = param11;
         this.rocketBuyCPU = param12;
         this.specialJumpCPU = param13;
      }
      
      public static function get instance() : ExtraInfoCommand
      {
         return _instance || (_instance = new ExtraInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 56;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 52;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.droneCPU = param1.readInt();
         this.droneCPU = this.droneCPU << 13 % 32 | this.droneCPU >>> 32 - 13 % 32;
         this.diploCPU = param1.readInt();
         this.diploCPU = this.diploCPU << 11 % 32 | this.diploCPU >>> 32 - 11 % 32;
         this.jumpCPU = param1.readInt();
         this.jumpCPU = this.jumpCPU << 6 % 32 | this.jumpCPU >>> 32 - 6 % 32;
         this.ammoCPU = param1.readInt();
         this.ammoCPU = this.ammoCPU >>> 11 % 32 | this.ammoCPU << 32 - 11 % 32;
         this.smartBomb = param1.readInt();
         this.smartBomb = this.smartBomb >>> 10 % 32 | this.smartBomb << 32 - 10 % 32;
         this.instaShield = param1.readInt();
         this.instaShield = this.instaShield << 2 % 32 | this.instaShield >>> 32 - 2 % 32;
         this.mineTurbo = param1.readInt();
         this.mineTurbo = this.mineTurbo << 16 % 32 | this.mineTurbo >>> 32 - 16 % 32;
         this.aimCPU = param1.readInt();
         this.aimCPU = this.aimCPU << 3 % 32 | this.aimCPU >>> 32 - 3 % 32;
         this.arolCPU = param1.readInt();
         this.arolCPU = this.arolCPU >>> 8 % 32 | this.arolCPU << 32 - 8 % 32;
         this.cloakCPU = param1.readInt();
         this.cloakCPU = this.cloakCPU << 11 % 32 | this.cloakCPU >>> 32 - 11 % 32;
         this.autoRlCPU = param1.readInt();
         this.autoRlCPU = this.autoRlCPU << 16 % 32 | this.autoRlCPU >>> 32 - 16 % 32;
         this.rocketBuyCPU = param1.readInt();
         this.rocketBuyCPU = this.rocketBuyCPU >>> 1 % 32 | this.rocketBuyCPU << 32 - 1 % 32;
         this.specialJumpCPU = param1.readInt();
         this.specialJumpCPU = this.specialJumpCPU << 4 % 32 | this.specialJumpCPU >>> 32 - 4 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(56);
         param1.writeInt(this.droneCPU >>> 13 % 32 | this.droneCPU << 32 - 13 % 32);
         param1.writeInt(this.diploCPU >>> 11 % 32 | this.diploCPU << 32 - 11 % 32);
         param1.writeInt(this.jumpCPU >>> 6 % 32 | this.jumpCPU << 32 - 6 % 32);
         param1.writeInt(this.ammoCPU << 11 % 32 | this.ammoCPU >>> 32 - 11 % 32);
         param1.writeInt(this.smartBomb << 10 % 32 | this.smartBomb >>> 32 - 10 % 32);
         param1.writeInt(this.instaShield >>> 2 % 32 | this.instaShield << 32 - 2 % 32);
         param1.writeInt(this.mineTurbo >>> 16 % 32 | this.mineTurbo << 32 - 16 % 32);
         param1.writeInt(this.aimCPU >>> 3 % 32 | this.aimCPU << 32 - 3 % 32);
         param1.writeInt(this.arolCPU << 8 % 32 | this.arolCPU >>> 32 - 8 % 32);
         param1.writeInt(this.cloakCPU >>> 11 % 32 | this.cloakCPU << 32 - 11 % 32);
         param1.writeInt(this.autoRlCPU >>> 16 % 32 | this.autoRlCPU << 32 - 16 % 32);
         param1.writeInt(this.rocketBuyCPU << 1 % 32 | this.rocketBuyCPU >>> 32 - 1 % 32);
         param1.writeInt(this.specialJumpCPU >>> 4 % 32 | this.specialJumpCPU << 32 - 4 % 32);
      }
   }
}

