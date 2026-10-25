package net.bigpoint.darkorbit.net.netty.handlers.contactlist
{
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.com.module.ContactListUpdateContactsCommand;
   import net.bigpoint.darkorbit.com.module.HighlightTypeModule;
   import net.bigpoint.darkorbit.mvc.contactsWindow.ContactsWindowNotifications;
   import net.bigpoint.darkorbit.mvc.contactsWindow.model.vo.ContactsWindowContactListEntryVO;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.featuresMenu.FeaturesMenuConstants;
   import net.bigpoint.darkorbit.mvc.gui.highlights.HighLightItemNotification;
   import net.bigpoint.darkorbit.mvc.gui.highlights.model.HighlightItemVO;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class ContactListUpdateContactsHandlerCommand extends ContactListConvertingAbstractCommand
   {
      
      public function ContactListUpdateContactsHandlerCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:ContactListUpdateContactsCommand = param1.getBody() as ContactListUpdateContactsCommand;
         var _loc3_:Vector.<ContactsWindowContactListEntryVO> = convertModuleEntryVectorIntoContactlistEntryVO(_loc2_.contacts);
         sendNotification(ContactsWindowNotifications.CONTACTS_UPDATE_FROM_SERVER,_loc3_);
      }
      
      override protected function handleTypeCommand__incomingPending(param1:ContactsWindowContactListEntryVO) : void
      {
         super.handleTypeCommand__incomingPending(param1);
         AudioManager.playSoundEffect(InGameCatalog.SOUND_ID_SHOW_HINT);
         var _loc2_:HighlightItemVO = new HighlightItemVO(GuiConstants.CONTACTLIST_WINDOW,GuiConstants.WINDOWS_ID,HighlightTypeModule.HIGHLIGHTTYPE_FLASH_WINDOW,0,10);
         var _loc3_:HighlightItemVO = new HighlightItemVO(GuiConstants.CONTACTLIST_WINDOW,FeaturesMenuConstants.MENU_ID,HighlightTypeModule.HIGHLIGHTTYPE_FLASH_WINDOW,0,10);
         facade.sendNotification(HighLightItemNotification.ADD_HIGHLIGHT,_loc2_);
         facade.sendNotification(HighLightItemNotification.ADD_HIGHLIGHT,_loc3_);
      }
      
      override protected function throwAnErrorIfAbstract() : void
      {
      }
   }
}

