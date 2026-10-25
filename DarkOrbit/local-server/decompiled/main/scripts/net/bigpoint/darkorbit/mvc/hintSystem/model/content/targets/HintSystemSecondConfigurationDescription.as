package net.bigpoint.darkorbit.mvc.hintSystem.model.content.targets
{
   import net.bigpoint.darkorbit.mvc.hintSystem.HintSystemConstants;
   import net.bigpoint.darkorbit.mvc.hintSystem.model.content.AbstractHintContentDescription;
   import net.bigpoint.darkorbit.mvc.hintSystem.model.vo.HintSystemButtonActionDescriptionVO;
   import net.bigpoint.darkorbit.mvc.hintSystem.model.vo.HintSystemContentVO;
   import net.bigpoint.darkorbit.net.JavascriptCallVO;
   
   public class HintSystemSecondConfigurationDescription extends AbstractHintContentDescription
   {
      
      private static const RESKEY:String = "HintSystemSecondConfigurationDescription";
      
      public function HintSystemSecondConfigurationDescription(param1:String)
      {
         super(param1);
      }
      
      override public function getViewStructureResKey(param1:String = "default") : String
      {
         return RESKEY;
      }
      
      override public function get content() : HintSystemContentVO
      {
         var _loc1_:JavascriptCallVO = null;
         if(_content == null)
         {
            _title = "targeted_hintwindow_title_secondconfiguration";
            _message = "targeted_hintwindow_message_secondconfiguration";
            _content = createContentVO();
            _loc1_ = new JavascriptCallVO("internalDock","seo_title_standard","internalDockEquipment");
            _loc1_.lootID = "";
            _content.registerButtonDescription(HintSystemConstants.CONFIRMATION_BUTTON_01,new HintSystemButtonActionDescriptionVO(null,_loc1_));
         }
         return _content;
      }
      
      override public function get sortOrder() : int
      {
         return 1000;
      }
   }
}

