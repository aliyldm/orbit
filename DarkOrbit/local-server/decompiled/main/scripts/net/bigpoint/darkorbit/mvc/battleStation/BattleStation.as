package net.bigpoint.darkorbit.mvc.battleStation
{
   import com.bigpoint.utils.PointLite;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.com.module.AssetCreateCommand;
   import net.bigpoint.darkorbit.com.module.ClanRelationModule;
   import net.bigpoint.darkorbit.com.module.MapAssetActivationRequest;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.minimap.traits.MiniMapIconTrait;
   import net.bigpoint.darkorbit.map.model.traits.AttackTargetTrait;
   import net.bigpoint.darkorbit.map.model.traits.hud.MapObjectInfoTrait;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.BattleStationNotification;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.common.model.assets.UberAssetsLib;
   import net.bigpoint.darkorbit.utils.math.FastMath;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class BattleStation extends MapEntity
   {
      
      private var _info:MapObjectInfoTrait;
      
      private var _deflectorShildID:int;
      
      private var _hullID:int;
      
      private var _deflectorShildExpansion:Number;
      
      private var _hullExpansion:Number;
      
      public const changed:ISignal = new Signal();
      
      public function BattleStation(param1:AssetCreateCommand)
      {
         super(param1.assetId,new PointLite(param1.posX,param1.posY,-200));
         var _loc2_:Function = param1.clanId == Hero.clanID ? this.handleIconClick : null;
         UberAssetsLib.instance.fillTraits(this,"battleStation",UberAssetsLib.LIB_BATTLE_STATION,_loc2_);
         addTrait(this._info = new MapObjectInfoTrait());
         this._info.username.value = param1.userName;
         this._info.clanTag.value = param1.clanTag;
         this._info.clanID.value = param1.clanId;
         this._info.factionID.value = param1.factionId;
         this._info.clanDiplomacy.value = param1.clanRelation.type;
         this.updateVisuals(param1.designId,param1.expansionStage);
         (getFirstTrait(AttackTargetTrait) as AttackTargetTrait).lockType.value = AttackTargetTrait.getTypeOnClanRelationModule(param1.clanRelation.type);
         (getFirstTrait(MiniMapIconTrait) as MiniMapIconTrait).resKey = this.getMinimapResKey(param1);
      }
      
      public static function getMiniMapColorByClanAndFaction(param1:int, param2:int, param3:int = 0) : uint
      {
         var _loc4_:uint = 0;
         if(param1 == Hero.clanID)
         {
            _loc4_ = 4281597747;
         }
         else if(param3 == ClanRelationModule.TYPE_NON_AGGRESSION_PACT || param3 == ClanRelationModule.TYPE_ALLIED || Hero.factionID.value == param2)
         {
            _loc4_ = 4294890119;
         }
         else
         {
            _loc4_ = 4294901760;
         }
         return _loc4_;
      }
      
      public function updateVisuals(param1:int, param2:int) : void
      {
         this._deflectorShildID = FastMath.getLowerByte(param1);
         this._hullID = FastMath.getUpperByte(param1);
         this._deflectorShildExpansion = FastMath.getUpperByte(param2);
         this._hullExpansion = FastMath.getLowerByte(param2);
         this.changed.dispatch();
      }
      
      private function handleIconClick() : void
      {
         GameFacade.getInstance().sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new MapAssetActivationRequest(id));
         GameFacade.getInstance().sendNotification(BattleStationNotification.BATTLE_STATION_ASSET_CLICKED,[id,this._info.username.value]);
      }
      
      private function getMinimapResKey(param1:AssetCreateCommand) : String
      {
         var _loc2_:String = null;
         if(param1.clanId == Hero.clanID)
         {
            _loc2_ = "mapIcon_battlestation_green";
         }
         else if(param1.clanRelation.type == ClanRelationModule.TYPE_NON_AGGRESSION_PACT || param1.clanRelation.type == ClanRelationModule.TYPE_ALLIED || Hero.factionID.value == param1.factionId)
         {
            _loc2_ = "mapIcon_battlestation_white";
         }
         else
         {
            _loc2_ = "mapIcon_battlestation_red";
         }
         return _loc2_;
      }
      
      public function get deflectorShildExpansion() : Number
      {
         return this._deflectorShildExpansion;
      }
      
      public function get hullExpansion() : Number
      {
         return this._hullExpansion;
      }
   }
}

