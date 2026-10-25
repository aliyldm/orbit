package net.bigpoint.darkorbit.gui.windows.specifics
{
   import flash.events.MouseEvent;
   import flash.text.TextFormatAlign;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.gui.GuiManager;
   import net.bigpoint.darkorbit.gui.container.SimpleContainer;
   import net.bigpoint.darkorbit.gui.elements.ButtonElement;
   import net.bigpoint.darkorbit.gui.elements.ButtonElementTypes;
   import net.bigpoint.darkorbit.gui.elements.TextAreaElement;
   import net.bigpoint.darkorbit.gui.elements.VideoElement;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.gui.featuresMenu.model.vo.FeatureWindowVO;
   import net.bigpoint.darkorbit.mvc.helpwindow.HelpVideoNotification;
   
   public class HelpVideoWindow extends VideoWindow
   {
      
      private static const GAP:Number = 50;
      
      public function HelpVideoWindow(param1:GuiManager, param2:FeatureWindowVO, param3:int, param4:int, param5:int, param6:String, param7:Boolean, param8:int = 0)
      {
         super(param1,param2,param3,param4,param5,param6,param7,param8);
      }
      
      override protected function handleLastButtonClick() : void
      {
         super.handleLastButtonClick();
         GameFacade.getInstance().forwardNotification(HelpVideoNotification.SHOW);
      }
      
      override protected function getLastStateKey() : String
      {
         return "btn_lable_fix_it";
      }
      
      override protected function initVideoElement() : void
      {
         videoElement = new VideoElement(-1);
      }
      
      override protected function initFastButton(param1:SWFFinisher) : void
      {
         fasterButton = new ButtonElement(ButtonElementTypes.TYPE_TUTORIAL_FASTER,BPLocale.getItem("video_btn_showAll"),param1.getEmbeddedMovieClip("button1"));
         fasterButton.addEventListener(MouseEvent.CLICK,handleFasterButtonClick);
         fasterButton.x = width - fasterButton.width - GAP;
         fasterButton.y = height - fasterButton.height - GAP;
         fasterButton.visible = false;
         simpleContainer.addElement(fasterButton,SimpleContainer.NO_ALIGN);
      }
      
      override protected function initContinueButton(param1:SWFFinisher) : void
      {
         continueButton = new ButtonElement(ButtonElementTypes.TYPE_TUTORIAL_CONTINUE,"",param1.getEmbeddedMovieClip("button1"));
         continueButton.addEventListener(MouseEvent.CLICK,handleContinueButtonClick);
         simpleContainer.addElement(continueButton,SimpleContainer.NO_ALIGN);
         continueButton.y = height - continueButton.height - GAP;
         continueButton.visible = false;
      }
      
      override protected function initTextAreaElement() : void
      {
         textAreaElement = new TextAreaElement(width - GAP,125,TextFormatAlign.LEFT);
         simpleContainer.addElement(textAreaElement,SimpleContainer.ALIGN_HORIZONTAL);
      }
   }
}

