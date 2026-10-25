package net.bigpoint.darkorbit.mvc.battleStation
{
   import com.bigpoint.utils.PointLite;
   import net.bigpoint.darkorbit.com.module.AssetCreateCommand;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.minimap.traits.MiniMapDotTrait;
   import net.bigpoint.darkorbit.map.model.traits.AttackTargetTrait;
   import net.bigpoint.darkorbit.map.model.traits.UberDisplayTrait;
   import net.bigpoint.darkorbit.map.model.traits.hud.MapObjectInfoTrait;
   import net.bigpoint.darkorbit.mvc.common.model.assets.UberAssetsLib;
   
   public class BattleStationModule extends MapEntity
   {
      
      public static const WRECK:int = 0;
      
      public static const HULL:int = 1;
      
      public static const DEFLECTOR:int = 2;
      
      public static const REPAIR:int = 3;
      
      public static const LASER_HIGH_RANGE:int = 6;
      
      public static const LASER_MID_RANGE:int = 5;
      
      public static const LASER_LOW_RANGE:int = 4;
      
      public static const ROCKET_LOW_ACCURACY:int = 7;
      
      public static const ROCKET_MID_ACCURACY:int = 8;
      
      public static const HONOR_BOOSTER:int = 9;
      
      public static const DAMAGE_BOOSTER:int = 10;
      
      public static const EXPERIENCE_BOOSTER:int = 11;
      
      private static const TRAIT_SETS:Object = {};
      
      TRAIT_SETS[WRECK] = "wreck";
      TRAIT_SETS[REPAIR] = "module_rep";
      TRAIT_SETS[LASER_HIGH_RANGE] = "module_laserhigh";
      TRAIT_SETS[LASER_MID_RANGE] = "module_lasermid";
      TRAIT_SETS[LASER_LOW_RANGE] = "module_laserlow";
      TRAIT_SETS[ROCKET_LOW_ACCURACY] = "module_rocketlow";
      TRAIT_SETS[ROCKET_MID_ACCURACY] = "module_rocketmid";
      TRAIT_SETS[HONOR_BOOSTER] = "module_hon";
      TRAIT_SETS[DAMAGE_BOOSTER] = "module_dama";
      TRAIT_SETS[EXPERIENCE_BOOSTER] = "module_xp";
      
      private var _assetId:String;
      
      private var _info:MapObjectInfoTrait;
      
      public function BattleStationModule(param1:AssetCreateCommand)
      {
         super(param1.assetId,new PointLite(param1.posX,param1.posY,-200));
         this._info = new MapObjectInfoTrait();
         this._info.username.value = param1.userName;
         this._info.clanTag.value = param1.clanTag;
         this._info.clanID.value = param1.clanId;
         this._info.factionID.value = param1.factionId;
         this._info.clanDiplomacy.value = param1.clanRelation.type;
         this.update(param1.designId,param1.expansionStage);
      }
      
      public function update(param1:int, param2:int) : void
      {
         var _loc4_:String = null;
         var _loc3_:String = TRAIT_SETS[param1];
         if(_loc3_)
         {
         }
         if(param1 != WRECK)
         {
            _loc4_ = _loc3_ + "" + Math.min(3,int(param2 / 5 + 1));
         }
         else
         {
            _loc4_ = _loc3_;
         }
         if(_loc4_ != this._assetId)
         {
            this._assetId = _loc4_;
            this.updateTraits(this,_loc4_,UberAssetsLib.LIB_BATTLE_STATION);
            if(param1 != WRECK)
            {
               addTrait(this._info);
            }
            else
            {
               removeTrait(this._info);
            }
         }
      }
      
      private function updateTraits(param1:MapEntity, param2:String, param3:String) : void
      {
         var _loc6_:UberDisplayTrait = null;
         var _loc7_:uint = 0;
         if(param1.getFirstTrait(UberDisplayTrait) == null)
         {
            UberAssetsLib.instance.fillTraits(param1,param2,param3);
         }
         else
         {
            param1.removeTraitByType(UberDisplayTrait);
            _loc6_ = UberDisplayTrait.fromXML(UberAssetsLib.instance.getDescriptor(param2,param3),false);
            if(_loc6_)
            {
               param1.addTrait(_loc6_);
            }
         }
         var _loc4_:AttackTargetTrait = getFirstTrait(AttackTargetTrait) as AttackTargetTrait;
         if(_loc4_)
         {
            _loc4_.lockType.value = AttackTargetTrait.getTypeOnClanRelationModule(this._info.clanDiplomacy.value);
         }
         var _loc5_:MiniMapDotTrait = getFirstTrait(MiniMapDotTrait) as MiniMapDotTrait;
         if(_loc5_)
         {
            _loc7_ = BattleStation.getMiniMapColorByClanAndFaction(this._info.clanID.value,this._info.factionID.value,this._info.clanDiplomacy.value);
            _loc5_.color = _loc7_;
         }
      }
   }
}

