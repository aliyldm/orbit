package net.bigpoint.darkorbit.mvc.soundTool.view
{
   import mx.core.IFlexModuleFactory;
   import net.bigpoint.darkorbit.audio.AudioManager;
   
   public class MusicListItemRenderer extends SoundListItemRenderer
   {
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      public function MusicListItemRenderer()
      {
         super();
         mx_internal::_document = this;
      }
      
      override public function set moduleFactory(param1:IFlexModuleFactory) : void
      {
         super.moduleFactory = param1;
         if(this.__moduleFactoryInitialized)
         {
            return;
         }
         this.__moduleFactoryInitialized = true;
      }
      
      override public function initialize() : void
      {
         super.initialize();
      }
      
      override protected function playSound() : void
      {
         AudioManager.stopMusic();
         AudioManager.loadMusic(pattern.getPatternID());
      }
      
      override protected function getButtonText() : String
      {
         return "Update";
      }
   }
}

