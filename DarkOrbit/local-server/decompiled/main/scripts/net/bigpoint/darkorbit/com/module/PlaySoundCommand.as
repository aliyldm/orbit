package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class PlaySoundCommand implements IModule
   {
      
      private static var _instance:PlaySoundCommand;
      
      public static const SOUNDTYPE_HELLSTORM_LAUNCHER_INITIATE_LOADING:int = 0;
      
      public static const SOUNDTYPE_HELLSTORM_LAUNCHER_LOAD:int = 1;
      
      public static const SOUNDTYPE_HELLSTORM_LAUNCHER_FULL:int = 2;
      
      public static const SOUNDTYPE_NEW_SHIP_RECEIVED:int = 3;
      
      public static const SOUNDTYPE_NPC_SLENDER_ATTACK:int = 4;
      
      public static const SOUNDTYPE_NPC_SLENDER_MENACE:int = 5;
      
      public static const SOUNDTYPE_NPC_SLENDER_REVEAL:int = 6;
      
      public static const SOUNDTYPE_NPC_SLENDER_VANISH:int = 7;
      
      public static const SOUNDTYPE__MAX:int = 8;
      
      public var soundType:int = 0;
      
      public function PlaySoundCommand(param1:int = 0)
      {
         super();
         this.soundType = param1;
      }
      
      public static function get instance() : PlaySoundCommand
      {
         return _instance || (_instance = new PlaySoundCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -6623;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.soundType = param1.readShort();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-6623);
         param1.writeShort(this.soundType);
      }
   }
}

