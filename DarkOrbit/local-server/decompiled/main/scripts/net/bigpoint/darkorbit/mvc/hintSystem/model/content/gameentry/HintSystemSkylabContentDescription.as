package net.bigpoint.darkorbit.mvc.hintSystem.model.content.gameentry
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.com.module.HintWindowAddComand;
   import net.bigpoint.darkorbit.mvc.hintSystem.HintSystemConstants;
   import net.bigpoint.darkorbit.mvc.hintSystem.model.content.AbstractHintContentDescription;
   import net.bigpoint.darkorbit.mvc.hintSystem.model.vo.HintSystemButtonActionDescriptionVO;
   import net.bigpoint.darkorbit.mvc.hintSystem.model.vo.HintSystemContentVO;
   import net.bigpoint.darkorbit.net.JavascriptCallVO;
   
   public class HintSystemSkylabContentDescription extends AbstractHintContentDescription
   {
      
      private static const RESKEY:String = "HintSystemSkylabContentDescription";
      
      public function HintSystemSkylabContentDescription(param1:String)
      {
         super(param1);
      }
      
      override public function getViewStructureResKey(param1:String = "default") : String
      {
         return RESKEY;
      }
      
      override public function get content() : HintSystemContentVO
      {
         var _loc1_:HintSystemContentVO = null;
         var _loc2_:JavascriptCallVO = null;
         if(_content == null)
         {
            _loc1_ = new HintSystemContentVO();
            _loc1_.title = BPLocale.getItem("gameentry_hintwindow_title_skylab");
            _loc1_.message = getFactionRelatedMessageText("gameentry_hintwindow_message_skylab");
            _loc1_.viewState = HintWindowAddComand.HINTWINDOWVISIBILITY_OPEN;
            _loc1_.playlistVO = getParsedPlaylist();
            _loc2_ = new JavascriptCallVO("internalSkylab","seo_title_skylab","");
            _loc2_.lootID = "";
            _loc1_.registerButtonDescription(HintSystemConstants.CONFIRMATION_BUTTON_02,new HintSystemButtonActionDescriptionVO(null,_loc2_));
            _content = _loc1_;
         }
         return _content;
      }
      
      override public function get sortOrder() : int
      {
         return 1800;
      }
   }
}

