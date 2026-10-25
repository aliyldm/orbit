package net.bigpoint.darkorbit.mvc.mapElements.common.controller
{
   import net.bigpoint.darkorbit.com.module.MapAssetIconAddHighlightCommand;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.traits.clickIcon.ClickIconTrait;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.common.sounds.SoundNotifications;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class MapAssetIconAddHighlightHandlerCommand extends DOAbstractSimpleCommand
   {
      
      public function MapAssetIconAddHighlightHandlerCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc4_:ClickIconTrait = null;
         var _loc2_:MapAssetIconAddHighlightCommand = param1.getBody() as MapAssetIconAddHighlightCommand;
         var _loc3_:MapEntity = screenManager.map.getEntityById(_loc2_.mapAssetId);
         if(_loc3_)
         {
            _loc4_ = _loc3_.getFirstTrait(ClickIconTrait) as ClickIconTrait;
            if(_loc4_)
            {
               _loc4_.highlight.value = true;
            }
            sendNotification(SoundNotifications.PLAY_SOUND_TRIGGER_MODULE,_loc2_.soundModule);
         }
      }
   }
}

