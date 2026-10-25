package net.bigpoint.darkorbit.refinement
{
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   
   public class RefinementLabel extends Sprite
   {
      
      private var refinementModule:RefinementModule;
      
      public var textField:TextField;
      
      public function RefinementLabel(param1:RefinementModule)
      {
         super();
         this.refinementModule = param1;
         this.init();
      }
      
      private function init() : void
      {
         var _loc1_:SWFFinisher = SWFFinisher(ResourceManager.fileCollection.getFinisher("refinement"));
         var _loc2_:Bitmap = _loc1_.getEmbeddedBitmap("labelSlot");
         this.addChild(_loc2_);
         this.textField = new TextField();
         this.textField.defaultTextFormat = Styles.logFmt;
         this.textField.embedFonts = Styles.logEmbed;
         this.textField.width = _loc2_.width;
         this.textField.multiline = false;
         this.textField.wordWrap = false;
         this.textField.autoSize = TextFieldAutoSize.CENTER;
         this.textField.textColor = 16777215;
         this.textField.antiAliasType = "advanced";
         this.textField.selectable = false;
         this.addChild(this.textField);
      }
      
      public function setText(param1:String) : void
      {
         this.textField.text = param1;
         this.textField.textColor = 16777215;
      }
   }
}

