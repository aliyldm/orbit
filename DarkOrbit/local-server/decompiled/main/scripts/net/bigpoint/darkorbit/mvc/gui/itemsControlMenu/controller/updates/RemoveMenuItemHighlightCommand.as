package net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.controller.updates
{
   import net.bigpoint.darkorbit.com.module.UIItemRemoveHighlightCommand;
   import net.bigpoint.darkorbit.com.module.UiItemSourceModule;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.featuresMenu.FeaturesMenuConstants;
   import net.bigpoint.darkorbit.mvc.gui.highlights.HighLightItemNotification;
   import net.bigpoint.darkorbit.mvc.gui.highlights.model.HighlightItemVO;
   import net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.ItemsControlMenuConstants;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class RemoveMenuItemHighlightCommand extends DOAbstractSimpleCommand
   {
      
      public function RemoveMenuItemHighlightCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:UIItemRemoveHighlightCommand = param1.getBody() as UIItemRemoveHighlightCommand;
         switch(_loc2_.itemSource.itemSource)
         {
            case UiItemSourceModule.ITEMSOURCE_FEATURE_BARS:
               sendNotification(HighLightItemNotification.REMOVE_HIGHLIGHT,new HighlightItemVO(_loc2_.itemId,FeaturesMenuConstants.MENU_ID,_loc2_.highlightType.type));
               break;
            case UiItemSourceModule.ITEMSOURCE_MENU_ITEM_BARS:
               sendNotification(HighLightItemNotification.REMOVE_HIGHLIGHT,new HighlightItemVO(_loc2_.itemId,ItemsControlMenuConstants.CATEGORY_BAR,_loc2_.highlightType.type));
               sendNotification(HighLightItemNotification.REMOVE_HIGHLIGHT,new HighlightItemVO(_loc2_.itemId,ItemsControlMenuConstants.STANDARD_SLOT_BAR,_loc2_.highlightType.type));
               sendNotification(HighLightItemNotification.REMOVE_HIGHLIGHT,new HighlightItemVO(_loc2_.itemId,ItemsControlMenuConstants.PREMIUM_SLOT_BAR,_loc2_.highlightType.type));
               sendNotification(HighLightItemNotification.REMOVE_HIGHLIGHT,new HighlightItemVO(_loc2_.itemId,ItemsControlMenuConstants.PRO_ACTION_BAR,_loc2_.highlightType.type));
               break;
            case UiItemSourceModule.ITEMSOURCE_WINDOW:
               sendNotification(HighLightItemNotification.REMOVE_HIGHLIGHT,new HighlightItemVO(_loc2_.itemId,GuiConstants.WINDOWS_ID,_loc2_.highlightType.type));
         }
      }
   }
}

