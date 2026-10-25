package net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.controller.updates
{
   import net.bigpoint.darkorbit.com.module.UIItemAddHighlightCommand;
   import net.bigpoint.darkorbit.com.module.UiItemSourceModule;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.common.sounds.SoundNotifications;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.featuresMenu.FeaturesMenuConstants;
   import net.bigpoint.darkorbit.mvc.gui.highlights.HighLightItemNotification;
   import net.bigpoint.darkorbit.mvc.gui.highlights.model.HighlightItemVO;
   import net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.ItemsControlMenuConstants;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class AddMenuItemHighlightCommand extends DOAbstractSimpleCommand
   {
      
      public function AddMenuItemHighlightCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:UIItemAddHighlightCommand = param1.getBody() as UIItemAddHighlightCommand;
         var _loc3_:String = "";
         switch(_loc2_.itemSource.itemSource)
         {
            case UiItemSourceModule.ITEMSOURCE_FEATURE_BARS:
               _loc3_ = FeaturesMenuConstants.MENU_ID;
               break;
            case UiItemSourceModule.ITEMSOURCE_MENU_ITEM_BARS:
               _loc3_ = ItemsControlMenuConstants.MENU_ID;
               break;
            case UiItemSourceModule.ITEMSOURCE_WINDOW:
               _loc3_ = GuiConstants.WINDOWS_ID;
         }
         sendNotification(HighLightItemNotification.ADD_HIGHLIGHT,new HighlightItemVO(_loc2_.itemId,_loc3_,_loc2_.highlightType.type));
         sendNotification(SoundNotifications.PLAY_SOUND_TRIGGER_MODULE,_loc2_.soundModule);
      }
   }
}

