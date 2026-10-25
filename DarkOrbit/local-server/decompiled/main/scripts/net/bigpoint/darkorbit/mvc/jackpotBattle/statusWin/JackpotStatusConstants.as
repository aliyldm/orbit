package net.bigpoint.darkorbit.mvc.jackpotBattle.statusWin
{
   public class JackpotStatusConstants
   {
      
      public static const PLAYER_PIC_BASE_LINK:String = "%BASE_PATH%flashAPI/profileImage.php?userId=%USERID%&instanceId=%INSTANCE%";
      
      public static const ID_PLACEHOLDER:RegExp = /%USERID%/;
      
      public static const INSTANCE_PLACEHOLDER:RegExp = /%INSTANCE%/;
      
      public static const BASE_PATH_PLACEHOLDER:RegExp = /%BASE_PATH%/;
      
      public static const LIB_ID:String = "jackpot";
      
      public static const UNKNOWN:String = "unknown";
      
      public static const WILDCARD:String = "wildcard";
      
      public static const FRAME:String = "frame";
      
      public static const VS_ING:String = "vs_img";
      
      public static const UNKNOWN_PLAYER_ID:int = 0;
      
      public static const WILDCARD_ID:int = -1;
      
      public static const AVATAR_WIDTH:int = 120;
      
      public static const AVATAR_HEIGHT:int = 130;
      
      public function JackpotStatusConstants()
      {
         super();
      }
   }
}

