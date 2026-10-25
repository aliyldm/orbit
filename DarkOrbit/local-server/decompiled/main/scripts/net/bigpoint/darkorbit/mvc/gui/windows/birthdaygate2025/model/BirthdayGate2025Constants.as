package net.bigpoint.darkorbit.mvc.gui.windows.birthdaygate2025.model
{
   import net.bigpoint.darkorbit.com.module.HighlightTypeModule;
   import net.bigpoint.darkorbit.mvc.gui.featuresMenu.FeaturesMenuConstants;
   import net.bigpoint.darkorbit.mvc.gui.highlights.model.HighlightItemVO;
   
   public class BirthdayGate2025Constants
   {
      
      public static const BIRTHDAY_2025:String = "birthday_2025";
      
      public static const INIT_VIEW_DATA:String = "init_view_data";
      
      public static const CLICK_REWARD_ITEM:String = "click_reward_item";
      
      public static const INIT_UI_RESOURCE_COMPLETE:String = "init_ui_resource_complete";
      
      public static const UI_ATLASXML:String = "birthdaygate2025_atlasXml";
      
      public static const UI_TEXTURE:String = "birthdaygate2025_texture";
      
      public static const RED_DOT:HighlightItemVO = new HighlightItemVO(BIRTHDAY_2025,FeaturesMenuConstants.MENU_ID,HighlightTypeModule.HIGHLIGHTTYPE_RED_DOT,0.3);
      
      public function BirthdayGate2025Constants()
      {
         super();
      }
   }
}

