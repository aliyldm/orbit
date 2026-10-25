package net.bigpoint.darkorbit.mvc.commandCenter.constants
{
   import net.bigpoint.darkorbit.com.module.HighlightTypeModule;
   import net.bigpoint.darkorbit.mvc.commandCenter.model.CommandCenterModel;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.featuresMenu.FeaturesMenuConstants;
   import net.bigpoint.darkorbit.mvc.gui.highlights.controller.HighlightFactory;
   import net.bigpoint.darkorbit.mvc.gui.highlights.model.HighlightItemVO;
   
   public class CommandCenterConsts
   {
      
      public static const WINDOW_XML_KEY:String = "commandCenterUI";
      
      public static const HIGHLIGHT_TIME:Number = 3;
      
      public static const XML_RES_KEY:String = "commandCenterUI";
      
      public static const ASSET_LIB:String = "commandCenterWindow";
      
      public static const CONTENT_BG_SPECIAL:String = "command_center_news_bg_special";
      
      public static const CONTENT_BG:String = "command_center_news_bg";
      
      public static const CONTENT_BOX_SPECIAL:String = "content_frame_box_special";
      
      public static const CONTENT_BOX:String = "content_frame_box";
      
      public static const CONTENT_LINE_SPECIAL:String = "content_frame_line_special";
      
      public static const CONTENT_LINE:String = "content_frame_line";
      
      public static const LIST_BG_SPECIAL:String = "command_center_tab_gold";
      
      public static const LIST_BG:String = "command_center_tab_blue";
      
      public static const LIST_HOVER_SPECIAL:String = "command_center_itemlist_special";
      
      public static const LIST_HOVER:String = "command_center_itemlist";
      
      public static const TOOLTIP_OFFSET_Y:Number = 10;
      
      public static const TIMER_XML:XML = <timer position="default_footer" style="timer"/>;
      
      public static const CONTENT_WIDTH:Number = 303;
      
      public static const CONTENT_HEIGHT:Number = 361;
      
      public static const NEWS_EVENT_PREFIX:String = "BE_";
      
      public static const TIMER_TIMEOUT_SEC:Number = 10000;
      
      public static const SLIDE_SHOW_INTERVAL:Number = 10000;
      
      public static const highlightLookup:Object = {};
      
      public static const REMINDER_DELAY:int = 5 * 60 * 1000;
      
      public static const FLASH:HighlightItemVO = new HighlightItemVO(GuiConstants.COMMAND_CENTER,FeaturesMenuConstants.MENU_ID,HighlightTypeModule.HIGHLIGHTTYPE_FLASH,0.3,CommandCenterConsts.HIGHLIGHT_TIME);
      
      public static const RED_DOT:HighlightItemVO = new HighlightItemVO(GuiConstants.COMMAND_CENTER,FeaturesMenuConstants.MENU_ID,HighlightTypeModule.HIGHLIGHTTYPE_RED_DOT,0.3);
      
      public static const YELLOW_FLASH_LOOP:HighlightItemVO = new HighlightItemVO(GuiConstants.COMMAND_CENTER,FeaturesMenuConstants.MENU_ID,HighlightFactory.YELLOW_HIGHLIGHT,0.3);
      
      highlightLookup[CommandCenterModel.NORMAL_STATE] = new Vector.<HighlightItemVO>();
      highlightLookup[CommandCenterModel.UNREAD_NEWS_STATE] = new <HighlightItemVO>[CommandCenterConsts.FLASH];
      highlightLookup[CommandCenterModel.UNREAD_DEALS_STATE] = new <HighlightItemVO>[CommandCenterConsts.YELLOW_FLASH_LOOP];
      
      public function CommandCenterConsts()
      {
         super();
      }
   }
}

