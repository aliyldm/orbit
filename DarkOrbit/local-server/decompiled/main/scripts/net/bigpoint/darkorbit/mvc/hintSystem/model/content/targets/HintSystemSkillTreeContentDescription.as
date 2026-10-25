package net.bigpoint.darkorbit.mvc.hintSystem.model.content.targets
{
   import net.bigpoint.darkorbit.mvc.hintSystem.HintSystemConstants;
   import net.bigpoint.darkorbit.mvc.hintSystem.model.content.AbstractHintContentDescription;
   import net.bigpoint.darkorbit.mvc.hintSystem.model.vo.HintSystemButtonActionDescriptionVO;
   import net.bigpoint.darkorbit.mvc.hintSystem.model.vo.HintSystemContentVO;
   import net.bigpoint.darkorbit.net.JavascriptCallVO;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class HintSystemSkillTreeContentDescription extends AbstractHintContentDescription
   {
      
      private static const RESKEY:String = "HintSystemSkillTreeContentDescription";
      
      private static const RESKEY_PAYMENTLINK:String = "HintSystemSkillTreePaymentLinkContentDescription";
      
      public function HintSystemSkillTreeContentDescription(param1:String)
      {
         super(param1);
      }
      
      override public function getViewStructureResKey(param1:String = "default") : String
      {
         var _loc2_:String = null;
         if(param1 == AbstractHintContentDescription.VIEWTEMPLATE_TYPE_PAYMENTLINK)
         {
            _loc2_ = Settings.dynamicHost + _content.paymentLink;
            _content.registerButtonDescription(HintSystemConstants.CONFIRMATION_BUTTON_01,new HintSystemButtonActionDescriptionVO(null,null,_loc2_));
            return RESKEY_PAYMENTLINK;
         }
         return RESKEY;
      }
      
      override public function get content() : HintSystemContentVO
      {
         var _loc1_:JavascriptCallVO = null;
         if(_content == null)
         {
            _title = "targeted_hintwindow_title_skilltree";
            _message = "targeted_hintwindow_message_skilltree";
            _content = createContentVO();
            _loc1_ = new JavascriptCallVO("internalPilotSheet","seo_title_standard","skilltree");
            _loc1_.lootID = "";
            _content.registerButtonDescription(HintSystemConstants.CONFIRMATION_BUTTON_02,new HintSystemButtonActionDescriptionVO(null,_loc1_));
         }
         return _content;
      }
      
      override public function get sortOrder() : int
      {
         return 1000;
      }
   }
}

