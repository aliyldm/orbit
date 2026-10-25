package net.bigpoint.darkorbit.mvc.gui.windows.connection.view.components
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.Main;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.gui.elements.*;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   
   public class ConnectionElement extends SimpleElement
   {
      
      public function ConnectionElement()
      {
         super(TYPE_CONNECTION);
         this.init();
      }
      
      private function init() : void
      {
         var _loc2_:MovieClip = null;
         var _loc1_:SWFFinisher = SWFFinisher(ResourceManager.fileCollection.getFinisher("ui"));
         _loc2_ = MovieClip(_loc1_.getEmbeddedMovieClip("connectionWindow"));
         _loc2_.mouseEnabled = Main.mouseEventsEnabled;
         _loc2_.mouseChildren = Main.mouseEventsEnabled;
         _loc2_.txtHeader.text = "";
         var _loc3_:TextField = TextField(_loc2_.txtBody);
         _loc3_.defaultTextFormat = Styles.simpleFmt;
         _loc3_.embedFonts = Styles.simpleEmbed;
         _loc3_.text = BPLocale.getItem("log_verbinde");
         var _loc4_:TextField = TextField(_loc2_.txtBottom);
         _loc4_.defaultTextFormat = Styles.simpleFmt;
         _loc4_.embedFonts = Styles.simpleEmbed;
         _loc4_.text = BPLocale.getItem("log_warten");
         _loc4_.height = Styles.simpleFontHeight + 5;
         this.addChild(_loc2_);
      }
   }
}

