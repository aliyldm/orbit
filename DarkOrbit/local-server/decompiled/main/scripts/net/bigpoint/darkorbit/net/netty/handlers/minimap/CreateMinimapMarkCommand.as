package net.bigpoint.darkorbit.net.netty.handlers.minimap
{
   import net.bigpoint.darkorbit.com.module.CreateMinimapMark;
   import net.bigpoint.darkorbit.map.model.minimap.MarkerVO;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.common.sounds.SoundNotifications;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class CreateMinimapMarkCommand extends DOAbstractSimpleCommand
   {
      
      public function CreateMinimapMarkCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:CreateMinimapMark = param1.getBody() as CreateMinimapMark;
         if(_loc2_.positionX >= 0 && _loc2_.positionY >= 0)
         {
            screenManager.minimap.addMapMarker(new MarkerVO(_loc2_.uid,_loc2_.positionX,_loc2_.positionY,_loc2_.count,"",_loc2_.interval,_loc2_.scale,_loc2_.inverse));
            sendNotification(SoundNotifications.PLAY_SOUND_TRIGGER_MODULE,_loc2_.soundModule);
         }
      }
   }
}

