package net.bigpoint.darkorbit.managers.keyboardManager.commands
{
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.map.model.Map;
   
   public class PlaySoundEffectCommand implements IKeyboardCommand
   {
      
      public static const NAME:String = "playSoundEffect";
      
      public function PlaySoundEffectCommand()
      {
         super();
      }
      
      public function execute(param1:Map, param2:Vector.<String>) : void
      {
         AudioManager.playSoundEffect(int(param2[0]));
      }
   }
}

