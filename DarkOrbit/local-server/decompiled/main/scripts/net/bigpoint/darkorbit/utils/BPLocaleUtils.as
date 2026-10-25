package net.bigpoint.darkorbit.utils
{
   import flash.ui.Keyboard;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   
   public class BPLocaleUtils
   {
      
      private static const locaKeys:Object = new Object();
      
      locaKeys[Keyboard.BACKSPACE] = BPLocale.getItem("keyboard_key_backspace");
      locaKeys[Keyboard.CONTROL] = BPLocale.getItem("keyboard_key_ctrl");
      locaKeys[Keyboard.ESCAPE] = BPLocale.getItem("keyboard_key_esc");
      locaKeys[Keyboard.CAPS_LOCK] = BPLocale.getItem("keyboard_key_capslock");
      locaKeys[Keyboard.DELETE] = BPLocale.getItem("keyboard_key_delete");
      locaKeys[Keyboard.END] = BPLocale.getItem("keyboard_key_end");
      locaKeys[Keyboard.ENTER] = BPLocale.getItem("keyboard_key_enter");
      locaKeys[Keyboard.HOME] = BPLocale.getItem("keyboard_key_home");
      locaKeys[Keyboard.INSERT] = BPLocale.getItem("keyboard_key_insert");
      locaKeys[Keyboard.PAGE_UP] = BPLocale.getItem("keyboard_key_page up");
      locaKeys[Keyboard.PAGE_DOWN] = BPLocale.getItem("keyboard_key_page down");
      locaKeys[Keyboard.SPACE] = BPLocale.getItem("keyboard_key_space");
      locaKeys[Keyboard.SHIFT] = BPLocale.getItem("keyboard_key_key_shift");
      locaKeys[Keyboard.TAB] = BPLocale.getItem("keyboard_key_tab");
      locaKeys[Keyboard.UP] = BPLocale.getItem("keyboard_key_up");
      locaKeys[Keyboard.DOWN] = BPLocale.getItem("keyboard_key_down");
      locaKeys[Keyboard.LEFT] = BPLocale.getItem("keyboard_key_left");
      locaKeys[Keyboard.RIGHT] = BPLocale.getItem("keyboard_key_right");
      locaKeys[144] = BPLocale.getItem("keyboard_key_numpad").split("\n").join(" ");
      locaKeys[145] = BPLocale.getItem("keyboard_key_roll");
      locaKeys[19] = BPLocale.getItem("keyboard_key_pause");
      locaKeys[93] = BPLocale.getItem("keyboard_key_option");
      locaKeys[92] = BPLocale.getItem("keyboard_key_win");
      locaKeys[91] = BPLocale.getItem("keyboard_key_win");
      locaKeys[-1] = BPLocale.getItem("keyboard_key_undefined");
      locaKeys[Keyboard.NUMPAD_0] = locaKeys[144] + " 0";
      locaKeys[Keyboard.NUMPAD_1] = locaKeys[144] + " 1";
      locaKeys[Keyboard.NUMPAD_2] = locaKeys[144] + " 2";
      locaKeys[Keyboard.NUMPAD_3] = locaKeys[144] + " 3";
      locaKeys[Keyboard.NUMPAD_4] = locaKeys[144] + " 4";
      locaKeys[Keyboard.NUMPAD_5] = locaKeys[144] + " 5";
      locaKeys[Keyboard.NUMPAD_6] = locaKeys[144] + " 6";
      locaKeys[Keyboard.NUMPAD_7] = locaKeys[144] + " 7";
      locaKeys[Keyboard.NUMPAD_8] = locaKeys[144] + " 8";
      locaKeys[Keyboard.NUMPAD_9] = locaKeys[144] + " 9";
      locaKeys[Keyboard.NUMPAD_ADD] = locaKeys[144] + " +";
      locaKeys[Keyboard.NUMPAD_SUBTRACT] = locaKeys[144] + " -";
      locaKeys[Keyboard.NUMPAD_MULTIPLY] = locaKeys[144] + " *";
      locaKeys[Keyboard.NUMPAD_DIVIDE] = locaKeys[144] + " /";
      
      public function BPLocaleUtils()
      {
         super();
      }
      
      public static function hasTranslation(param1:String, param2:String = "") : Boolean
      {
         var _loc3_:String = param2 == "" || param2 == null ? "" : param2 + ".";
         return BPLocale.getItemInCategory(param2,param1) != "{" + _loc3_ + param1 + "}";
      }
      
      public static function getKeyboardChar(param1:int) : String
      {
         var _loc2_:String = null;
         if(locaKeys[param1])
         {
            _loc2_ = locaKeys[param1];
         }
         else if(param1 > 111 && param1 <= 126)
         {
            _loc2_ = "F" + (param1 - 111).toString();
         }
         else
         {
            if(BPLocaleUtils.hasTranslation("keyboard_key_" + param1.toString()))
            {
               _loc2_ = BPLocale.getItem("keyboard_key_" + param1.toString());
            }
            if(!_loc2_ || _loc2_ == "")
            {
               _loc2_ = String.fromCharCode(param1);
            }
         }
         return _loc2_;
      }
   }
}

