package net.bigpoint.darkorbit.mvc.hintSystem
{
   import net.bigpoint.darkorbit.utils.HTMLTextReplaceVO;
   
   public class HintSystemConstants
   {
      
      public static const LIBRARY_NAME:String = "hintSystemUI";
      
      private static const PREFIX_NAME:String = "hintSystem_";
      
      public static const SKIN_DEFINITIONS_NAME:String = PREFIX_NAME + "skins";
      
      public static const BASE_WINDOW_TEMPLATE_NAME:String = PREFIX_NAME + "baseWindow";
      
      public static const OVERVIEW_WINDOW_NAME:String = PREFIX_NAME + "overviewWindow";
      
      public static const WINDOW_WAS_OPENED_FROM_CLIENT:Boolean = false;
      
      public static const WINDOW_WAS_OPENED_FROM_SERVER:Boolean = true;
      
      public static const USE_HTML_FOR_THE_GHOSTTYPER_EFFECT:Boolean = true;
      
      public static const TITLE_COLOR:uint = 15327936;
      
      public static const TITLE_COLOR_BRIGHTER:uint = 12169856;
      
      public static const USE_HTML_FOR_MESSAGE_LABEL:Boolean = true;
      
      public static const MESSAGE_LABEL_MARKED_TEXTAREAS_REPLACEMENTS:Vector.<HTMLTextReplaceVO> = new <HTMLTextReplaceVO>[new HTMLTextReplaceVO(/<font color="%marked_yellow%">/g,"<span class=\'yellow\'>"),new HTMLTextReplaceVO(/<span class="%marked_yellow%">/g,"<span class=\'yellow\'>"),new HTMLTextReplaceVO(/<\/font>/g,"</span>")];
      
      public static const TEMPORARY_HTML_TAG_SOLUTION:Vector.<HTMLTextReplaceVO> = new <HTMLTextReplaceVO>[new HTMLTextReplaceVO(/<font color="%marked_yellow%">/g,""),new HTMLTextReplaceVO(/<span class="%marked_yellow%">/g,""),new HTMLTextReplaceVO(/<\/font>/g,"")];
      
      public static const CONFIRMATION_BUTTON_01:String = "confirmationButton01";
      
      public static const CONFIRMATION_BUTTON_02:String = "confirmationButton02";
      
      public function HintSystemConstants()
      {
         super();
      }
   }
}

