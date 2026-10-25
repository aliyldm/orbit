package net.bigpoint.darkorbit.net.netty.handlers
{
   import flash.utils.Dictionary;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.com.module.PopupErrorMessageCommand;
   import net.bigpoint.darkorbit.fui.system.utils.FuiPopUpUtils;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class PopupErrorMessageCommandHandler extends DOAbstractSimpleCommand
   {
      
      private static var _messageKeys:Dictionary = null;
      
      public function PopupErrorMessageCommandHandler()
      {
         super();
      }
      
      private static function initKeys() : void
      {
         _messageKeys = new Dictionary();
         _messageKeys[PopupErrorMessageCommand.ERROR_CODE_ASSEMBLY_GENERAL_ERROR] = "error_bswin_unspecified";
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:PopupErrorMessageCommand = param1.getBody() as PopupErrorMessageCommand;
         if(_loc2_ == null)
         {
            return;
         }
         if(_messageKeys == null)
         {
            initKeys();
         }
         FuiPopUpUtils.createPopupLoadSkin(GuiConstants.POPUP_GENERIC_ICON_OK,null,null,this.getMessage(_messageKeys[_loc2_.errorCode]),FuiPopUpUtils.POPUP_ICON_SKIN_ERROR);
      }
      
      private function getMessage(param1:String) : String
      {
         var _loc2_:String = null;
         var _loc4_:String = null;
         var _loc3_:Array = param1.split(":");
         if(_loc3_.length > 1)
         {
            _loc2_ = _loc3_[0];
            _loc4_ = _loc3_[1];
            return BPLocale.getItemInCategory(_loc4_,_loc2_);
         }
         return BPLocale.getItem(param1);
      }
   }
}

