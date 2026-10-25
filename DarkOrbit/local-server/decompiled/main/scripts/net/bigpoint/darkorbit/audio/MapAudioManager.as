package net.bigpoint.darkorbit.audio
{
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.map.model.Map;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class MapAudioManager
   {
      
      private var _map:Map;
      
      private var _musicTypeIDs:Array = [];
      
      private var _currentMusicTypeID:int = -1;
      
      private var _musicLoopLast:Boolean = true;
      
      private var _disableCombatMusic:Boolean;
      
      private var _timeoutPointer:uint;
      
      public function MapAudioManager()
      {
         super();
         Settings.playMusic.changed.add(this.updateMusic);
         Settings.playCombatMusic.changed.add(this.updateMusic);
         Settings.combatMusicActive.changed.add(this.updateMusic);
         Settings.combatMusicActive.value = false;
      }
      
      public function set map(param1:Map) : void
      {
         if(this._map)
         {
            this._map.mapXmlChanged.remove(this.update);
         }
         this._map = param1;
         this._map.mapXmlChanged.add(this.update);
         this.update();
      }
      
      private function update() : void
      {
         clearTimeout(this._timeoutPointer);
         this._musicTypeIDs = this._map.mapXml.attribute("music").length() ? String(this._map.mapXml.attribute("music")).split(",") : [];
         this._musicLoopLast = String(this._map.mapXml.attribute("loopLastTrack")) !== "false";
         this._disableCombatMusic = String(this._map.mapXml.attribute("disableCombatMusic")) !== "false";
         this.playNextTrack();
      }
      
      private function updateMusic() : void
      {
         if(Settings.playMusic.value)
         {
            if(Settings.playCombatMusic.value && Settings.combatMusicActive.value && !this._disableCombatMusic)
            {
               AudioManager.switchMusicTrackToId(InGameCatalog.MUSIC_ID_COMBAT,true,0.5);
            }
            else if(this._currentMusicTypeID != -1)
            {
               AudioManager.switchMusicTrackToId(this._currentMusicTypeID,true,3,3,this._musicLoopLast);
            }
            else
            {
               AudioManager.stopMusic();
            }
         }
         else
         {
            AudioManager.stopMusic();
         }
      }
      
      private function playNextTrack() : void
      {
         var _loc1_:int = 0;
         if(this._musicTypeIDs.length > 0)
         {
            this._currentMusicTypeID = this._musicTypeIDs.shift();
            this._musicLoopLast = true;
         }
         if(this._musicTypeIDs.length > 0)
         {
            _loc1_ = int(this._musicTypeIDs.shift());
            this._timeoutPointer = setTimeout(this.playNextTrack,_loc1_ * 1000);
            this._musicLoopLast = false;
         }
         this.updateMusic();
      }
   }
}

