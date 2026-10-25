package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class GameplaySettingsModule implements IModule
   {
      
      private static var _instance:GameplaySettingsModule;
      
      public var notSet:Boolean = false;
      
      public var autoBoost:Boolean = false;
      
      public var autoRefinement:Boolean = false;
      
      public var quickslotStopAttack:Boolean = false;
      
      public var doubleclickAttack:Boolean = false;
      
      public var autoChangeAmmo:Boolean = false;
      
      public var autoStart:Boolean = false;
      
      public var autoBuyGreenBootyKeys:Boolean = false;
      
      public var showBattlerayNotifications:Boolean = false;
      
      public var showLowHealthWarning:Boolean = false;
      
      public function GameplaySettingsModule(param1:Boolean = false, param2:Boolean = false, param3:Boolean = false, param4:Boolean = false, param5:Boolean = false, param6:Boolean = false, param7:Boolean = false, param8:Boolean = false, param9:Boolean = false, param10:Boolean = false)
      {
         super();
         this.notSet = param1;
         this.autoBoost = param2;
         this.autoRefinement = param3;
         this.quickslotStopAttack = param4;
         this.doubleclickAttack = param5;
         this.autoChangeAmmo = param6;
         this.autoStart = param7;
         this.autoBuyGreenBootyKeys = param8;
         this.showBattlerayNotifications = param9;
         this.showLowHealthWarning = param10;
      }
      
      public static function get instance() : GameplaySettingsModule
      {
         return _instance || (_instance = new GameplaySettingsModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 273;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 10;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.notSet = param1.readBoolean();
         this.autoBoost = param1.readBoolean();
         this.autoRefinement = param1.readBoolean();
         this.quickslotStopAttack = param1.readBoolean();
         this.doubleclickAttack = param1.readBoolean();
         this.autoChangeAmmo = param1.readBoolean();
         this.autoStart = param1.readBoolean();
         this.autoBuyGreenBootyKeys = param1.readBoolean();
         this.showBattlerayNotifications = param1.readBoolean();
         this.showLowHealthWarning = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(273);
         param1.writeBoolean(this.notSet);
         param1.writeBoolean(this.autoBoost);
         param1.writeBoolean(this.autoRefinement);
         param1.writeBoolean(this.quickslotStopAttack);
         param1.writeBoolean(this.doubleclickAttack);
         param1.writeBoolean(this.autoChangeAmmo);
         param1.writeBoolean(this.autoStart);
         param1.writeBoolean(this.autoBuyGreenBootyKeys);
         param1.writeBoolean(this.showBattlerayNotifications);
         param1.writeBoolean(this.showLowHealthWarning);
      }
   }
}

