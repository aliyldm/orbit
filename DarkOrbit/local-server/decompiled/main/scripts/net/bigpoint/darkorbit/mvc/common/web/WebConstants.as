package net.bigpoint.darkorbit.mvc.common.web
{
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.com.module.PageRefreshCommand;
   
   public class WebConstants
   {
      
      public static const TECH_FACTORY_ACTION:String = "internalNanoTechFactory";
      
      public static const TECH_FACTORY_TEXTKEY:String = "seo_tittle_techfactory";
      
      public static const WEB_URL_ACTIONS_MAP:Dictionary = new Dictionary();
      
      public static const WEB_URL_TEXTKEYS_MAP:Dictionary = new Dictionary();
      
      WEB_URL_ACTIONS_MAP[PageRefreshCommand.PAGETYPE_TECH_FACTORY] = TECH_FACTORY_ACTION;
      WEB_URL_TEXTKEYS_MAP[PageRefreshCommand.PAGETYPE_TECH_FACTORY] = TECH_FACTORY_TEXTKEY;
      
      public function WebConstants()
      {
         super();
      }
   }
}

