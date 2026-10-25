package net.bigpoint.darkorbit.mvc.jackpotBattle.statusWin.view.decorator
{
   import com.bigpoint.utils.TimeFormatter;
   import flash.text.TextFormat;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.gui.container.SimpleContainer;
   import net.bigpoint.darkorbit.gui.elements.TextFieldElement;
   
   public class JackpotStatusFooterDecorator
   {
      
      private static const MARGIN:int = 10;
      
      private var _width:int;
      
      private var _height:int;
      
      private var _warningText:String = "";
      
      private var _remainingTimeText:String = "";
      
      private var _delegatesWarning:Array = new Array();
      
      private var _delegatesText:Array = new Array();
      
      private var _remainingTimeTextfield:TextFieldElement;
      
      private var _warningTextfield:TextFieldElement;
      
      private var _footerContainer:SimpleContainer;
      
      public function JackpotStatusFooterDecorator(param1:SimpleContainer, param2:int, param3:int)
      {
         super();
         this.initTextDelegate();
         this.initWarningDelegate();
         this._height = param3;
         this._width = param2;
         this._footerContainer = param1;
         this.createFooter();
      }
      
      private function initWarningDelegate() : void
      {
         this._delegatesWarning[JackpotStatusUiDecorator.WILDCARD] = "";
         this._delegatesWarning[JackpotStatusUiDecorator.FIGHTING] = BPLocale.getItem("jackpot_status_window_about_to_end_message");
         this._delegatesWarning[JackpotStatusUiDecorator.WAINTING] = "";
         this._delegatesWarning[JackpotStatusUiDecorator.SCHEDULED] = BPLocale.getItem("jackpot_status_window_about_to_begin_message");
      }
      
      private function initTextDelegate() : void
      {
         this._delegatesText[JackpotStatusUiDecorator.WILDCARD] = BPLocale.getItem("jackpot_status_window_remaining_wildcard_time_message");
         this._delegatesText[JackpotStatusUiDecorator.FIGHTING] = BPLocale.getItem("jackpot_status_window_remaining_fight_time_message");
         this._delegatesText[JackpotStatusUiDecorator.WAINTING] = BPLocale.getItem("jackpot_status_window_remaining_wait_time_message");
         this._delegatesText[JackpotStatusUiDecorator.SCHEDULED] = BPLocale.getItem("jackpot_status_window_remaining_time_message");
      }
      
      private function createFooter() : void
      {
         this.addRemainingTimeTextfield();
         this.addWarningTextfield();
      }
      
      private function addWarningTextfield() : void
      {
         var _loc1_:TextFormat = new TextFormat(Styles.corporateFontHeavy,Styles.simpleFontHeight,16711680);
         _loc1_.leftMargin = MARGIN;
         _loc1_.rightMargin = MARGIN;
         this._warningTextfield = new TextFieldElement(this._width,20,_loc1_,this._warningText);
         this._warningTextfield.visible = false;
         this._footerContainer.addElement(this._warningTextfield,SimpleContainer.ALIGN_VERTICAL);
      }
      
      private function addRemainingTimeTextfield() : void
      {
         var _loc1_:TextFormat = new TextFormat(Styles.corporateFontHeavy,Styles.simpleFontHeight,Styles.WHITE);
         _loc1_.leftMargin = MARGIN;
         _loc1_.rightMargin = MARGIN;
         this._remainingTimeTextfield = new TextFieldElement(this._width,40,_loc1_);
         this._remainingTimeTextfield.textField.multiline = true;
         this._remainingTimeTextfield.textField.wordWrap = true;
         this._footerContainer.addElement(this._remainingTimeTextfield,SimpleContainer.ALIGN_VERTICAL);
      }
      
      public function get warningTextfield() : TextFieldElement
      {
         return this._warningTextfield;
      }
      
      public function get remainingTimeTextfield() : TextFieldElement
      {
         return this._remainingTimeTextfield;
      }
      
      public function updateRemainingTime(param1:int) : void
      {
         var _loc2_:String = this._remainingTimeText.replace(/%TIME%/,TimeFormatter.formatTime(param1));
         this._remainingTimeTextfield.updateText(_loc2_);
      }
      
      public function changeRemainingTimeType(param1:int) : void
      {
         this._remainingTimeText = this._delegatesText[param1] ? this._delegatesText[param1] : this._remainingTimeText;
         this._warningText = this._delegatesWarning[param1] ? this._delegatesWarning[param1] : this._warningText;
         this._warningTextfield.updateText(this._warningText);
      }
   }
}

