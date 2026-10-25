package net.bigpoint.darkorbit.audio
{
   import com.greensock.TweenLite;
   import flash.events.Event;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.media.SoundTransform;
   import flash.utils.Dictionary;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.Main;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.model.Map;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   import net.bigpoint.darkorbit.settings.Settings;
   import net.bigpoint.darkorbit.utils.math.FastMath;
   
   public class AudioManager
   {
      
      private static var main:Main;
      
      private static var musicSndChannel:SoundChannel;
      
      private static var musicSndChannelSndTransform:SoundTransform;
      
      private static var sndCnt:int;
      
      private static var musicSndChannelLoop:Boolean = true;
      
      private static var lastTrack:AudioPattern = null;
      
      private static var soundRadius:int = 800;
      
      private static var soundVolumeLevel:Number = 0.8;
      
      private static var currentlyPlayingUniqueSounds:Dictionary = new Dictionary(true);
      
      private static var currentlyPlayingStackingSounds:Vector.<SoundChannel> = new Vector.<SoundChannel>();
      
      private static var currentlyPlayingStackingSoundsPatternIDs:Vector.<int> = new Vector.<int>();
      
      private static var musicProgresses:Dictionary = new Dictionary();
      
      private static var musicTween:TweenLite = null;
      
      public static const mapManager:MapAudioManager = new MapAudioManager();
      
      public function AudioManager()
      {
         super();
      }
      
      public static function init(param1:Main) : void
      {
         main = param1;
      }
      
      public static function loadMusic(param1:int, param2:Boolean = true) : void
      {
         var typeID:int = param1;
         var loop:Boolean = param2;
         var pattern:AudioPattern = PatternManager.musicPatterns[int(typeID)];
         if(pattern == null)
         {
            pattern = PatternManager.musicPatterns[0];
         }
         if(ResourceManager.fileCollection.isLoaded(pattern.resKey))
         {
            playMusic(pattern,loop);
         }
         else
         {
            if(lastTrack)
            {
               ResourceManager.fileCollection.removeCallbacks(lastTrack.resKey,onMusicLoaded);
            }
            ResourceManager.fileCollection.load(pattern.resKey,function(param1:SWFFinisher):void
            {
               onMusicLoaded(param1,loop);
            });
         }
      }
      
      private static function switchMusicTrackTo(param1:AudioPattern, param2:Boolean = true, param3:Number = 2, param4:Number = 2, param5:Boolean = true) : void
      {
         if(musicTween == null && lastTrack != null && (param1.resKey == lastTrack.resKey || !param2 && lastTrack.getPatternID() == InGameCatalog.MUSIC_ID_COMBAT))
         {
            return;
         }
         fadeOutMusic(param3,fadeInMusic,[param4,param1,param5]);
      }
      
      public static function switchMusicTrackToId(param1:int = 0, param2:Boolean = true, param3:Number = 3, param4:Number = 2, param5:Boolean = true) : void
      {
         var _loc6_:AudioPattern = PatternManager.musicPatterns[int(param1)];
         if(_loc6_)
         {
            switchMusicTrackTo(_loc6_,param2,param3,param4,param5);
         }
      }
      
      public static function fadeOutMusic(param1:Number = 2, param2:Function = null, param3:Array = null) : void
      {
         if(param2 == null)
         {
            param2 = stopMusic;
         }
         if(param3 == null)
         {
            param3 = [];
         }
         if(musicTween != null)
         {
            musicTween.kill();
            musicTween = null;
         }
         if(musicSndChannelSndTransform)
         {
            musicTween = TweenLite.to(musicSndChannelSndTransform,param1,{
               "volume":0,
               "onComplete":param2,
               "onCompleteParams":param3,
               "onUpdate":updateMusicSoundTransform
            });
         }
         else if(param2 != null)
         {
            TweenLite.delayedCall(0,param2,param3);
         }
      }
      
      public static function fadeInMusic(param1:Number = 2, param2:AudioPattern = null, param3:Boolean = true) : void
      {
         if(param2 != null)
         {
            if(Boolean(lastTrack) && Boolean(lastTrack.resKey != param2.resKey) && musicSndChannel != null)
            {
               if(musicSndChannel.position != 0 && musicSndChannelLoop)
               {
                  musicProgresses[lastTrack.resKey] = musicSndChannel.position;
               }
               musicSndChannel.stop();
            }
            loadMusic(param2.getPatternID(),param3);
         }
         if(musicTween != null)
         {
            musicTween.kill();
            musicTween = null;
         }
         musicSndChannelSndTransform = new SoundTransform(0,0);
         if(musicSndChannelSndTransform)
         {
            musicTween = TweenLite.to(musicSndChannelSndTransform,param1,{
               "volume":param2.getVolume() * (Settings.musicVolume / 50),
               "onUpdate":updateMusicSoundTransform,
               "onComplete":clearMusicTween
            });
         }
      }
      
      private static function clearMusicTween() : void
      {
         if(musicTween != null)
         {
            musicTween.kill();
            musicTween = null;
         }
      }
      
      private static function updateMusicSoundTransform() : void
      {
         if(musicSndChannel)
         {
            musicSndChannel.soundTransform = musicSndChannelSndTransform;
         }
      }
      
      public static function stopMusic() : void
      {
         if(musicTween != null)
         {
            musicTween.kill();
            musicTween = null;
         }
         if(musicSndChannel != null)
         {
            if(lastTrack != null && (musicSndChannel.position != 0 && musicSndChannelLoop))
            {
               musicProgresses[lastTrack.resKey] = musicSndChannel.position;
            }
            musicSndChannel.stop();
            musicSndChannel = null;
         }
         lastTrack = null;
      }
      
      private static function onMusicLoaded(param1:SWFFinisher, param2:Boolean = true) : void
      {
         var _loc3_:AudioPattern = null;
         for each(_loc3_ in PatternManager.musicPatterns)
         {
            if(_loc3_.resKey == param1.fileVO.id)
            {
               playMusic(_loc3_,param2);
            }
         }
      }
      
      private static function playMusic(param1:AudioPattern, param2:Boolean = true) : void
      {
         if(lastTrack != null && lastTrack.resKey == param1.resKey)
         {
            return;
         }
         if(musicSndChannel != null)
         {
            if(lastTrack != null && musicSndChannel.position != 0 && musicSndChannelLoop)
            {
               musicProgresses[lastTrack.resKey] = musicSndChannel.position;
            }
            musicSndChannel.stop();
         }
         var _loc3_:SWFFinisher = SWFFinisher(ResourceManager.fileCollection.getFinisher(param1.resKey));
         lastTrack = param1;
         var _loc4_:Number = 0;
         if(musicProgresses[param1.resKey] is Number)
         {
            _loc4_ = Number(musicProgresses[param1.resKey]);
         }
         if(musicSndChannelSndTransform == null)
         {
            musicSndChannelSndTransform = new SoundTransform(param1.getVolume() * (Settings.musicVolume / 50),0);
         }
         musicSndChannelLoop = param2;
         var _loc5_:Number = param2 ? int.MAX_VALUE : 0;
         var _loc6_:Sound = Sound(_loc3_.getEmbeddedSound("track"));
         musicSndChannel = _loc6_.play(0,_loc5_,musicSndChannelSndTransform);
      }
      
      public static function updateMusicVolume() : void
      {
         if(musicSndChannel != null && lastTrack != null)
         {
            if(musicTween)
            {
               musicTween.complete();
               clearMusicTween();
            }
            musicSndChannel.soundTransform = new SoundTransform(lastTrack.getVolume() * (Settings.musicVolume / 50),0);
         }
      }
      
      public static function updateSoundVolume() : void
      {
         var _loc1_:String = null;
         var _loc2_:int = 0;
         var _loc3_:SoundChannel = null;
         var _loc4_:Number = NaN;
         var _loc5_:SoundChannel = null;
         var _loc6_:Number = NaN;
         for(_loc1_ in currentlyPlayingUniqueSounds)
         {
            _loc3_ = currentlyPlayingUniqueSounds[_loc1_];
            if((PatternManager.soundPatterns[_loc1_] as AudioPattern).isVoice())
            {
               _loc4_ = (PatternManager.soundPatterns[_loc1_] as AudioPattern).getVolume() * soundVolumeLevel * (Settings.voiceVolume / 100);
            }
            else
            {
               _loc4_ = (PatternManager.soundPatterns[_loc1_] as AudioPattern).getVolume() * soundVolumeLevel * (Settings.soundVolume / 100);
            }
            _loc3_.soundTransform = new SoundTransform(_loc4_,0);
         }
         _loc2_ = 0;
         while(_loc2_ < currentlyPlayingStackingSounds.length)
         {
            _loc5_ = currentlyPlayingStackingSounds[_loc2_];
            if((PatternManager.soundPatterns[currentlyPlayingStackingSoundsPatternIDs[_loc2_]] as AudioPattern).isVoice())
            {
               _loc6_ = (PatternManager.soundPatterns[currentlyPlayingStackingSoundsPatternIDs[_loc2_]] as AudioPattern).getVolume() * soundVolumeLevel * (Settings.voiceVolume / 100);
            }
            else
            {
               _loc6_ = (PatternManager.soundPatterns[currentlyPlayingStackingSoundsPatternIDs[_loc2_]] as AudioPattern).getVolume() * soundVolumeLevel * (Settings.soundVolume / 100);
            }
            _loc5_.soundTransform = new SoundTransform(_loc6_,0);
            _loc2_++;
         }
      }
      
      public static function playSoundEffect(param1:int, param2:Boolean = false, param3:Boolean = false, param4:int = -1, param5:int = -1, param6:Boolean = true, param7:Boolean = false) : SoundChannel
      {
         var _loc12_:SoundChannel = null;
         var _loc13_:Number = NaN;
         var _loc16_:Ship = null;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc20_:Number = NaN;
         if(!param6 && sndCnt > 10)
         {
            return null;
         }
         if(param7 && Boolean(currentlyPlayingUniqueSounds[param1]))
         {
            return currentlyPlayingUniqueSounds[param1];
         }
         if(PatternManager.soundPatterns == null)
         {
            return null;
         }
         var _loc9_:AudioPattern = PatternManager.soundPatterns[param1];
         if(!Settings.playSFX.value && !_loc9_.isVoice())
         {
            return null;
         }
         if(!Settings.playVoice.value && _loc9_.isVoice())
         {
            return null;
         }
         var _loc10_:SWFFinisher = SWFFinisher(ResourceManager.fileCollection.getFinisher(_loc9_.soundbank));
         if(!_loc10_ || !_loc10_.isFinished)
         {
            ResourceManager.loadAndCall(_loc9_.soundbank,playSoundEffect,arguments,1000);
            return null;
         }
         var _loc11_:Sound = Sound(_loc10_.getEmbeddedObject(_loc9_.resKey));
         if(_loc9_.isVoice())
         {
            _loc13_ = _loc9_.getVolume() * soundVolumeLevel * (Settings.voiceVolume / 100);
         }
         else
         {
            _loc13_ = _loc9_.getVolume() * soundVolumeLevel * (Settings.soundVolume / 100);
         }
         var _loc14_:SoundTransform = new SoundTransform(_loc13_,0);
         var _loc15_:Map = ScreenManager.getInstance().map;
         if(_loc15_ != null && param4 != -1 && param5 != -1)
         {
            _loc16_ = _loc15_.hero;
            if(_loc16_ != null)
            {
               _loc17_ = Math.pow(_loc16_.position.y - param5,2) + Math.pow(_loc16_.position.x - param4,2);
               if(_loc17_ > soundRadius * soundRadius)
               {
                  return null;
               }
               _loc18_ = FastMath.sqrt(_loc17_);
               _loc19_ = _loc13_ - _loc13_ / soundRadius * _loc18_;
               _loc14_.volume = _loc19_;
               _loc20_ = -1 * (1 / 500) * (_loc16_.position.x - param4);
               _loc14_.pan = _loc20_;
            }
         }
         if(param2)
         {
            if(param3)
            {
               _loc12_ = _loc11_.play(0,9999,_loc14_);
               TweenLite.to(_loc14_,0.75,{
                  "volume":_loc13_,
                  "onUpdate":updateChannel,
                  "onUpdateParams":[_loc12_,_loc14_]
               });
            }
            else
            {
               _loc12_ = _loc11_.play(0,9999,_loc14_);
            }
         }
         else
         {
            _loc12_ = _loc11_.play(0,0,_loc14_);
         }
         if(_loc12_ == null)
         {
            return null;
         }
         if(!param6 && !param2)
         {
            _loc12_.addEventListener(Event.SOUND_COMPLETE,soundComplete);
            _loc12_.addEventListener(Event.SOUND_COMPLETE,clearCurrentlyPlayingSound);
            ++sndCnt;
         }
         if(param7)
         {
            currentlyPlayingUniqueSounds[param1] = _loc12_;
         }
         else
         {
            currentlyPlayingStackingSounds.push(_loc12_);
            currentlyPlayingStackingSoundsPatternIDs.push(param1);
         }
         return _loc12_;
      }
      
      private static function soundComplete(param1:Event) : void
      {
         var _loc2_:SoundChannel = param1.currentTarget as SoundChannel;
         _loc2_.removeEventListener(Event.SOUND_COMPLETE,soundComplete);
         --sndCnt;
      }
      
      private static function clearCurrentlyPlayingSound(param1:Event) : void
      {
         var _loc2_:SoundChannel = param1.currentTarget as SoundChannel;
         _loc2_.removeEventListener(Event.SOUND_COMPLETE,clearCurrentlyPlayingSound);
         forgetSoundChannel(_loc2_);
      }
      
      private static function forgetSoundChannel(param1:SoundChannel) : void
      {
         var _loc2_:int = getCurrentlyPlayingSoundChannel(param1);
         if(_loc2_ != -1)
         {
            currentlyPlayingUniqueSounds[_loc2_] = null;
            delete currentlyPlayingUniqueSounds[_loc2_];
         }
         var _loc3_:* = int(currentlyPlayingStackingSounds.length - 1);
         while(_loc3_ >= 0)
         {
            if(param1 == currentlyPlayingStackingSounds[_loc3_])
            {
               currentlyPlayingStackingSounds.splice(_loc3_,1);
               currentlyPlayingStackingSoundsPatternIDs.splice(_loc3_,1);
            }
            _loc3_--;
         }
      }
      
      private static function updateChannel(param1:SoundChannel, param2:SoundTransform) : void
      {
         if(param1 != null)
         {
            param1.soundTransform = param2;
         }
      }
      
      public static function removeLoop(param1:SoundChannel, param2:Boolean = false) : void
      {
         var _loc3_:SoundTransform = null;
         if(param1 == null)
         {
            return;
         }
         forgetSoundChannel(param1);
         if(param2)
         {
            _loc3_ = param1.soundTransform;
            TweenLite.to(_loc3_,0.75,{
               "volume":0,
               "onUpdate":updateChannel,
               "onUpdateParams":[param1,_loc3_],
               "onComplete":param1.stop
            });
         }
         else
         {
            param1.stop();
         }
      }
      
      public static function removeUniqueChannelById(param1:int, param2:Boolean = false) : void
      {
         var _loc3_:SoundChannel = currentlyPlayingUniqueSounds[param1] as SoundChannel;
         if(_loc3_)
         {
            removeLoop(_loc3_,param2);
            delete currentlyPlayingUniqueSounds[param1];
         }
      }
      
      public static function cleanup() : void
      {
         var _loc1_:SoundChannel = null;
         var _loc2_:SoundChannel = null;
         for each(_loc1_ in currentlyPlayingUniqueSounds)
         {
            if(_loc1_)
            {
               removeLoop(_loc1_,false);
            }
         }
         for each(_loc2_ in currentlyPlayingStackingSounds)
         {
            if(_loc2_)
            {
               removeLoop(_loc2_,false);
            }
         }
         currentlyPlayingStackingSounds.length = 0;
         currentlyPlayingUniqueSounds = new Dictionary();
         sndCnt = 0;
      }
      
      private static function getCurrentlyPlayingSoundChannel(param1:SoundChannel) : int
      {
         var _loc2_:Object = null;
         for(_loc2_ in currentlyPlayingUniqueSounds)
         {
            if(currentlyPlayingUniqueSounds[_loc2_] == param1)
            {
               return int(_loc2_);
            }
         }
         return -1;
      }
   }
}

