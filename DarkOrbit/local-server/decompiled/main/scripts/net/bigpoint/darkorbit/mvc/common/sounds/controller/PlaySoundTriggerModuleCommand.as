package net.bigpoint.darkorbit.mvc.common.sounds.controller
{
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.com.module.SoundTriggerModule;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class PlaySoundTriggerModuleCommand extends SimpleCommand
   {
      
      public function PlaySoundTriggerModuleCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:SoundTriggerModule = param1.getBody() as SoundTriggerModule;
         if(_loc2_.playSound)
         {
            AudioManager.playSoundEffect(_loc2_.soundId);
         }
      }
   }
}

