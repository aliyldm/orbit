package net.bigpoint.darkorbit.net
{
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.Main;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.com.module.AmmunitionTypeModule;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.impl.combat.AirstrikeEffect;
   import net.bigpoint.darkorbit.pattern.RocketPattern;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class RocketLauncherAssembly extends BaseAssembly
   {
      
      private static var instance:RocketLauncherAssembly;
      
      public var ammunitionTypeToRocketType:Dictionary;
      
      private var delegateDict:Dictionary;
      
      private var main:Main;
      
      public function RocketLauncherAssembly(param1:Function)
      {
         super();
         if(param1 !== hidden)
         {
            throw new Error("RocketLauncherAssembly is a Singleton and can only be accessed through RocketLauncherAssembly.getInstance()");
         }
         this.main = _main;
         this.initDelegateDict();
         this.initRocketTypeDict();
      }
      
      public static function getInstance() : RocketLauncherAssembly
      {
         if(instance == null)
         {
            instance = new RocketLauncherAssembly(hidden);
         }
         return instance;
      }
      
      private static function hidden() : void
      {
      }
      
      private function initDelegateDict() : void
      {
         this.delegateDict = new Dictionary();
         this.delegateDict[ServerCommands.ROCKETLAUNCHER_STATUS] = this.assembleSetStatusCommand;
         this.delegateDict[ServerCommands.ROCKETLAUNCHER_STATUS_LOWER] = this.assembleSetStatusCommand;
         this.delegateDict[ServerCommands.ROCKETLAUNCHER_ATTACK] = this.assembleRocketLauncherAttackCommand;
         this.delegateDict[ServerCommands.ROCKETLAUNCHER_ATTACK_LOWER] = this.assembleRocketLauncherAttackCommand;
      }
      
      private function initRocketTypeDict() : void
      {
         this.ammunitionTypeToRocketType = new Dictionary();
         this.ammunitionTypeToRocketType[AmmunitionTypeModule.AMMUNITIONTYPE_HELLSTORM] = RocketPattern.HSTRM01;
         this.ammunitionTypeToRocketType[AmmunitionTypeModule.AMMUNITIONTYPE_UBER_ROCKET] = RocketPattern.UBR100;
         this.ammunitionTypeToRocketType[AmmunitionTypeModule.AMMUNITIONTYPE_ECO_ROCKET] = RocketPattern.ECO10;
         this.ammunitionTypeToRocketType[AmmunitionTypeModule.AMMUNITIONTYPE_SAR01] = RocketPattern.SAR_01;
         this.ammunitionTypeToRocketType[AmmunitionTypeModule.AMMUNITIONTYPE_SAR02] = RocketPattern.SAR_02;
         this.ammunitionTypeToRocketType[AmmunitionTypeModule.AMMUNITIONTYPE_CBR] = RocketPattern.CBR;
         this.ammunitionTypeToRocketType[AmmunitionTypeModule.AMMUNITIONTYPE_BDR1212] = RocketPattern.BDR_1212;
         this.ammunitionTypeToRocketType[AmmunitionTypeModule.AMMUNITIONTYPE_PIR_100] = RocketPattern.PIR_100;
         this.ammunitionTypeToRocketType[AmmunitionTypeModule.AMMUNITIONTYPE_OBR_100] = RocketPattern.OBR_100;
      }
      
      public function assembleCommand(param1:Array) : void
      {
         var _loc2_:String = param1[2];
         if(this.delegateDict[_loc2_] != null)
         {
            this.delegateDict[_loc2_](param1);
         }
      }
      
      public function assembleRocketLauncherAttackCommand(param1:Array) : void
      {
         var _loc7_:MapEntity = null;
         var _loc8_:MapEntity = null;
         var _loc2_:int = int(param1[3]);
         var _loc3_:int = int(param1[4]);
         var _loc4_:int = int(param1[5]);
         var _loc5_:int = int(param1[6]);
         var _loc6_:Boolean = false;
         if(param1[7] == "M")
         {
            _loc6_ = true;
         }
         if(_main.screenManager.map != null)
         {
            _loc7_ = map.getEntityById(_loc2_);
            _loc8_ = map.getEntityById(_loc3_);
            if(Boolean(_loc7_) && Boolean(_loc8_))
            {
               _main.screenManager.map.effects.addEffect(new AirstrikeEffect(_loc7_,_loc8_,_loc5_,_loc4_,_loc6_));
            }
         }
      }
      
      private function setRocketLauncherStatus(param1:Vector.<int>, param2:int, param3:int) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         Settings.rocketLauncherTypes = param1;
         Settings.selectedLauncherRocket = param2;
         Settings.rocketLauncherRocketsLoaded = param3;
         if(Settings.rocketLauncherTypes.length == 0 || Settings.rocketLauncherTypes[0] == 0)
         {
            Settings.rocketLauncherRocketsLoaded = 0;
         }
         else
         {
            _loc4_ = 0;
            for each(_loc5_ in Settings.rocketLauncherTypes)
            {
               if(_loc5_ == 1)
               {
                  _loc4_ += 3;
               }
               else if(_loc5_ == 2)
               {
                  _loc4_ += 5;
               }
            }
            if(Settings.rocketLauncherRocketsLoaded == 1 && Settings.rocketLauncherRocketsLoaded < _loc4_)
            {
               AudioManager.playSoundEffect(InGameCatalog.SOUND_ID_ROCKETS_LOAD_START);
            }
            else if(Settings.rocketLauncherRocketsLoaded > 0 && Settings.rocketLauncherRocketsLoaded < _loc4_)
            {
               AudioManager.playSoundEffect(InGameCatalog.SOUND_ID_ROCKET_LOAD);
            }
            else if(Settings.rocketLauncherRocketsLoaded == _loc4_)
            {
               AudioManager.playSoundEffect(InGameCatalog.SOUND_ID_ROCKETS_LOADED);
            }
         }
      }
      
      public function assembleSetStatusCommand(param1:Array) : void
      {
         var _loc2_:Vector.<int> = new Vector.<int>();
         _loc2_.push(int(param1[3]));
         this.setRocketLauncherStatus(_loc2_,int(param1[4]),int(param1[5]));
      }
   }
}

