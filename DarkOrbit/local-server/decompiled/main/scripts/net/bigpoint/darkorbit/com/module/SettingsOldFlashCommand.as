package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class SettingsOldFlashCommand implements IModule
   {
      
      private static var _instance:SettingsOldFlashCommand;
      
      public var autoBoost:Boolean = false;
      
      public var displayDamage:Boolean = false;
      
      public var displayAllLasers:Boolean = false;
      
      public var displayExplosions:Boolean = false;
      
      public var displayPlayerName:Boolean = false;
      
      public var displayFractionIcon:Boolean = false;
      
      public var displayAlphaBG:Boolean = false;
      
      public var ignoreResources:Boolean = false;
      
      public var ignoreCargoBoxes:Boolean = false;
      
      public var simpleGates:Boolean = false;
      
      public var simpleOpponents:Boolean = false;
      
      public var sound:Boolean = false;
      
      public var music:Boolean = false;
      
      public var displayMessages:Boolean = false;
      
      public var displayHitpointsBubbles:Boolean = false;
      
      public var displayDigits:Boolean = false;
      
      public var displayChat:Boolean = false;
      
      public var dsplyDrones:Boolean = false;
      
      public var showStarsystem:Boolean = false;
      
      public var ignoreCARGO:Boolean = false;
      
      public var ignoreHostileCARGO:Boolean = false;
      
      public var autochangeAmmo:Boolean = false;
      
      public var enableFastBuy:Boolean = false;
      
      public var selectedLaser:AmmunitionTypeModule;
      
      public var selectedRocket:AmmunitionTypeModule;
      
      public function SettingsOldFlashCommand(param1:Boolean = false, param2:Boolean = false, param3:Boolean = false, param4:Boolean = false, param5:Boolean = false, param6:Boolean = false, param7:Boolean = false, param8:Boolean = false, param9:Boolean = false, param10:Boolean = false, param11:Boolean = false, param12:Boolean = false, param13:Boolean = false, param14:Boolean = false, param15:Boolean = false, param16:Boolean = false, param17:Boolean = false, param18:Boolean = false, param19:Boolean = false, param20:Boolean = false, param21:Boolean = false, param22:Boolean = false, param23:Boolean = false, param24:AmmunitionTypeModule = null, param25:AmmunitionTypeModule = null)
      {
         super();
         this.autoBoost = param1;
         this.displayDamage = param2;
         this.displayAllLasers = param3;
         this.displayExplosions = param4;
         this.displayPlayerName = param5;
         this.displayFractionIcon = param6;
         this.displayAlphaBG = param7;
         this.ignoreResources = param8;
         this.ignoreCargoBoxes = param9;
         this.simpleGates = param10;
         this.simpleOpponents = param11;
         this.sound = param12;
         this.music = param13;
         this.displayMessages = param14;
         this.displayHitpointsBubbles = param15;
         this.displayDigits = param16;
         this.displayChat = param17;
         this.dsplyDrones = param18;
         this.showStarsystem = param19;
         this.ignoreCARGO = param20;
         this.ignoreHostileCARGO = param21;
         this.autochangeAmmo = param22;
         this.enableFastBuy = param23;
         if(param24 == null)
         {
            this.selectedLaser = new AmmunitionTypeModule();
         }
         else
         {
            this.selectedLaser = param24;
         }
         if(param25 == null)
         {
            this.selectedRocket = new AmmunitionTypeModule();
         }
         else
         {
            this.selectedRocket = param25;
         }
      }
      
      public static function get instance() : SettingsOldFlashCommand
      {
         return _instance || (_instance = new SettingsOldFlashCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 88;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 23;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.autoBoost = param1.readBoolean();
         this.displayDamage = param1.readBoolean();
         this.displayAllLasers = param1.readBoolean();
         this.displayExplosions = param1.readBoolean();
         this.displayPlayerName = param1.readBoolean();
         this.displayFractionIcon = param1.readBoolean();
         this.displayAlphaBG = param1.readBoolean();
         this.ignoreResources = param1.readBoolean();
         this.ignoreCargoBoxes = param1.readBoolean();
         this.simpleGates = param1.readBoolean();
         this.simpleOpponents = param1.readBoolean();
         this.sound = param1.readBoolean();
         this.music = param1.readBoolean();
         this.displayMessages = param1.readBoolean();
         this.displayHitpointsBubbles = param1.readBoolean();
         this.displayDigits = param1.readBoolean();
         this.displayChat = param1.readBoolean();
         this.dsplyDrones = param1.readBoolean();
         this.showStarsystem = param1.readBoolean();
         this.ignoreCARGO = param1.readBoolean();
         this.ignoreHostileCARGO = param1.readBoolean();
         this.autochangeAmmo = param1.readBoolean();
         this.enableFastBuy = param1.readBoolean();
         this.selectedLaser = AmmunitionTypeModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.selectedLaser)
         {
            this.selectedLaser.read(param1);
         }
         this.selectedRocket = AmmunitionTypeModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.selectedRocket)
         {
            this.selectedRocket.read(param1);
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(88);
         param1.writeBoolean(this.autoBoost);
         param1.writeBoolean(this.displayDamage);
         param1.writeBoolean(this.displayAllLasers);
         param1.writeBoolean(this.displayExplosions);
         param1.writeBoolean(this.displayPlayerName);
         param1.writeBoolean(this.displayFractionIcon);
         param1.writeBoolean(this.displayAlphaBG);
         param1.writeBoolean(this.ignoreResources);
         param1.writeBoolean(this.ignoreCargoBoxes);
         param1.writeBoolean(this.simpleGates);
         param1.writeBoolean(this.simpleOpponents);
         param1.writeBoolean(this.sound);
         param1.writeBoolean(this.music);
         param1.writeBoolean(this.displayMessages);
         param1.writeBoolean(this.displayHitpointsBubbles);
         param1.writeBoolean(this.displayDigits);
         param1.writeBoolean(this.displayChat);
         param1.writeBoolean(this.dsplyDrones);
         param1.writeBoolean(this.showStarsystem);
         param1.writeBoolean(this.ignoreCARGO);
         param1.writeBoolean(this.ignoreHostileCARGO);
         param1.writeBoolean(this.autochangeAmmo);
         param1.writeBoolean(this.enableFastBuy);
         if(null != this.selectedLaser)
         {
            this.selectedLaser.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         if(null != this.selectedRocket)
         {
            this.selectedRocket.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
      }
   }
}

