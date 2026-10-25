package net.bigpoint.darkorbit.mvc.hintSystem.model.content.targets
{
   import net.bigpoint.darkorbit.mvc.hintSystem.model.content.AbstractHintContentDescription;
   import net.bigpoint.darkorbit.mvc.hintSystem.model.vo.HintSystemContentVO;
   
   public class HintSystemTrainingGroundsDescription extends AbstractHintContentDescription
   {
      
      private static const RESKEY:String = "HintSystemTrainingGroundsContentDescription";
      
      public function HintSystemTrainingGroundsDescription(param1:String)
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
            _title = "targeted_hintwindow_title_traininggrounds";
            _message = "targeted_hintwindow_message_traininggrounds";
            _content = createContentVO();
         }
         return _content;
      }
      
      override public function get sortOrder() : int
      {
         return 0;
      }
   }
}

