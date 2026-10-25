package net.bigpoint.darkorbit.net
{
   import com.bigpoint.utils.PointLite;
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.Main;
   import net.bigpoint.darkorbit.interfaces.IFrameObserver;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.model.Map;
   import net.bigpoint.darkorbit.map.model.effects.impl.combat.DamageEffect;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.net.netty.handlers.combat.AttackTypeMap;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class POIAssembly extends BaseAssembly implements IFrameObserver
   {
      
      private static var instance:POIAssembly;
      
      private var main:Main;
      
      private var delegateDict:Dictionary;
      
      private var shipID:int;
      
      private var damageTime:Number = 0;
      
      public function POIAssembly()
      {
         super();
         if(instance)
         {
            throw new Error("Singleton and can only access with POIAssembly.getInstance()");
         }
         this.main = _main;
         this.initDelegateDict();
      }
      
      public static function getInstance() : POIAssembly
      {
         if(instance == null)
         {
            instance = new POIAssembly();
         }
         return instance;
      }
      
      private function initDelegateDict() : void
      {
         this.delegateDict = new Dictionary();
         this.delegateDict[ServerCommands.POI_CREATE] = this.assembleCreatePOI;
         this.delegateDict[ServerCommands.POI_READY] = this.assemblePOIReady;
         this.delegateDict[ServerCommands.POI_REMOVE] = this.assembleRemovePOI;
         this.delegateDict[ServerCommands.POI_ENTER] = this.assembleEnterPOI;
         this.delegateDict[ServerCommands.POI_LEAVE] = this.assembleLeavePOI;
      }
      
      public function assembleCommand(param1:Array) : void
      {
         var _loc2_:String = param1[2];
         if(this.delegateDict[_loc2_] != null)
         {
            this.delegateDict[_loc2_](param1);
         }
      }
      
      public function assembleCreatePOI(param1:String, param2:String, param3:String, param4:int, param5:Boolean, param6:Boolean, param7:String, param8:Vector.<PointLite>, param9:Number = NaN) : void
      {
         if(this.map != null)
         {
            this.map.poiManager.addZone(param1,param2,param3,param4,param7,param5,param6,param8,param9);
         }
      }
      
      public function assembleRemovePOI(param1:String) : void
      {
         if(this.map != null)
         {
            this.map.poiManager.removeZone(param1);
         }
      }
      
      public function assemblePOIReady() : void
      {
         if(this.map != null)
         {
            this.map.poiManager.ready.dispatch();
         }
      }
      
      private function assembleEnterPOI(param1:Array) : void
      {
         if(param1[3] == ServerCommands.POI_DAMAGE)
         {
            this.shipID = param1[4];
            ScreenManager.addObserver(this);
         }
      }
      
      private function assembleLeavePOI(param1:Array) : void
      {
         if(param1[3] == ServerCommands.POI_DAMAGE)
         {
            this.shipID = param1[4];
            ScreenManager.removeObserver(this);
         }
      }
      
      public function updateTimer(param1:Number) : void
      {
         var _loc2_:Ship = null;
         this.damageTime += param1;
         if(this.damageTime > 1999)
         {
            if(Settings.qualityExplosion.value == Settings.QUALITY_HIGH && Settings.autoQualityReduction.value < Settings.AQ_LOW_EXPLOSION_DETAIL_LIMIT && Settings.autoQualityReduction.value < Settings.AQ_NO_EXPLOSION_LIMIT)
            {
               _loc2_ = ScreenManager.getInstance().map.getShipManager().getShip(this.shipID);
               this.map.effects.playEffect(new DamageEffect(_loc2_,AttackTypeMap.LASER));
            }
            this.damageTime = 0;
         }
      }
      
      public function cleanupShieldDamage() : void
      {
         ScreenManager.removeObserver(this);
      }
      
      private function get map() : Map
      {
         return ScreenManager.getInstance().map;
      }
   }
}

