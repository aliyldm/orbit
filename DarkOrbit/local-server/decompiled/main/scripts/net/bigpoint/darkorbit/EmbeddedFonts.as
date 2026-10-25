package net.bigpoint.darkorbit
{
   import flash.text.Font;
   
   public class EmbeddedFonts
   {
      
      private static var fontEurostileFl:Class = EmbeddedFonts_fontEurostileFl;
      
      private static var fontEurostileHeaFl:Class = EmbeddedFonts_fontEurostileHeaFl;
      
      private static var fontEurostileExtFl:Class = EmbeddedFonts_fontEurostileExtFl;
      
      private static var fontEurostileTMed:Class = EmbeddedFonts_fontEurostileTMed;
      
      public function EmbeddedFonts()
      {
         super();
      }
      
      public static function initialize() : Boolean
      {
         Font.registerFont(fontEurostileFl);
         Font.registerFont(fontEurostileHeaFl);
         Font.registerFont(fontEurostileExtFl);
         Font.registerFont(fontEurostileTMed);
         return true;
      }
      
      public static function createEmbeddedFontList() : String
      {
         var _loc4_:Font = null;
         var _loc1_:String = "";
         var _loc2_:Array = Font.enumerateFonts(true);
         _loc1_ += "Fonts: \n";
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc4_ = _loc2_[_loc3_];
            if(_loc4_.fontType == "embeddedCFF" || _loc4_.fontType == "embedded")
            {
               _loc1_ += "FONT " + _loc3_ + ":: name: " + _loc4_.fontName + "; typeface: " + _loc4_.fontStyle + "; type: " + _loc4_.fontType;
               _loc1_ += "*";
            }
            _loc1_ += "\n";
            _loc3_++;
         }
         return _loc1_;
      }
   }
}

