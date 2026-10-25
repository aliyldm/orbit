package net.bigpoint.darkorbit.mvc.hintSystem.controller.hintWindow
{
   import net.bigpoint.darkorbit.com.module.HighlightTypeModule;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.featuresMenu.view.FeaturesMenuMediator;
   import net.bigpoint.darkorbit.mvc.gui.featuresMenu.view.components.FeatureBtn;
   import net.bigpoint.darkorbit.mvc.gui.highlights.controller.HighlightFactory;
   import net.bigpoint.darkorbit.mvc.gui.highlights.model.HighlightItemVO;
   import net.bigpoint.darkorbit.mvc.gui.highlights.view.FlashWindowHighlight;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class HintSystemWindowCloseAnimationFinished extends SimpleCommand
   {
      
      public function HintSystemWindowCloseAnimationFinished()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc4_:FlashWindowHighlight = null;
         var _loc5_:HighlightItemVO = null;
         super.execute(param1);
         var _loc2_:FeaturesMenuMediator = facade.retrieveMediator(FeaturesMenuMediator.NAME) as FeaturesMenuMediator;
         var _loc3_:FeatureBtn = _loc2_.getGameFeatureBtnById(GuiConstants.HELP_WINDOW);
         if(_loc3_)
         {
            _loc4_ = HighlightFactory.createHighlight(HighlightTypeModule.HIGHLIGHTTYPE_FLASH_WINDOW) as FlashWindowHighlight;
            _loc5_ = new HighlightItemVO(null,null,HighlightTypeModule.HIGHLIGHTTYPE_FLASH_WINDOW,0.5);
            _loc4_.decorateUiElement(_loc3_,_loc5_);
            _loc4_.remove();
         }
      }
   }
}

