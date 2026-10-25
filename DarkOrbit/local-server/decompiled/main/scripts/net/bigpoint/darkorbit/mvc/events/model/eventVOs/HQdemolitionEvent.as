package net.bigpoint.darkorbit.mvc.events.model.eventVOs
{
   import net.bigpoint.darkorbit.com.module.AssetTypeModule;
   import net.bigpoint.darkorbit.com.module.FactionModule;
   import net.bigpoint.darkorbit.map.model.env.homebase.Headquarters;
   import net.bigpoint.darkorbit.mvc.events.model.interfaces.IDOEvent;
   
   public class HQdemolitionEvent implements IDOEvent
   {
      
      private static const FACTION_2_PATTERN_ID:Object = {};
      
      FACTION_2_PATTERN_ID[FactionModule.FACTION_MMO] = {};
      FACTION_2_PATTERN_ID[FactionModule.FACTION_MMO][AssetTypeModule.ASSETTYPE_COMPANY_HQ_HOME] = "headquarters_mmo_demolished";
      FACTION_2_PATTERN_ID[FactionModule.FACTION_MMO][AssetTypeModule.ASSETTYPE_COMPANY_HQ_OUTPOST] = "headquarters_mmo_demolished";
      FACTION_2_PATTERN_ID[FactionModule.FACTION_EIC] = {};
      FACTION_2_PATTERN_ID[FactionModule.FACTION_EIC][AssetTypeModule.ASSETTYPE_COMPANY_HQ_HOME] = "headquarters_eic_demolished";
      FACTION_2_PATTERN_ID[FactionModule.FACTION_EIC][AssetTypeModule.ASSETTYPE_COMPANY_HQ_OUTPOST] = "headquarters_eic_demolished";
      FACTION_2_PATTERN_ID[FactionModule.FACTION_VRU] = {};
      FACTION_2_PATTERN_ID[FactionModule.FACTION_VRU][AssetTypeModule.ASSETTYPE_COMPANY_HQ_HOME] = "headquarters_vru_demolished";
      FACTION_2_PATTERN_ID[FactionModule.FACTION_VRU][AssetTypeModule.ASSETTYPE_COMPANY_HQ_OUTPOST] = "headquarters_vru_demolished";
      
      private var _isActive:Boolean;
      
      private var _id:int;
      
      public function HQdemolitionEvent(param1:uint, param2:Boolean)
      {
         super();
         this._id = param1;
         this._isActive = param2;
         this.updateStaticPatterns();
      }
      
      public function get isActive() : Boolean
      {
         return this._isActive;
      }
      
      public function get id() : int
      {
         return this._id;
      }
      
      private function updateStaticPatterns() : void
      {
         Headquarters.overwritePatterns(this._isActive ? FACTION_2_PATTERN_ID : null);
      }
   }
}

