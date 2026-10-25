package net.bigpoint.darkorbit.questfm.conditions
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.com.module.AssetTypeModule;
   
   public class VisitMapAssetCondition extends net.bigpoint.darkorbit.questfm.conditions.Condition
   {
      
      public function VisitMapAssetCondition()
      {
         super();
      }
      
      override protected function parseMatches(param1:Vector.<String>) : void
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         super.parseMatches(param1);
         if(param1.length)
         {
            _loc2_ = int(param1[0]);
            _description = _description.replace(/%TYPE%/,BPLocale.getItem(InGameCatalog.instance.mapAssetLocakeys[_loc2_]));
            switch(_loc2_)
            {
               case AssetTypeModule.ASSETTYPE_HANGAR_HOME:
                  _helpIconData = getBitmapDataByKey("homestation_hangar");
                  break;
               case AssetTypeModule.ASSETTYPE_COMPANY_HQ_HOME:
                  _loc3_ = InGameCatalog.getInstance().factions_resKeys[Hero.factionID.value];
                  _helpIconData = getBitmapDataByKey("homestation_company_" + _loc3_);
                  break;
               case AssetTypeModule.ASSETTYPE_ORE_TRADE_HOME:
                  _helpIconData = getBitmapDataByKey("homestation_ore_trade");
                  break;
               case AssetTypeModule.ASSETTYPE_INSTANT_REPAIR_HOME:
                  _helpIconData = getBitmapDataByKey("homestation_instant_repair");
            }
         }
      }
   }
}

