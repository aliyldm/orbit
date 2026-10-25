package net.bigpoint.darkorbit.mvc.hintSystem.view.hintWindow.uistructures
{
   import flash.text.StyleSheet;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.fui.builder.repository.TextStyleRepository;
   import net.bigpoint.darkorbit.fui.builder.repository.TextStyleVO;
   import net.bigpoint.darkorbit.mvc.hintSystem.HintSystemConstants;
   import net.bigpoint.darkorbit.utils.HtmlTextUtils;
   
   public class HintWindowTextStylesStructure
   {
      
      public static const headerFontHeight:int = 18;
      
      public static const headerFontColour:uint = HintSystemConstants.TITLE_COLOR;
      
      public static const headerFormat:TextFormat = new TextFormat(Styles.corporateFontHeavy,headerFontHeight,headerFontColour);
      
      public static const messageHeaderFontHeight:int = 16;
      
      public static const messageHeaderFontColour:uint = 14610431;
      
      public static const messageHeaderFormat:TextFormat = new TextFormat(Styles.corporateFontHeavy,messageHeaderFontHeight,messageHeaderFontColour);
      
      public static const messageFontHeight:int = 15;
      
      public static const messageFontColour:uint = 11464690;
      
      public static const messageFormat:TextFormat = new TextFormat("EurostileFl",messageFontHeight,messageFontColour);
      
      public static const confirmationFontHeight:int = 16;
      
      public static const confirmationFontColour:uint = 16777215;
      
      public static const confirmationFormat:TextFormat = new TextFormat(Styles.corporateFontHeavy,confirmationFontHeight,confirmationFontColour,null,null,null,null,null,TextFormatAlign.CENTER);
      
      public function HintWindowTextStylesStructure()
      {
         super();
      }
      
      public static function init() : void
      {
         var _loc1_:TextStyleVO = new TextStyleVO("hintsystem_header");
         _loc1_.textFormat = headerFormat;
         _loc1_.embedFonts = Styles.baseEmbed;
         _loc1_.multiline = false;
         _loc1_.wordWrap = false;
         _loc1_.selectable = false;
         _loc1_.autoSize = TextFieldAutoSize.LEFT;
         _loc1_.border = false;
         var _loc2_:TextStyleVO = new TextStyleVO("hintsystem_message_header");
         _loc2_.textFormat = messageHeaderFormat;
         _loc2_.embedFonts = Styles.baseEmbed;
         _loc2_.wordWrap = true;
         _loc2_.selectable = false;
         _loc2_.autoSize = TextFieldAutoSize.LEFT;
         _loc2_.border = false;
         var _loc3_:Object = {"color":HtmlTextUtils.convertColorValueIntoHTMLFormat(Styles.YELLOW)};
         var _loc4_:StyleSheet = new StyleSheet();
         _loc4_.setStyle(".yellow",_loc3_);
         var _loc5_:TextStyleVO = new TextStyleVO("hintsystem_message");
         _loc5_.textFormat = messageFormat;
         _loc5_.embedFonts = Styles.baseEmbed;
         _loc5_.wordWrap = true;
         _loc5_.multiline = true;
         _loc5_.selectable = false;
         _loc5_.autoSize = TextFieldAutoSize.LEFT;
         _loc5_.border = false;
         var _loc6_:TextStyleVO = new TextStyleVO("hintsystem_confirmation");
         _loc6_.textFormat = confirmationFormat;
         _loc6_.embedFonts = Styles.baseEmbed;
         _loc6_.wordWrap = true;
         _loc6_.multiline = false;
         _loc6_.selectable = false;
         _loc6_.autoSize = TextFieldAutoSize.CENTER;
         _loc6_.border = false;
         var _loc7_:TextStyleRepository = TextStyleRepository.getInstance();
         _loc7_.register(_loc1_);
         _loc7_.register(_loc2_);
         _loc7_.register(_loc5_);
         _loc7_.register(_loc6_);
      }
   }
}

