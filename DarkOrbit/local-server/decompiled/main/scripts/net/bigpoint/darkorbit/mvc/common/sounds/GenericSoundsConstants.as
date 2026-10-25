package net.bigpoint.darkorbit.mvc.common.sounds
{
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.com.module.PlaySoundCommand;
   
   public class GenericSoundsConstants
   {
      
      public static const GENERIC_SOUNDS_MAP:Dictionary = new Dictionary();
      
      GENERIC_SOUNDS_MAP[PlaySoundCommand.SOUNDTYPE_HELLSTORM_LAUNCHER_INITIATE_LOADING] = InGameCatalog.SOUND_ID_ROCKETS_LOAD_START;
      GENERIC_SOUNDS_MAP[PlaySoundCommand.SOUNDTYPE_HELLSTORM_LAUNCHER_LOAD] = InGameCatalog.SOUND_ID_ROCKET_LOAD;
      GENERIC_SOUNDS_MAP[PlaySoundCommand.SOUNDTYPE_HELLSTORM_LAUNCHER_FULL] = InGameCatalog.SOUND_ID_ROCKETS_LOADED;
      GENERIC_SOUNDS_MAP[PlaySoundCommand.SOUNDTYPE_NPC_SLENDER_ATTACK] = InGameCatalog.NPC_SLENDER_ATTACK;
      GENERIC_SOUNDS_MAP[PlaySoundCommand.SOUNDTYPE_NPC_SLENDER_MENACE] = InGameCatalog.NPC_SLENDER_MENACE;
      GENERIC_SOUNDS_MAP[PlaySoundCommand.SOUNDTYPE_NPC_SLENDER_REVEAL] = InGameCatalog.NPC_SLENDER_REVEAL;
      GENERIC_SOUNDS_MAP[PlaySoundCommand.SOUNDTYPE_NPC_SLENDER_VANISH] = InGameCatalog.NPC_SLENDER_VANISH;
      
      public function GenericSoundsConstants()
      {
         super();
      }
   }
}

