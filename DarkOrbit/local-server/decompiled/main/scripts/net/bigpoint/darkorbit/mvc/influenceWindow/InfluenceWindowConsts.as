package net.bigpoint.darkorbit.mvc.influenceWindow
{
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.com.module.FactionModule;
   
   public class InfluenceWindowConsts
   {
      
      public static const XML_RES_KEY:String = "influenceWindowUI";
      
      public static const ITEM_RENDERER_CONTAINER_KEY:String = "itemrendererContainer";
      
      public static const COMPANY_IMAGE_KEY:String = "company_img";
      
      public static const COMPANY_SCORE_LABEL_KEY:String = "score";
      
      public static const COMPANY_PROGRESS_BAR_KEY:String = "progressbar";
      
      public static const COMPANY_PROGRESS_BAR_SKIN_NAME_MMO:String = "influence_window_progressbar_skin_mmo";
      
      public static const COMPANY_PROGRESS_BAR_SKIN_NAME_EIC:String = "influence_window_progressbar_skin_eic";
      
      public static const COMPANY_PROGRESS_BAR_SKIN_NAME_VRU:String = "influence_window_progressbar_skin_vru";
      
      public static const COMPANY_PROGRESS_BAR_SKIN_NAME_MMO_LEADING:String = "influence_window_progressbar_skin_mmo_leading";
      
      public static const COMPANY_PROGRESS_BAR_SKIN_NAME_EIC_LEADING:String = "influence_window_progressbar_skin_eic_leading";
      
      public static const COMPANY_PROGRESS_BAR_SKIN_NAME_VRU_LEADING:String = "influence_window_progressbar_skin_vru_leading";
      
      public static const INFLUENCE_ITEM_LIST_KEY:String = "influenceItemlist";
      
      public static const PLAYER_SCORE_LABEL_KEY:String = "playerScore";
      
      public static const COMPANY_INFO_CONTAINER_KEY:String = "infoContainer1";
      
      public static const PLAYER_INFO_CONTAINER_KEY:String = "infoContainer2";
      
      public static const COMPANY_INFO_SCROLLBAR_KEY:String = "scrollbar1";
      
      public static const PLAYER_INFO_SCROLLBAR_KEY:String = "scrollbar2";
      
      public static const COMPANY_INFO_SCROLLCONTAINER_KEY:String = "scrollContainer1";
      
      public static const PLAYER_INFO_SCROLLCONTAINER_KEY:String = "scrollContainer2";
      
      public static const VRU:String = InGameCatalog.instance.factions_resKeys[FactionModule.FACTION_VRU];
      
      public static const EIC:String = InGameCatalog.instance.factions_resKeys[FactionModule.FACTION_EIC];
      
      public static const MMO:String = InGameCatalog.instance.factions_resKeys[FactionModule.FACTION_MMO];
      
      public function InfluenceWindowConsts()
      {
         super();
      }
   }
}

