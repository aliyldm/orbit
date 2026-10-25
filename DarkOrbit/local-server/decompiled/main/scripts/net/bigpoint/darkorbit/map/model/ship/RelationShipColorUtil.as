package net.bigpoint.darkorbit.map.model.ship
{
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.model.Map;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   
   public class RelationShipColorUtil
   {
      
      public function RelationShipColorUtil()
      {
         super();
      }
      
      public static function getColorRelatedToHero(param1:Ship) : uint
      {
         var _loc2_:uint = 4294901760;
         var _loc3_:Ship = ScreenManager.getInstance().map.hero;
         if(_loc3_ == null)
         {
            return 4294901760;
         }
         if(param1 == _loc3_)
         {
            return 4294967295;
         }
         if(_loc3_.pet == param1)
         {
            return 4294967295;
         }
         if(Map.inSAEMap(ScreenManager.getInstance().map.getMapID()))
         {
            return 4294901760;
         }
         if(ScreenManager.getInstance().map.effects.getEffectForMapObject(param1.id,EffectIDList.INVASION_NPC_EFFECT))
         {
            return 4294945331;
         }
         if(param1.info.factionID.value == _loc3_.info.factionID.value)
         {
            _loc2_ = 4278229503;
         }
         if(Boolean(param1.info.clanID.value) && param1.info.clanID.value == _loc3_.info.clanID.value)
         {
            _loc2_ = 4281597747;
         }
         else if(Hero.radarCPUEquipped.value || Hero.premium.value)
         {
            switch(param1.info.clanDiplomacy.value)
            {
               case 1:
                  _loc2_ = 4281597747;
                  break;
               case 2:
                  _loc2_ = 4294953984;
                  break;
               case 3:
                  _loc2_ = param1.info.factionID.value == _loc3_.info.factionID.value ? uint(4294901760) : uint(4291559424);
            }
         }
         return _loc2_;
      }
   }
}

