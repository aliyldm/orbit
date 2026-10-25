package net.bigpoint.darkorbit.mvc.hintSystem.model.content.gameentry
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.com.module.HintWindowAddComand;
   import net.bigpoint.darkorbit.mvc.hintSystem.model.content.AbstractHintContentDescription;
   import net.bigpoint.darkorbit.mvc.hintSystem.model.content.IHintSystemContentDescription;
   import net.bigpoint.darkorbit.mvc.hintSystem.model.vo.HintSystemContentVO;
   
   public class HintSystemHowToFlyContentDescription extends AbstractHintContentDescription implements IHintSystemContentDescription
   {
      
      private static const RESKEY:String = "HintSystemHowToFlyContentDescription";
      
      public function HintSystemHowToFlyContentDescription(param1:String)
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
         if(_content == null)
         {
            _loc1_ = new HintSystemContentVO();
            _loc1_.title = BPLocale.getItem("gameentry_hintwindow_title_howtofly");
            _loc1_.message = getFactionRelatedMessageText("gameentry_hintwindow_message_howtofly_minimap");
            _loc1_.viewState = HintWindowAddComand.HINTWINDOWVISIBILITY_OPEN;
            _loc1_.playlistVO = getParsedPlaylist();
            _content = _loc1_;
         }
         return _content;
      }
      
      override public function get sortOrder() : int
      {
         return 200;
      }
   }
}

