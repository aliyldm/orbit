package net.bigpoint.darkorbit.loadingscreen.utils
{
   public class FlashVarsParser
   {
      
      public function FlashVarsParser()
      {
         super();
      }
      
      public static function parse(param1:Object) : void
      {
         Session.host = param1.host + "/";
         Session.cdnHost = param1.cdn || Session.host;
         if(param1.basePath)
         {
            Session.basePath = param1.basePath;
         }
         if(param1.lang)
         {
            Session.lang = param1.lang.split("_")[0];
         }
         if(param1.loadingClaim)
         {
            Session.loadingClaim = param1.loadingClaim + "...";
         }
         if(param1.loadingscreenAssetsXmlHash)
         {
            Session.loadingscreenAssetsXmlHash = param1.loadingscreenAssetsXmlHash;
         }
         if(param1.languageXmlHash)
         {
            Session.languageXMLHash = param1.languageXmlHash;
         }
         if(param1.crossdomainHash)
         {
            Session.crossdomainHash = param1.crossdomainHash;
         }
         if(param1.theme)
         {
            Session.theme = param1.theme != null ? param1.theme : "default";
         }
         if(param1.useDeviceFonts == "1")
         {
            Styles.useDeviceFonts();
         }
      }
   }
}

