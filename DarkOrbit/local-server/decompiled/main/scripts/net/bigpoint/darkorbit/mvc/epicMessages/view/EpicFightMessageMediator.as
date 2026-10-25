package net.bigpoint.darkorbit.mvc.epicMessages.view
{
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.mvc.abstract.view.DOAbstractMediator;
   import net.bigpoint.darkorbit.mvc.epicMessages.EpicFightNotifications;
   import net.bigpoint.darkorbit.mvc.traininggrounds.model.EpicMessageVo;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class EpicFightMessageMediator extends DOAbstractMediator
   {
      
      public static const NAME:String = "EpicFightMessageMediator";
      
      private var _timeoutID:uint;
      
      public function EpicFightMessageMediator(param1:String, param2:Object)
      {
         super(param1,param2);
         mapNotificationToMethod(EpicFightNotifications.SHOW_MESSAGE,this.updateDisplayedText);
      }
      
      private function get view() : EpicFightMessageContainer
      {
         return viewComponent as EpicFightMessageContainer;
      }
      
      override public function onRegister() : void
      {
         super.onRegister();
      }
      
      override public function onRemove() : void
      {
         MovieClipUtils.removeDisplayObject(this.view);
         super.onRemove();
      }
      
      private function updateDisplayedText(param1:INotification) : void
      {
         var _loc2_:EpicMessageVo = null;
         if(!this.view.parent)
         {
            ScreenManager.getWindowLayer().addChild(this.view);
         }
         _loc2_ = param1.getBody() as EpicMessageVo;
         this.view.updateDisplayedText(_loc2_.message);
         this.view.x = ScreenManager.halfScreenWidth - 0.5 * this.view.width;
         this.view.y = ScreenManager.halfScreenHeight * 0.5;
         clearTimeout(this._timeoutID);
         this._timeoutID = setTimeout(this.view.hideMessage,_loc2_.duration);
         if(_loc2_.soundID != -1)
         {
            AudioManager.playSoundEffect(_loc2_.soundID);
         }
      }
   }
}

