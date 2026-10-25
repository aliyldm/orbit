package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class AudioSettingsRequest implements IModule
   {
      
      private static var _instance:AudioSettingsRequest;
      
      public var sound:int = 0;
      
      public var music:int = 0;
      
      public var voice:int = 0;
      
      public var playCombatMusic:Boolean = false;
      
      public function AudioSettingsRequest(param1:int = 0, param2:int = 0, param3:int = 0, param4:Boolean = false)
      {
         super();
         this.sound = param1;
         this.music = param2;
         this.voice = param3;
         this.playCombatMusic = param4;
      }
      
      public static function get instance() : AudioSettingsRequest
      {
         return _instance || (_instance = new AudioSettingsRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 267;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 13;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.sound = param1.readInt();
         this.sound = this.sound >>> 2 % 32 | this.sound << 32 - 2 % 32;
         this.music = param1.readInt();
         this.music = this.music << 4 % 32 | this.music >>> 32 - 4 % 32;
         this.voice = param1.readInt();
         this.voice = this.voice << 7 % 32 | this.voice >>> 32 - 7 % 32;
         this.playCombatMusic = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(267);
         param1.writeInt(this.sound << 2 % 32 | this.sound >>> 32 - 2 % 32);
         param1.writeInt(this.music >>> 4 % 32 | this.music << 32 - 4 % 32);
         param1.writeInt(this.voice >>> 7 % 32 | this.voice << 32 - 7 % 32);
         param1.writeBoolean(this.playCombatMusic);
      }
   }
}

