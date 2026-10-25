package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class QualitySettingsModule implements IModule
   {
      
      private static var _instance:QualitySettingsModule;
      
      public var notSet:Boolean = false;
      
      public var qualityAttack:int = 0;
      
      public var qualityBackground:int = 0;
      
      public var qualityPresetting:int = 0;
      
      public var qualityCustomized:Boolean = false;
      
      public var qualityPOIzone:int = 0;
      
      public var qualityShip:int = 0;
      
      public var qualityEngine:int = 0;
      
      public var qualityExplosion:int = 0;
      
      public var qualityCollectables:int = 0;
      
      public var qualityEffect:int = 0;
      
      public function QualitySettingsModule(param1:Boolean = false, param2:int = 0, param3:int = 0, param4:int = 0, param5:Boolean = false, param6:int = 0, param7:int = 0, param8:int = 0, param9:int = 0, param10:int = 0, param11:int = 0)
      {
         super();
         this.notSet = param1;
         this.qualityAttack = param2;
         this.qualityBackground = param3;
         this.qualityPresetting = param4;
         this.qualityCustomized = param5;
         this.qualityPOIzone = param6;
         this.qualityShip = param7;
         this.qualityEngine = param8;
         this.qualityExplosion = param9;
         this.qualityCollectables = param10;
         this.qualityEffect = param11;
      }
      
      public static function get instance() : QualitySettingsModule
      {
         return _instance || (_instance = new QualitySettingsModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 269;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 20;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.notSet = param1.readBoolean();
         this.qualityAttack = param1.readShort();
         this.qualityAttack = 0xFFFF & ((0xFFFF & this.qualityAttack) << 13 % 16 | (0xFFFF & this.qualityAttack) >>> 16 - 13 % 16);
         this.qualityAttack = this.qualityAttack > 32767 ? int(this.qualityAttack - 65536) : this.qualityAttack;
         this.qualityBackground = param1.readShort();
         this.qualityBackground = 0xFFFF & ((0xFFFF & this.qualityBackground) >>> 13 % 16 | (0xFFFF & this.qualityBackground) << 16 - 13 % 16);
         this.qualityBackground = this.qualityBackground > 32767 ? int(this.qualityBackground - 65536) : this.qualityBackground;
         this.qualityPresetting = param1.readShort();
         this.qualityPresetting = 0xFFFF & ((0xFFFF & this.qualityPresetting) << 10 % 16 | (0xFFFF & this.qualityPresetting) >>> 16 - 10 % 16);
         this.qualityPresetting = this.qualityPresetting > 32767 ? int(this.qualityPresetting - 65536) : this.qualityPresetting;
         this.qualityCustomized = param1.readBoolean();
         this.qualityPOIzone = param1.readShort();
         this.qualityPOIzone = 0xFFFF & ((0xFFFF & this.qualityPOIzone) >>> 5 % 16 | (0xFFFF & this.qualityPOIzone) << 16 - 5 % 16);
         this.qualityPOIzone = this.qualityPOIzone > 32767 ? int(this.qualityPOIzone - 65536) : this.qualityPOIzone;
         this.qualityShip = param1.readShort();
         this.qualityShip = 0xFFFF & ((0xFFFF & this.qualityShip) << 11 % 16 | (0xFFFF & this.qualityShip) >>> 16 - 11 % 16);
         this.qualityShip = this.qualityShip > 32767 ? int(this.qualityShip - 65536) : this.qualityShip;
         this.qualityEngine = param1.readShort();
         this.qualityEngine = 0xFFFF & ((0xFFFF & this.qualityEngine) << 13 % 16 | (0xFFFF & this.qualityEngine) >>> 16 - 13 % 16);
         this.qualityEngine = this.qualityEngine > 32767 ? int(this.qualityEngine - 65536) : this.qualityEngine;
         this.qualityExplosion = param1.readShort();
         this.qualityExplosion = 0xFFFF & ((0xFFFF & this.qualityExplosion) << 10 % 16 | (0xFFFF & this.qualityExplosion) >>> 16 - 10 % 16);
         this.qualityExplosion = this.qualityExplosion > 32767 ? int(this.qualityExplosion - 65536) : this.qualityExplosion;
         this.qualityCollectables = param1.readShort();
         this.qualityCollectables = 0xFFFF & ((0xFFFF & this.qualityCollectables) << 1 % 16 | (0xFFFF & this.qualityCollectables) >>> 16 - 1 % 16);
         this.qualityCollectables = this.qualityCollectables > 32767 ? int(this.qualityCollectables - 65536) : this.qualityCollectables;
         this.qualityEffect = param1.readShort();
         this.qualityEffect = 0xFFFF & ((0xFFFF & this.qualityEffect) << 10 % 16 | (0xFFFF & this.qualityEffect) >>> 16 - 10 % 16);
         this.qualityEffect = this.qualityEffect > 32767 ? int(this.qualityEffect - 65536) : this.qualityEffect;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(269);
         param1.writeBoolean(this.notSet);
         param1.writeShort(0xFFFF & ((0xFFFF & this.qualityAttack) >>> 13 % 16 | (0xFFFF & this.qualityAttack) << 16 - 13 % 16));
         param1.writeShort(0xFFFF & ((0xFFFF & this.qualityBackground) << 13 % 16 | (0xFFFF & this.qualityBackground) >>> 16 - 13 % 16));
         param1.writeShort(0xFFFF & ((0xFFFF & this.qualityPresetting) >>> 10 % 16 | (0xFFFF & this.qualityPresetting) << 16 - 10 % 16));
         param1.writeBoolean(this.qualityCustomized);
         param1.writeShort(0xFFFF & ((0xFFFF & this.qualityPOIzone) << 5 % 16 | (0xFFFF & this.qualityPOIzone) >>> 16 - 5 % 16));
         param1.writeShort(0xFFFF & ((0xFFFF & this.qualityShip) >>> 11 % 16 | (0xFFFF & this.qualityShip) << 16 - 11 % 16));
         param1.writeShort(0xFFFF & ((0xFFFF & this.qualityEngine) >>> 13 % 16 | (0xFFFF & this.qualityEngine) << 16 - 13 % 16));
         param1.writeShort(0xFFFF & ((0xFFFF & this.qualityExplosion) >>> 10 % 16 | (0xFFFF & this.qualityExplosion) << 16 - 10 % 16));
         param1.writeShort(0xFFFF & ((0xFFFF & this.qualityCollectables) >>> 1 % 16 | (0xFFFF & this.qualityCollectables) << 16 - 1 % 16));
         param1.writeShort(0xFFFF & ((0xFFFF & this.qualityEffect) >>> 10 % 16 | (0xFFFF & this.qualityEffect) << 16 - 10 % 16));
      }
   }
}

