package net.bigpoint.darkorbit.map.model.env.homebase
{
   import com.bigpoint.utils.PointLite;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.com.module.AssetCreateCommand;
   import net.bigpoint.darkorbit.com.module.AssetTypeModule;
   import net.bigpoint.darkorbit.com.module.CompanyHierarchyRequest;
   import net.bigpoint.darkorbit.com.module.FactionModule;
   import net.bigpoint.darkorbit.gui.windows.FlexWindowManager;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.traits.clickIcon.ClickIconTrait;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.common.model.assets.UberAssetsLib;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   
   public class Headquarters extends MapEntity
   {
      
      private static var OVERWRITE_MAP:Object;
      
      private static const FACTION_2_PATTERN_ID:Object = {};
      
      private static const FACTION_2_SOUND_ID:Object = {};
      
      FACTION_2_PATTERN_ID[FactionModule.FACTION_MMO] = {};
      FACTION_2_PATTERN_ID[FactionModule.FACTION_MMO][AssetTypeModule.ASSETTYPE_COMPANY_HQ_HOME] = "headquarters_home_mmo";
      FACTION_2_PATTERN_ID[FactionModule.FACTION_MMO][AssetTypeModule.ASSETTYPE_COMPANY_HQ_OUTPOST] = "headquarters_outpost_mmo";
      FACTION_2_PATTERN_ID[FactionModule.FACTION_EIC] = {};
      FACTION_2_PATTERN_ID[FactionModule.FACTION_EIC][AssetTypeModule.ASSETTYPE_COMPANY_HQ_HOME] = "headquarters_home_eic";
      FACTION_2_PATTERN_ID[FactionModule.FACTION_EIC][AssetTypeModule.ASSETTYPE_COMPANY_HQ_OUTPOST] = "headquarters_outpost_eic";
      FACTION_2_PATTERN_ID[FactionModule.FACTION_VRU] = {};
      FACTION_2_PATTERN_ID[FactionModule.FACTION_VRU][AssetTypeModule.ASSETTYPE_COMPANY_HQ_HOME] = "headquarters_home_vru";
      FACTION_2_PATTERN_ID[FactionModule.FACTION_VRU][AssetTypeModule.ASSETTYPE_COMPANY_HQ_OUTPOST] = "headquarters_outpost_vru";
      FACTION_2_SOUND_ID[FactionModule.FACTION_MMO] = InGameCatalog.SOUND_ID_BUBBLE_CLICKED_HQ_MMO;
      FACTION_2_SOUND_ID[FactionModule.FACTION_EIC] = InGameCatalog.SOUND_ID_BUBBLE_CLICKED_HQ_EIC;
      FACTION_2_SOUND_ID[FactionModule.FACTION_VRU] = InGameCatalog.SOUND_ID_BUBBLE_CLICKED_HQ_VRU;
      
      private var _soundID:int = 0;
      
      private var _factionId:int;
      
      private var _type:uint;
      
      private var _showBubble:Boolean;
      
      public function Headquarters(param1:AssetCreateCommand)
      {
         super(param1.assetId,new PointLite(param1.posX,param1.posY));
         this._factionId = param1.factionId;
         this._type = param1.type.typeValue;
         this._showBubble = param1.showBubble;
         this.update();
      }
      
      public static function overwritePatterns(param1:Object) : void
      {
         OVERWRITE_MAP = param1;
      }
      
      public function update() : void
      {
         removeAllTraits();
         var _loc1_:Object = OVERWRITE_MAP || FACTION_2_PATTERN_ID;
         UberAssetsLib.instance.fillTraits(this,_loc1_[this._factionId][this._type],UberAssetsLib.LIB_DEFAULT,this._showBubble ? this.handleIconClick : null);
         var _loc2_:ClickIconTrait = getFirstTrait(ClickIconTrait) as ClickIconTrait;
         if(_loc2_)
         {
            _loc2_.disabledSignal.add(this.handleIconDisabled);
         }
         this._soundID = FACTION_2_SOUND_ID[this._factionId];
      }
      
      private function handleIconClick() : void
      {
         AudioManager.playSoundEffect(this._soundID);
         GameFacade.getInstance().sendNotification(GuiNotifications.OPEN_COMPANY_HIERARCHY_WINDOW);
         GameFacade.getInstance().sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new CompanyHierarchyRequest());
      }
      
      private function handleIconDisabled() : void
      {
         GameFacade.getInstance().sendNotification(GuiNotifications.CLOSE_WINDOW_BY_TYPE,FlexWindowManager.COMPANY_HIERARCHY_WINDOW);
      }
   }
}

