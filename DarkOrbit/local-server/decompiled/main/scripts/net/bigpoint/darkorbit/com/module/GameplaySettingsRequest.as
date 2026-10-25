package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class GameplaySettingsRequest implements IModule
   {
      
      private static var _instance:GameplaySettingsRequest;
      
      public var autoBoost:Boolean = false;
      
      public var autoRefinement:Boolean = false;
      
      public var quickslotStopAttack:Boolean = false;
      
      public var doubleclickAttack:Boolean = false;
      
      public var autoChangeAmmo:Boolean = false;
      
      public var autoStart:Boolean = false;
      
      public var autoBuyGreenBootyKeys:Boolean = false;
      
      public var showBattlerayNotifications:Boolean = false;
      
      public var showLowHealthWarning:Boolean = false;
      
      public function GameplaySettingsRequest(param1:Boolean = false, param2:Boolean = false, param3:Boolean = false, param4:Boolean = false, param5:Boolean = false, param6:Boolean = false, param7:Boolean = false, param8:Boolean = false, param9:Boolean = false)
      {
         super();
         this.autoBoost = param1;
         this.autoRefinement = param2;
         this.quickslotStopAttack = param3;
         this.doubleclickAttack = param4;
         this.autoChangeAmmo = param5;
         this.autoStart = param6;
         this.autoBuyGreenBootyKeys = param7;
         this.showBattlerayNotifications = param8;
         this.showLowHealthWarning = param9;
      }
      
      public static function get instance() : GameplaySettingsRequest
      {
         return _instance || (_instance = new GameplaySettingsRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 265;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 9;
      }
      
      public function read(param1:IDataInput) : void
      {
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
         param1.writeShort(265);
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

