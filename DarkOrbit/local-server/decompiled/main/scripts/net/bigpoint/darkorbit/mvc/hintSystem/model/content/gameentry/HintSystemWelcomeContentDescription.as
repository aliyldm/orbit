package net.bigpoint.darkorbit.mvc.hintSystem.model.content.gameentry
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.com.module.HintWindowAddComand;
   import net.bigpoint.darkorbit.fui.components.core.transitions.AlphaFadeEffect;
   import net.bigpoint.darkorbit.mvc.hintSystem.model.content.AbstractHintContentDescription;
   import net.bigpoint.darkorbit.mvc.hintSystem.model.content.IHintSystemContentDescription;
   import net.bigpoint.darkorbit.mvc.hintSystem.model.vo.HintSystemContentVO;
   import net.bigpoint.darkorbit.mvc.hintSystem.model.vo.HintSystemPlaylistItemVO;
   import net.bigpoint.darkorbit.mvc.hintSystem.model.vo.HintSystemPlaylistVO;
   
   public class HintSystemWelcomeContentDescription extends AbstractHintContentDescription implements IHintSystemContentDescription
   {
      
      private static const RESKEY:String = "HintSystemWelcomeContentDescription";
      
      private static const IMAGE_NAME:String = "hint-system_image_welcome_screen_";
      
      public function HintSystemWelcomeContentDescription(param1:String)
      {
         super(param1);
      }
      
      override public function getViewStructureResKey(param1:String = "default") : String
      {
         return RESKEY;
      }
      
      override public function get content() : HintSystemContentVO
      {
         var _loc1_:String = null;
         var _loc2_:HintSystemContentVO = null;
         var _loc3_:Vector.<HintSystemPlaylistItemVO> = null;
         var _loc4_:HintSystemPlaylistVO = null;
         if(_content == null)
         {
            _loc1_ = InGameCatalog.getInstance().questgiver_names[Hero.factionID.value];
            _loc2_ = new HintSystemContentVO();
            _loc2_.title = BPLocale.getItem("gameentry_hintwindow_title_welcome");
            _loc2_.message = getFactionRelatedMessageText("gameentry_hintwindow_message_welcome");
            _loc2_.message = _loc2_.message.replace("%MENTORNAME%",_loc1_);
            _loc2_.message = _loc2_.message.replace("%HERONAME%",Hero.username);
            _loc2_.viewState = HintWindowAddComand.HINTWINDOWVISIBILITY_OPEN;
            _loc3_ = new Vector.<HintSystemPlaylistItemVO>();
            _loc3_.push(this.getFactionDependedPlaylistItemVO());
            _loc4_ = new HintSystemPlaylistVO(_loc3_,false);
            _loc2_.playlistVO = _loc4_;
            _content = _loc2_;
         }
         return _content;
      }
      
      protected function getFactionDependedPlaylistItemVO() : HintSystemPlaylistItemVO
      {
         var _loc1_:String = IMAGE_NAME + Hero.factionName;
         return new HintSystemPlaylistItemVO(_loc1_,new AlphaFadeEffect(),4500);
      }
      
      override public function get sortOrder() : int
      {
         return 100;
      }
   }
}

