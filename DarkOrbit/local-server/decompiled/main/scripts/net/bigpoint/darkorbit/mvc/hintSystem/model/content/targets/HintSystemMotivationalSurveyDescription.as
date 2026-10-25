package net.bigpoint.darkorbit.mvc.hintSystem.model.content.targets
{
   import net.bigpoint.darkorbit.mvc.hintSystem.HintSystemConstants;
   import net.bigpoint.darkorbit.mvc.hintSystem.controller.hintWindow.OpenMotivationalSurveyCommand;
   import net.bigpoint.darkorbit.mvc.hintSystem.model.content.AbstractHintContentDescription;
   import net.bigpoint.darkorbit.mvc.hintSystem.model.vo.HintSystemButtonActionDescriptionVO;
   import net.bigpoint.darkorbit.mvc.hintSystem.model.vo.HintSystemContentVO;
   
   public class HintSystemMotivationalSurveyDescription extends AbstractHintContentDescription
   {
      
      private static const RESKEY:String = "HintSystemMotivationalSurveyDescription";
      
      public function HintSystemMotivationalSurveyDescription(param1:String)
      {
         super(param1);
      }
      
      override public function getViewStructureResKey(param1:String = "default") : String
      {
         return RESKEY;
      }
      
      override public function get content() : HintSystemContentVO
      {
         if(_content == null)
         {
            _title = "targeted_hintwindow_title_motivationalSurvey";
            _message = "targeted_hintwindow_message_motivationalSurvey_pay_feature_analysis";
            _content = createContentVO();
            _content.registerButtonDescription(HintSystemConstants.CONFIRMATION_BUTTON_01,new HintSystemButtonActionDescriptionVO(OpenMotivationalSurveyCommand));
            _content.registerButtonDescription(HintSystemConstants.CONFIRMATION_BUTTON_02,new HintSystemButtonActionDescriptionVO());
         }
         return _content;
      }
      
      override public function get sortOrder() : int
      {
         return 0;
      }
   }
}

