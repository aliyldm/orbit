package net.bigpoint.darkorbit.mvc.hintSystem.controller
{
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.com.module.HintWindowAddComand;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class HintSystemPlayHintSoundCommand extends SimpleCommand
   {
      
      public function HintSystemPlayHintSoundCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:int = InGameCatalog.SOUND_ID_SHOW_HINT;
         var _loc3_:HintWindowAddComand = param1.getBody() as HintWindowAddComand;
         if(_loc3_)
         {
            if(_loc3_.soundModule.playSound)
            {
               _loc2_ = _loc3_.soundModule.soundId;
            }
         }
         AudioManager.playSoundEffect(_loc2_);
      }
   }
}

