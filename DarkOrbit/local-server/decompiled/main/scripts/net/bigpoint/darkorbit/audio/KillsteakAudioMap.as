package net.bigpoint.darkorbit.audio
{
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.InGameCatalog;
   
   public class KillsteakAudioMap
   {
      
      public static const map:Dictionary = new Dictionary();
      
      public static const tripleKillKey:String = "epic_msg_killstreak_triplekill";
      
      public static const unstoppableKey:String = "epic_msg_killstreak_unstoppable";
      
      public static const godlikeKey:String = "epic_msg_killstreak_godlike";
      
      public static const likeABossKey:String = "epic_msg_killstreak_likeaboss";
      
      map[tripleKillKey] = InGameCatalog.SOUND_ID_KILLSTREAK_TRIPLE_KILL;
      map[unstoppableKey] = InGameCatalog.SOUND_ID_KILLSTREAK_UNSTOPPABLE;
      map[godlikeKey] = InGameCatalog.SOUND_ID_KILLSTREAK_GODLIKE;
      map[likeABossKey] = InGameCatalog.SOUND_ID_KILLSTREAK_LIKE_A_BOSS;
      
      public function KillsteakAudioMap()
      {
         super();
      }
   }
}

