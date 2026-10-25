package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class AudioSettingsModule implements IModule
   {
      
      private static var _instance:AudioSettingsModule;
      
      public var notSet:Boolean = false;
      
      public var sound:int = 0;
      
      public var music:int = 0;
      
      public var voice:int = 0;
      
      public var playCombatMusic:Boolean = false;
      
      public function AudioSettingsModule(param1:Boolean = false, param2:int = 0, param3:int = 0, param4:int = 0, param5:Boolean = false)
      {
         super();
         this.notSet = param1;
         this.sound = param2;
         this.music = param3;
         this.voice = param4;
         this.playCombatMusic = param5;
      }
      
      public static function get instance() : AudioSettingsModule
      {
         return _instance || (_instance = new AudioSettingsModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 271;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 14;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.notSet = param1.readBoolean();
         this.sound = param1.readInt();
         this.sound = this.sound >>> 14 % 32 | this.sound << 32 - 14 % 32;
         this.music = param1.readInt();
         this.music = this.music >>> 3 % 32 | this.music << 32 - 3 % 32;
         this.voice = param1.readInt();
         this.voice = this.voice << 3 % 32 | this.voice >>> 32 - 3 % 32;
         this.playCombatMusic = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(271);
         param1.writeBoolean(this.notSet);
         param1.writeInt(this.sound << 14 % 32 | this.sound >>> 32 - 14 % 32);
         param1.writeInt(this.music << 3 % 32 | this.music >>> 32 - 3 % 32);
         param1.writeInt(this.voice >>> 3 % 32 | this.voice << 32 - 3 % 32);
         param1.writeBoolean(this.playCombatMusic);
      }
   }
}

