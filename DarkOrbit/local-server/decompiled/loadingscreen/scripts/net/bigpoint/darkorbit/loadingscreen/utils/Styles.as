package net.bigpoint.darkorbit.loadingscreen.utils
{
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   
   public class Styles
   {
      
      public static const boldFontName:String = "EurostileHeaFl";
      
      public static const extFontName:String = "EurostileExtFl";
      
      public static var loadingFontHeight:int = 24;
      
      public static var loadingFmt:TextFormat = new TextFormat(boldFontName,loadingFontHeight,16434692);
      
      public static var loadingEmbed:Boolean = true;
      
      public static var loadingBtnFontHeight:int = 18;
      
      public static var loadingBtnFmt:TextFormat = new TextFormat(extFontName,loadingBtnFontHeight,16777215);
      
      public static var loadingBtnEmbed:Boolean = true;
      
      public static var loadingStartBtnFontHeight:int = 22;
      
      public static var loadingStartBtnFmt:TextFormat = new TextFormat(extFontName,loadingStartBtnFontHeight,16777215);
      
      public static var loadingStartBtnEmbed:Boolean = true;
      
      public static var h1FontHeight:int = 16;
      
      public static var h1Fmt:TextFormat = new TextFormat(boldFontName,h1FontHeight);
      
      public static var h1Embed:Boolean = true;
      
      public static var h2FontHeight:int = 16;
      
      public static var h2Fmt:TextFormat = new TextFormat(boldFontName,h2FontHeight);
      
      public static var h2Embed:Boolean = true;
      
      public static var strongStdFontHeight:int = 12;
      
      public static var strongStdFmt:TextFormat = new TextFormat(boldFontName,strongStdFontHeight);
      
      public static var strongStdEmbed:Boolean = true;
      
      public static var tooltipFontHeight:int = 12;
      
      public static var tooltipFontSidesMargin:int = 10;
      
      public static var tooltipFmt:TextFormat = new TextFormat("Tahoma",tooltipFontHeight,16777215);
      
      public static var tooltipEmbed:Boolean = false;
      
      loadingFmt.align = TextFormatAlign.CENTER;
      loadingBtnFmt.align = TextFormatAlign.CENTER;
      loadingStartBtnFmt.align = TextFormatAlign.CENTER;
      h1Fmt.align = TextFormatAlign.CENTER;
      h1Fmt.color = 16434692;
      h2Fmt.color = 16777215;
      tooltipFmt.leftMargin = tooltipFontSidesMargin;
      tooltipFmt.rightMargin = tooltipFontSidesMargin;
      
      public function Styles()
      {
         super();
      }
      
      public static function useDeviceFonts() : void
      {
         loadingEmbed = loadingBtnEmbed = loadingStartBtnEmbed = h1Embed = h2Embed = strongStdEmbed = false;
      }
      
      public static function distillAndWrite(param1:String, param2:TextField, param3:String = null, param4:TextFormat = null) : Boolean
      {
         var _loc8_:int = 0;
         if(param3 == null)
         {
            param3 = TextFieldAutoSize.LEFT;
         }
         var _loc5_:Number = param2.width;
         var _loc6_:Number = param2.height;
         param2.autoSize = param3;
         param2.text = param1;
         if(param4 != null)
         {
            param2.defaultTextFormat = param4;
         }
         if(param2.width <= _loc5_)
         {
            return false;
         }
         var _loc7_:String = param1;
         while(param2.width > _loc5_)
         {
            _loc8_ = _loc7_.length;
            _loc7_ = _loc7_.substring(0,_loc8_ - 3) + "… ";
            param2.text = _loc7_;
         }
         return true;
      }
   }
}

