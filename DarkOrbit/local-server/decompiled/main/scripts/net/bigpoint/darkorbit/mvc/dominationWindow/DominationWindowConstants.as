package net.bigpoint.darkorbit.mvc.dominationWindow
{
   import flash.filters.GlowFilter;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.com.module.FactionModule;
   
   public class DominationWindowConstants
   {
      
      public static const XML_RES_KEY:String = "dominationWindowUI";
      
      public static const WINDOW_CONTENT_CONTAINER:String = "windowContentContainer";
      
      public static const ITEMLIST:String = "dominationItemlist";
      
      public static const ITEMRENDERER_CONTAINER:String = "itemrendererContainer";
      
      public static const ITEM_COMPANY_IMAGE:String = "company_img";
      
      public static const ITEM_PROGRESS:String = "progressbar";
      
      public static const ITEM_SCORE:String = "score";
      
      public static const INFO_CONTAINER:String = "infoContainer";
      
      public static const SCROLL_CONTAINER:String = "scrollContainer";
      
      public static const CONTENT_CONTAINER:String = "content";
      
      public static const CONTENT_LABEL:String = "info";
      
      public static const SCROLL_BAR:String = "scrollbar";
      
      public static const BPLOCALE_KEY__COMPANY_REWARD:String = "label_domination_company_reward";
      
      public static const VRU:String = InGameCatalog.instance.factions_resKeys[FactionModule.FACTION_VRU];
      
      public static const EIC:String = InGameCatalog.instance.factions_resKeys[FactionModule.FACTION_EIC];
      
      public static const MMO:String = InGameCatalog.instance.factions_resKeys[FactionModule.FACTION_MMO];
      
      public static const INFO_AMOUNT:int = 1;
      
      public static const INFO_SECONDS:int = 60;
      
      public static const INFO_MESSAGE:String = BPLocale.getItem(DominationWindowConstants.BPLOCALE_KEY__COMPANY_REWARD).replace("%AMOUNT%",INFO_AMOUNT).replace("%SECONDS%",INFO_SECONDS);
      
      public static const MIN_DOMINTAION_SCORE:int = 9;
      
      public static const DOMINATION_FILTER:Array = [new GlowFilter(4520959,1,5,5,2)];
      
      public static const NOT_DOMINATION_FILTER:Array = [];
      
      public static const DOMINTAION_TEXT_STYLE:String = "domination_window_score_player_textstyle_leading";
      
      public static const NOT_DOMINTAION_TEXT_STYLE:String = "domination_window_score_player_textstyle";
      
      public static const COMPANY_PROGRESS_BAR_SKIN_NAME_MMO:String = "domination_window_progressbar_skin_mmo";
      
      public static const COMPANY_PROGRESS_BAR_SKIN_NAME_EIC:String = "domination_window_progressbar_skin_eic";
      
      public static const COMPANY_PROGRESS_BAR_SKIN_NAME_VRU:String = "domination_window_progressbar_skin_vru";
      
      public static const COMPANY_PROGRESS_BAR_SKIN_NAME_MMO_LEADING:String = "domination_window_progressbar_skin_mmo_leading";
      
      public static const COMPANY_PROGRESS_BAR_SKIN_NAME_EIC_LEADING:String = "domination_window_progressbar_skin_eic_leading";
      
      public static const COMPANY_PROGRESS_BAR_SKIN_NAME_VRU_LEADING:String = "domination_window_progressbar_skin_vru_leading";
      
      public function DominationWindowConstants()
      {
         super();
      }
   }
}

