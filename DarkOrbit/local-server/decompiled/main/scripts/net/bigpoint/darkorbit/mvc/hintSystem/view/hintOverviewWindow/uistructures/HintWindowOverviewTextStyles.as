package net.bigpoint.darkorbit.mvc.hintSystem.view.hintOverviewWindow.uistructures
{
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.fui.builder.repository.TextStyleRepository;
   import net.bigpoint.darkorbit.fui.builder.repository.TextStyleVO;
   
   public class HintWindowOverviewTextStyles
   {
      
      public static const eurostileT:String = "EurostileT";
      
      public static const overviewArchiveButtonFormat:TextFormat = new TextFormat(eurostileT,9,16777215,null,null,null,null,null,TextFormatAlign.CENTER);
      
      public static const overviewItemlistFormat:TextFormat = new TextFormat(eurostileT,12,11461375);
      
      public function HintWindowOverviewTextStyles()
      {
         super();
      }
      
      public static function init() : void
      {
         var _loc1_:TextStyleVO = new TextStyleVO("hintsystem_overview_itemlist");
         _loc1_.textFormat = overviewItemlistFormat;
         _loc1_.embedFonts = Styles.baseEmbed;
         _loc1_.multiline = false;
         _loc1_.wordWrap = false;
         _loc1_.selectable = false;
         _loc1_.autoSize = TextFieldAutoSize.LEFT;
         _loc1_.border = false;
         var _loc2_:TextStyleVO = new TextStyleVO("hintsystem_overview_archivebutton");
         _loc2_.textFormat = overviewArchiveButtonFormat;
         _loc2_.embedFonts = Styles.baseEmbed;
         _loc2_.multiline = false;
         _loc2_.wordWrap = true;
         _loc2_.selectable = false;
         _loc2_.autoSize = TextFieldAutoSize.CENTER;
         _loc2_.border = false;
         var _loc3_:TextStyleRepository = TextStyleRepository.getInstance();
         _loc3_.register(_loc1_);
         _loc3_.register(_loc2_);
      }
   }
}

