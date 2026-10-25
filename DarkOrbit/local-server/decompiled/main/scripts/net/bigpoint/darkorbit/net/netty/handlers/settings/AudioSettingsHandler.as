package net.bigpoint.darkorbit.net.netty.handlers.settings
{
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.com.module.AudioSettingsModule;
   import net.bigpoint.darkorbit.gui.SettingsWindowDecorator;
   import net.bigpoint.darkorbit.mvc.common.AssetNotifications;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class AudioSettingsHandler extends BaseHandler
   {
      
      private static var lastSavedSetting:AudioSettingsModule = null;
      
      public function AudioSettingsHandler()
      {
         super();
      }
      
      public static function run(param1:AudioSettingsModule, param2:Boolean = false) : void
      {
         if(!param2)
         {
            lastSavedSetting = param1;
         }
         var _loc3_:Boolean = Settings.soundVolume != param1.sound || Settings.voiceVolume != param1.voice;
         var _loc4_:Boolean = Settings.musicVolume != param1.music;
         Settings.soundVolume = param1.sound;
         Settings.playSFX.value = Settings.soundVolume > 1;
         Settings.musicVolume = param1.music;
         Settings.playMusic.value = Settings.musicVolume > 1;
         Settings.voiceVolume = param1.voice;
         Settings.playVoice.value = Settings.voiceVolume > 1;
         Settings.playCombatMusic.value = param1.playCombatMusic;
         if(SettingsWindowDecorator.getInstance())
         {
            SettingsWindowDecorator.getInstance().updateAudioSliderValues();
         }
         if(_loc4_)
         {
            AudioManager.updateMusicVolume();
         }
         if(_loc3_)
         {
            if(Settings.playSFX.value || Settings.playVoice.value)
            {
               _facade.sendNotification(AssetNotifications.PRELOAD_LIST,"sounds",AssetNotifications.TYPE_PRELOAD_LIST_TYPE_PATTERN_KEY);
            }
            AudioManager.updateSoundVolume();
         }
      }
      
      public static function updateLastSavedSettings(param1:AudioSettingsModule) : void
      {
         lastSavedSetting = param1;
      }
      
      public static function restoreLastSavedSettings() : void
      {
         if(lastSavedSetting != null)
         {
            run(lastSavedSetting);
         }
      }
   }
}

