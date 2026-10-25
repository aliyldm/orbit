package net.bigpoint.darkorbit.utils
{
   public class WebsiteAssetUtils
   {
      
      private static const PLAYER_PIC_BASE_LINK:String = "%BASE_PATH%flashAPI/profileImage.php?userId=%USERID%&instanceId=%INSTANCE%";
      
      private static const ID_PLACEHOLDER:RegExp = /%USERID%/;
      
      private static const INSTANCE_PLACEHOLDER:RegExp = /%INSTANCE%/;
      
      private static const BASE_PATH_PLACEHOLDER:RegExp = /%BASE_PATH%/;
      
      public function WebsiteAssetUtils()
      {
         super();
      }
      
      public static function generateUserPicLoadUrl(param1:int, param2:int, param3:String) : String
      {
         return PLAYER_PIC_BASE_LINK.replace(BASE_PATH_PLACEHOLDER,param3).replace(ID_PLACEHOLDER,param1).replace(INSTANCE_PLACEHOLDER,param2);
      }
   }
}

