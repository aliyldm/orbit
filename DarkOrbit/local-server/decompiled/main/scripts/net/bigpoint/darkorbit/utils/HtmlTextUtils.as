package net.bigpoint.darkorbit.utils
{
   import com.bigpoint.utils.TimeFormatter;
   import com.bigpoint.utils.time.TimeVo;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   
   public class HtmlTextUtils
   {
      
      private static const FONT_COLOR_TAG_OPEN:String = "<font color=\'#";
      
      private static const FONT_FONTFAMILY_TAG_OPEN:String = "<font fontFamily=\'";
      
      private static const CLOSE_TAG:String = "\'>";
      
      private static const FONT_TAG_CLOSE:String = "</font>";
      
      private static const B_TAG_OPEN:String = "<b>";
      
      private static const B_TAG_CLOSE:String = "</b>";
      
      public static const BR:String = "<br/>";
      
      private static const REG_EX:RegExp = /<[^<]+?>/gi;
      
      public function HtmlTextUtils()
      {
         super();
      }
      
      public static function coloriseText(param1:uint, param2:String) : String
      {
         return FONT_COLOR_TAG_OPEN + param1.toString(16) + CLOSE_TAG + param2 + FONT_TAG_CLOSE;
      }
      
      public static function fontText(param1:String, param2:String) : String
      {
         return FONT_FONTFAMILY_TAG_OPEN + param1 + CLOSE_TAG + param2 + FONT_TAG_CLOSE;
      }
      
      public static function makeBoldText(param1:String) : String
      {
         return B_TAG_OPEN + param1 + B_TAG_CLOSE;
      }
      
      public static function getFormatedTimeWithColores(param1:uint, param2:uint, param3:int, param4:Boolean = true, param5:Boolean = false, param6:Boolean = false) : String
      {
         var _loc14_:String = null;
         var _loc15_:Array = null;
         var _loc16_:String = null;
         var _loc17_:Array = null;
         var _loc7_:TimeVo = TimeFormatter.getSeparatedTimeValues(param3,param4,param5);
         var _loc8_:String = "";
         var _loc9_:String = "";
         if(param5)
         {
            _loc14_ = BPLocale.getItem("abbreviation_days");
            _loc15_ = _loc14_.split("%VALUE%");
            _loc15_ = coloriseTexts(param1,_loc15_);
            _loc9_ = coloriseText(param2,_loc7_.daysVal.toString());
            _loc8_ += _loc15_.join(_loc9_);
         }
         if(param4)
         {
            if(_loc8_.length > 0)
            {
               _loc8_ += " ";
            }
            _loc16_ = BPLocale.getItem("abbreviation_hours");
            _loc17_ = _loc16_.split("%VALUE%");
            _loc17_ = coloriseTexts(param1,_loc17_);
            _loc9_ = coloriseText(param2,_loc7_.hoursVal.toString());
            _loc8_ += _loc17_.join(_loc9_);
         }
         if(param6)
         {
            _loc8_ += "<br/>";
         }
         if(_loc8_.length > 0)
         {
            _loc8_ += " ";
         }
         var _loc10_:String = BPLocale.getItem("abbreviation_minutes");
         var _loc11_:Array = _loc10_.split("%VALUE%");
         _loc11_ = coloriseTexts(param1,_loc11_);
         _loc9_ = coloriseText(param2,_loc7_.minutesVal.toString());
         _loc8_ += _loc11_.join(_loc9_);
         if(_loc8_.length > 0)
         {
            _loc8_ += " ";
         }
         var _loc12_:String = BPLocale.getItem("abbreviation_seconds");
         var _loc13_:Array = _loc12_.split("%VALUE%");
         _loc13_ = coloriseTexts(param1,_loc13_);
         _loc9_ = coloriseText(param2,_loc7_.secondsVal.toString());
         return _loc8_ + _loc13_.join(_loc9_);
      }
      
      private static function coloriseTexts(param1:uint, param2:Array) : Array
      {
         var _loc4_:String = null;
         var _loc3_:Array = [];
         for each(_loc4_ in param2)
         {
            _loc3_.push(coloriseText(param1,_loc4_));
         }
         return _loc3_;
      }
      
      public static function convertColorValueIntoHTMLFormat(param1:uint) : String
      {
         return "#" + param1.toString(16);
      }
      
      public static function replaceFontTagsInLocalisedTextWithSpanTags(param1:String, param2:Vector.<HTMLTextReplaceVO>) : String
      {
         var _loc3_:HTMLTextReplaceVO = null;
         var _loc4_:RegExp = null;
         var _loc5_:String = null;
         for each(_loc3_ in param2)
         {
            _loc4_ = _loc3_.regExp;
            _loc5_ = _loc3_.string;
            param1 = param1.replace(_loc4_,_loc5_);
         }
         return param1;
      }
      
      public static function escapeHtmlText(param1:String) : String
      {
         var _loc2_:XML = <xml/>;
         _loc2_.appendChild(param1);
         return _loc2_.toXMLString();
      }
      
      public static function removeTags(param1:String) : String
      {
         return param1.replace(REG_EX,"");
      }
   }
}

