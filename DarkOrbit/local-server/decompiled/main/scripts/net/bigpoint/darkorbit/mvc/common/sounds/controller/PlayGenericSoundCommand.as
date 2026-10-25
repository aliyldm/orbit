package net.bigpoint.darkorbit.mvc.common.sounds.controller
{
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.com.module.PlaySoundCommand;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.common.sounds.GenericSoundsConstants;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class PlayGenericSoundCommand extends DOAbstractSimpleCommand
   {
      
      public function PlayGenericSoundCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:PlaySoundCommand = param1.getBody() as PlaySoundCommand;
         var _loc3_:int = int(int(GenericSoundsConstants.GENERIC_SOUNDS_MAP[_loc2_.soundType]) || 0);
         if(_loc3_)
         {
            AudioManager.playSoundEffect(_loc3_);
         }
      }
   }
}

