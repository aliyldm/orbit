package net.bigpoint.darkorbit.net
{
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.Main;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.impl.ChargingBlobEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.TechShieldBackupEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.VoltageLinkEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.combat.ChainBoltEffect;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   
   public class TechAssembly extends BaseAssembly
   {
      
      private static var instance:TechAssembly;
      
      private var delegateDict:Dictionary;
      
      private var main:Main;
      
      public function TechAssembly(param1:Function)
      {
         super();
         if(param1 !== hidden)
         {
            throw new Error("TechAssembly is a Singleton and can only be accessed through TechAssembly.getInstance()");
         }
         this.main = _main;
         this.initDelegateDict();
      }
      
      public static function getInstance() : TechAssembly
      {
         if(instance == null)
         {
            instance = new TechAssembly(hidden);
         }
         return instance;
      }
      
      private static function hidden() : void
      {
      }
      
      private function initDelegateDict() : void
      {
         this.delegateDict = new Dictionary();
         this.delegateDict[ServerCommands.CHAIN_BOLT] = this.assembleChainBoltCommand;
         this.delegateDict[ServerCommands.TECHS_ACTIVATE] = this.assembleActivateCommand;
         this.delegateDict[ServerCommands.EXPLOSIVE_CHARGING_BLOB] = this.assembleExplosiveChargingBlobCommand;
      }
      
      public function assembleCommand(param1:Array) : void
      {
         var _loc2_:String = param1[2];
         if(this.delegateDict[_loc2_] != null)
         {
            this.delegateDict[_loc2_](param1);
         }
      }
      
      public function assembleSubCommand(param1:Array) : void
      {
         var _loc2_:String = param1[3];
         if(this.delegateDict[_loc2_] != null)
         {
            this.delegateDict[_loc2_](param1);
         }
      }
      
      private function assembleChainBoltCommand(param1:Array) : void
      {
         var _loc6_:MapEntity = null;
         var _loc2_:int = int(param1[3]);
         var _loc3_:int = int(param1[4]);
         var _loc4_:Array = [int(param1[5])];
         var _loc5_:int = 6;
         while(_loc5_ < param1.length)
         {
            if(param1[_loc5_] != undefined)
            {
               _loc4_.push(int(param1[_loc5_]));
            }
            _loc5_++;
         }
         if(map != null)
         {
            _loc6_ = map.getShipManager().getShip(_loc3_);
            switch(_loc2_)
            {
               case 1:
                  map.effects.playEffect(new ChainBoltEffect(_loc6_,_loc4_));
                  break;
               case 2:
                  map.effects.playEffect(new VoltageLinkEffect(_loc6_,_loc4_));
                  break;
               default:
                  map.effects.playEffect(new ChainBoltEffect(_loc6_,_loc4_));
            }
         }
      }
      
      private function assembleActivateCommand(param1:Array) : void
      {
         var _loc2_:String = param1[4];
         var _loc3_:int = int(param1[5]);
         var _loc4_:Ship = map.getShipManager().getShip(_loc3_);
         if(_loc4_ == null)
         {
            return;
         }
         switch(_loc2_)
         {
            case ServerCommands.TECH_SHIELD_BACK_UP:
               map.effects.addMapObjectEffectOnce(new TechShieldBackupEffect(_loc4_,EffectIDList.TECH_SHIELD_BACKUP_EFFECT));
               break;
            case ServerCommands.TECH_SHIELD_BACK_UP_2:
               map.effects.addMapObjectEffectOnce(new TechShieldBackupEffect(_loc4_,EffectIDList.TECH_SHIELD_BACKUP_EFFECT_2));
         }
      }
      
      private function assembleExplosiveChargingBlobCommand(param1:Array) : void
      {
         var _loc4_:MapEntity = null;
         var _loc5_:MapEntity = null;
         var _loc2_:int = int(param1[4]);
         var _loc3_:int = int(param1[5]);
         if(map != null)
         {
            _loc4_ = map.getShipManager().getShip(_loc2_);
            _loc5_ = map.getShipManager().getShip(_loc3_);
            map.effects.addEffect(new ChargingBlobEffect(_loc4_,_loc5_));
         }
      }
   }
}

