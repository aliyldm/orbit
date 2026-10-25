package net.bigpoint.darkorbit.mvc.hintSystem.model.content.targets
{
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.mvc.hintSystem.HintSystemConstants;
   import net.bigpoint.darkorbit.mvc.hintSystem.model.content.AbstractHintContentDescription;
   import net.bigpoint.darkorbit.mvc.hintSystem.model.vo.HintSystemButtonActionDescriptionVO;
   import net.bigpoint.darkorbit.mvc.hintSystem.model.vo.HintSystemContentVO;
   import net.bigpoint.darkorbit.net.JavascriptCallVO;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class HintSystemGalaxyGatesContentDescription extends AbstractHintContentDescription
   {
      
      private static const RESKEY:String = "HintSystemGalaxyGatesContentDescription";
      
      private static const RESKEY_PAYMENTLINK:String = "HintSystemGalaxyGatesPaymentLinkContentDescription";
      
      public function HintSystemGalaxyGatesContentDescription(param1:String)
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
         var _loc1_:String = null;
         var _loc2_:JavascriptCallVO = null;
         if(_content == null)
         {
            _title = "targeted_hintwindow_title_galaxygates";
            _message = "targeted_hintwindow_message_galaxygates";
            _content = createContentVO();
            _loc1_ = Hero.factionName.toUpperCase();
            _content.message = _content.message.replace("%companyShortName%",_loc1_);
            _loc2_ = new JavascriptCallVO("internalGalaxyGates","seo_title_standard");
            _loc2_.lootID = "";
            _content.registerButtonDescription(HintSystemConstants.CONFIRMATION_BUTTON_02,new HintSystemButtonActionDescriptionVO(null,_loc2_));
         }
         return _content;
      }
      
      override public function get sortOrder() : int
      {
         return 1000;
      }
   }
}

