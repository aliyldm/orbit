package net.bigpoint.darkorbit.mvc.gui.highlights.view
{
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.mvc.gui.highlights.model.HighlightItemVO;
   
   public class FlashHighlightWithSound extends FlashHighlight
   {
      
      public function FlashHighlightWithSound()
      {
         super();
      }
      
      override public function decorateUiElement(param1:Object, param2:HighlightItemVO) : void
      {
         super.decorateUiElement(param1,param2);
         AudioManager.playSoundEffect(InGameCatalog.SOUND_ID_COOLDOWN_FINISHED);
      }
   }
}

