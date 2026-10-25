package net.bigpoint.darkorbit.mvc.tdm.statusWindow.view.decorator
{
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.gui.container.SimpleContainer;
   import net.bigpoint.darkorbit.mvc.tdm.statusWindow.TDMStatusWindowConstants;
   
   public class TDMStatusScoreContainerDecorator
   {
      
      private var _headline:TextField;
      
      private var _mmoScore:TextField;
      
      private var _eicScore:TextField;
      
      private var _vruScore:TextField;
      
      public function TDMStatusScoreContainerDecorator(param1:SimpleContainer)
      {
         super();
         this.decorate(param1);
      }
      
      private function decorate(param1:SimpleContainer) : void
      {
         this._headline = new TextField();
         this._mmoScore = new TextField();
         this._eicScore = new TextField();
         this._vruScore = new TextField();
         var _loc2_:TextFormat = new TextFormat(Styles.corporateFontHeavy,Styles.infoFieldFontHeight,Styles.WHITE,true);
         this._headline.defaultTextFormat = _loc2_;
         var _loc3_:TextFormat = new TextFormat(Styles.corporateFontHeavy,Styles.infoFieldFontHeight,Styles.repairWindowWhite,false);
         var _loc4_:TextFormat = new TextFormat(Styles.corporateFontHeavy,Styles.infoFieldFontHeight,Styles.repairWindowWhite,false);
         var _loc5_:TextFormat = new TextFormat(Styles.corporateFontHeavy,Styles.infoFieldFontHeight,Styles.repairWindowWhite,false);
         _loc3_.align = TextFormatAlign.CENTER;
         _loc4_.align = TextFormatAlign.CENTER;
         _loc5_.align = TextFormatAlign.CENTER;
         this._vruScore.defaultTextFormat = _loc5_;
         this._eicScore.defaultTextFormat = _loc4_;
         this._mmoScore.defaultTextFormat = _loc3_;
         this._headline.autoSize = TextFieldAutoSize.LEFT;
         this._headline.embedFonts = this._vruScore.embedFonts = this._eicScore.embedFonts = this._mmoScore.embedFonts = Styles.baseEmbed;
         this._headline.selectable = this._vruScore.selectable = this._eicScore.selectable = this._mmoScore.selectable = false;
         this._vruScore.width = this._eicScore.width = this._mmoScore.width = 50;
         param1.addElement(this._headline);
         param1.addElement(this._mmoScore,SimpleContainer.ALIGN_VERTICAL,10);
         param1.addElement(this._eicScore,SimpleContainer.ALIGN_HORIZONTAL,TDMStatusWindowConstants.TOTAL_SCORE_GAP);
         param1.addElement(this._vruScore,SimpleContainer.ALIGN_HORIZONTAL,TDMStatusWindowConstants.TOTAL_SCORE_GAP);
         this._vruScore.autoSize = TextFieldAutoSize.RIGHT;
         this._eicScore.autoSize = TextFieldAutoSize.CENTER;
         this._mmoScore.autoSize = TextFieldAutoSize.LEFT;
      }
      
      public function get headline() : TextField
      {
         return this._headline;
      }
      
      public function get mmoScore() : TextField
      {
         return this._mmoScore;
      }
      
      public function get eicScore() : TextField
      {
         return this._eicScore;
      }
      
      public function get vruScore() : TextField
      {
         return this._vruScore;
      }
   }
}

