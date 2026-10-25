package net.bigpoint.darkorbit.mvc.hintSystem.model.content.targets
{
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.mvc.hintSystem.HintSystemConstants;
   import net.bigpoint.darkorbit.mvc.hintSystem.model.content.AbstractHintContentDescription;
   import net.bigpoint.darkorbit.mvc.hintSystem.model.vo.HintSystemButtonActionDescriptionVO;
   import net.bigpoint.darkorbit.mvc.hintSystem.model.vo.HintSystemContentVO;
   
   public class HintSystemAsseblyContentDescription extends AbstractHintContentDescription
   {
      
      private static const RESKEY:String = "HintSystemAssemblyContentDescription";
      
      public function HintSystemAsseblyContentDescription(param1:String)
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
         if(_content == null)
         {
            _title = "targeted_hintwindow_title_assembly";
            _message = "targeted_hintwindow_message_assembly";
            _content = createContentVO();
            _loc1_ = Hero.factionName.toUpperCase();
            _content.message = _content.message.replace("%companyShortName%",_loc1_);
            _content.registerButtonDescription(HintSystemConstants.CONFIRMATION_BUTTON_02,new HintSystemButtonActionDescriptionVO(null,null));
         }
         return _content;
      }
      
      override public function get sortOrder() : int
      {
         return 1000;
      }
   }
}

