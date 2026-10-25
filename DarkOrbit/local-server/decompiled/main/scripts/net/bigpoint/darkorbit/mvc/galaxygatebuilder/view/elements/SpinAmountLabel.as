package net.bigpoint.darkorbit.mvc.galaxygatebuilder.view.elements
{
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.text.TextField;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   
   public class SpinAmountLabel extends Sprite
   {
      
      private var bg:Bitmap;
      
      private var _text:String;
      
      private var labelTxt:TextField;
      
      public function SpinAmountLabel()
      {
         super();
         var _loc1_:AssetsProxy = GameFacade.getInstance().retrieveProxy(AssetsProxy.NAME) as AssetsProxy;
         var _loc2_:SWFFinisher = SWFFinisher(_loc1_.getLib("common"));
         this.bg = _loc2_.getEmbeddedBitmap("spinAmount_label_bg");
         addChild(this.bg);
         this.labelTxt = new TextField();
         this.labelTxt.defaultTextFormat = Styles.spinAmountLabelFmt;
         this.labelTxt.embedFonts = Styles.spinAmountLabelEmbed;
         this.labelTxt.height = 20;
         this.labelTxt.width = 140;
         this.labelTxt.selectable = false;
         this.labelTxt.x = 44;
         this.labelTxt.y = 9;
         this.labelTxt.mouseEnabled = false;
         addChild(this.labelTxt);
         mouseEnabled = false;
      }
      
      public function set text(param1:String) : void
      {
         this._text = param1;
         this.labelTxt.text = this._text;
      }
   }
}

